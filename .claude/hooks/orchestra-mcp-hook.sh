#!/bin/bash
# Orchestra MCP hook — pipes Claude Code events to MCP server + Discord
# Uses jq @sh for safe shell variable extraction
set +e

INPUT=$(cat)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

# Extract basic fields
EVENT_NAME=$(echo "$INPUT" | jq -r '.hook_event_name // "unknown"')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // ""')
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // ""')

# 1) Forward to MCP server in BACKGROUND (don't block Discord)
(echo "$INPUT" | jq -c '{
  jsonrpc: "2.0", id: 1, method: "tools/call",
  params: {
    name: "receive_hook_event",
    arguments: {
      event_type: .hook_event_name,
      session_id: (.session_id // ""),
      tool_name: (.tool_name // ""),
      agent_type: (.agent_type // ""),
      data: .
    }
  }
}' | orchestra-mcp --workspace "$PROJECT_DIR" 2>/dev/null | head -1 > /dev/null) &

# 2) Forward to Discord (fast path)
if [ -f "$PROJECT_DIR/.env" ]; then
  set -a
  source "$PROJECT_DIR/.env" 2>/dev/null
  set +a
fi

if [ -z "$DISCORD_BOT_TOKEN" ] || [ -z "$DISCORD_LISTEN_CHANNEL_ID" ]; then
  exit 0
fi

# Helper: get tool_response content
# Claude Code sends tool_response as array: [{"type":"text","text":"...json..."}]
get_mcp_data() {
  echo "$INPUT" | jq -r '.tool_response[0].text // .tool_response // ""' 2>/dev/null
}

# Build Discord message
FIELDS="[]"
case "$EVENT_NAME" in
  SessionStart)
    COLOR=3066993; TITLE="Session Started"; DESC="Claude Code session started"
    ;;
  Stop)
    COLOR=15158332; TITLE="Session Ended"; DESC="Claude Code session completed"
    ;;
  SubagentStart)
    COLOR=3447003; TITLE="Agent: $AGENT_TYPE"; DESC="Subagent launched"
    ;;
  SubagentStop)
    COLOR=10181046; TITLE="Agent Done: $AGENT_TYPE"; DESC="Subagent finished"
    ;;
  PostToolUse)
    case "$TOOL_NAME" in
      Bash)
        COLOR=15844367; TITLE="Bash Command"
        DESC=$(echo "$INPUT" | jq -r '"`\(.tool_input.command // "" | .[0:150])`"')
        ;;
      Write)
        COLOR=15844367; TITLE="File Written"
        DESC=$(echo "$INPUT" | jq -r '"`\(.tool_input.file_path // "")`"')
        ;;
      Edit)
        COLOR=15844367; TITLE="File Edited"
        DESC=$(echo "$INPUT" | jq -r '"`\(.tool_input.file_path // "")`"')
        ;;
      Task)
        COLOR=3447003; TITLE="Task Spawned"
        DESC=$(echo "$INPUT" | jq -r '.tool_input.description // "" | .[0:200]')
        ;;
      mcp__orchestra-mcp__*)
        MCP_TOOL="${TOOL_NAME#mcp__orchestra-mcp__}"
        COLOR=1752220
        MCP_DATA=$(get_mcp_data)

        case "$MCP_TOOL" in
          set_current_task|advance_task|complete_task|update_task|reject_task)
            TASK_ID=$(echo "$INPUT" | jq -r '.tool_input.task_id // ""')
            PROJECT=$(echo "$INPUT" | jq -r '.tool_input.project // ""')
            EPIC_ID=$(echo "$INPUT" | jq -r '.tool_input.epic_id // ""')
            STORY_ID=$(echo "$INPUT" | jq -r '.tool_input.story_id // ""')

            TASK_TITLE=$(echo "$MCP_DATA" | jq -r '.title // .task.title // ""' 2>/dev/null)
            TASK_TYPE=$(echo "$MCP_DATA" | jq -r '.type // .task.type // "task"' 2>/dev/null)
            PRIORITY=$(echo "$MCP_DATA" | jq -r '.priority // .task.priority // ""' 2>/dev/null)
            STATUS=$(echo "$MCP_DATA" | jq -r '.status // .task.status // .to // ""' 2>/dev/null)
            FROM=$(echo "$MCP_DATA" | jq -r '.from // ""' 2>/dev/null)
            DESC_TEXT=$(echo "$MCP_DATA" | jq -r '(.description // .task.description // "") | .[0:150]' 2>/dev/null)

            TITLE="$MCP_TOOL"
            DESC=""
            [ -n "$TASK_TITLE" ] && [ "$TASK_TITLE" != "null" ] && DESC="**$TASK_TITLE**"
            if [ -n "$FROM" ] && [ "$FROM" != "null" ] && [ -n "$STATUS" ] && [ "$STATUS" != "null" ]; then
              DESC="$DESC\n\`$FROM\` → \`$STATUS\`"
            elif [ -n "$STATUS" ] && [ "$STATUS" != "null" ]; then
              DESC="$DESC → \`$STATUS\`"
            fi

            FIELDS=$(jq -n \
              --arg tid "$TASK_ID" --arg ttype "$TASK_TYPE" --arg priority "$PRIORITY" \
              --arg epic "$EPIC_ID" --arg story "$STORY_ID" --arg project "$PROJECT" \
              --arg desc "$DESC_TEXT" \
              '[
                {name:"Task",value:("`" + $tid + "` " + $ttype),inline:true},
                (if $priority != "" and $priority != "null" then {name:"Priority",value:$priority,inline:true} else empty end),
                (if $project != "" then {name:"Project",value:$project,inline:true} else empty end),
                (if $epic != "" then {name:"Epic",value:("`" + $epic + "`"),inline:true} else empty end),
                (if $story != "" then {name:"Story",value:("`" + $story + "`"),inline:true} else empty end),
                (if $desc != "" and $desc != "null" then {name:"Description",value:($desc | .[0:150]),inline:false} else empty end)
              ]')
            ;;
          get_project_status)
            PROJECT=$(echo "$INPUT" | jq -r '.tool_input.project // ""')
            PROJ_STATUS=$(echo "$MCP_DATA" | jq -r '.status // ""' 2>/dev/null)
            PROJ_DESC=$(echo "$MCP_DATA" | jq -r '(.description // "") | .[0:200]' 2>/dev/null)
            EPICS=$(echo "$MCP_DATA" | jq -r '.epics | length' 2>/dev/null || echo "0")
            STORIES=$(echo "$MCP_DATA" | jq -r '.stories | length' 2>/dev/null || echo "0")
            TASKS=$(echo "$MCP_DATA" | jq -r '.tasks | length' 2>/dev/null || echo "0")
            DONE=$(echo "$MCP_DATA" | jq -r '[.tasks[] | select(.status == "done")] | length' 2>/dev/null || echo "0")

            TITLE="Project Status: $PROJECT"
            DESC="$PROJ_DESC"
            FIELDS=$(jq -n \
              --arg status "$PROJ_STATUS" --arg epics "$EPICS" --arg stories "$STORIES" \
              --arg tasks "$TASKS" --arg done "$DONE" \
              '[{name:"Status",value:$status,inline:true},{name:"Epics",value:$epics,inline:true},{name:"Stories",value:$stories,inline:true},{name:"Tasks",value:($done + "/" + $tasks + " done"),inline:true}]')
            ;;
          get_workflow_status)
            PROJECT=$(echo "$INPUT" | jq -r '.tool_input.project // ""')
            COMP=$(echo "$MCP_DATA" | jq -r '.completion_pct // "0"' 2>/dev/null)
            TOTAL=$(echo "$MCP_DATA" | jq -r '(.total // 0) | tostring' 2>/dev/null)
            DONE=$(echo "$MCP_DATA" | jq -r '(.done // 0) | tostring' 2>/dev/null)

            TITLE="Workflow: $PROJECT"
            DESC="**$DONE/$TOTAL** tasks done (**$COMP%** complete)"
            FIELDS=$(jq -n --arg comp "$COMP" --arg done "$DONE" --arg total "$TOTAL" \
              '[{name:"Completion",value:($comp + "%"),inline:true},{name:"Done",value:$done,inline:true},{name:"Total",value:$total,inline:true}]')
            ;;
          create_task|create_story|create_epic)
            NEW_TITLE=$(echo "$MCP_DATA" | jq -r '.title // ""' 2>/dev/null)
            NEW_ID=$(echo "$MCP_DATA" | jq -r '.id // ""' 2>/dev/null)
            NEW_TYPE=$(echo "$MCP_DATA" | jq -r '.type // ""' 2>/dev/null)

            TITLE="Created: $NEW_TYPE"; DESC="**$NEW_TITLE** (\`$NEW_ID\`)"; COLOR=3066993
            ;;
          get_next_task)
            TASK_TITLE=$(echo "$MCP_DATA" | jq -r '.title // ""' 2>/dev/null)
            TASK_ID=$(echo "$MCP_DATA" | jq -r '.id // ""' 2>/dev/null)
            PRIORITY=$(echo "$MCP_DATA" | jq -r '.priority // ""' 2>/dev/null)
            STATUS=$(echo "$MCP_DATA" | jq -r '.status // ""' 2>/dev/null)

            TITLE="Next Task"; DESC="**$TASK_TITLE**"
            FIELDS=$(jq -n --arg id "$TASK_ID" --arg p "$PRIORITY" --arg s "$STATUS" \
              '[{name:"ID",value:("`" + $id + "`"),inline:true},{name:"Priority",value:$p,inline:true},{name:"Status",value:$s,inline:true}]')
            ;;
          save_session|save_memory)
            SUMMARY=$(echo "$INPUT" | jq -r '.tool_input.summary // "" | .[0:200]')
            TITLE="$MCP_TOOL"; DESC="$SUMMARY"; COLOR=10181046
            ;;
          search)
            QUERY=$(echo "$INPUT" | jq -r '.tool_input.query // ""')
            TITLE="Search"; DESC="Query: \`$QUERY\`"
            ;;
          list_epics|list_stories|list_tasks)
            PROJECT=$(echo "$INPUT" | jq -r '.tool_input.project // ""')
            COUNT=$(echo "$MCP_DATA" | jq -r 'length // 0' 2>/dev/null || echo "0")
            TITLE="$MCP_TOOL"; DESC="**$PROJECT** — $COUNT items"
            ;;
          *)
            TITLE="MCP: $MCP_TOOL"
            DESC=$(echo "$INPUT" | jq -r '.tool_input | [
              (if .project then "**" + .project + "**" else empty end),
              (if .task_id then "`" + .task_id + "`" else empty end),
              (if .title then .title else empty end)
            ] | join(" — ") | .[0:300]')
            ;;
        esac
        ;;
      *)
        exit 0
        ;;
    esac
    ;;
  Notification)
    COLOR=16776960; TITLE="Notification"
    DESC=$(echo "$INPUT" | jq -r '.message // "Claude Code notification" | .[0:500]')
    ;;
  *)
    exit 0
    ;;
esac

# Send to Discord (fire and forget)
curl -s -X POST "https://discord.com/api/v10/channels/$DISCORD_LISTEN_CHANNEL_ID/messages" \
  -H "Authorization: Bot $DISCORD_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$(jq -n \
    --arg title "$TITLE" --arg desc "$DESC" --argjson color "${COLOR:-7506394}" \
    --arg session "$SESSION_ID" --argjson fields "$FIELDS" \
    '{embeds:[{title:$title,description:$desc,color:$color,fields:$fields,footer:{text:("Session: " + ($session | .[0:8]) + " | Orchestra MCP")},timestamp:(now | todate)}]}')" \
  > /dev/null 2>&1 &

exit 0

---
id: FEAT-SOM
kind: feature
priority: P0
project_slug: orchestra-web
status: backlog
title: AI Chat Page (Full ChatBox Integration)
type: feature
---

# AI Chat Page (Full ChatBox Integration)

Full AI chat interface using @orchestra-mcp/ai's ChatBox component system. Multi-session chat with streaming responses, event cards, model selection, and agent switching.

File: `apps/web/src/pages/chat.tsx` + `apps/web/src/pages/chat/[id].tsx`

Chat list page (`chat.tsx`):
- List all AI sessions via mcp.callTool("list_sessions")
- Each session: name, model badge, last message preview, timestamp
- "New Chat" Button → create session via mcp.callTool("create_session")
- Delete session with confirmation
- Click → navigate to /chat/:id

Chat session page (`chat/[id].tsx`):
- Full-height layout using ChatLayout from @orchestra-mcp/desktop
- ChatBox from @orchestra-mcp/ai as the core component
- ChatModelSelector from @orchestra-mcp/ai for model switching
- ChatModeSelector from @orchestra-mcp/ai for mode (chat/agent/codex)
- ChatThinkingToggle from @orchestra-mcp/ai for extended thinking
- EventCardRenderer from @orchestra-mcp/ai for rendering tool use events:
  - BashCard, GrepCard, EditCard, CreateCard (file operations)
  - McpCard, OrchestraCard (MCP tool calls)
  - TaskCard, TodoListCard (project management)
  - SprintCard, BurndownChartCard (sprint tracking)
  - MemoryCard, SessionCard (RAG memory)
  - WebSearchCard, WebFetchCard (web tools)
  - GitHubPRCard, GitHubIssueCard, CIStatusCard (integrations)
- ChatInput from @orchestra-mcp/ai with MentionPopup (@ mentions) and CommandPalette (/ commands)
- useAutoScroll hook for message streaming
- SessionSidebar from @orchestra-mcp/desktop showing session list on left

Zustand store (`apps/web/src/stores/chat.ts`):
- State: {sessions[], currentSession, messages[], streaming, error}
- Actions: {fetchSessions, createSession, deleteSession, sendMessage, appendChunk}
- Wire mcp.callTool("send_message") for sending, stream chunks via SSE or polling

Acceptance: Chat list shows sessions, new session creates via MCP, ChatBox renders with event cards, model selector works, streaming messages display progressively
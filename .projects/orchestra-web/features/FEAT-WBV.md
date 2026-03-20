---
id: FEAT-WBV
kind: feature
priority: P1
project_slug: orchestra-web
status: backlog
title: Agents Page (Define, Run, Test Workflows)
type: feature
---

# Agents Page (Define, Run, Test Workflows)

Agent and workflow management UI backed by the agent-orchestrator plugin's 20 tools.

File: `apps/web/src/pages/agents.tsx`

Three-tab layout (Tabs from @orchestra-mcp/ui):

**Tab 1: Agents**
- List cards via mcp.callTool("list_agents")
- Each card (Panel from @orchestra-mcp/ui): agent name, provider Badge, model, instruction preview
- "New Agent" Button → slide-over form:
  - name Input, instruction Textarea, provider Select, model Input, max_budget Input
  - Create via mcp.callTool("define_agent")
- Delete Button with confirmation
- "Run" Button → inline prompt Input → mcp.callTool("run_agent", {agent_id, prompt}) → show result in CodeBlock from @orchestra-mcp/editor

**Tab 2: Workflows**
- List cards via mcp.callTool("list_workflows")
- Each card: workflow name, type Badge (sequential/parallel/loop), step count
- "New Workflow" Button → form:
  - name Input, type Select (sequential/parallel/loop), steps (add/remove agent steps)
  - Create via mcp.callTool("define_workflow")
- "Run" Button → mcp.callTool("run_workflow") → poll mcp.callTool("get_run_status") every 2s
- Run progress: ProgressBar from @orchestra-mcp/ui + status Badge

**Tab 3: Compare Providers**
- Prompt Textarea
- Multi-select providers (Checkbox list: claude, openai, gemini, ollama)
- System prompt Textarea (optional)
- "Compare" Button → mcp.callTool("compare_providers", {prompt, providers})
- Results: side-by-side Panel grid showing each provider's response
- DataTable from @orchestra-mcp/widgets showing cost/duration per provider

Zustand store (`apps/web/src/stores/agents.ts`):
- State: {agents[], workflows[], runs[], comparing}
- Actions: {fetchAgents, createAgent, deleteAgent, runAgent, fetchWorkflows, createWorkflow, runWorkflow, compareProviders}

Sidebar nav item: "Agents" with bx-bot icon

Acceptance: agent list loads, new agent creates, run agent shows result, workflow run polls status, compare providers shows side-by-side results
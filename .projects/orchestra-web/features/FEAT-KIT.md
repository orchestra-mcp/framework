---
id: FEAT-KIT
kind: feature
priority: P1
project_slug: orchestra-web
status: backlog
title: DevTools Panel (Terminal, Database, SSH, Git, Logs)
type: feature
---

# DevTools Panel (Terminal, Database, SSH, Git, Logs)

Full developer tools panel using @orchestra-mcp/devtools — embedded sessions for terminal, database, SSH, git, log viewer, file explorer, debugger, and test runner.

File: `apps/web/src/pages/devtools.tsx`

Layout:
- DevToolsSidebar from @orchestra-mcp/devtools as the root component (handles session list + switching)
- DevToolsSessionSidebar wraps active session content
- NewSessionPicker for adding new session tabs
- SessionContent renders the active session by type

Session types to wire (all from @orchestra-mcp/devtools, backed by MCP tools):
1. TerminalSession → mcp.callTool("terminal_*") from plugin-devtools-terminal
2. DatabaseSession → mcp.callTool("db_*") from plugin-devtools-database
3. SSHSession → mcp.callTool("ssh_*") from plugin-devtools-ssh
4. LogViewerSession → mcp.callTool("log_*") from plugin-devtools-log-viewer
5. FileExplorerSession → mcp.callTool("file_*") from plugin-devtools-file-explorer
6. ServiceManagerSession → mcp.callTool("service_*") from plugin-devtools-services
7. DebuggerSession → mcp.callTool("debug_*") from plugin-devtools-debugger
8. TestingSession → mcp.callTool("test_*") from plugin-devtools-test-runner

DevToolsWorkerService setup:
- Initialize DevToolsWorkerService on mount with gateway WebSocket URL
- buildWsUrl() pointing to wss://localhost:4433/ws for real-time streaming

Zustand store (`apps/web/src/stores/devtools.ts`):
- State: {sessions[], activeSessionId, sessionStates}
- Actions: {addSession, removeSession, setActive, updateSessionState}

Sidebar nav item: "DevTools" with bx-terminal icon, 8th nav item in sidebar

Acceptance: DevToolsSidebar renders, can add Terminal/Database/Git sessions, session content area shows correct UI per type, sessions persist via Zustand
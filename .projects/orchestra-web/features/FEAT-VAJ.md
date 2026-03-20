---
id: FEAT-VAJ
kind: feature
priority: P0
project_slug: orchestra-web
status: backlog
title: Dashboard Scaffold + MCP Client
type: feature
---

# Dashboard Scaffold + MCP Client

Vite + React 19 + TypeScript project at apps/web/ with a custom MCP client for the new JSON-RPC 2.0 gateway. Wires in workspace packages via pnpm workspace:* protocol.

Files:
- `apps/web/package.json` — name @orchestra/web, private true, react 19, react-dom 19, react-router-dom 7, workspace deps: "@orchestra-mcp/ui": "workspace:*", "@orchestra-mcp/tasks": "workspace:*", "@orchestra-mcp/theme": "workspace:*", "@orchestra-mcp/icons": "workspace:*", "@orchestra-mcp/editor": "workspace:*", "@orchestra-mcp/explorer": "workspace:*", "@orchestra-mcp/widgets": "workspace:*". Dev: vite 6, @vitejs/plugin-react, typescript 5.7
- `apps/web/vite.config.ts` — react plugin, path alias @ -> src/, server.proxy: '/rpc' -> 'https://localhost:4433' (for dev without building Go binary)
- `apps/web/tsconfig.json` + `tsconfig.app.json` — strict mode, @ path alias, includes packages/@orchestra-mcp paths for workspace resolution
- `apps/web/index.html` — Vite entry pointing to /src/main.tsx

MCP client (`apps/web/src/lib/mcp-client.ts`):
- Speaks JSON-RPC 2.0 to POST /rpc (the new gateway, NOT the old 19191 REST bridge)
- MCPClient class: baseUrl string, requestId counter
- call<T>(method, params): POST /rpc with {jsonrpc:"2.0", id, method, params}, throw on HTTP error or json.error
- Convenience: listTools() -> tools[], callTool(name, args) -> content[], listPrompts() -> prompts[], getPrompt(name, args) -> messages[]
- Singleton export: `export const mcp = new MCPClient(window.location.origin)` (works both embedded in binary and via dev proxy)

Utils (`apps/web/src/lib/utils.ts`): cn() using clsx + tailwind-merge (same as rest of codebase)

Acceptance: pnpm install succeeds resolving workspace packages, pnpm build produces dist/ with 0 TypeScript errors, tsc -b compiles clean
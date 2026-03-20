---
id: FEAT-GCX
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Remote Repo Workspaces + Bot Chat Integration
type: feature
---

# Remote Repo Workspaces + Bot Chat Integration

GitHub repo management system: clone repos via OAuth, run Claude prompts in workspaces, auto-sync to GitHub, route Slack/Discord bot chat through web API. Includes CallTool wiring for bridge plugins, workspace manager service, REST handlers, and frontend repos page.


---
**in-progress -> in-testing** (2026-03-10T21:27:43Z):
## Changes
- libs/plugin-bridge-slack/internal/bot.go (added SetCaller method)
- libs/plugin-bridge-slack/internal/caller.go (new — Sender interface, MakeToolCaller, ExtractText)
- libs/plugin-bridge-slack/internal/workspace_client.go (new — HTTP client for web server chat API)
- libs/plugin-bridge-slack/internal/config.go (added APIURL, APIToken, DefaultWorkspace fields)
- libs/plugin-bridge-slack/internal/handlers/chat.go (workspace routing with @workspace prefix, fallback to local CallTool)
- libs/plugin-bridge-slack/cmd/main.go (wire lazy caller via OrchestratorClient)
- libs/plugin-bridge-slack/export.go (accept Sender param for in-process use)
- libs/plugin-bridge-discord/internal/bot.go (added SetCaller method)
- libs/plugin-bridge-discord/internal/caller.go (new — Sender interface, MakeToolCaller, ExtractText)
- libs/plugin-bridge-discord/internal/workspace_client.go (new — HTTP client for web server chat API)
- libs/plugin-bridge-discord/internal/config.go (added APIURL, APIToken, DefaultWorkspace fields)
- libs/plugin-bridge-discord/internal/handlers/chat.go (workspace routing with @workspace prefix, fallback to local CallTool)
- libs/plugin-bridge-discord/cmd/main.go (wire lazy caller via OrchestratorClient)
- libs/plugin-bridge-discord/export.go (accept Sender param for in-process use)
- apps/web/internal/models/repo_workspace.go (new — GORM model)
- apps/web/internal/services/workspace_manager.go (new — clone, prompt, sync, auto-sync)
- apps/web/internal/handlers/repo_workspaces.go (new — CRUD + chat + GitHub list)
- apps/web/internal/handlers/oauth.go (GitHub scope user:email -> user:email repo)
- apps/web/internal/database/database.go (added RepoWorkspace to AutoMigrate)
- apps/web/internal/config/config.go (added RepoBaseDir field)
- apps/web/internal/routes/routes.go (registered /api/repos routes)
- apps/web/cmd/main.go (WorkspaceManager init + AutoSyncLoop)
- apps/next/src/app/(app)/repos/page.tsx (new — frontend repos page)
- apps/next/src/components/layout/dashboard-sidebar.tsx (added Repos nav item)


---
**in-testing -> in-docs** (2026-03-10T21:31:40Z):
## Results
- libs/plugin-bridge-slack/internal/caller_test.go (5 tests: ExtractText nil/text/no-text/empty/nested — all PASS)
- libs/plugin-bridge-slack/internal/workspace_client_test.go (6 tests: ChatSuccess/ChatError/ChatAPIError/AuthHeader/NoToken/URLConstruction — all PASS)
- libs/plugin-bridge-slack/internal/handlers/chat_test.go (7 tests: parseWorkspace with no prefix/workspace/workspace-only/dashes/empty/at-only/UUID — all PASS)
- libs/plugin-bridge-discord/internal/caller_test.go (5 tests: same ExtractText suite — all PASS)
- libs/plugin-bridge-discord/internal/workspace_client_test.go (6 tests: same WorkspaceClient suite — all PASS)
- libs/plugin-bridge-discord/internal/handlers/chat_test.go (7 tests: same parseWorkspace suite — all PASS)
- apps/web/internal/handlers/repo_workspaces_test.go (14 tests: ListEmpty/ListWithData/Create/CreateMissingFields/CreateNoGitHub/Show/ShowNotFound/Delete/DeleteNotFound/ChatNotReady/ChatMissingPrompt/ChatNotFound/UserScopedList/CreateDuplicate — all PASS)

Total: 50 new tests, all passing. Full test output verified with `go test -v -count=1`.


---
**in-docs -> in-review** (2026-03-10T21:32:20Z):
## Docs
- docs/repo-workspaces.md (new — architecture, API reference, bot integration, setup guide, file manifest)


---
**Review (approved)** (2026-03-10T21:32:47Z): All 50 tests pass. Code builds clean across all 3 packages. Documentation complete.
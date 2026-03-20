---
id: FEAT-XMN
kind: feature
priority: P2
project_slug: orchestra-win
status: backlog
title: DevOps sub-plugin — CI/CD pipeline management
type: feature
---

# DevOps sub-plugin — CI/CD pipeline management

Implement `Orchestra.Desktop/Plugins/DevToolsPlugin/DevOps/` — CI/CD pipeline browser and deployment management.

**`DevOpsPage.xaml`** — `TabView`:
- **Pipelines:** `ListView` (name, branch, status dot, last run time, duration), Run/Cancel buttons, click → run detail with stages/steps tree
- **Deployments:** `ListView` (env, version, status, deployed by, time), Promote/Rollback buttons
- **Environments:** `ListView` (name, current version, health), env variable editor
- **Releases:** changelog `ListView` with tag + notes + artifact links

**Provider integrations (via MCP backend):**
- GitHub Actions: `gh` CLI or REST API
- Azure DevOps: REST API with PAT
- GitLab CI: REST API
- Bitbucket Pipelines: REST API

**Live log streaming:** pipeline step logs stream via `StreamChunk` into embedded `TerminalControl` (xterm.js read-only mode)

**`DevOpsService.cs`** — provider-agnostic interface, dispatches to correct API client based on configured provider

**MCP tools called:** `devops_list_pipelines`, `devops_trigger`, `devops_cancel`, `devops_get_run`, `devops_list_deployments`, `devops_promote`, `devops_rollback`, `devops_get_logs`

**Platform:** Desktop, HoloLens
---
id: FEAT-UFQ
kind: feature
priority: P1
project_slug: orchestra-web
status: backlog
title: Settings Page (Gateway, Theme, Accounts)
type: feature
---

# Settings Page (Gateway, Theme, Accounts)

Settings page using @orchestra-mcp/settings components for configuring the gateway connection, theme, and AI provider accounts.

File: `apps/web/src/pages/settings.tsx`

Layout:
- SettingsNav from @orchestra-mcp/settings for left-side navigation tabs
- SettingsForm from @orchestra-mcp/settings for each settings section

Settings sections:

1. **Connection** (SettingsGroup):
   - Gateway URL: Input (default: https://localhost:4433)
   - API Key: Input type="password" (optional Bearer token)
   - Test Connection: Button → POST /health, show success/error toast
   - Saved to localStorage via connectionStore

2. **Appearance** (SettingsGroup):
   - ThemePicker from @orchestra-mcp/theme — select color theme (orchestra, ocean, forest, sunset)
   - Theme variant: light/dark/system toggle using theme-switcher from @orchestra-mcp/theme
   - Sidebar width: range slider (200-320px)
   - Font size: Select (sm/md/lg)

3. **AI Accounts** (SettingsGroup):
   - Table of accounts via mcp.callTool("list_accounts") from tools-agentops
   - Per row: name, provider Badge, model, budget usage ProgressBar from @orchestra-mcp/ui
   - "Add Account" → modal form with: name, provider Select, auth_method Select, api_key Input, max_budget Input
   - Create via mcp.callTool("create_account")
   - Delete with confirmation via mcp.callTool("remove_account")

4. **About** (SettingsGroup):
   - Orchestra version from mcp.callTool("health_check") via engine.rag
   - Plugin list: tools list grouped by plugin ID
   - Links: GitHub, Docs, Issue reporting

Acceptance: all 4 settings sections render, gateway URL saves to connectionStore and reconnects, theme picker applies immediately, account CRUD works
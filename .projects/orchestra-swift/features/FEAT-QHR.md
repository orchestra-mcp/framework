---
created_at: "2026-03-10T14:18:25Z"
description: Add slack provider to apps/web/internal/handlers/oauth.go (Slack OAuth2 with identity.basic scope). Add Slack button to login page, add Slack to connected accounts in settings page, add Slack OAuth admin fields in admin-integrations section. Mirror Discord OAuth implementation.
estimate: M
id: FEAT-QHR
kind: feature
labels:
    - plan:PLAN-IDD
priority: P1
project_id: orchestra-swift
status: done
title: Slack OAuth Login + Connected Account
updated_at: "2026-03-10T14:44:45Z"
version: 5
---

# Slack OAuth Login + Connected Account

Add slack provider to apps/web/internal/handlers/oauth.go (Slack OAuth2 with identity.basic scope). Add Slack button to login page, add Slack to connected accounts in settings page, add Slack OAuth admin fields in admin-integrations section. Mirror Discord OAuth implementation.


---
**in-progress -> in-testing** (2026-03-10T14:42:46Z):
## Changes
- apps/web/internal/handlers/oauth.go (added slack provider config, Slack user_scope param, Slack nested token response parsing, Slack nested user info parsing)
- apps/next/src/app/[locale]/(auth)/login/page.tsx (added Slack social button, 2x2 grid layout)
- apps/next/src/app/(app)/settings/page.tsx (added Slack to connected accounts, added Slack OAuth admin fields in integrations)
- libs/plugin-bridge-slack/.gitignore (new — scaffolding)
- libs/plugin-bridge-slack/LICENSE (new — scaffolding)
- libs/plugin-bridge-slack/CODE_OF_CONDUCT.md (new — scaffolding)
- libs/plugin-bridge-slack/SECURITY.md (new — scaffolding)
- libs/plugin-bridge-slack/CHANGELOG.md (new — scaffolding)
- libs/plugin-bridge-slack/README.md (new — scaffolding)
- libs/plugin-bridge-slack/.github/CONTRIBUTING.md (new)
- libs/plugin-bridge-slack/.github/FUNDING.yml (new)
- libs/plugin-bridge-slack/.github/SECURITY.md (new)
- libs/plugin-bridge-slack/.github/ISSUE_TEMPLATE/bug_report.md (new)
- libs/plugin-bridge-slack/.github/ISSUE_TEMPLATE/config.yml (new)
- libs/plugin-bridge-slack/.github/ISSUE_TEMPLATE/feature_request.md (new)
- libs/plugin-bridge-slack/.github/workflows/ci.yml (new)
- libs/plugin-bridge-slack/docs/CONTRIBUTING.md (new)
- libs/plugin-bridge-slack/docs/TOOLS_REFERENCE.md (new)


---
**in-testing -> in-docs** (2026-03-10T14:43:31Z):
## Results
- apps/web/internal/handlers/oauth_test.go (4 new Slack tests added: TestExchangeCode_SlackNestedToken, TestFetchUserInfo_SlackNestedUser, TestSlackOAuthStateRoundTrip, TestProviderConfigStruct_Slack)

All 22 handler tests pass: `ok github.com/orchestra-mcp/web/internal/handlers 0.715s`


---
**in-docs -> in-review** (2026-03-10T14:44:21Z):
## Docs
- docs/slack-oauth.md (new — Slack OAuth v2 flow, token/user info formats, Slack app setup, configuration)
- docs/discord-oauth.md (updated — added Slack to supported providers, credentials list, and login buttons)


---
**Review (approved)** (2026-03-10T14:44:45Z): Slack OAuth approved. Full provider support with nested response parsing, login button, connected accounts, admin fields.

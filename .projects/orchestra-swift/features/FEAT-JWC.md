---
created_at: "2026-03-10T22:11:35Z"
description: Add OAuth 2.0 + PKCE flow for connecting Claude Code accounts to Orchestra. Works in both MCP CLI (2-call pattern) and web dashboard. Stores OAuth token as Orchestra account with auth_method="oauth".
id: FEAT-JWC
kind: feature
priority: P1
project_id: orchestra-swift
status: done
title: Claude Code OAuth Account Setup
updated_at: "2026-03-10T22:18:20Z"
version: 5
---

# Claude Code OAuth Account Setup

Add OAuth 2.0 + PKCE flow for connecting Claude Code accounts to Orchestra. Works in both MCP CLI (2-call pattern) and web dashboard. Stores OAuth token as Orchestra account with auth_method="oauth".


---
**in-progress -> in-testing** (2026-03-10T22:15:44Z):
## Changes
- libs/plugin-tools-agentops/internal/tools/oauth_claude.go (new — PKCE OAuth flow with connect_claude_code_account tool)
- libs/plugin-tools-agentops/internal/tools/usage.go (added oauth case to buildClaudeEnv, added CLAUDE_CONFIG_DIR support)
- libs/plugin-tools-agentops/internal/tools/account.go (added oauth to auth_method enum and validation)
- libs/plugin-tools-agentops/internal/plugin.go (registered connect_claude_code_account tool)
- apps/web/internal/handlers/oauth_claude_code.go (new — web dashboard OAuth handler with Start + Exchange endpoints)
- apps/web/internal/routes/routes.go (registered GET /api/oauth/claude-code/start and POST /api/oauth/claude-code/exchange)


---
**in-testing -> in-docs** (2026-03-10T22:17:30Z):
## Results
- libs/plugin-tools-agentops/internal/tools/oauth_claude_test.go (7 tests, all pass)
  - TestConnectClaudeCodeAccountSchema: validates schema properties and required fields
  - TestConnectClaudeCodeAccount_Step1_StartFlow: verifies PKCE flow generates authorize URL
  - TestConnectClaudeCodeAccount_MissingName: validates missing name returns error
  - TestConnectClaudeCodeAccount_InvalidState: validates invalid state returns error
  - TestBuildClaudeEnv_OAuth: verifies oauth auth_method sets CLAUDE_CODE_OAUTH_TOKEN
  - TestBuildClaudeEnv_OAuthEmpty: verifies empty access_token doesn't set env var
  - TestBuildClaudeEnv_ConfigDir: verifies config_dir sets CLAUDE_CONFIG_DIR
- Full build passes: go build ./libs/plugin-tools-agentops/... and go build ./apps/web/...


---
**in-docs -> in-review** (2026-03-10T22:17:59Z):
## Docs
- docs/claude-code-oauth.md (new — documents MCP CLI flow, web dashboard flow, token usage, multi-account support, OAuth details, auth methods summary)


---
**Review (approved)** (2026-03-10T22:18:20Z): All changes approved. OAuth flow for both CLI and web dashboard implemented with PKCE, 7 tests passing, full build clean.

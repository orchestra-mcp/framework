# Claude Code OAuth Account Setup

Connect Claude Code accounts to Orchestra via OAuth 2.0 + PKCE. Supports both MCP CLI and web dashboard flows.

## Overview

Orchestra can authenticate with Claude Code using OAuth tokens obtained through Anthropic's OAuth flow. This enables multi-account support — connect work and personal Claude accounts on the same machine.

## MCP CLI Flow (2-call pattern)

### Step 1: Start the flow

```
connect_claude_code_account(name="Work")
```

This generates PKCE credentials, opens your browser to the Claude approval page, and returns instructions with the state token.

### Step 2: Complete with the authorization code

After approving in the browser, you'll see an authorization code on the redirect page. Copy it and call:

```
connect_claude_code_account(name="Work", code="AUTH_CODE", state="STATE_TOKEN")
```

This exchanges the code for OAuth tokens and creates an Orchestra account with `auth_method="oauth"`.

## Web Dashboard Flow

### Start

```
GET /api/oauth/claude-code/start
```

Returns `{ authorize_url, state }`. Open the URL in a new browser tab.

### Exchange

After the user approves and copies the code:

```
POST /api/oauth/claude-code/exchange
Body: { "code": "AUTH_CODE", "state": "STATE_TOKEN" }
```

Returns `{ success, token (masked), expires_at, scope }`. The tokens are stored as an `OAuthAccount` linked to the authenticated user.

## How Tokens Are Used

When spawning a Claude Code session with an OAuth account, Orchestra sets:

```
CLAUDE_CODE_OAUTH_TOKEN=sk-ant-oat01-...
```

This env var is read by Claude Code CLI for authentication.

## Multi-Account Support

Each account can optionally specify a `config_dir` in its config to isolate Claude Code configuration:

```
create_account(name="Work", auth_method="oauth", config={"config_dir": "/path/to/config"})
```

This sets `CLAUDE_CONFIG_DIR` when spawning sessions, allowing separate Claude Code profiles per account.

## OAuth Details

| Parameter | Value |
|-----------|-------|
| Authorize URL | `https://claude.ai/oauth/authorize` |
| Token URL | `https://console.anthropic.com/v1/oauth/token` |
| Client ID | `9d1c250a-e61b-44d9-88ed-5944d1962f5e` |
| Redirect URI | `https://console.anthropic.com/oauth/code/callback` |
| Scopes | `org:create_api_key user:profile user:inference` |
| PKCE Method | S256 |
| Token Lifetime | ~1 year |
| Token Format | `sk-ant-oat01-...` |

## Auth Methods Summary

| Method | Env Var Set | Use Case |
|--------|------------|----------|
| `claude_code` | (none) | Uses local Claude Code login |
| `setup_token` | `CLAUDE_CODE_TOKEN` | Team setup tokens |
| `api_key` | `ANTHROPIC_API_KEY` | Direct API key |
| `oauth` | `CLAUDE_CODE_OAUTH_TOKEN` | OAuth token from approval flow |
| `custom` | (all config keys) | Custom env vars |

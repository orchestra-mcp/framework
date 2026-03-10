# AI Chat Page — Web Dashboard

## Overview

The AI Chat page (`apps/next/src/app/(app)/chat/page.tsx`) provides a chat interface powered by MCP bridge tools through the tunnel. Users can chat with AI models configured on their local machine without needing API keys in the web app.

## Features

- **Session management**: Create, list, pause, delete chat sessions
- **Multi-provider support**: Claude, OpenAI, Gemini, Ollama — uses whatever accounts are configured on the tunnel machine
- **Message threading**: User/AI message bubbles with auto-scroll
- **Model selector**: Choose account and model when creating a new chat
- **Collapsible session sidebar**: Status filter tabs, session list with provider icons
- **Typing indicator**: Shows "Thinking..." while waiting for AI response

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `list_accounts` | Fetch available AI provider accounts from tunnel |
| `create_session` | Create a new persistent chat session |
| `list_sessions` | List sessions with optional status filter |
| `get_session` | Load session details and conversation history |
| `send_message` | Send user message and receive AI response |
| `pause_session` | Pause an active session |
| `delete_session` | Delete a session and its history |

## Architecture

The chat page does NOT call AI APIs directly. All AI interactions go through the tunnel:

```
Browser → WebSocket → Web Backend → Tunnel (WebSocket) → Orchestra MCP → Bridge Plugin → AI Provider
```

Each tunnel machine can have different AI accounts configured via `create_account` / `list_accounts`. The web app discovers available accounts at chat creation time.

## Middleware

The `/chat` and `/plans` routes must be listed in `APP_PREFIXES` in `apps/next/src/middleware.ts` to skip i18n locale routing. Without this, Next.js treats them as marketing routes and applies locale prefixes, causing 404s.

## Error Handling

All MCP tool calls use silent catch blocks — no `console.error` output. When the bridge plugin isn't running on the tunnel machine (e.g. `list_sessions` fails with "context canceled"), the page gracefully shows empty state instead of logging errors to the browser console. This is intentional: the bridge not running is an expected condition, not an error.

The New Chat modal distinguishes between two failure modes:
- **Tunnel unreachable** (`accountsFetchFailed = true`): Shows "Could not reach the tunnel. Make sure Orchestra is running on your machine." with a Retry button.
- **No accounts configured** (`accounts.length === 0`): Shows "No AI accounts configured. Run `orchestra account create` on your tunnel machine."

## Parsers

- `parseMCPSessions()`: Header-based column mapping for `list_sessions` markdown table
- `parseMCPAccounts()`: Header-based column mapping for `list_accounts` markdown table
- `parseSessionDetail()`: Extracts metadata (name, account, model, provider) and conversation turns from `get_session` response

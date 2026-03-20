# Orchestra Cloud MCP

A hosted personal MCP service at `mcp.orchestra-mcp.dev` that lets any user (coder or not) add Orchestra to their AI agent with one click — no local installation required.

## What It Is

The Cloud MCP is the **WebGate running as a multi-tenant cloud service**. It gives every Orchestra user a personal MCP endpoint their Claude agent can connect to in order to:

- Check if Orchestra is installed on their machine
- Install Orchestra, IDEs, and the desktop app via shell scripts
- Browse and install packs, plugins, skills, agents, and workflows from the marketplace
- Read and update their Orchestra web profile
- Control exactly what the agent can access via permission toggles in Settings

## Protocol

Implements **MCP 2025-11-25** (Streamable HTTP transport):

| Endpoint | Method | Description |
|----------|--------|-------------|
| `POST /mcp` | Streamable HTTP | Main MCP request/response |
| `GET /mcp` | SSE stream | Server push channel |
| `GET /health` | HTTP | Health check |

Server info returned on `initialize`:
```json
{
  "name": "orchestra-cloud-mcp",
  "version": "1.0.0",
  "title": "Orchestra Cloud",
  "description": "Personal Orchestra MCP — manage your profile, install Orchestra, browse the marketplace, and control agent permissions from the web.",
  "websiteUrl": "https://orchestra-mcp.dev"
}
```

## Tools

### Public Tools (no auth required)

These tools work for anyone — no account needed. Rate-limited at 10 req/min per IP.

| Tool | Description |
|------|-------------|
| `check_status` | Returns shell command to check if Orchestra is installed |
| `install_orchestra` | Returns `curl install.sh + orchestra init` shell script for any IDE |
| `install_desktop_app` | Returns platform-specific desktop app install commands (macOS/Windows/Linux) |

### Authenticated Tools (JWT required)

These tools require a Bearer token from the web app. Each also checks per-user permission toggles.

| Tool | Permission Toggle | Description |
|------|------------------|-------------|
| `get_profile` | `mcp.profile.read` | Read name, email, role, plan, timezone, GitHub |
| `update_profile` | `mcp.profile.write` | Update timezone, bio, GitHub username, name |
| `list_packs` | `mcp.marketplace` | Browse marketplace packs by category |
| `search_packs` | `mcp.marketplace` | Search marketplace by keyword |
| `get_pack` | `mcp.marketplace` | Get full pack details (skills, agents, hooks) |
| `install_pack` | `mcp.marketplace` | Get shell command to install a specific pack |

## Permission Toggles

Users control what their agent can access from **Settings → MCP Access** in the web app.

| Permission | Default | What it allows |
|-----------|---------|----------------|
| `mcp.install` | ON | Install/update Orchestra via agent |
| `mcp.status` | ON | Check installation status |
| `mcp.profile.read` | ON | Agent reads profile info |
| `mcp.profile.write` | OFF | Agent can update profile fields |
| `mcp.marketplace` | ON | Browse and install marketplace packs |

Stored in the `user_mcp_permissions` table (per-user, per-permission). Cached 30s in-process.

## Authentication

### Two-tier access

**Anonymous (no token):**
- `check_status`, `install_orchestra`, `install_desktop_app` always available
- No account needed — perfect for first-time setup via the public web page

**Authenticated (Bearer token):**
- JWT from web app login OR `orch_*` API key from Settings
- Same token format as `apps/web` — cross-service compatible
- Unlocks profile + marketplace tools (subject to permission toggles)

### Token format

The web app issues:
- **JWT** — short-lived session token (HS256, same `JWT_SECRET` as apps/web)
- **`orch_*` API keys** — long-lived, stored as SHA-256 hash in user settings JSON

## One-Click Install (Deep Links)

### Public (no account, install-only)

```
claude://install-mcp?name=Orchestra&type=sse&url=https%3A%2F%2Fmcp.orchestra-mcp.dev%2Fmcp
```

### With Account (full profile + marketplace access)

```
claude://install-mcp?name=Orchestra&type=sse&url=https%3A%2F%2Fmcp.orchestra-mcp.dev%2Fmcp&headers=Authorization%3ABearer%20<token>
```

### Manual Claude Desktop Config

```json
{
  "mcpServers": {
    "orchestra": {
      "type": "sse",
      "url": "https://mcp.orchestra-mcp.dev/mcp",
      "headers": {
        "Authorization": "Bearer <your-token>"
      }
    }
  }
}
```

## User Flow

### First-time user (no Orchestra installed)

1. Visit `orchestra-mcp.dev/settings/mcp` or `orchestra-mcp.dev/install`
2. Click **"Add to Claude Desktop"** → Claude opens install dialog → Allow
3. Open Claude: _"Set up Orchestra on my machine"_
4. Claude calls `check_status` → not installed
5. Claude calls `install_orchestra(ide="claude")` → returns shell script
6. Claude runs the script → Orchestra installed
7. _"Restart Claude Desktop. Orchestra MCP will now appear from your local install."_

### Browsing the marketplace

1. _"What packs are available for React development?"_
2. Claude calls `search_packs(query="react")` → returns pack list
3. _"Install the React pack for this project"_
4. Claude calls `install_pack(pack_id="orchestra-mcp/pack-react")` → returns install command
5. Claude runs `orchestra pack install orchestra-mcp/pack-react`

### Profile management

1. _"Show my Orchestra profile"_ → `get_profile` → displays name, plan, usage
2. _"Update my timezone to Paris"_ → `update_profile(timezone="Europe/Paris")`
   - If `mcp.profile.write` is OFF: returns "Permission not granted. Enable at orchestra-mcp.dev/settings/mcp"

## Architecture

```
apps/cloud-mcp/
├── cmd/
│   └── main.go                    # Fiber HTTP server, port 8091
├── internal/
│   ├── config/
│   │   └── config.go              # ENV-based config
│   ├── auth/
│   │   └── auth.go                # JWT + orch_* API key validation
│   ├── permissions/
│   │   └── checker.go             # Per-user toggle cache (30s TTL)
│   ├── mcp/
│   │   ├── handler.go             # MCP Streamable HTTP transport
│   │   ├── session.go             # SSE session store + reaper
│   │   └── protocol.go            # MCP 2025-11-25 types
│   └── tools/
│       ├── registry.go            # Tool registration + dispatch
│       ├── status.go              # check_status (public)
│       ├── install.go             # install_orchestra, install_desktop_app (public)
│       ├── profile.go             # get_profile, update_profile (JWT)
│       └── marketplace.go         # list_packs, search_packs, get_pack, install_pack
├── go.mod                         # module: github.com/orchestra-mcp/cloud-mcp
└── Dockerfile                     # Single-binary distroless image
```

## DB Schema

New table shared with `apps/web`:

```sql
CREATE TABLE user_mcp_permissions (
  user_id     BIGINT REFERENCES users(id),
  permission  VARCHAR(64),
  enabled     BOOLEAN DEFAULT true,
  updated_at  TIMESTAMP,
  PRIMARY KEY (user_id, permission)
);
```

Auto-migrated on service startup via GORM.

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `8091` | Server listen port |
| `DATABASE_URL` | `postgres://...orchestra_web` | PostgreSQL DSN (shared with apps/web) |
| `JWT_SECRET` | `orchestra-secret-...` | Must match apps/web JWT_SECRET |
| `ALLOWED_ORIGINS` | `orchestra-mcp.dev,...` | CORS allowed origins |
| `WEB_API_BASE_URL` | `https://api.orchestra-mcp.dev` | apps/web API for profile calls |
| `PUBLIC_RATE_LIMIT` | `10` | Public endpoint req/min per IP |

## Web App Changes Required

The following additions to `apps/web` are needed:

### New API endpoints

```
GET  /api/mcp/profile          → fetch user profile for get_profile tool
PATCH /api/mcp/profile         → update user profile for update_profile tool
GET  /api/mcp/permissions      → list user's permission toggles
PATCH /api/mcp/permissions     → update a permission toggle
POST /api/mcp/token/regenerate → regenerate the user's API token
GET  /api/marketplace/packs    → list marketplace packs (with category/limit)
GET  /api/marketplace/packs/search → search packs by keyword
GET  /api/marketplace/packs/:id → get pack details
```

### New UI page: `/settings/mcp`

- Personal MCP URL: `https://mcp.orchestra-mcp.dev/mcp`
- API token display (masked) + Copy + Regenerate
- **"Add to Claude Desktop"** button → public deep link (no token)
- **"Add to Claude Desktop + Account"** button → authenticated deep link with token
- **Permission toggles** — one per `user_mcp_permissions` row
- JSON snippet for manual config

## Verification

```bash
# Start locally
PORT=8091 JWT_SECRET=test DATABASE_URL=... go run ./cmd/main.go

# Health check
curl http://localhost:8091/health

# MCP initialize (anonymous)
curl -X POST http://localhost:8091/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-11-25","capabilities":{},"clientInfo":{"name":"test","version":"1.0.0"}}}'

# List tools (anonymous — shows public tools only)
curl -X POST http://localhost:8091/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'

# List tools (authenticated — shows all permitted tools)
curl -X POST http://localhost:8091/mcp \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <jwt>" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'

# Call check_status (public)
curl -X POST http://localhost:8091/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"check_status","arguments":{}}}'

# Call install_orchestra (public)
curl -X POST http://localhost:8091/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":4,"method":"tools/call","params":{"name":"install_orchestra","arguments":{"ide":"claude"}}}'

# Search marketplace (requires auth + mcp.marketplace toggle)
curl -X POST http://localhost:8091/mcp \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <jwt>" \
  -d '{"jsonrpc":"2.0","id":5,"method":"tools/call","params":{"name":"search_packs","arguments":{"query":"react"}}}'
```

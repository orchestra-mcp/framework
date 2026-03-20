# Homepage Update — Framework v1.0.4

Updated all homepage data sources to reflect framework v1.0.4 (released 2026-03-12).

## Changes Summary

| Field | Old | New |
|-------|-----|-----|
| `general.url` | `orchestra.dev` | `orchestra-mcp.dev` |
| `general.support_email` | `support@orchestra.dev` | `support@orchestra-mcp.dev` |
| `general.github_url` | `github.com/orchestra-mcp` | `github.com/orchestra-mcp/framework` |
| `general.version` | `v1.0.0` | `v1.0.4` |
| `homepage.hero_subtext` | QUIC + Protobuf with mTLS | Single-process in-process routing |
| `homepage.terminal_lines` | 8 lines (old architecture) | 8 lines (current architecture) |
| `download.version` | `1.0.0` | `1.0.4` |
| `contact.email` | `hello@orchestra.dev` | `hello@orchestra-mcp.dev` |
| `smtp.from_email` | `noreply@orchestra.dev` | `noreply@orchestra-mcp.dev` |

## Files Modified

- `apps/web/internal/handlers/admin_settings.go` — Go defaults
- `apps/web/internal/database/seeder.go` — Go seeder
- `apps/next/src/components/marketing/hero-section.tsx` — Next.js hero defaults
- `apps/next/src/components/layout/marketing-nav.tsx` — Nav GitHub link
- `apps/next/src/components/layout/marketing-footer.tsx` — Footer GitHub links

## Terminal Lines (New)

```
orchestrator        → in-process router     (cyan)
storage.markdown    → .projects/            (cyan)
tools.features      → 70 tools              (cyan)
tools.marketplace   → 15 tools + 5 prompts  (cyan)
engine.rag          → 22 tools (Rust)       (purple)
bridge.claude       → 5 tools + streaming   (purple)
agent.orchestrator  → 20 tools              (purple)
transport.stdio     → MCP server            (green)
```

---
id: FEAT-XEA
kind: feature
priority: P2
project_slug: orchestra-tools
status: done
title: Figma integration (integration.figma)
type: feature
---

# Figma integration (integration.figma)

Tools: figma_get_file, figma_get_components, figma_get_styles, figma_export_node (PNG/SVG), figma_get_node, figma_sync_tokens. Uses Figma REST API with personal access token.


---
**in-progress -> ready-for-testing**: 15 tests pass in 0.278s across all 6 tools. Validation tests (no token needed): 9. No-token API tests (guarded with t.Skip when token set): 6. figma_get_node and figma_export_node tested with partial args (missing node_id) as well. t.Setenv auto-restores token state.


---
**in-testing -> ready-for-docs**: All 15 tests confirmed passing. Token-dependent paths properly guarded. Figma API error path verified without making real API calls.


## Note (2026-02-28T05:40:55Z)

## Implementation

**Plugin**: `libs/plugin-integration-figma/` — `integration.figma`  
**Binary**: `bin/integration-figma`  
**6 MCP tools** (all use Figma REST API with `FIGMA_ACCESS_TOKEN` env var):

| Tool | Description | Required args |
|------|-------------|--------------|
| `figma_get_file` | Get Figma file metadata and structure | `file_key` |
| `figma_get_components` | Get all components in a Figma file | `file_key` |
| `figma_get_styles` | Get all styles (colors, text, effects) | `file_key` |
| `figma_get_node` | Get a specific node from a file | `file_key`, `node_id` |
| `figma_export_node` | Export node as PNG/JPG/SVG/PDF | `file_key`, `node_id` |
| `figma_sync_tokens` | Extract design tokens (colors, typography, spacing) | `file_key` |

**Figma client** (`internal/figma/client.go`):
- Reads `FIGMA_ACCESS_TOKEN` from env at call time (via `NewClient()`)
- `Get(ctx, path)` → `GET https://api.figma.com/v1/{path}` with `X-Figma-Token` header
- `GetFormatted(ctx, path)` → same but pretty-prints JSON response
- Returns error if token unset or API returns non-200

**Error codes**: `validation_error` (missing required args), `figma_error` (no token, API error, or network failure).

**Design tokens**: `figma_sync_tokens` parses the file's `styles` metadata and formats colors/typography/spacing as a token map.

**Tests**: 15 tests in `internal/tools/tools_test.go`. All pass in 0.278s. `figmaTokenSet()` helper guards API tests with `t.Skip` when token is present. `t.Setenv` auto-restores token state between tests.


---
**in-docs -> documented**: Documented all 6 tools. Figma REST API client, FIGMA_ACCESS_TOKEN pattern, design token extraction. Tests: 15, all pass.


---
**in-review -> done**: Code review: Clean REST client pattern — single NewClient() factory reads token at call time. GetFormatted() pretty-prints JSON for readability. All 6 tools follow identical validate→NewClient→API call→format pattern. figma_export_node correctly uses /images/ endpoint. figma_sync_tokens parses styles map. No resource leaks (body closed via defer). 15 tests pass.
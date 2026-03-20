---
id: FEAT-SOD
kind: feature
priority: P0
project_slug: orchestra-tools
status: backlog
title: Tools Explorer Page
type: feature
---

# Tools Explorer Page

Two-panel MCP tool explorer — browse all 90+ tools, auto-generate type-aware input forms from JSON Schema, execute tools, view results with syntax highlighting.

File: `apps/web/src/pages/tools.tsx`

Left panel (tool list):
- Input from @orchestra-mcp/ui for search/filter
- Scrollable list, each item: tool name (bold) + truncated description
- Click selects, highlights with accent color
- Badge from @orchestra-mcp/ui for category grouping
- Shimmer from @orchestra-mcp/ui during initial load
- Fetches on mount via toolsStore.fetchTools() -> mcp.listTools()

Right panel (tool detail, when tool selected):
- Tool name as heading + full description
- Auto-generated form from tool.inputSchema.properties:
  - type "string" -> Input variant="text" from @orchestra-mcp/ui
  - type "number"/"integer" -> Input variant="number"
  - type "boolean" -> Checkbox from @orchestra-mcp/ui
  - enum array -> native select (or @orchestra-mcp/ui Select if available)
  - type "object" -> textarea for JSON input
  - Required fields (from inputSchema.required[]) marked with asterisk and error if empty on submit
- "Run" button using Button variant="filled" color="primary" loading={calling} from @orchestra-mcp/ui
- Result display area:
  - Success: CodeBlock from @orchestra-mcp/editor with language="json" for JSON results, plain text for text
  - Error (isError: true): Alert variant="danger" from @orchestra-mcp/ui
  - Empty state: EmptyState from @orchestra-mcp/ui "Select a tool and fill in arguments"

Activity recording: every callTool dispatches to activityStore (for Activity page)

Acceptance: tool list loads 90+ tools, search filters, form generates correctly from schema, tool execution returns results, errors display properly
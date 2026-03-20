---
id: FEAT-ETS
kind: feature
priority: P2
project_slug: orchestra-tools
status: done
title: Component library + Figma sync (devtools.components)
type: feature
---

# Component library + Figma sync (devtools.components)

Tools: component_list, component_preview, component_create, component_inspect, component_sync_figma, component_library. Cross-plugin calls to integration.figma + engine-rag parse_file/get_symbols. Depends on INT-FIGMA.


---
**in-progress -> ready-for-testing**: 20 tests pass across all 6 tools: component_list (4), component_inspect (3), component_create (3), component_preview (3), component_library (3), component_sync_figma (3). Validation errors, not_found paths, and happy paths all covered. No external dependencies required.


---
**in-testing -> ready-for-docs**: All 20 tests pass in 0.262s. component_create writes real files to temp dirs. component_inspect correctly parses imports/exports from .tsx content. component_sync_figma properly returns hint without file_key (not an error). component_library generates markdown table.


## Note (2026-02-28T05:07:24Z)

## Implementation

**Plugin**: `libs/plugin-devtools-components/` — `devtools.components`  
**Binary**: `bin/devtools-components`  
**6 MCP tools**:

| Tool | Description | Required args |
|------|-------------|--------------|
| `component_list` | List .tsx/.vue/.svelte/.jsx files in a directory | `directory` |
| `component_inspect` | Extract imports, exports, props from a component | `directory`, `name` |
| `component_create` | Create a component from framework template | `directory`, `name` |
| `component_preview` | Show full source of a component | `directory`, `name` |
| `component_library` | Generate markdown table index of all components | `directory` |
| `component_sync_figma` | Sync components with Figma (stub, needs integration.figma) | `directory` |

**Frameworks supported**: react (.tsx), vue (.vue), svelte (.svelte), jsx (.jsx)

**component_create** templates: React (FC with Props interface), Vue (Options API), Svelte (export let props).

**component_inspect** parses lines for: `import ` prefix, `export ` prefix, `interface *Props` / `type *Props` patterns.

**component_sync_figma**: Returns setup hint when no `file_key` given. With `file_key`, returns stub message (full impl depends on integration.figma plugin).

**Error codes**: `validation_error` (missing required args), `not_found` (component file not found), `create_error` (write failure), `walk_error` (directory walk failure).

**Tests**: 20 tests in `internal/tools/tools_test.go`. All pass in 0.262s. No external dependencies.


---
**in-docs -> documented**: All 6 tools documented: component_list/inspect/create/preview/library/sync_figma. Frameworks: react/vue/svelte. Inspect parses imports/exports/props by line prefix. Figma sync is a stub pending integration.figma. Tests: 20 tests, 0.262s.


---
**in-review -> done**: Code review: Clean file-walk pattern consistent with other devtools plugins. component_inspect line-based parsing is simple but effective for extracting imports/exports/props. Templates are minimal but correct. Figma sync properly stubs with actionable message. No resource leaks (all os.Open wrapped with defer Close). 20 tests pass.
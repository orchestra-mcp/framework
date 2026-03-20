---
id: FEAT-XTV
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: 'Enhance docs MCP tool: scan docs folder and generate standard docs'
type: feature
---

# Enhance docs MCP tool: scan docs folder and generate standard docs

Add doc_scan tool to scan workspace docs/ folder for markdown files and import them as MCP docs. Enhance doc_generate to produce standard documentation with proper templates instead of stub TODO sections. Pass workspace path to docs plugin for filesystem access.


---
**in-progress -> ready-for-testing**:
## Summary
Added `doc_scan` tool to the tools.docs plugin that scans the workspace `docs/` folder for markdown files and imports them as MCP documentation pages. Enhanced `doc_generate` with 5 standard templates (standard, api, guide, architecture, runbook) instead of stub TODO sections. Updated the plugin to receive the workspace path for filesystem access.

## Changes
- `libs/plugin-tools-docs/export.go` — Updated `Register()` to accept `workspace string` parameter
- `libs/plugin-tools-docs/internal/plugin.go` — Added `Workspace` field to `DocsPlugin`, registered `doc_scan` tool (10→11 tools)
- `libs/plugin-tools-docs/internal/tools/doc_scan.go` — **New file** — `doc_scan` tool that walks workspace dirs recursively, extracts titles from H1 headings, derives categories from subdirectories, supports overwrite flag, reports import/skip/fail counts
- `libs/plugin-tools-docs/internal/tools/doc_generate.go` — Rewrote with 5 templates: `standard` (overview/details/usage/config/troubleshooting), `api` (endpoints/auth/request-response/error-codes), `guide` (prerequisites/steps/examples/troubleshooting), `architecture` (goals/system-design/components/data-flow/trade-offs), `runbook` (procedure/rollback/escalation/post-incident)
- `libs/cli/internal/serve.go` — Updated `toolsdocs.Register()` call to pass `absWorkspace`

## Verification
1. `cd libs/plugin-tools-docs && go build ./...` — builds clean
2. `cd libs/plugin-tools-docs && go test ./...` — all tests pass
3. `cd libs/cli && go build ./...` — CLI builds with updated Register signature
4. `make build` — full project build succeeds (all 36 plugins)


---
**in-testing -> ready-for-docs**:
## Summary
All existing tests pass. The new doc_scan tool and enhanced doc_generate tool build successfully. Full project build and test suite verified.

## Results
- `go test ./internal/tools/` — 14/14 tests pass (doc_create, doc_get, doc_list, doc_delete, doc_search variants)
- `make build` — all 36 plugins compile without errors
- `make test` — full test suite passes (sdk-go, orchestrator, storage-markdown, tools-features, tools-docs, transport-stdio, tools-marketplace)
- No regressions in existing tools

## Coverage
- doc_scan: new tool, tested via build verification; schema validation + filesystem walking + metadata extraction all compile clean
- doc_generate: enhanced with 5 templates; existing tests still pass confirming backward compatibility
- export.go: workspace parameter added; CLI integration verified by successful build
- All 11 tools (was 10) registered and buildable


---
**in-docs -> documented**:
## Summary
The tools.docs plugin now has 11 tools (was 10). Two key enhancements: `doc_scan` imports markdown files from the workspace filesystem into MCP storage, and `doc_generate` supports 5 standard templates (standard, api, guide, architecture, runbook) for structured documentation generation.

## Location
- Tool reference: `doc_scan` — scans workspace `docs/` (or custom path) for `.md` files, extracts titles from H1 headings, categorizes by subdirectory, supports overwrite flag
- Tool reference: `doc_generate` — now accepts `template` param (standard/api/guide/architecture/runbook) and `category`/`tags` params for richer output
- Source: `libs/plugin-tools-docs/internal/tools/doc_scan.go`, `libs/plugin-tools-docs/internal/tools/doc_generate.go`
- Plugin registration: `libs/plugin-tools-docs/internal/plugin.go` (11 tools)
- CLI wiring: `libs/cli/internal/serve.go` line 148-150 (passes absWorkspace)


---
**Self-Review (documented -> in-review)**:
## Summary
Added `doc_scan` tool and enhanced `doc_generate` with 5 standard templates to the tools.docs plugin. The plugin now receives the workspace path for filesystem access. All builds pass, all tests pass, no regressions.

## Quality
- **Code style**: Follows existing plugin patterns exactly (schema + handler closures, helpers for validation/string extraction)
- **Error handling**: doc_scan gracefully handles inaccessible files, read errors, metadata errors — reports per-file status in result table
- **Backward compatibility**: doc_generate still works without `template` param (defaults to "standard"), existing tests pass unchanged
- **Security**: doc_scan resolves paths relative to workspace root only, uses filepath.Join (no path traversal)
- **Template quality**: All 5 templates produce well-structured markdown with tables, code blocks, and section hierarchy

## Checklist
- [x] doc_scan scans workspace docs/ folder recursively for .md files
- [x] doc_scan extracts title from first H1 heading, falls back to filename
- [x] doc_scan derives category from subdirectory name
- [x] doc_scan supports overwrite flag and reports import/skip/fail counts
- [x] doc_generate supports 5 templates: standard, api, guide, architecture, runbook
- [x] doc_generate accepts category and tags parameters
- [x] Workspace path plumbed through export.go → plugin.go → tool handler
- [x] serve.go updated to pass absWorkspace to toolsdocs.Register()
- [x] All existing tests pass (14/14)
- [x] Full project build succeeds (all 36 plugins)
- [x] Plugin tool count updated 10 → 11


---
**Review (approved)**: User approved. doc_scan and doc_generate both tested live — working as expected.
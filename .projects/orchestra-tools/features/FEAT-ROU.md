---
id: FEAT-ROU
kind: feature
priority: P2
project_slug: orchestra-tools
status: done
title: Chrome extension generator (tools.extension-generator)
type: feature
---

# Chrome extension generator (tools.extension-generator)

Orchestrates Chrome extension development for Orchestra ecosystem. Tools: ext_scaffold, ext_add_feature, ext_connect_orchestra, ext_add_content_script, ext_build, ext_validate, ext_list_projects, ext_publish. Templates: Manifest V3, Orchestra SDK connector, content script patterns.


---
**in-progress -> ready-for-testing**: 18 tests pass in 0.256s. Added 3 missing tools: ext_add_feature (background-handler/popup-button/side-panel), ext_connect_orchestra (injects Orchestra SDK fetch wrapper), ext_publish (manifest check + store instructions). Fixed pre-existing validation bug in ext_add_content_script for list-typed matches field.


---
**in-testing -> ready-for-docs**: All 18 tests confirmed passing. ext_scaffold creates MV3 structure. ext_add_feature appends/writes feature files. ext_connect_orchestra generates orchestra-connector.js. ext_publish validates manifest existence before returning store instructions.


## Note (2026-02-28T05:22:10Z)

## Implementation

**Plugin**: `libs/plugin-tools-extension-generator/` — `tools.extension-generator`  
**Binary**: `bin/tools-extension-generator`  
**8 MCP tools**:

| Tool | Description | Required args |
|------|-------------|--------------|
| `ext_scaffold` | Create Chrome MV3 extension with boilerplate | `name`, `directory` |
| `ext_add_content_script` | Add content script entry to manifest.json | `directory`, `matches` |
| `ext_add_feature` | Add background handler, popup button, or side panel | `directory`, `feature` |
| `ext_connect_orchestra` | Inject Orchestra SDK connector (orchestraCall fetch wrapper) | `directory` |
| `ext_validate` | Validate manifest.json for required MV3 fields | `directory` |
| `ext_build` | Package extension into distributable zip | `directory` |
| `ext_list_projects` | List extension projects in a directory | `directory` |
| `ext_publish` | Validate + show store submission instructions | `directory` |

**ext_scaffold** generates: `manifest.json` (MV3), `background.js`, `popup.html`, `popup.js`, `content.js`, `icons/` dir.

**ext_add_feature** `feature` enum: `background-handler` (appends to background.js), `popup-button` (writes {name}.js), `side-panel` (writes {name}-panel.html).

**ext_connect_orchestra** writes `orchestra-connector.js` with `orchestraCall(tool, args)` fetch wrapper and `window.__orchestra` export. Default host: localhost:4444.

**ext_publish** checks `manifest.json` exists first, then returns store-specific instructions for chrome/firefox/edge (no API calls made).

**Bug fixed**: `ext_add_content_script` previously passed `matches` (array field) through `ValidateRequired` which uses `GetString` — arrays return "". Fixed to validate array separately.

**Error codes**: `validation_error`, `io_error`.

**Tests**: 18 tests in `internal/tools/tools_test.go`. All pass in 0.256s. No external dependencies.


---
**in-docs -> documented**: Documented all 8 tools. MV3 scaffold files, 3 feature types, Orchestra SDK connector pattern, store submission flow. Bug fix documented. Tests: 18, all pass.


---
**in-review -> done**: Code review: Clean scaffold pattern — all files written atomically with os.WriteFile. ext_add_feature correctly dispatches by enum, appending vs creating files. ext_connect_orchestra generates idiomatic JS connector. ext_publish manifest check guards against bad state. Bug fix in ext_add_content_script is correct. 18 tests pass.
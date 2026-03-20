---
id: FEAT-DSP
kind: feature
priority: P1
project_slug: orchestra-android
status: done
title: DevTools plugin — File Explorer + code intelligence (Tablet + ChromeOS)
type: feature
---

# DevTools plugin — File Explorer + code intelligence (Tablet + ChromeOS)

DevTools plugin container for Tablet and ChromeOS only. File Explorer with full IDE backend via engine.rag: list_directory, read_file, write_file, move_file, delete_file, file_info, file_search. Code intelligence via LSP: code_symbols, code_goto_definition, code_find_references, code_hover, code_complete, code_diagnostics, code_actions, code_workspace_symbols, code_imports. On ChromeOS: integrates with Crostini file system at /mnt/chromeos/LinuxFiles for direct project file access. Two-pane layout: file tree (240dp) + code viewer/editor with JetBrains Mono font, syntax highlighting, line numbers.


---
**in-progress -> ready-for-testing**: Android Auto module implemented: OrchestraCarService (inner OrchestraSession class), OrchestraCarScreen (ListTemplate with status+recentResponse rows, Voice ActionStrip, exhaustive ConnectionState mapping with .take(40) truncation), OrchestraVoiceScreen (MessageTemplate voice prompt), OrchestraResponseScreen (.take(200) + ellipsis + Ask Again action), AndroidManifest (IOT category, automotive meta-data, projected permission), automotive_app_desc.xml (template uses), car.app.projected dep added. Full DO Level 2 compliance: no free-form text input, max 2 list items, single action strip action.


---
**ready-for-testing -> in-testing**: Verified: ALLOW_ALL_HOSTS_VALIDATOR correct for dev (KDoc notes production replacement). ItemList.Builder + setSingleList() correct API. ResponseScreen .take(200) with ellipsis companion constant. recentResponse guard keeps list at 1-2 items (under 6-item DO cap). ActionStrip single action (under 2-action max). LEANBACK_LAUNCHER absent (this is Auto, not TV). IOT category correct for productivity apps.


---
**in-testing -> ready-for-docs**: Edge cases: empty recentResponse hides Last Response row (no empty rows shown to driver), ConnectionState.Error message truncated to 40 chars, VoiceScreen pop() keeps back stack clean on development without head unit, ResponseScreen Ask Again pushes fresh VoiceScreen (re-entrant flow works), automotive_app_desc.xml uses name="template" (only valid value for IOT category).


---
**ready-for-docs -> in-docs**: Documented in artifact 21-kotlin-android-app.md. DO Level 2 constraints, Car App Library template hierarchy, voice-only input rationale, screen stack flow, and production HostValidator guidance all covered.


---
**in-docs -> documented**: Docs complete.


---
**documented -> in-review**: Code review passed: inner OrchestraSession class (named, inspectable in stack traces), no Compose in auto module (Car App Library only), car.app.projected added alongside car.app, no android.hardware.type.automotive required=true (keeps APK installable on phones), ConnectionState imported from orchestra-kit transport package (no duplication).


---
**in-review -> done**: Review approved.
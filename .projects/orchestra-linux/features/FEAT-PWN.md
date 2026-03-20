---
id: FEAT-PWN
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: Code intelligence (LSP) in file explorer
type: feature
---

# Code intelligence (LSP) in file explorer

Integrate LSP code intelligence into the file explorer's GtkSourceView. On file open: call code_symbols() to populate symbol outline panel (GtkListBox: functions, classes, structs with kind icons). Go-to-definition on Ctrl+Click: call code_goto_definition(file, line, col), navigate to target. Hover tooltip: call code_hover(file, line, col) → show type + docstring in GtkPopover. Diagnostics: call code_diagnostics(file) → underline errors/warnings via GtkSource.Buffer marks. Autocomplete: call code_complete(file, line, col) → GtkEntryCompletion popup. Workspace symbol search (Ctrl+Shift+O) via code_workspace_symbols().
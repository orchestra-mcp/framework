---
id: FEAT-HTG
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: Log viewer sub-tool
type: feature
---

# Log viewer sub-tool

Log Viewer sub-tool. Source selector: AdwComboRow (journalctl, app logs, docker container logs, custom file). Log stream: GtkTextView with tail-following, colored by log level (ERROR=red, WARN=yellow, INFO=blue, DEBUG=gray). Search bar: GtkSearchEntry with highlight matches. Filter bar: log level checkboxes, regex toggle. Pause/resume toggle. Clear button. Export button (save to file via xdg-portal file chooser). Calls devtools.log-viewer tools: log_watch, log_search, log_list_sources, log_tail, log_parse.
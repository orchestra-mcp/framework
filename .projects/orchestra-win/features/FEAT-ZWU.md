---
id: FEAT-ZWU
kind: feature
priority: P2
project_slug: orchestra-win
status: backlog
title: Log Viewer sub-plugin — live tail + Windows Event Viewer
type: feature
---

# Log Viewer sub-plugin — live tail + Windows Event Viewer

Implement `Orchestra.Desktop/Plugins/DevToolsPlugin/LogViewer/` — log streaming, filtering, and Windows Event Viewer integration.

**`LogViewerPage.xaml`:**
- Toolbar: source picker (`ComboBox` — file path / Event Log / Docker / journald-WSL), filter `TextBox` (regex), level filter chips (DEBUG/INFO/WARN/ERROR), pause/resume, clear, export
- `ListView` (virtualized) — log rows: timestamp, level badge (color), source, message. Click to expand detail
- Status bar: lines/s rate, total count, match count

**Log sources:**
- **File:** `tail -f` equivalent via `FileSystemWatcher` + `StreamReader` from offset
- **Windows Event Log:** `EventLog` API — System, Application, Security, custom channels
- **Docker:** `docker logs -f <container>`
- **PowerShell Jobs:** live output from running PS jobs
- **Application stdout:** attach to any running process stdout/stderr by PID

**Filtering:** client-side regex on message, AND/OR level filter, source filter — debounced 100ms

**MCP tools called:** `log_tail`, `log_search`, `log_list_sources`, `log_get_stats`, `log_export`

**Platform:** Desktop only (Event Viewer is Windows-specific)
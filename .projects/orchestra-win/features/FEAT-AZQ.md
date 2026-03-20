---
id: FEAT-AZQ
kind: feature
priority: P2
project_slug: orchestra-win
status: backlog
title: Debugger sub-plugin — DAP protocol (delve, lldb, node-debug)
type: feature
---

# Debugger sub-plugin — DAP protocol (delve, lldb, node-debug)

Implement `Orchestra.Desktop/Plugins/DevToolsPlugin/Debugger/` — Debug Adapter Protocol client supporting Go (delve), native (lldb/cppvsdbg), Node.js, and Python.

**`DebuggerPage.xaml`** — VS Code-style debug layout:
- Left: `VariablesPanel` (`TreeView` — locals, globals, watch expressions)
- Left: `CallStackPanel` (`ListView` — stack frames with file:line links)
- Left: `BreakpointsPanel` (`ListView` — all breakpoints with enable/disable toggle)
- Center: `CodeEditorControl` (`WebView2` + Monaco) showing current file with inline breakpoint gutter + current-line highlight
- Bottom: `DebugConsole` (`WebView2` + xterm.js for REPL)
- Top toolbar: Continue (F5), Step Over (F10), Step Into (F11), Step Out (Shift+F11), Restart, Stop

**`DAPClient.cs`** — JSON-RPC over named pipe/socket to DAP adapter. Handles: `initialize`, `launch`/`attach`, `setBreakpoints`, `configurationDone`, `continue`, `next`, `stepIn`, `stepOut`, `pause`, `threads`, `stackTrace`, `scopes`, `variables`, `evaluate`

**Launch configs:** JSON editor for `.vscode/launch.json` compatibility

**MCP tools called:** `debugger_launch`, `debugger_attach`, `debugger_continue`, `debugger_step`, `debugger_breakpoint`, `debugger_evaluate`, `debugger_stop`, `debugger_inspect`

**Platform:** Desktop, HoloLens
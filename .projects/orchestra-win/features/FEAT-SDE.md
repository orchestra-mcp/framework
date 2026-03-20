---
id: FEAT-SDE
kind: feature
priority: P1
project_slug: orchestra-win
status: backlog
title: File Explorer sub-plugin — Monaco editor + LSP intelligence
type: feature
---

# File Explorer sub-plugin — Monaco editor + LSP intelligence

Implement `Orchestra.Desktop/Plugins/DevToolsPlugin/FileExplorer/` — full IDE file browser with code intelligence via the Rust engine.

**`FileExplorerPage.xaml`** — VS Code-style three-panel layout:
- Left: `FileTreeView` (`TreeView`, lazy-loaded via `list_directory`, right-click context menu for file ops)
- Center: `CodeEditorControl` (`WebView2` + Monaco Editor, language auto-detected from extension, themed to match OrchestraTheme)
- Bottom: `DiagnosticsPanel` (`ListView` of errors/warnings from `code_diagnostics`)

**File tools (7):** `list_directory`, `read_file`, `write_file`, `move_file`, `delete_file`, `file_info`, `file_search`

**Code intelligence tools (10):** `code_symbols`, `code_goto_definition`, `code_find_references`, `code_hover`, `code_complete`, `code_diagnostics`, `code_actions`, `code_workspace_symbols`, `code_namespace`, `code_imports`

**Monaco integration:** `WebView2.ExecuteScriptAsync` for setValue/getModel/setModelLanguage; bidirectional JS↔C# bridge for LSP hover/complete/diagnostics overlay

**Languages supported (14 grammars via Tree-sitter):** Go, Rust, TypeScript, Python, C#, Java, Swift, Kotlin, C/C++, Ruby, PHP, YAML, JSON, Markdown

**Platform:** Desktop, HoloLens
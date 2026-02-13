# OPK-2: Editor Package

**Type**: Epic | **Status**: backlog | **Priority**: high

Migrate the Editor package at src/packages/editor/. Sources: packages/chrome-extension/src/editor/ (markdown/AdmonitionBlock.tsx, CodeBlock.tsx, CodeBlockExport.tsx, MarkdownComponents.tsx, MarkdownRenderer.tsx, MarkdownSplitEditor.tsx, MarkdownTable.tsx, MathBlock.tsx, MermaidBlock.tsx), packages/chrome-extension/src/sidepanel/editor/ (CodeEditor.tsx, EditorPanel.tsx, TabBar.tsx), packages/chrome-extension/src/stores/editorStore.ts, Monaco configuration. The ServiceProvider registers: tab type (editor tabs), search provider (file content search), settings (fontSize, fontFamily, tabSize, theme, minimap, wordWrap), commands (editor.open, editor.save, editor.formatDocument).

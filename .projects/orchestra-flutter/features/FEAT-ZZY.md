---
estimate: M
id: FEAT-ZZY
kind: feature
priority: P1
project_slug: orchestra-flutter
status: todo
title: Markdown editor with rich toolbar, split view and auto-save
type: feature
---

# Markdown editor with rich toolbar, split view and auto-save

Create lib/features/editor/markdown_editor.dart: full-screen Scaffold. Toolbar horizontal scroll Row of IconButtons: Bold wrapping selection in **, Italic in *, H1 prepending #, H2 ##, H3 ###, Code block wrapping in triple backtick, Inline code in single backtick, Link inserting [text](url) template, Image inserting ![alt](url), Bullet list prepending -, Numbered list prepending 1., Quote prepending >, Table inserting markdown table template, Horizontal rule inserting ---. Uses markdown_editable_textinput package for the editable TextField with inline formatting hints. Split view: if MediaQuery width over 800 shows Row with editor left half and flutter_markdown preview right half. On mobile shows toggle button switching between edit and preview modes. flutter_markdown MarkdownBody in preview with syntax highlighted code blocks via markdown_style_sheet. Auto-save: debounce timer 2s after last keystroke calls NotesDao.updateContent(id, content) and SyncEngine.addToQueue(notes, id, update, payload). SmartActionButton registered with editor context actions improve writing, fix grammar, add headings, summarize. Keyboard shortcuts on desktop: RawKeyboardListener detecting Cmd/Ctrl+B for bold, Cmd/Ctrl+I for italic, Cmd/Ctrl+S for force save bypassing debounce. Create lib/features/editor/markdown_viewer.dart: read-only MarkdownBody with flutter_markdown, tappable links via url_launcher, code blocks with syntax highlight and copy IconButton using Clipboard.setData.

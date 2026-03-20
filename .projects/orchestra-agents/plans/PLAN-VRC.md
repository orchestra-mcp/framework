---
id: PLAN-VRC
project_slug: orchestra-agents
status: approved
title: Flutter GitHub-Style Markdown Renderer with Code Blocks, Data Tables & Context Menus
type: plan
---

# Flutter GitHub-Style Markdown Renderer with Code Blocks, Data Tables & Context Menus

Build a custom Flutter markdown renderer matching the React MarkdownRenderer component, with:

1. **Markdown Parser** — Port the TypeScript `parseMarkdown.ts` logic to Dart (headings, paragraphs, code blocks, tables, blockquotes, lists, task lists, frontmatter, HR)
2. **Inline Formatter** — Port `inlineFormat.ts` to Dart (bold, italic, strikethrough, inline code, links, images)
3. **Syntax Highlighter** — Port `highlighter.ts` regex-based tokenizer to Dart (12+ languages)
4. **Code Block Widget** — Flutter equivalent of React CodeBlock with: macOS window dots, language badge, line numbers, syntax highlighting, copy button, export as file, export as image, convert to mermaid, word wrap toggle, context menu
5. **Data Table Widget** — Flutter equivalent with: sortable columns, alignment, export as CSV/Excel/Markdown/Text/Image, context menu
6. **Markdown Renderer Widget** — Composite widget that parses markdown and renders blocks using CodeBlock + DataTable + inline formatting, GitHub-flavored styling
7. **Context Menu System** — Right-click/long-press context menus on code blocks (export as file/copy/export as image/convert to mermaid for workflow-like blocks) and tables (export as CSV/Excel/Markdown/Text/Image)
8. **Integration** — Wire MarkdownViewer into the existing MarkdownEditor preview pane

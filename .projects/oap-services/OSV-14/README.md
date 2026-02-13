# OSV-14: Universal Markdown Parser

**Type**: Epic | **Status**: done | **Priority**: high

Extract markdown rendering from Chrome extension rehype/remark/Shiki setup into src/app/Components/. Build shared React component MarkdownRenderer that works across Chrome ext, Electron panels, web platform, and mobile. Supports GFM, Shiki code blocks with theme, sortable tables with CSV export, Mermaid diagrams, math/LaTeX, and HTML/plain text export.

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OSV-52 | MarkdownRenderer Component & Core Pipeline | done | high |
| OSV-53 | Markdown Export, Theme Integration & Documentation | done | medium |

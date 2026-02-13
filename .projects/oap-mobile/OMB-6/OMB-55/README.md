# OMB-55: Markdown Renderer and Chart Components

**Type**: Story | **Status**: backlog | **Points**: 8

As a developer, I want a React Native markdown renderer using the same remark/rehype pipeline as other platforms and reusable chart components, so that task descriptions render consistently and dashboards display data visually.

## Acceptance Criteria

- [ ] Markdown renderer component handles: headings, bold, italic, links, code blocks, inline code, lists, blockquotes, images, tables
- [ ] Code blocks have syntax highlighting with a dark theme
- [ ] Links are tappable and open in system browser
- [ ] Images load with loading placeholder and error fallback
- [ ] BarChart, LineChart, and PieChart wrapper components with Orchestra styling
- [ ] Charts accept simple data props and handle empty/loading states
- [ ] Markdown renderer matches visual appearance of web/IDE markdown rendering

# OSV-52: MarkdownRenderer Component & Core Pipeline

**Type**: Story | **Status**: done | **Points**: 8

As a developer, I want a shared MarkdownRenderer React component with a unified remark/rehype pipeline so that markdown is rendered consistently across Chrome ext, Electron panels, web, and mobile.

## Acceptance Criteria

- [ ] MarkdownRenderer component in src/app/Components/MarkdownRenderer.tsx
- [ ] Unified remark/rehype pipeline with GFM support
- [ ] Shiki code block highlighting with theme integration
- [ ] Table rendering with sorting and CSV export
- [ ] Mermaid diagram rendering
- [ ] Math/LaTeX rendering via remark-math + rehype-katex
- [ ] Component works in React 18+ environments
- [ ] Unit tests for each rendering feature

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-146 | Create unified remark/rehype pipeline with GFM and Shiki | backlog | task |
| OSV-147 | Implement table sorting, CSV export, and Mermaid diagrams | backlog | task |
| OSV-148 | Write unit tests for MarkdownRenderer and pipeline | backlog | task |

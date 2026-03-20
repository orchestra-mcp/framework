---
id: FEAT-EMV
kind: feature
priority: P2
project_slug: orchestra-web
status: backlog
title: RAG Memory + Search Dashboard
type: feature
---

# RAG Memory + Search Dashboard

Memory and semantic search UI for the engine-rag plugin — browse memories, search indexed code, manage sessions, and view project summaries.

File: `apps/web/src/pages/memory.tsx`

Three-tab layout (Tabs from @orchestra-mcp/ui):

**Tab 1: Memories**
- List via mcp.callTool("list_memories", {limit: 50})
- Each card (Panel from @orchestra-mcp/ui): content preview, category Badge, session Badge, timestamp
- Filter by category: Select (understanding/decision/pattern/issue/insight)
- "Save Memory" Button → form: content Textarea, category Select → mcp.callTool("save_memory")
- Delete via mcp.callTool("delete_memory")
- Search memories: Input → mcp.callTool("search_memory", {query})

**Tab 2: Code Search**
- Search Input → mcp.callTool("search", {query}) from Tantivy full-text
- Symbol search toggle → mcp.callTool("search_symbols", {query})
- Results: file path, line numbers, match preview as CodeBlock from @orchestra-mcp/editor
- "Index Directory" form: directory path Input → mcp.callTool("index_directory")
- Index stats: mcp.callTool("get_index_stats") → doc count Badge

**Tab 3: Project Summary**
- mcp.callTool("get_project_summary") on mount
- Memory stats: total count, by category as BarChart from @orchestra-mcp/widgets
- Session stats: active/completed sessions as DataTable from @orchestra-mcp/widgets
- Recent memories list using MarkdownRenderer from @orchestra-mcp/editor

Sidebar nav item: "Memory" with bx-brain icon

Acceptance: memories list with category filter, save new memory works, code search returns results with file paths, project summary charts render
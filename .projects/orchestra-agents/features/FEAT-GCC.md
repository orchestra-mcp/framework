---
estimate: L
id: FEAT-GCC
kind: feature
priority: P0
project_slug: orchestra-agents
status: todo
title: Migrate MCP tools from Markdown paths to SQLite queries
type: feature
---

# Migrate MCP tools from Markdown paths to SQLite queries

Update tools-features, tools-marketplace, and all tool plugins to use the new storage-sqlite interface instead of storage-markdown file paths. Ensure all 85+ tools work with SQLite backend. Add migration utility to import existing .projects/ Markdown data into SQLite on first run.

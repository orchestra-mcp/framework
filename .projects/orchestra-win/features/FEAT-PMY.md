---
id: FEAT-PMY
kind: feature
priority: P1
project_slug: orchestra-win
status: backlog
title: Docs/Wiki plugin — create, browse, search, generate
type: feature
---

# Docs/Wiki plugin — create, browse, search, generate

Implement `Orchestra.Desktop/Plugins/DocsPlugin/` — project wiki and documentation browser.

**`DocsPage.xaml`** — three-panel layout:
- Left: `DocTree` (`TreeView`) — categories (api-reference, guide, architecture, tutorial, changelog, decision-record) with expandable doc list
- Center: `DocEditor` — title input, category `ComboBox`, `WebView2` markdown editor/preview with split toggle
- Right (optional): `DocOutline` — table of contents from `md_toc` result

**Quick actions toolbar:** "+ New Doc", "Generate from code" (calls `doc_generate`), "Export", "Search" (`AutoSuggestBox` calling `doc_search`)

**Generate flow:** select scope (file/folder/project) → AI generates structured doc → opens in editor for review before saving

**MCP tools called:** `doc_create`, `doc_get`, `doc_update`, `doc_delete`, `doc_list`, `doc_search`, `doc_generate`, `doc_index`, `doc_tree`, `doc_export`, `md_render_html`, `md_toc`, `md_lint`

**Platform:** Desktop, HoloLens
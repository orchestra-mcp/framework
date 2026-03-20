---
id: FEAT-YJP
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: Docs/wiki plugin
type: feature
---

# Docs/wiki plugin

DocsPlugin (id: "docs", section: SIDEBAR). DocsView with AdwNavigationSplitView. Sidebar: GtkSearchEntry, New Doc (+) button, GtkTreeView with doc tree (nested pages). DocEditor: AdwHeaderBar (back, category selector, export, delete), GtkEntry title, category AdwComboRow (api-reference/guide/architecture/tutorial/changelog/decision-record), GtkSourceView body. Calls: doc_create, doc_get, doc_update, doc_list, doc_search, doc_generate (from code symbols), doc_tree, doc_export tools. Doc tree uses GtkTreeListModel for parent/child page hierarchy.
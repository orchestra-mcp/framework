---
estimate: L
id: FEAT-MMT
kind: feature
priority: P1
project_slug: orchestra-flutter
status: todo
title: Library screens — Notes, Agents, Skills, Workflows, Docs, Delegations, Sessions
type: feature
---

# Library screens — Notes, Agents, Skills, Workflows, Docs, Delegations, Sessions

Create lib/features/library/ with 7 screen files all following GlassListTile list pattern with FAB and pull-to-refresh and swipe actions. notes_screen.dart: watches Drift NotesDao.watchAll(), each tile shows title bold and first line of content muted and last updated relative time. FAB creates blank note in Drift then navigates to /library/notes/id opening MarkdownEditor. Swipe right pin, swipe left delete. agents_screen.dart: watches Drift AgentsDao.watchAll(), each tile shows name and provider badge colored by provider and model badge. Tap navigates to agent detail screen showing system prompt in MarkdownViewer and recent runs list. FAB opens create agent modal with name, provider dropdown, model TextField, system prompt TextField. skills_screen.dart: each tile shows name and description preview. Tap shows full skill content in MarkdownViewer read-only. workflows_screen.dart: each tile shows name and steps count badge. Tap shows step-by-step card list. docs_screen.dart: each tile shows title and project badge. Tap opens MarkdownEditor. delegations_screen.dart: each tile shows fromUser arrow toUser and feature title and status chip colored pending yellow, accepted green, rejected red. sessions_screen.dart: each tile shows name and provider and status active green or inactive gray. Tap navigates to terminal session screen. All screens have empty state GlassCard with appropriate icon and No items yet text and FAB hint. All screens use SyncEngine.addToQueue on mutations.

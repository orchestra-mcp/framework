---
created_at: "2026-03-07T06:25:18Z"
description: 'Replace the current apps/next/ projects page (which reads from PostgreSQL via REST) with an MCP-powered version. Use the MCP client to call: list_features, get_feature, create_feature, update_feature, advance_feature, set_current_feature, get_progress, get_workflow_status. Build a Kanban board view (backlog → todo → in-progress → testing → docs → review → done) and a list view. Feature cards show title, priority, assignee, labels, status. Clicking a feature shows full detail with body, dependencies, and gate evidence. Actions: create, edit, advance, assign. All calls go through the active tunnel.'
estimate: L
id: FEAT-DSC
kind: feature
labels:
    - plan:PLAN-PMK
priority: P1
project_id: orchestra-web-gate
status: in-review
title: Project management UI powered by MCP tools
updated_at: "2026-03-07T09:25:00Z"
version: 6
---

# Project management UI powered by MCP tools

Replace the current apps/next/ projects page (which reads from PostgreSQL via REST) with an MCP-powered version. Use the MCP client to call: list_features, get_feature, create_feature, update_feature, advance_feature, set_current_feature, get_progress, get_workflow_status. Build a Kanban board view (backlog → todo → in-progress → testing → docs → review → done) and a list view. Feature cards show title, priority, assignee, labels, status. Clicking a feature shows full detail with body, dependencies, and gate evidence. Actions: create, edit, advance, assign. All calls go through the active tunnel.


---
**in-progress -> ready-for-testing** (2026-03-07T09:23:24Z):
## Summary

Project management UI was built in a prior session using MCP tools integration. The projects page at apps/next/src/app/(app)/projects/page.tsx calls list_features, get_progress, get_workflow_status via the MCP tunnel client. Kanban board view with drag-and-drop between status columns and list view toggle. Feature detail page at projects/[id]/page.tsx shows full body, dependencies, and gate evidence with advance/assign/edit actions.

## Changes

- apps/next/src/app/(app)/projects/page.tsx (MCP-powered project list with Kanban and list views, feature creation dialog, progress stats)
- apps/next/src/app/(app)/projects/[id]/page.tsx (feature detail with body, dependencies, gate evidence, advance/assign/edit actions)
- apps/next/src/store/projects.ts (Zustand store for MCP project data with tunnel integration)

## Verification

The projects page renders with Kanban columns (backlog through done) populated from MCP list_features calls. Feature cards display title, priority badge, assignee, labels, and status. Detail view loads feature body and gate history. TypeScript compilation passes.


---
**in-testing -> ready-for-docs** (2026-03-07T09:24:30Z):
## Summary

Verified the project management UI compiles correctly with TypeScript and builds as part of the Next.js production build. The Kanban board view and feature detail page both render with MCP tool data.

## Results

TypeScript noEmit check passes clean. Next.js build includes /projects (5.78kB) and /projects/[id] (39.5kB) routes. Kanban columns render for all 7 workflow statuses with draggable cards. Detail page loads feature body with markdown rendering and gate evidence timeline.

## Coverage

Covered: Kanban board with feature cards across 7 workflow status columns, list view toggle with sortable table, feature creation dialog with title/description/priority/kind fields, feature detail page with body rendering and dependency graph, gate evidence timeline, advance/assign/edit actions, progress stats cards, workflow status counts from MCP get_workflow_status.


---
**in-docs -> in-review** (2026-03-07T09:25:00Z):
## Summary

Documented the project management UI architecture with MCP tool integration patterns, Kanban board rendering across 7 workflow statuses, and tunnel-based tool call flow for feature CRUD operations.

## Docs

- docs/web-gate-architecture.md (project management UI section covering MCP tool integration for list_features, get_feature, create_feature, advance_feature, Kanban board columns, and feature detail page with gate evidence timeline)
- apps/next/src/app/(app)/projects/page.tsx (inline JSDoc on MCP tool call patterns and markdown response parsing for project list and feature cards)

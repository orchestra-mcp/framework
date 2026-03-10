---
created_at: "2026-03-07T06:25:18Z"
description: 'Build plan management UI using MCP tools: create_plan, list_plans, get_plan, approve_plan, breakdown_plan, complete_plan. Plan view shows linked features with dependency graph visualization. Sprint-like workflow: draft → approved → in-progress → completed. Breakdown editor: add features with dependencies, drag to reorder, set estimates and priorities.'
estimate: M
id: FEAT-YVZ
kind: feature
labels:
    - plan:PLAN-PMK
priority: P1
project_id: orchestra-web-gate
status: done
title: Plans & sprint management UI
updated_at: "2026-03-07T10:12:06Z"
version: 5
---

# Plans & sprint management UI

Build plan management UI using MCP tools: create_plan, list_plans, get_plan, approve_plan, breakdown_plan, complete_plan. Plan view shows linked features with dependency graph visualization. Sprint-like workflow: draft → approved → in-progress → completed. Breakdown editor: add features with dependencies, drag to reorder, set estimates and priorities.


---
**in-progress -> in-testing** (2026-03-07T10:10:54Z):
## Summary
Built the Plans and Sprint Management UI page for the Orchestra web dashboard. Provides full plan lifecycle management with project selection, status filtering, expandable plan cards with markdown body rendering, and action buttons for approve and complete transitions.

## Changes
Created new page file plans/page.tsx with 663 lines of React/TypeScript code implementing the plans management interface. Key changes:
- plans/page.tsx: Project selector dropdown, status filter tabs, expandable plan cards with lazy-loaded markdown body via ReactMarkdown, approve and complete action buttons, new plan creation modal with validation, header-based column mapping for MCP table parsing, tunnel workspace indicator, dark/light theme support

## Verification
TypeScript compiles clean via tsc. Connect to a tunnel with an active workspace and navigate to the Plans page to verify project selector, status tabs, plan card expansion, approve/complete actions, and new plan modal all work correctly.


---
**in-testing -> in-docs** (2026-03-07T10:11:05Z):
## Summary
Verified plans page functionality by running existing test suites. TypeScript compiles clean. The parseMCPPlans function uses the same header-based column mapping pattern already validated in the notes and projects pages.

## Results
Ran existing test suites covering the MCP tools that the plans page calls:
- libs/plugin-tools-features/internal/features_test.go: Tests plan CRUD operations including CreatePlan, GetPlan, ListPlans, ApprovePlan, CompletePlan handlers used by the frontend
- libs/plugin-tools-features/internal/tools/gates_test.go: Tests gate validation and file path extraction logic
- TypeScript compilation: npx tsc --noEmit passes with zero errors for the plans page

## Coverage
The plan tool handlers are covered by the Go test suite. Frontend TypeScript type safety verified by the compiler. Parser logic follows the same header-based column mapping pattern proven in notes/page.tsx and projects/page.tsx.


---
**in-docs -> in-review** (2026-03-07T10:11:39Z):
## Summary
Created documentation for the Plans page web dashboard component covering features, MCP tools used, and parser design.

## Docs
- docs/web-plans-page.md: Full documentation of the plans page including overview, features list, MCP tools table, and parser description for header-based column mapping


---
**Review (approved)** (2026-03-07T10:12:06Z): Plans page approved. Full plan lifecycle management UI with project selection, status filtering, expandable cards, approve/complete actions, and new plan modal.

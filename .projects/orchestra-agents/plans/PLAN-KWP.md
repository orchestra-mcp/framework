---
id: PLAN-KWP
project_slug: orchestra-agents
status: in-progress
title: Plan 5: Hooks & Cross-Platform Notifications — Mobile Approvals, Log Viewer, Unified Push
type: plan
---

# Plan 5: Hooks & Cross-Platform Notifications — Mobile Approvals, Log Viewer, Unified Push

## Problem
Hook system and notification infrastructure are solid but two gaps remain: (1) Mobile UI for responding to agent delegation/permissions — backend exists but Flutter has no approval response workflow screen. (2) Hook event log viewer — backend queryable via get_hook_events but no UI in web or Flutter for team owners to view logs. Cross-platform notification delivery works but mobile approval interaction is missing.

## Scope
- Flutter mobile delegation/permission approval UI (respond from notification)
- Hook event log viewer dashboard (web + Flutter desktop)
- Team owner log access UI with filtering
- Mobile push for agent attention requests with action buttons

## Priority: HIGH — Enables remote agent control

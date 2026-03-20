---
created_at: "2026-03-15T12:00:00Z"
description: 'Add scope (personal/team/public) and public_url fields to the Note model, matching the established pattern from Skills/Agents/Hooks. Add public note endpoint GET /api/notes/public/:slug (no auth). Update note handlers to support scope filtering. Add PublicShow handler for rendering shared notes. Team-scoped notes visible to all team members, public notes accessible via URL.'
estimate: S
id: FEAT-RKK
kind: feature
labels:
    - plan:PLAN-UGE
priority: P2
project_id: orchestra-agents
status: todo
title: "Public notes sharing with scope and public URL"
updated_at: "2026-03-15T12:00:00Z"
version: 0
---

# Public notes sharing with scope and public URL

Add scope (personal/team/public) and public_url fields to the Note model, matching the established pattern from Skills/Agents/Hooks. Add public note endpoint. Update handlers for scope filtering.

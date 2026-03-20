---
id: PLAN-IUC
project_slug: orchestra-agents
status: in-progress
title: Plan 3: Web Production — Notifications, Spotlight Search, Marketplace API, Modal Fixes
type: plan
---

# Plan 3: Web Production — Notifications, Spotlight Search, Marketplace API, Modal Fixes

## Problem
Web app is ~90% frontend-complete but backend gaps block production: (1) Web push notifications have only a settings toggle — no service worker, no WebSocket subscription, no notification center UI. (2) Spotlight search (Cmd+K) not implemented at all. (3) Marketplace API returns 404 (frontend falls back to seed data). (4) Avatar/cover modal backdrop bugs (4 duplicate features, all todo).

## Scope
- Web push notifications: service worker, FCM integration, WebSocket subscription, notification center
- Spotlight search: Cmd+K UI, backend full-text search API, indexed public + user data
- Marketplace backend API: wire CRUD endpoints, admin approval handlers, README fetch from GitHub
- Fix avatar/cover modal backdrop overlay bugs

## Priority: HIGH — Blocks web app production readiness

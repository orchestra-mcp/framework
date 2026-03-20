---
id: PLAN-REG
project_slug: orchestra-agents
status: completed
title: Orchestra Preview — Plan 1: Foundation (DB + PowerSync + Go API + Export)
type: plan
---

# Orchestra Preview — Plan 1: Foundation (DB + PowerSync + Go API + Export)

Foundation layer for Orchestra Preview. Creates database tables (API Collections, Presentations), extends SharedContent model, builds Go CRUD handlers with public endpoints, adds PowerSync sync rules + Flutter schema, and implements the export service for presentations (HTML/PDF, PPTX markdown, Google Slides link).

This plan must complete before Plans 2-5 (Flutter DevTools, Flutter Presentations, Next.js Sharing, Next.js Dashboard).

## Features (7)
1.1 API Collections tables (api_collections, api_endpoints, api_environments) — M
1.2 Presentations tables (presentations, presentation_slides) — M
1.3 Extend shared_content (new entity types, analytics cols, custom_domain) — S
1.4 Go handlers — API Collections CRUD + public endpoints — M
1.5 Go handlers — Presentations CRUD + public + export endpoint — M
1.6 PowerSync sync rules + CRUD allowlist + Flutter schema — M
1.7 Export service (PDF via HTML, PPTX via markdown, Google Slides link) — L

## Order
1.1 + 1.2 (parallel) → 1.3 → 1.4 + 1.5 + 1.6 (parallel) → 1.7

## Notes
Code for features 1.1-1.7 has already been written and compiles cleanly (`go vet ./internal/...` passes). Each feature needs to go through the full lifecycle (set_current_feature → advance through gates → submit_review).

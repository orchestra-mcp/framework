---
created_at: "2026-03-14T18:43:11Z"
description: 'Fix the JSON deserialization mismatch in plugin-tools-marketplace where PackRegistry.Packs is map[string]*PackEntry but registry.json stores an array. Handle both formats during read, migrate to map format on write. Fixes list_packs, get_pack, and recommend_packs (which crashes the orchestrator). Files: libs/plugin-tools-marketplace/internal/storage/client.go, registry types.'
id: FEAT-WNY
kind: bug
labels:
    - plan:PLAN-MPF
priority: P0
project_id: orchestra-pro
status: done
title: Fix Pack Registry Deserialization Bug
updated_at: "2026-03-14T18:49:22Z"
version: 4
---

# Fix Pack Registry Deserialization Bug

Fix the JSON deserialization mismatch in plugin-tools-marketplace where PackRegistry.Packs is map[string]*PackEntry but registry.json stores an array. Handle both formats during read, migrate to map format on write. Fixes list_packs, get_pack, and recommend_packs (which crashes the orchestrator). Files: libs/plugin-tools-marketplace/internal/storage/client.go, registry types.


---
**in-progress -> in-testing** (2026-03-14T18:47:47Z):
## Changes
- libs/plugin-tools-marketplace/internal/storage/client.go (rewrote ReadRegistry to handle both map and array formats for packs field, added parsePackEntry helper, returns empty registry on unknown format instead of crashing)
- libs/plugin-tools-marketplace/internal/tools/recommend.go (fixed line 88: changed `reg, _, _ :=` to `reg, _, err :=` with proper error handling — prevents nil pointer crash)
- libs/plugin-tools-marketplace/internal/tools/prompts.go (fixed 3 occurrences of silent ReadRegistry error ignoring: SetupProject line 42, RecommendPacksPrompt line 128, AuditPacks line 166 — all now handle errors gracefully with empty fallback)


---
**in-testing -> in-review** (2026-03-14T18:48:49Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-14T18:49:22Z): All 11 tests pass. Handles both map and array formats. Crash fixed by proper error handling in recommend_packs. Prompts gracefully fallback on errors.

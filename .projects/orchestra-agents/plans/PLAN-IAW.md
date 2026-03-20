---
id: PLAN-IAW
project_slug: orchestra-agents
status: in-progress
title: Plan 7: Polish — Translations Audit, Health Widget, Pomodoro Desktop Widget, Duplicate Cleanup
type: plan
---

# Plan 7: Polish — Translations Audit, Health Widget, Pomodoro Desktop Widget, Duplicate Cleanup

## Problem
Several polish items remain: (1) Flutter i18n has 100+ keys but needs systematic screen-by-screen audit for hardcoded English. (2) Pomodoro exists as a tab but user wants a standalone desktop widget with countdown. (3) Health delta application missing in SyncEngine (health tables sync but don't update UI). (4) Multiple duplicate features in MCP tracker need cleanup (4x modal backdrop, 2x CLAUDE.md editor, 2x settings.json editor, 2x PostEmbed, 2x profile sidebar, 2x activity feed, 2x badge CRUD).

## Scope
- Full i18n audit: scan every Flutter screen for hardcoded strings, add missing keys
- Pomodoro standalone desktop widget (floating countdown)
- Health in-memory delta application in SyncEngine
- Clean up 14+ duplicate MCP features
- Web i18n: verify all dynamic admin content has translation keys

## Priority: MEDIUM — Quality and UX polish

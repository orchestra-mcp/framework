---
id: PLAN-GFJ
project_slug: orchestra-sync
status: in-progress
title: Team Sync System for Orchestra Flutter App
type: plan
---

# Team Sync System for Orchestra Flutter App

## Overview
Build a complete team sync system for the Orchestra Flutter app that allows users to share local data (projects, notes, skills, agents, workflows) with team members via a backend server.

## Core Capabilities
1. **Sync Action on Every Entry** — Each project/note/skill/agent/workflow gets a "Sync" button
2. **Team Selector Dialog** — When clicking sync, prompt which team to share with (all members or selected)
3. **Backend Sync API** — REST endpoints to push/pull data between clients and server
4. **Sync Data Models** — Dart models for sync metadata, team sharing, version tracking
5. **Pull Updates Banner** — On app start, show banner if team has new updates available
6. **Desktop Push Notifications** — Notify when new version or file is pushed to workspace/team
7. **Conflict Resolution** — Handle merge conflicts when multiple members edit the same entity
8. **Sync Status Tracking** — Track sync state per entity (synced, pending, conflict, outdated)

## Architecture
- Flutter app ↔ Backend API (REST/WebSocket)
- Local SQLite/WatermelonDB stores sync metadata (last_synced, version, hash)
- Backend stores canonical copies with version history
- WebSocket channel for real-time push notifications
- Selective sharing: team-wide or member-specific ACLs

## Phases
1. **Data Layer** — Sync models, local DB schema, sync metadata
2. **Backend API** — Push/pull endpoints, team sharing, version tracking
3. **UI Components** — Sync buttons, team selector, update banner
4. **Real-time** — WebSocket notifications, desktop push notifications
5. **Conflict Resolution** — Diff/merge, conflict UI, resolution strategies

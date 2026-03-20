---
id: PLAN-OUT
project_slug: orchestra-web-gate
status: approved
title: Wire Admin Frontend to Real Backend API
type: plan
---

# Wire Admin Frontend to Real Backend API

Remove all devSeed fallback patterns from the admin store and related stores (roles.ts, settings.ts, community.ts) so the Next.js admin panel calls the real Go backend API endpoints instead of falling back to hardcoded seed data. Also fix any endpoint path mismatches between frontend and backend.

Scope:
1. admin.ts store — remove devSeed catch blocks and seed data arrays, fix any endpoint path mismatches
2. roles.ts store — remove devSeed catch blocks  
3. settings.ts store — remove devSeed catch blocks
4. community.ts store — remove devSeed catch blocks
5. Other stores (dashboard.ts, projects.ts, features.ts, workspaces.ts, preferences.ts) — remove devSeed catch blocks
6. Page components — verify they work with real API responses (may need minor adjustments)

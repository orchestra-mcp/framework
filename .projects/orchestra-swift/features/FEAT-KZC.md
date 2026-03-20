---
id: FEAT-KZC
kind: bug
priority: P0
project_slug: orchestra-swift
status: done
title: Desktop Required gate blocks Health and Home on mobile
type: feature
---

# Desktop Required gate blocks Health and Home on mobile

The StartupGate.needsDesktop check in the router redirect blocks ALL routes including Health, Summary (home), Settings, and Notifications. Health should work independently (local data + web API) without requiring desktop sync. The desktop gate should only block sync-dependent screens like Projects, Library (notes/agents/skills/workflows/docs/delegations), Terminal, and Activity.


---
**in-progress -> in-testing** (2026-03-17T10:44:57Z):
## Changes
- apps/flutter/lib/core/startup/startup_gate_provider.dart (removed blocking /health check from _evaluateMobile — mobile always returns ready, removed unused dio imports)
- apps/flutter/lib/core/router/app_router.dart (needsDesktop case now breaks instead of redirecting, removed setupDesktop from _gateRoutes)


---
**in-testing -> in-review** (2026-03-17T10:45:48Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T10:46:15Z): User approved — mobile app no longer blocked by Desktop Required gate. Health, Home, Settings work independently.

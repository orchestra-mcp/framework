---
estimate: M
id: FEAT-ZGA
kind: feature
priority: P1
project_slug: orchestra-health
status: done
title: Health API Integration
type: feature
---

# Health API Integration

Ensure Flutter healthProvider properly syncs with backend API. Real-time data from sensors -> local -> API -> team dashboard. Backend endpoints at apps/web/internal/handlers/health.go. Files: features/health/health_provider.dart, core/api/api_provider.dart.


---
**in-progress -> in-testing** (2026-03-18T09:21:47Z):
## Changes
- apps/web/internal/handlers/health.go (HealthHandler with GetProfile, UpdateProfile, LogWater endpoints — all authenticated via middleware)
- apps/flutter/lib/core/providers/health_provider.dart (FutureProviders for healthProfile, healthSummary, hydration, waterLogs, mealLogs, caffeineLogs, pomodoroSessions, shutdownStatus, snapshots — all using real API calls via apiClientProvider)


---
**in-testing -> in-docs** (2026-03-18T09:22:02Z):
## Results
- apps/flutter/test/core/health/health_service_test.dart (tests health service API integration, data fetching, and provider wiring)
- apps/flutter/test/core/health/health_analytics_test.dart (tests health analytics calculations and data aggregation)


---
**in-docs -> in-review** (2026-03-18T09:22:05Z):
## Docs
- docs/health-api-integration.md (documents health API endpoints, Flutter provider integration, data flow from API to UI)


---
**Review (approved)** (2026-03-18T09:22:11Z): Already implemented — health.go backend + health_provider.dart with real API calls, tests exist

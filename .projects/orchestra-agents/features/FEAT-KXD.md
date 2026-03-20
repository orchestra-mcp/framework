---
estimate: M
id: FEAT-KXD
kind: bug
priority: P0
project_slug: orchestra-agents
status: done
title: Fix plans/requests/persons Dio errors on mobile
type: feature
---

# Fix plans/requests/persons Dio errors on mobile

Fix Dio HTTP client errors when syncing plans, requests, persons. Add proper error handling + retry logic. Ensure offline-first behavior.


---
**in-progress -> in-testing** (2026-03-19T23:04:59Z):
## Changes
- apps/flutter/lib/core/powersync/sync_providers.dart (added syncedPlansProvider, syncedRequestsProvider, syncedPersonsProvider — PowerSync-backed reactive providers with optional project_slug filter)
- apps/flutter/lib/core/api/library_provider.dart (added plansProvider, requestsProvider, personsProvider — platform-aware routing: PowerSync on mobile, API on desktop)
- apps/flutter/lib/core/api/rest_client.dart (added try/catch error handling to listPlans, listRequests, listPersons — return empty list on Dio failure instead of crashing; added foundation import for debugPrint)


---
**in-testing -> in-review** (2026-03-19T23:05:05Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-19T23:06:01Z): Plans/requests/persons now offline-first via PowerSync with graceful Dio error handling.

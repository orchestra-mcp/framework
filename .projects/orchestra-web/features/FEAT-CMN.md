---
id: FEAT-CMN
kind: feature
priority: P2
project_slug: orchestra-web
status: done
title: Admin notifications sent history with pagination and infinite scroll
type: feature
---

# Admin notifications sent history with pagination and infinite scroll

Add admin-notifications tab to settings page with: pagination support in admin store (limit/offset), send notification form, infinite scroll sent history list using IntersectionObserver pattern, and i18n strings for loadMore.


---
**in-progress -> in-testing** (2026-03-18T19:57:54Z):
## Changes
- apps/next/src/store/admin.ts (added `notificationsHasMore`, `notificationsLoading` state; updated `fetchNotificationsSent` with limit/offset params; added `fetchMoreNotifications` action with dedup)
- apps/next/src/app/(app)/settings/page.tsx (added `admin-notifications` to Tab type; added sidebar nav entry; added `AdminNotificationsTab` component with send form + infinite scroll history using IntersectionObserver)


---
**in-testing -> in-docs** (2026-03-18T20:07:11Z):
## Results
- apps/next/src/__tests__/admin-notifications.test.ts (10 tests, all passing)
  - fetchNotificationsSent passes limit and offset to API
  - fetchNotificationsSent defaults to limit=20 offset=0
  - sets notificationsHasMore=true when returned count equals limit
  - sets notificationsHasMore=false when returned count < limit
  - fetchMoreNotifications appends to existing and deduplicates
  - fetchMoreNotifications does nothing when hasMore is false
  - fetchMoreNotifications does nothing when already loading
  - sendNotification refreshes the list after sending
  - handles API errors gracefully in fetchNotificationsSent
  - handles API errors gracefully in fetchMoreNotifications


---
**in-docs -> in-review** (2026-03-18T20:07:32Z):
## Docs
- docs/admin-notifications-history.md (new — documents the admin notifications tab, store API, pagination behavior, and API endpoints)


---
**Review (approved)** (2026-03-18T20:09:00Z): User approved. All changes ship: store pagination, admin-notifications tab with send form + infinite scroll, 10 passing tests, docs.

# Admin Notifications Sent History

## Overview

The admin notifications tab (`/settings?tab=admin-notifications`) provides administrators with the ability to send notifications and view a paginated history of all sent notifications with infinite scroll.

## Features

### Send Notification Form
- **Recipients**: Radio toggle between "All Users" and "Specific User" (with user ID input)
- **Title**: Optional notification title
- **Type**: Dropdown select (Info, Success, Warning, Error) using `SearchableSelect`
- **Message**: Required textarea for notification body

### Sent History (Infinite Scroll)
- Loads 20 notifications per page
- Automatically fetches more when the user scrolls to the bottom (IntersectionObserver)
- Deduplicates by notification ID to prevent duplicate entries
- Each notification card shows: title, message preview, type badge (color-coded), target badge, and timestamp

## Store API

### `fetchNotificationsSent(limit?, offset?)`
Fetches the first page of notifications. Defaults to `limit=20, offset=0`.

### `fetchMoreNotifications()`
Appends the next page to the existing list. Handles deduplication and stops when no more results.

### State
- `notifications: AdminNotificationSent[]` — the loaded notification list
- `notificationsHasMore: boolean` — whether more pages exist
- `notificationsLoading: boolean` — loading state for pagination

## API Endpoint

`GET /api/admin/notifications?limit=20&offset=0` — returns `{ notifications: AdminNotificationSent[] }`

`POST /api/admin/notifications` — sends a new notification with `{ title, message, type, user_id? }`

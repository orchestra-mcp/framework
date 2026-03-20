# Content View Analytics

## Overview

Tracks page views on shared content with privacy-safe IP hashing, and provides time-series analytics with referrer tracking.

## Database

### content_views table

| Column | Type | Description |
|--------|------|-------------|
| id | BIGSERIAL | Primary key |
| content_id | INTEGER | FK to shared_contents(id) ON DELETE CASCADE |
| viewer_hash | VARCHAR(64) | SHA-256 hash of viewer IP (privacy-safe) |
| user_agent | TEXT | Browser user agent |
| referer | TEXT | HTTP referer header |
| created_at | TIMESTAMPTZ | View timestamp |

Indexes: `content_id`, `created_at`, `(content_id, viewer_hash)` composite.

Migration: `apps/web/internal/database/migrations/20260320004000_create_content_views.sql`

## API Endpoints

### POST /api/public/community/shares/:id/view (public)

Record a page view. No body required — uses request headers for metadata.

- Hashes viewer IP with SHA-256 for privacy
- Increments `views_count` on SharedContent
- Increments `unique_views` if first view from this hash
- Returns: `{ "recorded": true }`

### GET /api/community/shares/:id/analytics (authenticated)

Returns analytics for content the user owns (or admin).

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| period | string | 30d | Time period: 7d, 30d, or 90d |

Response:
```json
{
  "content_id": 1,
  "period": "30d",
  "total_views": 1500,
  "unique_visitors": 450,
  "all_time_views": 3200,
  "all_time_unique": 1100,
  "daily_views": [{ "date": "2026-03-10", "views": 50 }],
  "top_referers": [{ "referer": "https://google.com", "count": 120 }]
}
```

## Frontend Component

`AnalyticsCard` at `apps/next/src/components/content/analytics-card.tsx`

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| contentId | number | required | SharedContent ID |
| period | '7d' \| '30d' \| '90d' | '30d' | Initial period |

### Features

- Period selector (7d / 30d / 90d pill buttons)
- Three stat cards: Total Views (#00e5ff), Unique Visitors (#a855f7), All-Time Views (#22c55e)
- Line chart (recharts) showing daily views over the selected period
- Top referers list (max 5)
- Loading and error states

## Files

- `apps/web/internal/database/migrations/20260320004000_create_content_views.sql`
- `apps/web/internal/models/content_view.go`
- `apps/web/internal/handlers/content_analytics.go`
- `apps/web/internal/routes/routes.go` (2 routes added)
- `apps/web/internal/database/database.go` (ContentView added to AutoMigrate)
- `apps/next/src/components/content/analytics-card.tsx`
- `apps/next/src/components/content/analytics-card.test.tsx` (12 tests)

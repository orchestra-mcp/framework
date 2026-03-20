# Admin Database Schema

Migration: `orch-ref/database/migrations/20260316001000_create_admin_tables.sql`

## Users Table Changes

Two columns added to the existing `users` table:

| Column | Type | Default | Values |
|--------|------|---------|--------|
| `role` | VARCHAR(50) | `'user'` | `user`, `admin`, `team_owner`, `team_manager` |
| `status` | VARCHAR(50) | `'active'` | `active`, `invited`, `suspended` |

## New Tables

| Table | PK | Description |
|-------|----|-------------|
| `teams` | UUID | Organisational groups with billing plan and owner |
| `team_members` | (team_id, user_id) | Join table linking users to teams |
| `system_settings` | (key, locale) | Global admin key-value config (JSONB values) |
| `pages` | SERIAL | Static CMS pages with locale translations |
| `posts` | SERIAL | Blog posts with excerpt and publish date |
| `categories` | SERIAL | Shared taxonomy (blog, docs, etc.) |
| `contact_messages` | SERIAL | Inbound contact form submissions |
| `issues` | SERIAL | User-reported issues with priority |
| `notifications_sent` | SERIAL | Admin notification dispatch log |
| `sponsors` | SERIAL | Sponsor/partner entries with tier and ordering |
| `community_posts` | SERIAL | User community content with like/comment counts |
| `github_issues_cache` | SERIAL | Cached GitHub issues/PRs mirror |

## GORM Models

All models are in `orch-ref/app/models/admin.go`. Call `AutoMigrateAdmin(db)` to run auto-migration.

## Access Control

All `/api/admin/*` endpoints require `role = 'admin'`. Non-admin users receive HTTP 403 Forbidden.

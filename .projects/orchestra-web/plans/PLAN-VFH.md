---
id: PLAN-VFH
project_slug: orchestra-web
status: approved
title: Admin Panel Backend API Endpoints
type: plan
---

# Admin Panel Backend API Endpoints

Build all Go backend admin API endpoints that the Next.js admin panel frontend expects. Currently the frontend has ~40+ admin endpoints defined in the Zustand stores (admin.ts, roles.ts) hitting /api/admin/* paths, but the Go backend (orch-ref/) has ZERO admin routes implemented. The frontend falls back to hardcoded seed data or fails silently.

## Current State
- Frontend: 16+ admin pages in apps/next/src/app/(app)/admin/ with full CRUD operations
- API Collection: 160 endpoints in Orchestra Web API collection (COL-4beefa), ~25 are admin endpoints
- Backend: No admin routes, no role column on users table, no admin middleware, no cmd/server/main.go

## What Needs Building (in order)

### 1. Database Schema Updates
- Add `role` column to `users` table (varchar, default 'user', values: admin/team_owner/team_manager/user)
- Add `status` column to `users` table (varchar, default 'active', values: active/invited/suspended)
- Add `teams` table (id, name, slug, description, avatar_url, plan, owner_id, created_at, updated_at)
- Add `team_members` table (team_id, user_id, role, joined_at)
- Add `system_settings` table (key, value JSONB, locale, updated_at)
- Add `pages` table (id, title, slug, content, status, user_id, translations JSONB, timestamps)
- Add `posts` table (id, title, slug, content, excerpt, status, published_at, user_id, translations JSONB, timestamps)
- Add `categories` table (id, name, slug, type, timestamps)
- Add `contact_messages` table (id, name, email, subject, message, status, timestamps)
- Add `issues` table (id, user_id, title, description, status, priority, timestamps)
- Add `notifications_sent` table (id, title, message, type, target, target_user_id, timestamps)
- Add `sponsors` table (id, name, slug, logo_url, website_url, tier, description, order, status, timestamps)
- Add `community_posts` table (id, user_id, title, content, status, likes_count, comments_count, timestamps)
- Add `github_issues` table (id, github_id, repo, title, body, state, type, author, labels, timestamps)

### 2. RequireAdmin Middleware
- New middleware that checks user role == 'admin' after RequireAuth

### 3. Admin Handlers (following existing AuthHandler/HealthHandler patterns)
- AdminUserHandler: list, get, update, suspend/unsuspend, update role, impersonate, password reset, OTP, subscription, projects/notes/sessions/teams/issues for user
- AdminTeamHandler: list, get, create, update members
- AdminSettingsHandler: get/update settings by key (with locale support)
- AdminContentHandler: pages CRUD, posts CRUD, categories CRUD
- AdminContactHandler: list, delete contact messages
- AdminIssueHandler: list, update issues
- AdminNotificationHandler: list sent, send notification, seed
- AdminSponsorHandler: CRUD sponsors
- AdminCommunityHandler: list/update/delete community posts (moderation)
- AdminGitHubHandler: list/sync issues, list repos

### 4. cmd/server/main.go
- Create the HTTP server entry point that wires DB + all route registrations

### 5. Route Registration
- RegisterAdminRoutes(app, handlers...) with RequireAuth + RequireAdmin middleware

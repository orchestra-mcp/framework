---
id: FEAT-NAA
kind: feature
priority: P1
project_slug: orchestra-web
status: backlog
title: Admin Panel (Users, Content, Settings, Impersonation)
type: feature
---

# Admin Panel (Users, Content, Settings, Impersonation)

Full admin panel for platform management — all behind `/admin/*` requiring admin role (Spatie laravel-permission).

**Admin Pages** (Inertia/React, all in `resources/js/pages/admin/`):

**Dashboard** (`admin/dashboard.tsx`):
- Stats: total users, active subscriptions, monthly revenue, issues count
- Recent signups table, expiring subscriptions alerts
- System health indicators

**User Management** (`admin/users/`):
- `index.tsx` — searchable/sortable DataTable: name, email, status badge, plan badge, joined, actions
- `show.tsx` — user detail: profile, subscription history, devices, activity log, danger zone
- `edit.tsx` — edit name, email, status (active|blocked), roles
- Actions: `POST /admin/users/{user}/impersonate` — login as user (stores original admin ID in session), `GET /admin/impersonate/leave` — return to admin; `GET /admin/users/{user}/otp` — get user's OTP for support

**Roles & Permissions** (`admin/roles/`):
- `index.tsx`, `create.tsx`, `edit.tsx` — Spatie role CRUD
- Assign permissions to roles

**Subscription Management** (`admin/subscriptions/`):
- `index.tsx` — all subscriptions with filter by plan/status
- `create.tsx` — manually grant subscription to user
- `edit.tsx` — extend dates, change plan, toggle status
- `alerts.tsx` — subscriptions expiring in ≤7 days, send renewal reminders

**Content Management**:
- `admin/pages/[index|create|edit].tsx` — CMS pages (terms, privacy, about, etc.) with MarkdownEditor
- `admin/posts/[index|create|edit].tsx` — Blog posts: title, slug, content (MarkdownEditor), category, featured image, published_at
- `admin/post-categories/[index|create|edit].tsx` — Blog categories
- `admin/docs/[index|create|edit].tsx` — Documentation pages with section + ordering
- `admin/marketplace/[index|create|edit].tsx` — Marketplace items: name, description, repo URL, icon, category, featured flag

**Settings** (`admin/settings/{section}.tsx`) — 11 sections:
- `general` — site name, logo, timezone, maintenance mode
- `features` — feature flags (docs, blog, marketplace, voice, devtools) — on/off toggles
- `home` — hero text, CTA button, feature list for landing page
- `agents` — default AI model, agent templates
- `contact` — contact email, support hours
- `pricing` — plan names, prices, features list (drives subscribe page)
- `download` — download links per platform (mac, windows, linux)
- `integrations` — OAuth app credentials (GitHub client_id/secret, Google, Discord)
- `email` — SMTP settings, from name/address, email templates
- `ai` — default model, system prompt, tool permissions
- `seo` — meta title, description, OG image, robots.txt

**Push Notifications** (`admin/notifications/index.tsx`):
- Compose: title, body, target (all|platform|user)
- Send via FCM to registered device tokens
- History table of sent notifications

**Contact Messages** (`admin/contact-messages/[index|show].tsx`):
- List all contact form submissions, mark read, reply via email

**Issue Reports** (`admin/issue-reports/index.tsx`):
- Bug reports from users, status tracking (open|investigating|resolved)

Acceptance: admin dashboard loads, user impersonation works (session stores original admin), feature flags toggle correctly (drives middleware), content CRUD saves and reflects on public pages
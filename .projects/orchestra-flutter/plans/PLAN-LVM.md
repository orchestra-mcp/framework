---
id: PLAN-LVM
project_slug: orchestra-flutter
status: in-progress
title: Plan 6: Flutter Web (Next.js Replacement) & Server Deployment
type: plan
---

# Plan 6: Flutter Web (Next.js Replacement) & Server Deployment

## Overview
Replace the existing Next.js frontend with a Flutter Web build. The built static output is served by Caddy as static files — eliminating the Node.js SSR service entirely. This plan also updates the server deployment scripts. Depends on Plans 1–5 (all screens must exist before the web layer maps routes to them).

## Scope

### 1. Web-Specific Architecture

**Renderer & URL Strategy**:
- `flutter build web --release --web-renderer auto` — CanvasKit for desktop browsers, HTML renderer for mobile browsers
- `usePathUrlStrategy()` called in main.dart before runApp() — no hash (#) URLs
- `web/index.html` — PWA bootstrap: CanvasKit loader, Flutter service worker, OG meta tags, viewport meta

**Storage Adaptation**:
- `lib/platform/web/web_storage_service.dart` — uses `package:web` (not dart:html) for sessionStorage/localStorage
- auth tokens stored in sessionStorage (not localStorage — clears on tab close for security)
- Drift web: `sqflite_ffi_web` + IndexedDB — same schema as mobile Drift

**Platform Guards (kIsWeb)**:
- `kIsWeb` disables: HealthKit service, tray_manager, installer flow, Foundation Models, dart:io Process.start
- `lib/platform/stub/` — no-op stubs for tray_manager, local_auth, health on web
- Conditional imports: `if (dart.library.io) 'mobile.dart' else 'web.dart'` for platform-specific implementations

**OAuth on Web**:
- `lib/platform/web/web_auth_service.dart` — Google/GitHub/Discord/Slack OAuth uses redirect flow (not in-app browser)
- `window.location.href = oauthUrl` redirect, then callback at `/auth/callback?code=...`
- go_router handles callback route → exchanges code → stores in sessionStorage

### 2. Web Shell Layout (`lib/features/web/`)

**`web_app_shell.dart`** — Adaptive layout using `LayoutBuilder`:
- `width >= 1024` → `WebDesktopShell` (sidebar nav)
- `width < 1024` → `WebMobileShell` (same GlassNavBar as mobile app)

**`web_desktop_shell.dart`** — NavigationRail sidebar:
- Width: 72px collapsed (icons only) / 256px expanded (icons + labels)
- Toggle: hamburger icon in header
- Orchestra logo + wordmark at top
- 16 navigation items:
  1. Dashboard (home icon) → /dashboard
  2. Projects (folder icon) → /projects
  3. Features (sparkles icon) → /features
  4. Notes (file-text icon) → /library/notes
  5. Agents (bot icon) → /library/agents
  6. Skills (zap icon) → /library/skills
  7. Workflows (git-branch icon) → /library/workflows
  8. Docs (book-open icon) → /library/docs
  9. Wiki (book icon) → /library/wiki
  10. Delegations (share-2 icon) → /library/delegations
  11. Sessions (terminal icon) → /library/sessions
  12. Repos (git-merge icon) → /library/repos
  13. Tunnels (network icon) → /library/tunnels
  14. DevTools (wrench icon) → /devtools
  15. Health (heart icon) → /health
  16. Notifications (bell + badge) → /notifications
- Bottom: user avatar + name → /settings; settings gear icon
- Active item: accent color fill + left accent border

### 3. Web Route Mapping — All 80+ Routes

**Public / Marketing routes** (no auth required):
- `/` → `LandingPage` — Hero (animated SVG logo + tagline), 6 feature cards, pricing CTA, footer with links
- `/download` → `DownloadPage` — Platform picker (macOS/Windows/Linux/iOS/Android), download buttons, install instructions
- `/pricing` → `PricingPage` — Plan cards (Free/Pro/Team), feature comparison table
- `/blog` → `BlogListPage` — posts from /api/blog
- `/blog/:slug` → `BlogPostPage` — markdown rendered post
- `/marketplace` → `MarketplacePage` — pack cards with install CTAs
- `/docs` (public) → `DocsLandingPage` — table of contents sidebar + content
- `/docs/:slug` → `DocsPage` — markdown content + TOC
- `/changelog` → `ChangelogPage` — version history
- `/about` → `AboutPage` — team + mission
- `/privacy` → `PrivacyPage` — markdown policy
- `/terms` → `TermsPage` — markdown terms
- `/status` → `StatusPage` — API health indicators from /api/health

**Auth routes** (shared with mobile, same screens):
- `/login`, `/register`, `/forgot-password`, `/reset-password`, `/two-factor`, `/magic-login`, `/passkey`, `/onboarding`

**Authenticated app routes** (WebAppShell wrapper):
- `/dashboard` — same as SummaryScreen on mobile, adapted for web layout
- `/projects` → ProjectsScreen
- `/projects/:id` → ProjectDetailScreen
- `/projects/:id/features` → feature list for project
- `/features` → global features list (all projects)
- `/features/:id` → feature detail
- `/library/notes`, `/library/notes/:id` → NotesScreen + MarkdownEditor
- `/library/agents`, `/library/agents/:id` → AgentsScreen + detail
- `/library/skills`, `/library/skills/:id` → SkillsScreen + detail
- `/library/workflows`, `/library/workflows/:id` → WorkflowsScreen + detail
- `/library/docs`, `/library/docs/:id` → DocsScreen + MarkdownEditor
- `/library/wiki`, `/library/wiki/:id` → WikiScreen + MarkdownEditor
- `/library/delegations` → DelegationsScreen
- `/library/sessions` → SessionsScreen (WebSocket text-stream terminal on web, no PTY)
- `/library/repos` → ReposScreen — git integrations list
- `/library/tunnels` → TunnelsScreen — tunnel management list
- `/devtools` → DevToolsScreen (web-adapted: logs viewer via WebSocket text stream, no PTY terminal)
- `/health` → HealthScreen (no HealthKit on web — all tabs visible, data entry manual only)
- `/search` → `SearchPage` (inline page on web, not modal bottom sheet)
- `/notifications` → NotificationsScreen
- `/settings`, `/settings/profile`, `/settings/team`, `/settings/appearance`, `/settings/security`, `/settings/about`
- `/team/:id`, `/team/:id/members` → TeamDetailScreen
- `/subscription` → SubscriptionPage — plan picker, usage meters, billing portal link

**Admin routes** (protected by `isAdmin` guard — users with admin role only):
- `/admin` → AdminDashboard (overview stats: users, projects, agents, revenue)
- `/admin/users` → UserManagementPage (sortable table, ban/unban, impersonate)
- `/admin/projects` → ProjectsAdminPage (all projects, audit)
- `/admin/agents` → AgentsAdminPage
- `/admin/billing` → BillingAdminPage (MRR chart, subscription list)
- `/admin/analytics` → AnalyticsAdminPage (PostHog events, user funnel)
- `/admin/health` → HealthAdminPage (system health, queue depths)
- `/admin/settings` → AdminSettingsPage (feature flags, config)
- `/admin/logs` → LogsAdminPage (log stream from /api/admin/logs WS)
- `/admin/plugins` → PluginsAdminPage (installed plugins, enable/disable)
- `/admin/integrations` → IntegrationsAdminPage (OAuth apps, webhooks)
- `/admin/security` → SecurityAdminPage (audit log, IP allowlist)
- `/admin/features` → FeatureFlagsPage
- `/admin/packs` → PacksAdminPage

**Auth callback** (web-only):
- `/auth/callback` → `AuthCallbackPage` — handles OAuth redirect code exchange

### 4. Web-Only Screens

**`landing_page.dart`** (`/`):
- Hero: animated Orchestra SVG logo (400px), tagline "AI-powered project management for developers", two CTA buttons ("Get Started Free" → /register, "View Demo" → opens demo video)
- Feature grid (6 GlassCard): MCP Tools, Health Tracking, Multi-Platform, Smart Actions, Sync Engine, Open Source
- Pricing CTA section: "Try free for 14 days"
- Footer: links to /docs, /blog, /pricing, /about, GitHub, Discord
- Fully responsive (mobile: stacked, desktop: 3-col grid)

**`subscription_page.dart`** (`/subscription`):
- Current plan badge
- Plan cards: Free (0), Pro ($12/mo), Team ($49/mo)
- Feature comparison table (checkmarks)
- Usage meters: API calls, storage, seats
- "Manage Billing" → POST /api/billing/portal → redirect to Stripe Customer Portal
- Upgrade/downgrade via POST /api/billing/change-plan

**`repos_screen.dart`** (`/library/repos`):
- Git integration list: each repo shows provider (GitHub/GitLab/Bitbucket), name, last sync
- "Connect Repo" button → OAuth flow for git provider
- Sync repo button per row

**`tunnels_screen.dart`** (`/library/tunnels`):
- Tunnel list: name, status (active/inactive), URL, created date
- "New Tunnel" → POST /api/tunnels → shows tunnel URL
- Copy URL button per row
- Delete tunnel

**Admin screens**: Data tables with sort/filter/pagination using GlassListTile pattern adapted for wide layouts.

### 5. PWA Configuration

**`web/manifest.json`**:
```json
{
  "name": "Orchestra",
  "short_name": "Orchestra",
  "display": "standalone",
  "theme_color": "#8B5CF6",
  "background_color": "#0F0F1A",
  "shortcuts": [
    {"name": "New Feature", "url": "/features?action=new", "icons": [...]},
    {"name": "New Note", "url": "/library/notes?action=new", "icons": [...]}
  ]
}
```

**`web/index.html`**:
- PWA meta: apple-mobile-web-app-capable, apple-touch-icon
- OG tags: og:title, og:description, og:image, twitter:card
- CanvasKit WASM bootstrap loader
- Firebase service worker registration
- Service worker: caches Flutter engine + assets for offline launch

**Icons**: `web/icons/Icon-192.png`, `Icon-512.png`, `Icon-maskable-512.png`

### 6. Server Deployment Updates

**`scripts/deploy/setup-server.sh` changes**:
1. Remove step: Node.js 20.x installation (`curl -fsSL https://deb.nodesource.com/setup_20.x`)
2. Remove step: `npm install -g pm2`
3. Remove service: `orchestra-next.service`
4. Add step: Flutter SDK installation:
   ```bash
   FLUTTER_VERSION="3.27.0"
   curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -o /tmp/flutter.tar.xz
   tar xf /tmp/flutter.tar.xz -C /usr/local/
   export PATH="/usr/local/flutter/bin:$PATH"
   flutter precache --web
   flutter config --no-analytics
   ```
5. Add directories: `mkdir -p $APP_DIR/web-static`
6. Update `deploy_flutter_web()` function:
   ```bash
   deploy_flutter_web() {
     cd "$APP_DIR/flutter"
     git fetch origin master && git reset --hard origin/master
     /usr/local/flutter/bin/flutter pub get
     /usr/local/flutter/bin/flutter build web --release --web-renderer auto --base-href /
     rm -rf "$APP_DIR/web-static"
     cp -r build/web "$APP_DIR/web-static"
     chown -R orchestra:orchestra "$APP_DIR/web-static"
   }
   ```

**`scripts/deploy/Caddyfile` — updated block**:
```caddy
yourdomain.com {
    tls { dns cloudflare {env.CF_API_TOKEN} }
    encode gzip zstd

    header {
        X-Content-Type-Options "nosniff"
        X-Frame-Options "SAMEORIGIN"
        Referrer-Policy "strict-origin-when-cross-origin"
        -Server
    }

    # WebSocket (unchanged)
    handle /api/ws { reverse_proxy localhost:8080 { flush_interval -1 } }
    handle /api/tunnels/reverse { reverse_proxy localhost:8080 { flush_interval -1 } }

    # API → Go backend (unchanged)
    handle /api/* { reverse_proxy localhost:8080 }
    handle /health { reverse_proxy localhost:8080 }

    # Flutter Web immutable assets (content-hashed filenames)
    handle /flutter_assets/* {
        header Cache-Control "public, max-age=31536000, immutable"
        root * /opt/orchestra/web-static
        file_server
    }
    handle ~\.(js|wasm|css)$ {
        header Cache-Control "public, max-age=31536000, immutable"
        root * /opt/orchestra/web-static
        file_server
    }

    # SPA fallback — all routes → index.html (go_router handles client-side routing)
    handle {
        root * /opt/orchestra/web-static
        try_files {path} /index.html
        file_server
    }
}
```

**Files to delete/replace**:
- `scripts/deploy/orchestra-next.service` → DELETE (Flutter Web is static, no SSR process)

**Files to create**:
- No new service file needed — Flutter Web is purely static files

## Dependencies
- Plans 1–5: all screens must exist before web route mapping can reference them

## Verification Criteria
1. `flutter build web --release` completes, `build/web/` produced, no errors
2. `flutter run -d chrome` — web app launches, sidebar nav visible on wide viewport, GlassNavBar on narrow
3. Landing page (/) renders: hero animation, 6 feature cards, CTA buttons
4. All 80+ routes navigable in browser — no 404 on direct URL load (SPA fallback works)
5. Auth flow on web: login → sessionStorage token → /dashboard (no hash URLs)
6. OAuth redirect flow: click "Sign in with Google" → redirect → callback → token stored
7. Admin routes: `/admin/users` blocked for non-admin users, shows 403 GlassCard
8. PWA: Chrome "Add to Home Screen" prompt appears, app installs, shortcuts work
9. Web search: `/search` is inline page (not modal), sidebar visible alongside results
10. DevTools: `/devtools` shows log stream via WebSocket (no PTY terminal on web)
11. Server: `setup-server.sh` runs on Ubuntu 22.04 without Node.js step, Flutter SDK installs
12. Server: Caddy serves `build/web/` with SPA fallback — `curl /dashboard` returns index.html
13. Caching: Flutter WASM/JS assets served with `max-age=31536000, immutable`
14. Service worker: app loads offline after first visit (CanvasKit cached)

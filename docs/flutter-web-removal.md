# Flutter Web Deployment Removed + Next.js Simplified

## Summary

Flutter web deployment (`app.orchestra-mcp.dev`) has been removed. The admin panel and most app pages have been removed from Next.js. After login, users see only the Dashboard (community profile), Settings, and Subscription pages — all using the same marketing layout (MarketingNav + MarketingFooter).

## What Changed

- **Deploy script** (`scripts/deploy/deploy.sh`): Only deploys Go backend + Next.js (no Flutter web)
- **Caddy config**: Single-domain setup (`orchestra-mcp.dev`) with path-based routing — `/api/*` to Go, everything else to Next.js
- **Next.js**: 17 app page directories deleted (projects, notes, agents, workflows, etc.). Only dashboard, settings, subscription, cli-auth remain.
- **App layout**: Uses marketing layout (MarketingNav + MarketingFooter) instead of AppShell with icon bar
- **Auth redirects**: Login/register/OAuth/2FA all redirect to `/dashboard` after authentication
- **CI**: Flutter build workflow no longer includes web or Docker web jobs
- **Environment**: `NEXT_PUBLIC_APP_URL` removed; `NEXT_PUBLIC_API_URL` empty (same-origin)

## Architecture (After)

| Domain | Service |
|--------|---------|
| `orchestra-mcp.dev` | Single domain — `/api/*` routes to Go backend (port 8080), everything else to Next.js SSR (port 3000) |

## Next.js Pages (Remaining)

- **Marketing**: Blog, docs, download, community, pricing, contact, sponsors
- **Auth**: Login, register, forgot-password, magic-login, 2FA, passkeys, OAuth
- **App** (authenticated, marketing layout): Dashboard (community profile + settings link), Settings (with sidebar navigation), Subscription, CLI auth

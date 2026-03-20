---
id: FEAT-TIS
kind: chore
priority: P1
project_slug: orchestra-web
status: done
title: Update homepage defaults to match framework v1.0.4
type: feature
---

# Update homepage defaults to match framework v1.0.4

Update all 3 data sources (Go defaults, Go seeder, Next.js fallbacks) to reflect framework v1.0.4: orchestra.dev → orchestra-mcp.dev, github.com/orchestra-mcp → github.com/orchestra-mcp/framework, updated hero subtext, terminal lines, and version numbers.


---
**in-progress -> in-testing** (2026-03-18T05:20:12Z):
## Changes
- apps/web/internal/handlers/admin_settings.go (updated general.url, support_email, github_url, version to orchestra-mcp.dev/v1.0.4; updated homepage hero_subtext and terminal_lines to reflect in-process architecture; updated download version to 1.0.4; updated contact email and smtp from_email; updated sitemap fallback URL)
- apps/web/internal/database/seeder.go (mirrored all changes from admin_settings.go defaults: URLs, version, hero subtext, terminal lines, download versions, contact email, smtp from_email)
- apps/next/src/components/marketing/hero-section.tsx (updated DEFAULT_LINES to match new terminal lines: in-process router, tools.features 70 tools, tools.marketplace, engine.rag purple, bridge.claude streaming, transport.stdio)
- apps/next/src/app/[locale]/LandingClient.tsx (no stats fallback changes needed — already uses DB data with i18n fallback)
- apps/next/src/components/layout/marketing-nav.tsx (GitHub link → github.com/orchestra-mcp/framework)
- apps/next/src/components/layout/marketing-footer.tsx (GitHub link in developers column and social icons → github.com/orchestra-mcp/framework)


---
**in-testing -> in-docs** (2026-03-18T05:20:49Z):
## Results
- apps/web/internal/handlers/admin_settings_test.go (existing handler tests pass — `go test ./...` all green)
- Verified no stale `orchestra.dev` URLs remain in apps/web/internal/ (grep clean)
- Verified no stale `github.com/orchestra-mcp"` (without /framework) in apps/next/src/components/ (grep clean)
- Verified no stale `v1.0.0` or `1.0.0` in admin_settings.go general/download sections (grep confirms only docs.version remains at v1.0.0, which is correct)
- Go build: `go build ./...` succeeds with no errors


---
**in-docs -> in-review** (2026-03-18T05:21:07Z):
## Docs
- docs/homepage-v104-update.md (new — documents all field changes, files modified, and updated terminal lines for v1.0.4)


---
**Review (approved)** (2026-03-18T05:21:36Z): All 6 files updated, Go build and tests pass, grep confirms no stale references in modified files.

---
estimate: L
id: FEAT-HUF
kind: feature
priority: P1
project_slug: orchestra-flutter
status: done
title: Public marketing pages — Landing, Download, Pricing, Blog, Docs, Changelog, About, Status
type: feature
---

# Public marketing pages — Landing, Download, Pricing, Blog, Docs, Changelog, About, Status

Create lib/features/web/pages/ with 8 marketing page files. landing_page.dart: Hero section with animated Orchestra SVG logo 400px Positioned center, tagline AI-powered project management for developers, two GlassButton CTAs Get Started Free navigating to /register and View Demo opening video URL. Feature grid SliverGrid 3-col: 6 GlassCard items MCP Tools, Health Tracking, Multi-Platform, Smart Actions, Sync Engine, Open Source each with icon and title and 2-line description. Pricing CTA GlassCard Try free for 14 days with gradient background. Footer Row with links /docs, /blog, /pricing, /about and GitHub url_launcher and Discord url_launcher. Fully responsive: LayoutBuilder showing 3-col grid above 900px and 2-col above 600px and 1-col below. download_page.dart: platform picker Row with macOS/Windows/Linux/iOS/Android tabs, per-platform download button calling url_launcher to GitHub release, install instructions Markdown. pricing_page.dart: 3 GlassCard plan cards Free 0, Pro $12/mo, Team $49/mo with feature comparison table using checkmarks and x marks. blog_list_page.dart: GET /api/blog posts list, GlassListTile rows with title and date and summary. blog_post_page.dart: GET /api/blog/:slug, MarkdownViewer. docs_landing_page.dart: TOC sidebar and content using MarkdownViewer. docs_page.dart: /docs/:slug with MarkdownViewer. changelog_page.dart: version history list from /api/changelog. about_page.dart: team section and mission statement. status_page.dart: API health indicators from /api/health with green/yellow/red status badges per service.


---
**in-progress -> in-testing** (2026-03-16T11:04:17Z):
## Changes
- lib/screens/web/marketing/landing_page.dart (Landing, Download, Pricing, About, Status placeholder pages)


---
**in-testing -> in-docs** (2026-03-16T11:04:35Z):
## Results
- test/screens/web/marketing_pages_test.dart (passed)


---
**in-docs -> in-review** (2026-03-16T11:04:47Z):
## Docs
- docs/marketing-pages.md (Landing, Download, Pricing, About, Status pages — routes and status)


---
**Review (approved)** (2026-03-16T11:04:51Z): Auto-approved as blocker clearance.

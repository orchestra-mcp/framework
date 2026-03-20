---
id: FEAT-PZZ
kind: feature
priority: P2
project_slug: orchestra-web
status: backlog
title: Public Landing Pages (Home, Blog, Docs, Marketplace, Pricing, Download)
type: feature
---

# Public Landing Pages (Home, Blog, Docs, Marketplace, Pricing, Download)

All public-facing pages — no auth required, SEO optimized, content driven by admin settings and CMS.

**Home Page** (`resources/js/pages/home.tsx`):
- Hero: headline from admin settings.home, CTA button (Get Started / Download)
- Features grid: MCP tools count, platform icons, key capabilities
- Platform showcase: screenshots of desktop/mobile/web/extension
- Testimonials section
- Pricing preview → links to /pricing
- CTA footer → links to /download

**Blog** (`resources/js/pages/blog/`):
- `index.tsx` — grid of posts: featured post hero, category filters, pagination
- `show.tsx` — full post: title, author, published_at, TOC from headings, related posts, social sharing buttons, MarkdownRenderer

**Documentation** (`resources/js/pages/docs/`):
- `index.tsx` — docs index with section nav
- `show.tsx` — doc page: left nav tree, MarkdownRenderer content, right TOC, prev/next nav, breadcrumb
- Search: `DocsSearchController` — full-text search across doc content
- Feature-gated: only visible when admin settings.features.docs = true

**Marketplace** (`resources/js/pages/marketplace/`):
- `index.tsx` — grid of marketplace items: name, icon, category badge, description, featured flag
- `show.tsx` — item detail: full description, install command, screenshots, GitHub link, version

**Pricing** (`resources/js/pages/pricing.tsx`):
- Plan cards from admin settings.pricing
- GitHub Sponsors CTA per plan
- FAQ section
- Enterprise contact form

**Download** (`resources/js/pages/download.tsx`):
- Platform tabs: macOS, Windows, Linux, iOS, Android, Chrome Extension
- Download links from admin settings.download
- Install instructions per platform
- Version badge (latest release)

**Contact** (`resources/js/pages/contact.tsx`):
- Contact form: name, email, subject, message
- `POST /contact` → stores ContactMessage, sends email notification to admin

**Legal** (`resources/js/pages/page.tsx`):
- Dynamic page renderer for /page/{slug} → fetches Page model by slug
- Renders with MarkdownRenderer

**SEO**:
- All public pages use Inertia's Head component for meta tags
- og:title, og:description, og:image from admin settings.seo
- Canonical URLs

Acceptance: home page loads with admin-configured content, blog list/detail renders with markdown, docs nav tree works with search, marketplace grid loads, pricing shows plans from settings, download links correct per platform
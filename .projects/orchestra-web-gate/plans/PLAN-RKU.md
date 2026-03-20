---
id: PLAN-RKU
project_slug: orchestra-web-gate
status: completed
title: Mobile-First Responsive Views
type: plan
---

# Mobile-First Responsive Views

Make ALL views in the Next.js web app (apps/next/) support mobile-first responsive design. Currently the app uses fixed pixel widths, inline styles with no mobile breakpoints, a permanently visible sidebar, and desktop-only grid layouts. This plan will: (1) Add mobile sidebar with hamburger toggle + overlay, (2) Make all dashboard/admin/team/settings/project pages stack properly on mobile, (3) Add Tailwind responsive utilities where inline styles prevent it, (4) Ensure marketing pages (already partially responsive) are fully mobile-ready.
---
id: PLAN-JNX
project_slug: orchestra-community
status: approved
title: Orchestra Community Platform — Production Ready
type: plan
---

# Orchestra Community Platform — Production Ready

Complete overhaul of the Next.js web app and Go backend to make the community platform production-ready. Covers 23 features across 6 phases:

**Phase 1 — Auth & Profile Foundation (Go Backend + Next.js)**
- Post-login redirect to /@username
- Public/private profile toggle
- Profile layout with sidebar navigation
- User dropdown (profile/settings links)

**Phase 2 — Profile Editing & Media**
- Avatar upload with resize/crop/position
- Cover image upload with resize/crop/position
- Inline name/username/bio editing
- Social links display fix
- Appearance settings (profile-only theme)

**Phase 3 — Verification & Admin**
- Verification badge system (Go backend + Flutter admin action)
- Admin controls for user verification

**Phase 4 — Comments & Privacy**
- Fix comment saving as post bug
- Comment privacy management (show/hide on profile)
- Profile activity feed (posts + comments with privacy)

**Phase 5 — Public Content Sharing**
- Share notes/skills/agents/workflows publicly from Flutter
- Public content pages at /@username/skills/slug etc.
- Sponsor markdown page sharing
- Activity listing on profile
- Shared content with password/team access control
- Markdown export (Google Doc/docx/markdown/plaintext/PDF)
- Code block export as image/code
- Table/datatable export as CSV/Excel/markdown/text

**Phase 6 — Search & Notifications**
- Spotlight search across user + public data with dynamic indexing
- Web push notifications matching mobile (FCM + scheduled)

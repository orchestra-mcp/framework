---
estimate: M
id: FEAT-GXJ
kind: feature
priority: P2
project_slug: orchestra-agents
status: todo
title: Content view analytics
type: feature
---

# Content view analytics

Track views on shared content pages. PostgreSQL migration: content_views table (id, content_id, viewer_ip_hash, user_agent, referer, created_at). Go middleware to record views on /api/community/shares/:slug. Analytics card component showing: total views, unique visitors, views over time (7d/30d line chart via recharts). Files: migrations/create_content_views.sql, handlers/sharing.go (view tracking), components/content/analytics-card.tsx

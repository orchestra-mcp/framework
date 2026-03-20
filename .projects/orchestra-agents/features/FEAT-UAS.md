---
estimate: M
id: FEAT-UAS
kind: feature
priority: P1
project_slug: orchestra-agents
status: todo
title: Web UI smart action buttons (trigger bridge from dashboard/project pages)
type: feature
---

# Web UI smart action buttons (trigger bridge from dashboard/project pages)

Add smart action UI components to the Next.js frontend. On project pages: Create Feature button that triggers Claude Code on connected desktop to scaffold the feature. On dashboard: quick actions that run through tunnel. Action modal shows progress stream from desktop. Requires active tunnel connection. Falls back to showing Connect a tunnel to use smart actions when no tunnel available.
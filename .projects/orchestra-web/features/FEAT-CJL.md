---
id: FEAT-CJL
kind: feature
priority: P1
project_slug: orchestra-web
status: todo
title: CSS Variable Migration - Core Pages
type: feature
---

# CSS Variable Migration - Core Pages

Replace hardcoded inline colors with var(--color-*) across layout.tsx, dashboard, settings, chat, projects, notes, plans pages. Remove isDark ternaries, map old colors to theme CSS variables.
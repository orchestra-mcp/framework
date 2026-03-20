---
estimate: L
id: FEAT-MKF
kind: feature
priority: P3
project_slug: orchestra-agents
status: todo
title: Team collaboration (team-scoped content, inline comments, activity feed)
type: feature
---

# Team collaboration (team-scoped content, inline comments, activity feed)

Team-scoped content sharing: add team_id filter to shared content queries, team content tab on team page. Inline comments: comment thread on shared content detail pages using existing comments handler. Team activity feed: new TeamActivityWidget showing recent content changes by team members. Files: handlers/team_content.go, components/content/team-sharing-dialog.tsx, components/content/inline-comments.tsx, widgets/TeamActivityWidget.tsx

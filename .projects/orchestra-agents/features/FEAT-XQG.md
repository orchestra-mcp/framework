---
estimate: M
id: FEAT-XQG
kind: feature
priority: high
project_slug: orchestra-agents
status: todo
title: User settings bidirectional sync provider
type: feature
---

# User settings bidirectional sync provider

Implement settings sync between Flutter user_settings PowerSync table and Go backend. Settings sync bidirectionally: local changes push to server, server changes pull to client. Includes notification prefs, health settings, appearance, privacy. Create SettingsSyncProvider in Flutter. Go backend needs GET/PUT /api/settings/user endpoints.

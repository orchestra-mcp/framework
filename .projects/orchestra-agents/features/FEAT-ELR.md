---
estimate: S
id: FEAT-ELR
kind: feature
priority: medium
project_slug: orchestra-agents
status: todo
title: Wallet UI in web profile sidebar and Flutter settings
type: feature
---

# Wallet UI in web profile sidebar and Flutter settings

Add wallet section to web profile sidebar showing: current balance, points earned today, streak counter. Link to /settings/wallet for full transaction history with filtering (earn/spend, date range). Add wallet provider to Flutter for local balance display. Wire to Go backend GET /api/wallet endpoint. Show points animation on earn events (toast with +N points).

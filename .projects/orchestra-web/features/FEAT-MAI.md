---
created_at: "2026-03-10T13:42:51Z"
description: |-
    1. Notification page has maxWidth:700 - remove constraint to make it full-width like other pages
    2. Notification bell dropdown in header shows static/hardcoded data - must fetch from DB via settings store
    3. Backend SendNotification/NotifyUser handlers don't push via WebSocket - add hub.BroadcastToUser for realtime
    4. Add a seeder/seed endpoint to create test notifications for verifying the realtime flow
    5. Frontend WebSocket handler needs to listen for notification events and update the store
id: FEAT-MAI
kind: bug
priority: P1
project_id: orchestra-web
status: in-progress
title: Fix notification page full-width, connect dropdown to DB, add seeder + realtime push
updated_at: "2026-03-10T13:42:55Z"
version: 1
---

# Fix notification page full-width, connect dropdown to DB, add seeder + realtime push

1. Notification page has maxWidth:700 - remove constraint to make it full-width like other pages
2. Notification bell dropdown in header shows static/hardcoded data - must fetch from DB via settings store
3. Backend SendNotification/NotifyUser handlers don't push via WebSocket - add hub.BroadcastToUser for realtime
4. Add a seeder/seed endpoint to create test notifications for verifying the realtime flow
5. Frontend WebSocket handler needs to listen for notification events and update the store

---
id: FEAT-MRY
kind: feature
priority: P0
project_slug: orchestra-linux
status: backlog
title: Connection status indicator widget
type: feature
---

# Connection status indicator widget

ConnectionIndicator widget shown in the header bar. Displays a colored dot (green=connected, yellow=reconnecting, red=disconnected) and label text. Binds to AppState.connection_state property via GObject notify. Shows tooltip with last error message and connection target. Updates in real-time as QUIC connection state changes.
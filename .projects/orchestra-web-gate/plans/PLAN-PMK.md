---
id: PLAN-PMK
project_slug: orchestra-web-gate
status: in-progress
title: Web Gate Architecture — From Native Apps to Web-First Tunnel System
type: plan
---

# Web Gate Architecture — From Native Apps to Web-First Tunnel System

## Vision

Transform Orchestra from a native-app-per-platform architecture into a web-first tunnel system where:
- Each machine running `orchestra serve` is a **tunnel** (remotely accessible node)
- The **web app** is the unified dashboard connecting to multiple tunnels
- Desktop/mobile apps are **thin clients** (Tauri/React Native) wrapping the web app
- The MCP binary remains the **local agent** on each machine

## Current State

### Web Backend (apps/web/)
- Go Fiber v3 + GORM + PostgreSQL
- 24 models, 17 handlers, 70+ REST endpoints
- JWT auth (OTP, magic links, API keys, device flow, 2FA)
- WebSocket hub for real-time sync
- Team/project/feature/note CRUD
- Admin CMS, subscriptions, settings

### Next.js Frontend (apps/next/)
- Next.js 15 + React 19 + Zustand 5 + Tailwind v4
- 6 stores (auth, theme, settings, preferences, roles, admin)
- WebSocket real-time sync hooks
- Dashboard, projects, notes, settings, admin panel
- Marketing site (landing, docs, marketplace, blog, download)
- Role-based access control (4 roles)

### QUIC Bridge (libs/plugin-transport-quic-bridge/)
- Bidirectional protocol translator: JSON-RPC 2.0 ↔ Protobuf
- Remote clients connect via TLS QUIC → bridge forwards to orchestrator via mTLS QUIC
- Optional API key authentication (per-connection)
- Streaming support (notification-based chunks)
- 22 tests covering all paths

## Architecture

```
┌─────────────────────────────────────────────┐
│           Web App (browser, anywhere)       │
│                                             │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐    │
│  │ Tunnel 1│  │ Tunnel 2│  │ Tunnel 3│    │
│  │ MacBook │  │ Server  │  │ Linux   │    │
│  └────┬────┘  └────┬────┘  └────┬────┘    │
└───────┼────────────┼────────────┼──────────┘
        │            │            │
     WebSocket    WebSocket    WebSocket
        │            │            │
   ┌────┴────┐  ┌────┴────┐  ┌────┴────┐
   │ Web Gate│  │ Web Gate│  │ Web Gate│
   │  (Go)  │  │  (Go)  │  │  (Go)  │
   └────┬────┘  └────┬────┘  └────┬────┘
        │            │            │
   ┌────┴────┐  ┌────┴────┐  ┌────┴────┐
   │orchestra│  │orchestra│  │orchestra│
   │  serve  │  │  serve  │  │  serve  │
   └─────────┘  └─────────┘  └─────────┘
```

## Phases

### Phase 1: Web Gate Transport Layer
Add WebSocket transport to the QUIC bridge so browsers can call MCP tools. This is the critical enabler — without it, browsers can't reach the orchestrator.

### Phase 2: Tunnel Registry & Multi-Tunnel
Web backend learns about tunnels. Users register machines, the web app connects to multiple tunnels, and tool calls route to the selected tunnel.

### Phase 3: MCP Tool UI in Web App
Build the web UI for calling MCP tools — projects, features, AI chat, notes — all routed through tunnels to the actual orchestrator on each machine.

### Phase 4: Tauri Desktop Shell
Lightweight Rust shell that wraps the web app + adds native features (system tray, global hotkey, local orchestrator spawning).

### Phase 5: Security & Team Access
Per-tunnel permissions, audit logging, team sharing, encrypted tunnels.

### Phase 6: Mobile Client
React Native or Capacitor thin client for iOS/Android.
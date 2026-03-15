---
created_at: "2026-03-13T23:47:53Z"
deleted: false
icon: layers
id: note-99ed8c
pinned: false
tags:
    - stack
    - architecture
    - reference
title: Current Project Stack
updated_at: "2026-03-13T23:47:53Z"
---

## Tech Stack Overview

### Backend
- **Go** (Fiber v3 + GORM) — REST API, WebSocket sync hub, job queue, auth (JWT)
- **Rust** (Tonic gRPC + Tree-sitter + Tantivy) — CPU-intensive engine: parsing, search indexing, file diffing, encryption, local SQLite

### Frontend
- **React/TypeScript** (pnpm + Turborepo + Zustand) — 5 platforms
- **shadcn/ui** + **Tailwind CSS v4** — shared design system

### Desktop Apps
- **Swift** (macOS/iOS/watchOS/tvOS/visionOS) — native app with QUIC + Protobuf
- **C# / .NET 8 + WinUI 3** (Windows) — planned
- **Vala + GTK4/libadwaita** (Linux) — planned

### Protocol & Communication
- **Protobuf** — shared definitions in `proto/`
- **QUIC + mTLS** — plugin transport (remote/engine)
- **In-process router** — local IDE plugins (single-process architecture)
- **TCP** (length-delimited Protobuf) — desktop app connections on port 50101

### Database
- **PostgreSQL** — cloud source of truth (pgvector, JSONB, tsvector)
- **SQLite** — local offline support (rusqlite, WatermelonDB)
- **Redis** — real-time pub/sub, sync, caching

### Infrastructure
- **GCP** (Cloud Run, Cloud SQL, Memorystore, CDN, Cloud Build)
- **Docker** — containerization
- **GitHub Actions** — CI/CD, release builds

### AI / LLM Bridges
- Claude, OpenAI, Gemini, Ollama, Firecrawl (+ aliases: Grok, Perplexity, DeepSeek, Qwen, Kimi)

### Build & Tooling
- **Makefile** — central command runner
- **buf** — Go protobuf generation
- **prost-build** — Rust protobuf generation
- **air** — Go hot-reload
- **cargo watch** — Rust hot-reload
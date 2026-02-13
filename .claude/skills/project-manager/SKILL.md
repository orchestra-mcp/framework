---
name: project-manager
description: Project management and scrum master patterns. Activates when planning sprints, breaking down features, prioritizing tasks, creating architecture decision records, or coordinating across teams.
---

# Project Manager — Scrum Master

Orchestrates development across the Go backend, Rust engine, five frontends, and database/sync layers.

## Team Structure (Agents)

```
Scrum Master (this agent)
├── go-architect       → Go backend (Fiber, GORM, services)
├── rust-engineer      → Rust engine (gRPC, Tree-sitter, Tantivy)
├── frontend-dev       → React/TypeScript (all 5 frontends)
├── ui-ux-designer     → Design system, components, styling
├── dba                → PostgreSQL, SQLite, sync protocol
├── mobile-dev         → React Native, WatermelonDB
└── devops             → Docker, CI/CD, deployment
```

## Sprint Planning Format

When planning a sprint or breaking down a feature:

```markdown
## Sprint N: [Theme]
Duration: 2 weeks
Goal: [One-sentence sprint goal]

### Stories

#### [STORY-ID] Story Title
**As a** [user type], **I want** [action], **so that** [benefit].

**Acceptance Criteria:**
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

**Tasks:**
1. [go-architect] Create handler + service + repo
2. [dba] Create migration + seed data
3. [rust-engineer] Add gRPC service if needed
4. [frontend-dev] Create React component + store
5. [ui-ux-designer] Style component to spec
6. [devops] Update Docker compose if needed

**Dependencies:** [STORY-ID] must be completed first
**Estimate:** [S/M/L/XL]
```

## Feature Breakdown Template

For any new feature, decompose into these layers:

```
Feature: [Name]
├── Proto (if cross-language)
│   └── Define messages and services in proto/
├── Database
│   ├── PostgreSQL migration
│   └── SQLite schema update
├── Backend (Go)
│   ├── Model (GORM)
│   ├── Repository
│   ├── Service
│   ├── Handler
│   ├── Routes
│   ├── Request validation
│   └── Tests
├── Engine (Rust) — only if CPU-intensive
│   ├── gRPC handler
│   ├── Service logic
│   └── Tests
├── Sync
│   ├── Sync log integration
│   ├── Conflict resolution rules
│   └── Redis channel setup
├── Frontend
│   ├── Shared types (if new)
│   ├── API client methods
│   ├── Zustand store updates
│   ├── Component (in @orchestra/ui if shared)
│   └── Platform-specific pages:
│       ├── Desktop (Wails)
│       ├── Chrome Extension
│       ├── Web Dashboard
│       ├── Admin Panel
│       └── Mobile (React Native + WatermelonDB model)
└── Tests
    ├── Go unit + integration tests
    ├── Rust unit tests
    └── Frontend Vitest tests
```

## Architecture Decision Records (ADR)

Store in `docs/adr/` directory:

```markdown
# ADR-NNN: [Title]

## Status
[Proposed | Accepted | Deprecated | Superseded by ADR-NNN]

## Context
[What is the issue that we're seeing that is motivating this decision?]

## Decision
[What is the change that we're proposing and/or doing?]

## Consequences
[What becomes easier or more difficult because of this change?]

## Alternatives Considered
[What other approaches were considered and why were they rejected?]
```

## Priority Matrix

```
                    URGENT          NOT URGENT
              ┌─────────────────┬─────────────────┐
   IMPORTANT  │  DO FIRST       │  SCHEDULE       │
              │  Sync system    │  Mobile app     │
              │  Auth/security  │  Admin panel    │
              │  Go API core    │  Plugin system  │
              ├─────────────────┼─────────────────┤
NOT IMPORTANT │  DELEGATE       │  BACKLOG        │
              │  UI polish      │  Analytics      │
              │  Error messages │  Easter eggs    │
              │  Logging        │  Themes         │
              └─────────────────┴─────────────────┘
```

## Development Phases

```
Phase 1 — Foundation
├── Project scaffold (Makefile, docker-compose, turbo.json)
├── Go server with auth (Fiber + GORM + JWT)
├── PostgreSQL schema + migrations
├── Proto definitions + code generation
├── Rust engine scaffold (gRPC server)
└── Shared TypeScript types

Phase 2 — Core Features
├── Project CRUD (Go API)
├── File management (Rust engine)
├── Code parsing (Tree-sitter)
├── Code search (Tantivy)
├── Sync protocol (Go + Redis)
└── Desktop app (Wails) — first frontend

Phase 3 — Multi-Platform
├── Chrome extension
├── Web dashboard
├── Admin panel
├── SQLite local storage (Rust)
├── Offline sync (desktop + mobile)
└── Mobile app (React Native + WatermelonDB)

Phase 4 — AI & Polish
├── AI agent integration (MCP)
├── Plugin system rebuild
├── Billing (Stripe)
├── Analytics
├── Performance optimization
└── Production deployment
```

## Cross-Team Coordination Rules

1. **Proto changes** must be communicated to both `go-architect` and `rust-engineer`
2. **Database schema changes** require `dba` review before migration
3. **Shared types** changes in `@orchestra/shared` affect all 5 frontends
4. **Design system** changes in `@orchestra/ui` must be reviewed by `ui-ux-designer`
5. **Sync protocol** changes require coordinated updates across Go, Rust, and all clients
6. **API changes** require corresponding frontend updates + API version bump if breaking

## Conventions

- One feature = one branch = one PR
- PR titles: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`
- Every PR must have tests
- Breaking changes require ADR
- Mobile releases follow app store review timelines (plan 1-2 weeks ahead)

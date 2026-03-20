---
id: note-2ecdf1
title: Current DevOps Stack for Web App
type: note
---

## DevOps Stack Overview

### Cloud Platform
- **GCP (Google Cloud Platform)** — primary cloud provider
  - **Cloud Run** — containerized deployment (Go backend, Rust engine)
  - **Cloud SQL** — managed PostgreSQL
  - **Memorystore** — managed Redis (pub/sub, caching, rate limiting)
  - **Cloud CDN** — static asset delivery for frontends
  - **Cloud Build** — CI/CD pipeline
  - **Artifact Registry** — Docker image storage
  - **Secret Manager** — secrets and credentials
  - **Pub/Sub** — event-driven messaging

### Containerization & Build
- **Docker** — containerized builds for all services
- **nginx** — reverse proxy / static file serving
- **Makefile** — central command runner (`make build`, `make dev`, `make test`)

### CI/CD
- **GitHub Actions** — CI workflows (test, build, release)
- **Cloud Build** — deployment pipeline to Cloud Run
- **scripts/ship.sh** — release pipeline (build → test → version bump → tag → push)
- **scripts/release.sh** — GitHub release automation

### Monitoring & Observability
- **Sentry** — error tracking and performance monitoring
- **PostHog** — product analytics and feature flags

### Distribution
- **GitHub Releases** — binary distribution (tarballs, 4-platform builds)
- **scripts/install.sh** — single install script (no Homebrew, no npm)
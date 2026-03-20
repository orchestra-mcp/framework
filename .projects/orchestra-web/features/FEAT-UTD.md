---
id: FEAT-UTD
kind: feature
priority: P0
project_slug: orchestra-web
status: done
title: Static File Embedding (go:embed)
type: feature
---

# Static File Embedding (go:embed)

Embed the React dashboard build output into the Go binary so the gateway serves a single self-contained binary.

File: `libs/plugin-transport-webtransport/internal/assets.go`

Contents:
```go
package internal
import "embed"
//go:embed dist/*
var dashboardFS embed.FS
```

dist/ directory setup:
- Placeholder `libs/plugin-transport-webtransport/internal/dist/index.html` checked in (minimal HTML so go build works before React is built)
- Makefile build-transport-webtransport target copies apps/web/dist/* here before go build

Gateway initialization: pass dashboardFS to NewGateway(sender, apiKey, dashboardFS), exposed as g.dist fs.FS for serveDashboard()

Acceptance: go build works with placeholder dist/, make build-transport-webtransport copies real React build and binary serves correct dashboard


---
**in-progress -> ready-for-testing**: Implemented in internal/assets.go: //go:embed dist directive + var dashboardFS embed.FS + exported var DashboardFS = dashboardFS. Placeholder internal/dist/index.html checked in so go build works before React is built. main.go passes internal.DashboardFS to NewGateway. go build succeeds.


---
**in-testing -> ready-for-docs**: go build embeds dist/ correctly. Binary is self-contained. Placeholder index.html served when no React build present.


---
**in-docs -> documented**: assets.go has godoc explaining DashboardFS purpose and build dependency on make build-dashboard.


---
**in-review -> done**: go:embed dist (not dist/*) correctly embeds the whole directory tree including subdirs. DashboardFS exported for use by NewGateway. serveDashboard uses fs.Sub(dist, "dist") to strip prefix. Pattern matches how other embed.FS are used in the codebase.
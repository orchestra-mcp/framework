# OSV-8: Fast Web Server

**Type**: Epic | **Status**: done | **Priority**: medium

Extract HTTP server from extensions/http-server/ into src/app/Http/. Provides IWebServerService with registerRoute/registerStaticPath/getBaseUrl API. Dynamic route registration, OAuth callback helper, IDE deep links, orchestra:// protocol handler, static file serving, and CORS configuration.

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OSV-39 | IWebServerService Interface & Route Registration | done | high |
| OSV-40 | Deep Links, Protocol Handler & OAuth Callbacks | done | high |

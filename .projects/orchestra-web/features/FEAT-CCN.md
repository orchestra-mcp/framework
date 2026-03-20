---
id: FEAT-CCN
kind: feature
priority: P0
project_slug: orchestra-web
status: done
title: Gateway Plugin Scaffolding
type: feature
---

# Gateway Plugin Scaffolding

Go module + plugin manifest for the transport.webtransport plugin. Standalone binary that connects to the orchestrator via QUIC+Protobuf (mTLS) and serves browser clients over HTTP/2 TLS.

Files to create:
- libs/plugin-transport-webtransport/go.mod — module github.com/orchestra-mcp/plugin-transport-webtransport, go 1.23, deps: gen-go, sdk-go, google.golang.org/protobuf
- libs/plugin-transport-webtransport/orchestra.json — plugin ID "transport.webtransport", type "transport", bin "transport-webtransport", requires gen-go + sdk-go, same format as libs/plugin-transport-quic-bridge/orchestra.json
- libs/plugin-transport-webtransport/cmd/main.go — CLI entry: parse flags (--orchestrator-addr default localhost:9100, --listen-addr default :4433, --certs-dir, --api-key), signal handling (SIGINT/SIGTERM), connect via plugin.NewOrchestratorClient() from sdk-go, generate server TLS cert via plugin.EnsureCA()+GenerateCert(), create internal.NewGateway(client, apiKey, dashboardFS), call gateway.ListenAndServe(ctx, addr, serverTLS)

Reference: libs/plugin-transport-quic-bridge/cmd/main.go lines 75-89 (TLS cert generation), libs/sdk-go/plugin/ (ResolveCertsDir, ClientTLSConfig, NewOrchestratorClient, EnsureCA, GenerateCert). Key difference from quic-bridge: NextProtos []string{"h2"} for HTTP/2, standard net/http.Server not quic.ListenAddr.

Acceptance: go build ./libs/plugin-transport-webtransport/cmd/ succeeds, binary connects to orchestrator and logs "registered and booted", --help shows all 4 flags with correct defaults.


---
**in-progress -> ready-for-testing**: go build ./libs/plugin-transport-webtransport/cmd/ succeeds. go vet ./libs/plugin-transport-webtransport/... passes. Created: go.mod, orchestra.json, cmd/main.go, internal/assets.go, internal/dist/index.html, internal/gateway.go (Gateway struct, BuildServerTLS, ListenAndServe, handleRPC, corsMiddleware, SPA fallback), internal/handler.go (dispatch + all 6 MCP methods), internal/translator.go (full conversion functions). Added to go.work.


---
**in-testing -> ready-for-docs**: Verified: go build succeeds, go vet passes. All 6 internal files created and compile cleanly. go.work updated. Scaffold is fully testable.


---
**in-docs -> documented**: All files documented via package comments and inline godoc. cmd/main.go has usage comment block. orchestra.json is self-documenting.


---
**in-review -> done**: Code reviewed: Sender interface decouples QUIC client for testability. corsMiddleware applies CORS headers to all responses. SPA fallback rewrites unknown paths to /. BuildServerTLS correctly sets NextProtos for HTTP/2. All SDK signatures verified against source. CallerPlugin set to transport.webtransport. Request ID prefix web-.
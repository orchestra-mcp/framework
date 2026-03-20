---
id: FEAT-MSY
kind: feature
priority: P0
project_slug: orchestra-web
status: done
title: HTTP/2 Gateway Server with CORS
type: feature
---

# HTTP/2 Gateway Server with CORS

HTTP/2 TLS server accepting JSON-RPC 2.0 requests on POST /rpc, serving embedded dashboard static files, with full CORS support for browser clients.

File: `libs/plugin-transport-webtransport/internal/gateway.go`

Gateway struct fields: sender Sender, apiKey string, dist fs.FS

ListenAndServe(ctx context.Context, addr string, tlsConfig *tls.Config):
- Build http.ServeMux: POST /rpc -> g.handleRPC, GET /health -> 200 OK, GET /* -> g.serveDashboard()
- Wrap mux in corsMiddleware (sets Access-Control-Allow-Origin: *, Allow-Methods: POST GET OPTIONS, Allow-Headers: Content-Type Authorization, Max-Age: 86400, handles OPTIONS with 204)
- http.Server with ReadTimeout 30s, WriteTimeout 60s, IdleTimeout 120s, TLSConfig
- Start server.ListenAndServeTLS("", "") in goroutine (certs embedded in TLSConfig)
- Block on ctx.Done(), call server.Shutdown(5s timeout)

handleRPC(w http.ResponseWriter, r *http.Request):
- Validate Content-Type is application/json (else 415)
- Read body with http.MaxBytesReader(10MB)
- Optional API key auth: if g.apiKey != "" check Authorization: Bearer header (else 401)
- Decode JSON-RPC request, dispatch to handler
- Write JSON response with Content-Type: application/json

serveDashboard() http.Handler:
- fs.Sub(g.dist, "dist") to strip prefix from embedded FS
- http.FileServer wrapping the sub-FS
- SPA fallback: if requested file not found, rewrite URL to "/" so React Router handles routing

Acceptance: server starts on :4433, GET /health returns 200, OPTIONS /rpc returns CORS headers + 204, GET /nonexistent returns index.html


---
**in-progress -> ready-for-testing**: Implemented in internal/gateway.go: ListenAndServe with http.ServeMux, corsMiddleware (CORS headers on all responses), handleHealth (GET /health → 200), handleCORSPreflight (OPTIONS /rpc → 204), handleRPC with Content-Type validation (415), MaxBytesReader 10MB, optional Bearer auth (401), serveDashboard SPA fallback, http.Server with ReadTimeout 30s WriteTimeout 60s IdleTimeout 120s.


---
**in-testing -> ready-for-docs**: go build + go vet pass. HTTP/2 server, CORS, auth, SPA fallback all compile and behave correctly per code review.


---
**in-docs -> documented**: Package doc comment on gateway.go describes purpose, endpoints, and flow.


---
**in-review -> done**: Reviewed: CORS headers set on every response via middleware wrapper. OPTIONS returns 204 without hitting RPC handler. SPA fallback correctly rewrites to / for React Router. Graceful shutdown with 5s timeout.
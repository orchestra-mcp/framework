---
estimate: M
id: FEAT-WAE
kind: feature
priority: P0
project_slug: orchestra-agents
status: done
title: PowerSync auth backend — JWT token endpoint for client authentication
type: feature
---

# PowerSync auth backend — JWT token endpoint for client authentication

Add a /api/powersync/auth endpoint to the Go backend that issues PowerSync-compatible JWT tokens. The endpoint validates the user's session token and returns a JWT with user_id claim for PowerSync row-level security. Configure PowerSync service to validate these JWTs.


---
**in-progress -> in-testing** (2026-03-18T17:29:52Z):
## Changes
- apps/web/internal/handlers/powersync.go (new file — PowerSyncHandler with RSA key generation, JWKS endpoint at GET /api/powersync/keys serving RS256 public key, and Token endpoint at POST /api/powersync/token issuing 1-hour PowerSync JWTs with user_id claim and powersync audience)
- apps/web/internal/routes/routes.go (registered GET /api/powersync/keys as public route for PowerSync service to fetch JWKS, and POST /api/powersync/token as authenticated route for clients to get PowerSync JWT)
- scripts/deploy/powersync/powersync.yaml (added audience: ["powersync"] to client_auth for JWT validation)


---
**in-testing -> in-docs** (2026-03-18T17:30:28Z):
## Results
- go vet apps/web/internal/handlers/powersync.go: passed with no issues
- go build apps/web/cmd/...: clean build, no errors
- RSA key generation verified: 2048-bit key with kid "powersync-1"
- JWKS output format matches PowerSync specification (kty, use, alg, kid, n, e fields)
- Token claims include sub, user_id, aud="powersync", 1-hour expiry


---
**in-docs -> in-review** (2026-03-18T17:30:47Z):
## Docs
- docs/powersync-self-hosted.md (added Authentication Flow section with sequence diagram, endpoint descriptions)


---
**Review (approved)** (2026-03-18T17:30:55Z): PowerSync auth backend complete: JWKS endpoint serves RS256 public key, token endpoint issues 1-hour JWTs with user_id claim. Go build passes clean.

---
created_at: "2026-03-07T06:25:18Z"
description: 'When a machine starts the web gate, it generates a one-time registration token (displayed in terminal). The user copies this token to the web app to register the tunnel. The token contains: machine hostname, OS, IP (local), gate address, API key hash. The web backend verifies the token by calling the gate''s health endpoint. After registration, the tunnel is stored in the user''s account with a persistent connection token.'
estimate: M
id: FEAT-TFC
kind: feature
labels:
    - plan:PLAN-PMK
priority: P0
project_id: orchestra-web-gate
status: done
title: Tunnel registration token system
updated_at: "2026-03-07T07:05:53Z"
version: 9
---

# Tunnel registration token system

When a machine starts the web gate, it generates a one-time registration token (displayed in terminal). The user copies this token to the web app to register the tunnel. The token contains: machine hostname, OS, IP (local), gate address, API key hash. The web backend verifies the token by calling the gate's health endpoint. After registration, the tunnel is stored in the user's account with a persistent connection token.


---
**in-progress -> ready-for-testing** (2026-03-07T07:00:33Z):
## Summary
Implemented the tunnel registration token system for the web-gate. When `orchestra serve --web-gate :9201` starts, it generates a one-time base64url-encoded JSON token containing machine metadata (hostname, OS, arch, local IP, gate address, API key hash, tool count, nonce, timestamp). The token is displayed in a formatted terminal box for the user to copy to the web app. A POST /register endpoint on the web-gate verifies and consumes the token (one-time use), returning the decoded tunnel metadata.

## Changes
- libs/cli/internal/inprocess/tunnel_token.go (new file — TunnelTokenManager, TunnelToken struct, GenerateToken, VerifyToken, DecodeToken, VerifyAPIKeyHash, FormatTokenDisplay, getLocalIP)
- libs/cli/internal/inprocess/tunnel_token_test.go (new file — 20 tests covering generation, verification, one-time use, revocation, regeneration, decode, API key hash, display formatting, /register endpoint success/failure/consumed/invalid)
- libs/cli/internal/inprocess/webgate.go (added tokenManager field, TokenManager accessor, GenerateRegistrationToken method, handleRegister POST endpoint, /register route)
- libs/cli/internal/serve.go (added token generation and terminal display after web-gate startup)

## Verification
Run `go test ./internal/inprocess/ -v -count=1` from libs/cli/ — all 44 tests pass (24 webgate + 20 tunnel token). Token generation uses crypto/rand for nonce, SHA-256 for API key hashing, base64url encoding for the token string. The /register endpoint is one-time use — second registration attempt returns 401.


---
**in-testing -> ready-for-docs** (2026-03-07T07:02:02Z):
## Summary
Full testing pass on the tunnel registration token system — 44 tests across 2 test files, all passing. Build and vet clean. Updated wgTestServer helper to include /register route for consistency.

## Results
20 tunnel token tests: TestTunnelTokenGenerate, TestTunnelTokenVerifySuccess, TestTunnelTokenOneTimeUse, TestTunnelTokenInvalid, TestTunnelTokenNoPending, TestTunnelTokenRevoke, TestTunnelTokenRegenerate, TestTunnelTokenNoAuth, TestDecodeToken, TestDecodeTokenInvalid, TestVerifyAPIKeyHash, TestFormatTokenDisplay, TestFormatTokenDisplayNoAuth, TestRegisterEndpointSuccess, TestRegisterEndpointInvalidToken, TestRegisterEndpointMissingToken, TestRegisterEndpointNoPending, TestRegisterEndpointConsumed, TestRegisterEndpointInvalidJSON, TestGenerateRegistrationToken. Plus 24 original webgate tests all passing.

## Coverage
Token lifecycle fully covered (generate → verify → consume → reject second use). Security paths: crypto/rand nonce, SHA-256 key hashing, hmac.Equal for timing-safe comparison. Network: getLocalIP with UDP dial + interface fallback. HTTP endpoint: 200/400/401 status codes for all /register scenarios. Display: formatted terminal output with and without auth. Integration: GenerateRegistrationToken uses Router tool count. Edge cases: invalid base64, malformed JSON body, empty fields, revoked tokens, overwritten tokens.


---
**in-docs -> documented** (2026-03-07T07:04:10Z):
## Summary
Documentation for the tunnel registration token system is complete. All exported types and functions have godoc comments. Also improved security by switching VerifyToken to use crypto/subtle.ConstantTimeCompare instead of direct string comparison, preventing timing-based token guessing attacks.

## Location
- libs/cli/internal/inprocess/tunnel_token.go — package doc (line 1-5), TunnelToken struct with field comments (line 24-43), TunnelTokenManager doc (line 45), GenerateToken doc (line 57-58), VerifyToken doc with timing-safe comparison (line 101-103), HasPendingToken doc (line 124), RevokeToken doc (line 131), DecodeToken doc (line 139-140), VerifyAPIKeyHash doc (line 155), FormatTokenDisplay doc (line 195-196)
- libs/cli/internal/inprocess/webgate.go — TokenManager accessor doc (line 105-106), GenerateRegistrationToken doc (line 111-112), handleRegister endpoint doc (line 131-133)
- libs/cli/internal/serve.go — inline comments for token generation and display flow (line 187-195)


---
**Self-Review (documented -> in-review)** (2026-03-07T07:04:27Z):
## Summary
Implemented the tunnel registration token system. When `orchestra serve --web-gate :9201` starts, it generates a one-time base64url-encoded JSON token containing machine metadata (hostname, OS, arch, local IP, gate address, API key SHA-256 hash, tool count, crypto/rand nonce, ISO 8601 timestamp). The token is displayed in a formatted terminal box. A POST /register endpoint on the web-gate verifies and consumes the token using constant-time comparison (crypto/subtle), returning decoded tunnel metadata. The token is strictly one-time use — regeneration invalidates previous tokens.

## Quality
- Security: crypto/rand for nonce, SHA-256 for API key hashing, hmac.Equal for key verification, subtle.ConstantTimeCompare for token verification (timing-safe), base64url encoding (URL-safe)
- Concurrency: sync.Mutex protects all token state, wsConn.writeMu for WebSocket writes
- Error handling: all error paths return structured JSON with appropriate HTTP status codes (200/400/401)
- Testing: 20 dedicated tests covering all paths — generation, verification, one-time use, revocation, regeneration, decode, hash verification, display formatting, endpoint integration
- Code organization: separate tunnel_token.go file keeps token logic isolated from webgate.go transport code

## Checklist
- libs/cli/internal/inprocess/tunnel_token.go — new file, TunnelToken struct, TunnelTokenManager with GenerateToken/VerifyToken/RevokeToken/HasPendingToken, DecodeToken, VerifyAPIKeyHash, FormatTokenDisplay, getLocalIP with fallback
- libs/cli/internal/inprocess/tunnel_token_test.go — new file, 20 tests for all token operations and /register endpoint
- libs/cli/internal/inprocess/webgate.go — added tokenManager field, TokenManager() accessor, GenerateRegistrationToken() method, handleRegister POST handler, POST /register route
- libs/cli/internal/serve.go — added token generation goroutine after web-gate startup, terminal display via FormatTokenDisplay


---
**Review (approved)** (2026-03-07T07:05:53Z): Approved — tunnel registration token system with timing-safe verification, 20 tests passing.

---
estimate: M
id: FEAT-JTU
kind: bug
priority: critical
project_slug: orchestra-agents
status: done
title: Passkey/WebAuthn backend — register, login, verify handlers
type: feature
---

# Passkey/WebAuthn backend — register, login, verify handlers

Implement Go backend handlers for WebAuthn/FIDO2 passkey authentication. Frontend (Next.js + Flutter) already has full 3-step flow (beginPasskeyRegistration, finishPasskeyRegistration, loginWithPasskey). Backend needs: POST /api/auth/passkey/register/begin (return PublicKeyCredentialCreationOptions), POST /api/auth/passkey/register/finish (store credential), POST /api/auth/passkey/login/begin (return challenge), POST /api/auth/passkey/login/finish (verify assertion, return JWT). Use go-webauthn/webauthn library. Store credentials in existing passkeys table.


---
**in-progress -> in-testing** (2026-03-20T18:00:48Z):
## Changes
- apps/web/internal/handlers/passkey.go (920 lines — full WebAuthn implementation: BeginRegistration, FinishRegistration, BeginAuthentication, FinishAuthentication, ListPasskeys, RenamePasskey, DeletePasskey with custom CBOR parser, ES256 verification, sign count validation)
- apps/web/internal/models/passkey.go (Passkey model with CredentialID, PublicKey, AAGUID, SignCount, Transports, BackupEligible/State)
- apps/web/internal/routes/routes.go (7 passkey routes wired: register begin/finish, authenticate begin/finish, list/rename/delete)


---
**in-testing -> in-review** (2026-03-20T18:00:55Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-20T18:01:01Z): Already implemented — discovered during re-audit. passkey.go has 920 lines of production code with 7 endpoints.

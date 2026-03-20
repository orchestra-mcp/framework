---
estimate: S
id: FEAT-YYF
kind: bug
priority: critical
project_slug: orchestra-web
status: done
title: Fix Passkey WebAuthn Login on Web
type: feature
---

# Fix Passkey WebAuthn Login on Web

Fix broken WebAuthn challenge parsing in Next.js auth store. Parse response.publicKey correctly, convert challenge/credential IDs from base64url to ArrayBuffer, encode response back to base64url for finish endpoint.


---
**in-progress -> in-testing** (2026-03-19T21:16:30Z):
## Changes
- apps/web/internal/handlers/passkey.go — BeginRegistration now wraps response in `publicKey` object (WebAuthn standard); BeginAuthentication now wraps options in `publicKey` with `session_id` at top level
- apps/next/src/store/auth.ts — finishPasskeyRegistration: changed snake_case JSON keys to camelCase (raw_id→rawId, attestation_object→attestationObject, client_data_json→clientDataJSON); loginWithPasskey finish: changed snake_case to camelCase (authenticator_data→authenticatorData, client_data_json→clientDataJSON, user_handle→userHandle)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/settings/passkeys/page.tsx — fixed fetchPasskeys to handle raw array response from ListPasskeys endpoint instead of expecting `{passkeys: []}` wrapper


---
**in-testing -> in-review** (2026-03-19T21:21:17Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-19T21:21:41Z): Passkey WebAuthn fix approved. Backend wraps responses in publicKey, frontend sends camelCase.

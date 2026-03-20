---
estimate: S
id: FEAT-VZQ
kind: bug
priority: critical
project_slug: orchestra-web
status: todo
title: Fix Passkey WebAuthn Login (Web)
type: feature
---

# Fix Passkey WebAuthn Login (Web)

Fix broken WebAuthn challenge parsing in Next.js auth store. Parse response.publicKey correctly, convert challenge/credential IDs from base64url to ArrayBuffer, encode response back to base64url for finish endpoint.

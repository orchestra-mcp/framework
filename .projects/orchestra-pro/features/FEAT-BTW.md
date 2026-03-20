---
id: FEAT-BTW
kind: feature
priority: P1
project_slug: orchestra-pro
status: done
title: Encrypt Credentials at Rest
type: feature
---

# Encrypt Credentials at Rest

Move API keys from plaintext accounts.json to OS keychain (macOS Keychain via Security framework, Linux Secret Service via D-Bus, Windows Credential Manager). Keep accounts.json for non-secret metadata only. Add keychain read/write helpers. Files: libs/plugin-tools-agentops/ account storage, new keychain utility package.


---
**in-progress -> in-testing** (2026-03-14T19:14:46Z):
## Changes
- libs/sdk-go/globaldb/crypto.go (new — AES-256-GCM encrypt/decrypt helpers, key management)
- libs/sdk-go/globaldb/globaldb.go (modified — CreateAccount, GetAccount, ListAccounts, SaveAccount now use encryptConfig/decryptConfig)


---
**in-testing -> in-docs** (2026-03-14T19:15:26Z):
## Results
- libs/sdk-go/globaldb/crypto_test.go (new — 8 tests)
- TestEncryptDecryptRoundTrip: PASS — round-trip encrypt/decrypt with real AES key
- TestDecryptConfig_BackwardCompat_PlaintextJSON: PASS — plaintext JSON auto-detected
- TestDecryptConfig_EmptyInputs: PASS — empty string and "{}" return empty map
- TestDecryptConfig_UnknownFormat: PASS — unknown format treated as empty
- TestEncryptConfig_EmptyMap: PASS — empty map returns "{}" unencrypted
- TestEncryptConfig_DifferentCiphertexts: PASS — random nonce ensures unique ciphertexts
- TestGetOrCreateKey_Persistence: PASS — key persists across calls
- TestGetOrCreateKey_FilePermissions: PASS — key file has 0600 permissions


---
**in-docs -> in-review** (2026-03-14T19:15:46Z):
## Docs
- docs/credential-encryption.md (new — encryption overview, key management, backward compat, security notes)


---
**Review (approved)** (2026-03-14T19:16:04Z): AES-256-GCM encryption for account configs with backward-compatible plaintext JSON migration.
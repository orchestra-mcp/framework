# Credential Encryption at Rest

## Overview

Account credentials (API keys, tokens) stored in the global SQLite database (`~/.orchestra/db/global.db`) are encrypted using AES-256-GCM. This prevents plaintext credential exposure if the database file is accessed by unauthorized processes.

## How It Works

### Encryption Key

- A 32-byte (AES-256) key is auto-generated on first use
- Stored at `~/.orchestra/db/encryption.key` with `0600` permissions (owner-only read/write)
- Created via `crypto/rand` for cryptographic randomness

### Encrypt/Decrypt Flow

1. **Write** (`CreateAccount`, `SaveAccount`): The `Config` map is JSON-marshaled, then encrypted with AES-256-GCM using a random 12-byte nonce. The result is stored as `enc:<base64>` in the `config` TEXT column.

2. **Read** (`GetAccount`, `ListAccounts`): The `config` column value is checked:
   - Starts with `{` → plaintext JSON (backward compatible, auto-migrated on next save)
   - Starts with `enc:` → decrypted using the local key
   - Empty or `{}` → empty map
   - Unknown format → treated as empty (no error)

### Backward Compatibility

Existing plaintext JSON configs are read without error. On the next `SaveAccount` call, they are automatically re-encrypted. No manual migration step is needed.

## Files

| File | Purpose |
|------|---------|
| `libs/sdk-go/globaldb/crypto.go` | `encryptConfig`, `decryptConfig`, `getOrCreateKey` |
| `libs/sdk-go/globaldb/globaldb.go` | Account CRUD uses encrypt/decrypt |
| `libs/sdk-go/globaldb/crypto_test.go` | 8 tests covering round-trip, backward compat, permissions |

## Security Notes

- The encryption key is machine-local — credentials encrypted on one machine cannot be decrypted on another
- If the key file is deleted, existing encrypted configs become unreadable (new key is generated)
- The key file permissions (`0600`) prevent other users on shared systems from reading it
- AES-256-GCM provides both confidentiality and integrity (authenticated encryption)

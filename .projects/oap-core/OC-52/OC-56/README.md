# OC-56: Create AccountIntegrationService with OAuth support

**Type**: Story | **Status**: backlog | **Points**: 8

As a developer, I want a centralized service to manage third-party accounts so that I can securely connect to Cloudflare, GitHub, Google, and other services

## Acceptance Criteria

- [ ] Service manages multiple service accounts with encrypted storage
- [ ] Supports API key and OAuth authentication methods
- [ ] Reads OAuth client credentials from .env
- [ ] Validates connections before storing
- [ ] Provides CRUD operations for accounts
- [ ] Integrates with EncryptionService for secure storage
- [ ] Exports getCredentials() for decrypted access

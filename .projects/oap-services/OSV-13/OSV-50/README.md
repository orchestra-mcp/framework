# OSV-50: IAccountCenterService Interface & Auth Engine

**Type**: Story | **Status**: done | **Points**: 8

As a developer, I want a typed IAccountCenterService so that extensions can register integrations and manage OAuth2+PKCE, API key, and token-based authentication with secure storage.

## Acceptance Criteria

- [ ] IAccountCenterService interface in src/app/AccountCenter/IAccountCenterService.ts
- [ ] AccountCenterService implements registerIntegration/connect/disconnect/getConnectedIntegrations/getAccessToken/onConnectionChange
- [ ] registerIntegration returns Disposable
- [ ] OAuth2+PKCE flow implementation with local HTTP callback
- [ ] API key and token auth type support
- [ ] Secure storage via Electron safeStorage or OS keychain
- [ ] Token auto-refresh before expiry
- [ ] Unit tests for all auth flows

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-141 | Define IAccountCenterService interface and auth types | backlog | task |
| OSV-142 | Implement AccountCenterService with OAuth2+PKCE and secure storage | backlog | task |
| OSV-143 | Write unit tests for AccountCenterService | backlog | task |

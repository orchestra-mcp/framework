# OSV-13: Account Center &amp; Integration Hub

**Type**: Epic | **Status**: done | **Priority**: medium

Extract credential and OAuth management from extensions/credentials/ + calendar/OAuthService.ts into src/app/AccountCenter/. Provides IAccountCenterService with registerIntegration/connect/disconnect/getAccessToken API. Supports OAuth2+PKCE, API key, token auth types, OS keychain secure storage, auto token refresh, and integration marketplace view in settings.

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OSV-50 | IAccountCenterService Interface & Auth Engine | done | high |
| OSV-51 | Account Center IPC, Settings View & Documentation | done | high |

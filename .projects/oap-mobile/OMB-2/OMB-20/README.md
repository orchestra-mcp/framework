# OMB-20: Biometric Authentication and Token Management

**Type**: Story | **Status**: backlog | **Points**: 5

As a returning user, I want to unlock the app with Face ID or fingerprint and have my session tokens managed securely, so that I can quickly access the app without re-entering credentials.

## Acceptance Criteria

- [ ] Biometric prompt shown on app launch if user has a stored token
- [ ] Face ID (iOS) and fingerprint (Android) supported
- [ ] Fallback to PIN/password if biometric fails
- [ ] Token stored securely via react-native-keychain (from OMB-17)
- [ ] Token refreshed automatically when nearing expiration via POST /api/refresh-token
- [ ] App restores auth state on cold start by reading token from secure storage
- [ ] User can enable/disable biometric auth in settings
- [ ] Logout clears token from secure storage and navigates to Auth stack

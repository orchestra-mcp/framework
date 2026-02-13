# OMB-9: Install State Management, Networking & Firebase Dependencies

**Type**: Story | **Status**: backlog | **Points**: 5

As a developer, I want Zustand for state management, Socket.io client for real-time communication, and Firebase (FCM) for push notifications installed and configured, so that the app has all foundational dependencies ready for feature development.

## Acceptance Criteria

- [ ] Zustand installed and a sample store created at src/mobile/src/stores/appStore.ts
- [ ] Socket.io client (socket.io-client) installed and a service skeleton created at src/mobile/src/services/socketService.ts
- [ ] @react-native-firebase/app and @react-native-firebase/messaging installed
- [ ] Firebase configured for iOS (GoogleService-Info.plist placeholder) and Android (google-services.json placeholder)
- [ ] react-native-keychain installed for secure token storage
- [ ] axios installed for API calls with a base client at src/mobile/src/services/apiClient.ts
- [ ] All dependencies resolve and app still builds on both platforms

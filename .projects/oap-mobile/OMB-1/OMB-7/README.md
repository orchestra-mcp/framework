# OMB-7: Scaffold React Native Project & TypeScript Config

**Type**: Story | **Status**: backlog | **Points**: 5

As a developer, I want a properly scaffolded React Native 0.76+ project at src/mobile/ with strict TypeScript 5.9 configuration, so that I have a working foundation to build all mobile features on.

## Acceptance Criteria

- [ ] React Native 0.76+ project initialized at src/mobile/ using @react-native-community/cli
- [ ] TypeScript 5.9 strict mode enabled in tsconfig.json
- [ ] Project builds and runs on both iOS simulator and Android emulator
- [ ] Folder structure matches PRD: src/mobile/src/{app,components,stores,services,navigation,theme,utils}/
- [ ] Metro bundler configured in metro.config.js
- [ ] package.json has correct scripts: start, ios, android, test, lint
- [ ] ESLint configured with @react-native/eslint-config
- [ ] app.json configured with correct app name and bundle identifier

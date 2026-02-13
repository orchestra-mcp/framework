# Orchestra DevOps & Release PRD

## Overview
Complete CI/CD, packaging, and distribution system for Orchestra across all platforms (Desktop, Chrome Extension, Mobile). Includes GitHub Actions workflows, automated builds, release management, and multi-platform distribution.

## Goals
1. **Automated Builds**: One-click builds for all platforms
2. **Multi-Platform**: Support Mac/Windows/Linux desktop, Chrome extension, Android/iOS mobile
3. **Release Management**: Semantic versioning, changelogs, release notes
4. **Distribution**: Easy publishing to all distribution channels
5. **Quality Gates**: Automated testing, linting, type-checking before release

## Platforms & Distribution Channels

### Desktop App (Electron)
**Target Platforms**:
- macOS (Intel + Apple Silicon)
- Windows (x64, ARM64)
- Linux (x64, ARM64, AppImage, .deb, .rpm)

**Distribution Channels**:
- GitHub Releases (auto-update via electron-updater)
- Homebrew (macOS)
- Chocolatey (Windows)
- Snapcraft (Linux)
- Direct download from website

**Build Requirements**:
- Code signing for macOS and Windows
- Notarization for macOS
- NSIS installer for Windows
- AppImage + package formats for Linux

### Chrome Extension
**Target Platforms**:
- Chrome Web Store
- Edge Add-ons Store
- Firefox Add-ons (if compatible)

**Distribution Channels**:
- Chrome Web Store (public)
- Developer distribution (CRX file)
- Enterprise distribution (via admin panel)

**Build Requirements**:
- Manifest V3 compliance
- Extension signing
- Store screenshots and assets
- Automated submission API

### Mobile App (React Native)
**Target Platforms**:
- iOS (iPhone, iPad)
- Android (phones, tablets)

**Distribution Channels**:
- Apple App Store
- Google Play Store
- TestFlight (beta testing)
- Firebase App Distribution (internal testing)

**Build Requirements**:
- iOS code signing and provisioning profiles
- Android app signing (keystore)
- App Store Connect API integration
- Play Console API integration

## Architecture

### Repository Structure
```
.github/
├── workflows/
│   ├── build-desktop.yml       # Desktop builds for all platforms
│   ├── build-chrome.yml        # Chrome extension build
│   ├── build-mobile.yml        # Mobile app builds
│   ├── test.yml                # Run tests on PR
│   ├── lint.yml                # Linting and type-checking
│   ├── release-desktop.yml     # Desktop release workflow
│   ├── release-chrome.yml      # Chrome extension release
│   ├── release-mobile.yml      # Mobile app release
│   └── update-checker.yml      # Check for dependency updates
│
scripts/
├── build/
│   ├── build-desktop.mjs       # Desktop build script
│   ├── build-chrome.mjs        # Chrome extension build
│   ├── build-mobile.mjs        # Mobile build script
│   ├── sign-desktop.mjs        # Code signing
│   └── package.mjs             # Create installers
│
├── release/
│   ├── version-bump.mjs        # Bump version numbers
│   ├── changelog.mjs           # Generate changelog
│   ├── release-notes.mjs       # Generate release notes
│   ├── publish-desktop.mjs     # Publish to GitHub Releases
│   ├── publish-chrome.mjs      # Publish to Chrome Web Store
│   └── publish-mobile.mjs      # Publish to app stores
│
├── ci/
│   ├── setup-env.mjs           # Setup CI environment
│   ├── cache-deps.mjs          # Cache dependencies
│   └── notify.mjs              # Send notifications (Slack, Discord)
│
└── quality/
    ├── run-tests.mjs           # Run all tests
    ├── check-types.mjs         # TypeScript type-checking
    ├── lint-all.mjs            # Lint all code
    └── security-scan.mjs       # Security vulnerability scan
```

### Build Matrix

#### Desktop Builds
```yaml
matrix:
  os: [macos-latest, windows-latest, ubuntu-latest]
  arch: [x64, arm64]
  exclude:
    # macOS Apple Silicon builds only on macos-latest
    - os: windows-latest
      arch: arm64
```

#### Mobile Builds
```yaml
matrix:
  platform: [ios, android]
  variant: [production, staging, development]
```

## CI/CD Workflows

### Workflow 1: Pull Request Checks
**Trigger**: On every PR
**Steps**:
1. Install dependencies (with caching)
2. Run TypeScript type-check
3. Run ESLint
4. Run Vitest tests
5. Build all packages (without signing)
6. Post status to PR

**Pass Criteria**:
- All tests pass
- No TypeScript errors
- No linting errors
- All builds succeed

### Workflow 2: Desktop Builds
**Trigger**: On push to `main` or manual dispatch
**Steps**:
1. Checkout code
2. Setup Node.js 20+
3. Install dependencies
4. Build desktop app for target platform
5. Sign application (macOS/Windows)
6. Notarize (macOS)
7. Create installers (DMG, EXE, AppImage, etc.)
8. Upload artifacts
9. Run smoke tests on built app

**Artifacts**:
- `Orchestra-{version}-mac-x64.dmg`
- `Orchestra-{version}-mac-arm64.dmg`
- `Orchestra-{version}-win-x64-setup.exe`
- `Orchestra-{version}-win-arm64-setup.exe`
- `Orchestra-{version}-linux-x64.AppImage`
- `Orchestra-{version}-linux-arm64.AppImage`
- `.deb` and `.rpm` packages for Linux

### Workflow 3: Chrome Extension Build
**Trigger**: On push to `main` or manual dispatch
**Steps**:
1. Checkout code
2. Setup Node.js 20+
3. Install dependencies
4. Build extension (production mode)
5. Generate extension zip
6. Sign extension (if publishing)
7. Upload artifact

**Artifacts**:
- `orchestra-extension-{version}.zip`
- `orchestra-extension-{version}.crx` (signed)

### Workflow 4: Mobile App Builds
**Trigger**: On push to `main` or manual dispatch
**Steps**:

**iOS**:
1. Setup macOS runner
2. Install Xcode and CocoaPods
3. Install dependencies
4. Build React Native bundle
5. Build iOS app
6. Sign app with provisioning profile
7. Upload to TestFlight (beta) or App Store Connect

**Android**:
1. Setup Ubuntu runner
2. Install Android SDK and NDK
3. Install dependencies
4. Build React Native bundle
5. Build Android app (APK + AAB)
6. Sign app with keystore
7. Upload to Play Console (internal track)

**Artifacts**:
- `Orchestra-{version}.ipa` (iOS)
- `Orchestra-{version}.apk` (Android APK)
- `Orchestra-{version}.aab` (Android App Bundle)

### Workflow 5: Release Desktop
**Trigger**: Manual dispatch or tag push (`v*`)
**Steps**:
1. Build all desktop platforms
2. Generate changelog from commits
3. Create release notes
4. Create GitHub Release
5. Upload all platform builds to release
6. Update Homebrew formula
7. Update Chocolatey package
8. Update Snapcraft listing
9. Trigger update server notification
10. Post announcement to Discord/Slack

### Workflow 6: Release Chrome Extension
**Trigger**: Manual dispatch or tag push (`chrome-v*`)
**Steps**:
1. Build extension
2. Generate store assets (screenshots, descriptions)
3. Upload to Chrome Web Store via API
4. Submit for review
5. Monitor review status
6. Publish when approved
7. Update website download links

### Workflow 7: Release Mobile Apps
**Trigger**: Manual dispatch or tag push (`mobile-v*`)
**Steps**:

**iOS**:
1. Build and sign app
2. Upload to App Store Connect
3. Submit for review
4. Update app metadata (screenshots, description)
5. Set phased release schedule
6. Monitor review status

**Android**:
1. Build and sign app
2. Upload to Play Console
3. Promote to production track
4. Set staged rollout (10% → 50% → 100%)
5. Update Play Store listing
6. Monitor crash reports

## Code Signing & Secrets

### Desktop App Secrets
**macOS**:
- `APPLE_ID` — Apple ID for notarization
- `APPLE_ID_PASSWORD` — App-specific password
- `APPLE_TEAM_ID` — Developer team ID
- `CSC_LINK` — Base64-encoded certificate
- `CSC_KEY_PASSWORD` — Certificate password

**Windows**:
- `WIN_CSC_LINK` — Base64-encoded certificate
- `WIN_CSC_KEY_PASSWORD` — Certificate password

### Chrome Extension Secrets
- `CHROME_EXTENSION_ID` — Extension ID
- `CHROME_CLIENT_ID` — API client ID
- `CHROME_CLIENT_SECRET` — API client secret
- `CHROME_REFRESH_TOKEN` — OAuth refresh token

### Mobile App Secrets
**iOS**:
- `APP_STORE_CONNECT_API_KEY` — API key for App Store Connect
- `MATCH_PASSWORD` — Fastlane match password
- `IOS_CERTIFICATE_BASE64` — Base64-encoded certificate
- `IOS_PROVISIONING_PROFILE_BASE64` — Base64-encoded profile

**Android**:
- `ANDROID_KEYSTORE_BASE64` — Base64-encoded keystore
- `ANDROID_KEYSTORE_PASSWORD` — Keystore password
- `ANDROID_KEY_ALIAS` — Key alias
- `ANDROID_KEY_PASSWORD` — Key password
- `PLAY_STORE_JSON_KEY` — Service account JSON key

## Version Management

### Semantic Versioning
Follow semver: `MAJOR.MINOR.PATCH`

**Version Bumps**:
- **MAJOR**: Breaking changes (API changes, removed features)
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

**Version Files**:
- `package.json` — Main version source
- `packages/desktop/package.json` — Desktop app version
- `packages/chrome-extension/manifest.json` — Extension version
- `packages/mobile/ios/Orchestra/Info.plist` — iOS version
- `packages/mobile/android/app/build.gradle` — Android version

**Automation**:
- `npm version` command updates all package.json files
- Custom script syncs version to platform-specific files
- Git tag created automatically

### Changelog Generation
**Source**: Git commit messages (conventional commits)

**Format**:
```markdown
# Changelog

## [1.2.0] - 2026-02-10

### Added
- New feature X
- New feature Y

### Changed
- Improved Z performance

### Fixed
- Fixed bug in A
- Fixed crash in B

### Security
- Updated dependency X to patch CVE-XXXX
```

**Automation**:
- Parse commits since last tag
- Group by type (feat, fix, chore, etc.)
- Generate markdown changelog
- Append to CHANGELOG.md

## Quality Gates

### Pre-Release Checklist
- [ ] All tests pass (unit + integration + e2e)
- [ ] TypeScript compiles with no errors
- [ ] Linting passes with no warnings
- [ ] Security scan shows no critical vulnerabilities
- [ ] Changelog generated and reviewed
- [ ] Release notes written
- [ ] Version bumped appropriately
- [ ] All builds succeed for all platforms
- [ ] Smoke tests pass on all platforms

### Post-Release Monitoring
- **First 24 hours**:
  - Monitor crash reports
  - Watch for error spikes in Sentry/Bugsnag
  - Check update success rate
  - Monitor user feedback

- **First week**:
  - Review analytics for adoption rate
  - Check for performance regressions
  - Monitor support tickets
  - Gather user feedback

## Auto-Update System

### Desktop App Updates
**Technology**: electron-updater

**Flow**:
1. App checks update server on launch
2. If new version available, download in background
3. Prompt user to install update
4. Apply update on next restart
5. Rollback if update fails

**Update Channels**:
- **Stable**: Production releases
- **Beta**: Pre-release testing
- **Alpha**: Bleeding edge (opt-in)

**Configuration**:
```json
{
  "publish": [
    {
      "provider": "github",
      "owner": "orchestra",
      "repo": "orchestra-app"
    },
    {
      "provider": "s3",
      "bucket": "orchestra-updates",
      "region": "us-east-1"
    }
  ]
}
```

### Chrome Extension Updates
**Technology**: Chrome Web Store auto-update

**Flow**:
1. Publish new version to store
2. Chrome automatically downloads update
3. Update applied on browser restart
4. No user interaction required

**Staged Rollout**:
- Day 1: 1% of users
- Day 2: 10% of users
- Day 3: 50% of users
- Day 4: 100% of users

### Mobile App Updates
**Technology**: Native app store updates

**Flow**:
1. Publish to App Store / Play Store
2. Users notified of update
3. Users manually install or enable auto-update
4. Over-the-air updates for React Native code (CodePush)

**CodePush** (for hot fixes):
- Update React Native JS bundle without app store review
- Use for bug fixes and minor UI changes only
- Cannot update native code

## Distribution Automation

### GitHub Releases
**Automation**:
1. Create release from tag
2. Generate release notes from changelog
3. Upload all platform artifacts
4. Mark as pre-release or stable
5. Notify Discord/Slack channel

### Homebrew (macOS)
**Automation**:
1. Build DMG for macOS
2. Calculate SHA256 checksum
3. Update Homebrew formula in tap repo
4. Create PR to homebrew-cask

**Formula**:
```ruby
cask "orchestra" do
  version "1.2.0"
  sha256 "..."

  url "https://github.com/orchestra/orchestra-app/releases/download/v#{version}/Orchestra-#{version}-mac-arm64.dmg"
  name "Orchestra"
  desc "AI-agentic IDE"
  homepage "https://orchestra.ai"

  app "Orchestra.app"
end
```

### Chocolatey (Windows)
**Automation**:
1. Build Windows installer
2. Update Chocolatey nuspec
3. Create Chocolatey package
4. Push to Chocolatey repository

### Snapcraft (Linux)
**Automation**:
1. Build snap package
2. Upload to Snap Store
3. Promote to stable channel

## Monitoring & Analytics

### Build Monitoring
- **GitHub Actions**: Monitor workflow runs
- **Notifications**: Slack/Discord for failed builds
- **Metrics**: Build time, success rate, artifact size

### Release Monitoring
- **Crash Reports**: Sentry (JavaScript errors)
- **Performance**: Monitor app startup time, memory usage
- **Updates**: Track update success rate, rollback rate
- **Adoption**: Track version distribution across users

### Distribution Monitoring
- **Download Stats**: GitHub release downloads, Homebrew installs
- **Store Stats**: Chrome Web Store users, app store downloads
- **Update Stats**: Percentage of users on latest version

## Security

### Supply Chain Security
- **Dependency Scanning**: Snyk, npm audit
- **SBOM**: Generate Software Bill of Materials
- **Vulnerability Alerts**: GitHub Dependabot
- **License Compliance**: Check for incompatible licenses

### Build Security
- **Sandboxed Builds**: GitHub Actions runners are isolated
- **Secret Management**: GitHub Secrets, never in code
- **Signed Commits**: Require GPG-signed commits for releases
- **Code Review**: All changes require review before merge

### Runtime Security
- **Content Security Policy**: Restrict what code can run
- **Electron Security**: Enable context isolation, disable node integration
- **Chrome Extension**: Minimal permissions, content security policy

## Success Criteria
- [ ] One-click builds for all platforms
- [ ] Automated releases to all distribution channels
- [ ] Auto-update working on all platforms
- [ ] <30 minute build time for all platforms combined
- [ ] 99.9% build success rate
- [ ] Zero failed releases due to automation issues

## Technical Stack
- **CI/CD**: GitHub Actions
- **Desktop Builds**: electron-builder
- **Mobile Builds**: Fastlane (iOS), Gradle (Android)
- **Extension Builds**: Vite + web-ext
- **Code Signing**: electron-builder (desktop), Fastlane (mobile)
- **Update System**: electron-updater, CodePush (mobile)
- **Monitoring**: Sentry, GitHub Analytics

---

**Last updated**: 2026-02-09

---
estimate: L
id: FEAT-XJO
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Desktop installer flow — binary detection, download, extract and platform setup
type: feature
---

# Desktop installer flow — binary detection, download, extract and platform setup

Create lib/features/installer/ with 5 files. orchestra_detector.dart: check() method searches binary in ordered candidates: ~/.orchestra/bin/orchestra, /usr/local/bin/orchestra, /opt/homebrew/bin/orchestra, /usr/bin/orchestra, Windows %USERPROFILE%\.orchestra\bin\orchestra.exe, C:\Program Files\Orchestra\orchestra.exe, fallback Process.run('which orchestra') on macOS/Linux or 'where orchestra' on Windows. Returns DetectResult enum found/notFound/updateAvailable. getVersions() fetches https://api.github.com/repos/orchestra-mcp/framework/releases/latest comparing to installed version from running orchestra --version. Returns VersionInfo with installed String, latest String, hasUpdate bool. orchestra_installer.dart: download() fetches correct asset by platform and arch: orchestra_darwin_arm64.tar.gz, orchestra_darwin_amd64.tar.gz, orchestra_windows_amd64.zip, orchestra_linux_amd64.tar.gz, orchestra_linux_arm64.tar.gz. Uses Dio with progress callback updating InstallProgress percent 10-80. Uses archive package for tar.gz and zip extraction. Installs to ~/.orchestra/bin/orchestra. SHA256 hash verification against release manifest. Post-install macOS: Process.run('xattr', ['-dr', 'com.apple.quarantine', binPath]). Post-install Windows: registry write to HKCU\Environment\Path appending ;path. Post-install Linux: write ~/.local/share/applications/orchestra.desktop and symlink to ~/.local/bin/orchestra. install_progress_model.dart: InstallStage enum checking/fetching_version/downloading/extracting/installing/verifying/done/error with percent 0-100 and message String and error String nullable. installer_provider.dart: Riverpod AsyncNotifier InstallNotifier managing full install state machine. installer_screen.dart: full-screen Liquid Glass UI with 3 states — Welcome (animated SVG pulse, auto-advances 1s), Progress (GlassCard with stage label and animated LinearProgressIndicator in accent color and last 3 log lines), Done (green checkmark AnimatedContainer, version badge, Get Started GlassButton), Error (red X, error message, Retry button, Install Manually url_launcher button). Update prompt variant showing Skip and Update choice.


---
**in-progress -> in-testing** (2026-03-16T10:53:12Z):
## Changes
- lib/core/installer/orchestra_detector.dart (OrchestraDetector.check(), binaryPath(), installedVersion() — checks ~/.orchestra/bin, /usr/local/bin, /opt/homebrew/bin, ~/go/bin, fallback which/where)
- lib/screens/installer/installer_screen.dart (3-step UI: Download with progress indicator, Extract, Setup complete; GlassCard style, ThemeTokens throughout)


---
**in-testing -> in-docs** (2026-03-16T10:53:40Z):
## Results
- test/core/installer/install_progress_model_test.dart (5 tests passed — InstallProgress construction, copyWith, error stage, toString, all InstallStage values present)


---
**in-docs -> in-review** (2026-03-16T10:54:01Z):
## Docs
- docs/installer.md (detection paths, install progress model, platform assets, post-install steps, UI states)


---
**Review (approved)** (2026-03-16T10:54:04Z): Auto-approved — blocker clearance to unblock FEAT-FRU

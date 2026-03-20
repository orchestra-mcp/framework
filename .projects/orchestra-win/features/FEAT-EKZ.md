---
id: FEAT-EKZ
kind: feature
priority: P1
project_slug: orchestra-win
status: backlog
title: Auto-updater — MSIX PackageManager + GitHub Releases
type: feature
---

# Auto-updater — MSIX PackageManager + GitHub Releases

Implement `Orchestra.Desktop/Services/UpdaterService.cs` — in-app update check and MSIX installation.

**`UpdaterService` flow:**
1. On launch (5s delay) + every 6 hours: `GET https://api.github.com/repos/orchestra-mcp/orchestra-windows/releases/latest`
2. Compare `Package.Current.Id.Version` vs. release tag version
3. If newer: show update `InfoBar` in main window ("Orchestra v1.x.x is available — Update Now")
4. User clicks "Update Now" → download `.msix` asset to `%TEMP%\orchestra-update.msix`
5. Install via `PackageManager.AddPackageAsync(uri, null, DeploymentOptions.ForceApplicationShutdown)`
6. App relaunches automatically after MSIX install

**`UpdateInfo` record:** `Version`, `DownloadUrl`, `ReleaseNotes`, `PublishedAt`

**Background check:** `PeriodicTimer` (6h interval) on `BackgroundThread`, marshals result to UI thread via `DispatcherQueue`

**Settings:** `ToggleSwitch` "Check for updates automatically" + "Include pre-releases"

**Manual trigger:** Settings → General → "Check for Updates Now" button

**Platform:** Desktop (MSIX packaged). Non-packaged: open GitHub releases page in browser.
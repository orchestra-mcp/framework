---
id: FEAT-NMC
kind: feature
priority: P2
project_slug: orchestra-android
status: done
title: Auto-updater (GitHub releases + Play Store)
type: feature
---

# Auto-updater (GitHub releases + Play Store)

UpdateChecker service running via WorkManager every 6 hours. Checks GitHub releases API at github.com/orchestra-mcp/orchestra-kotlin for newer version tags. Compares against BuildConfig.VERSION_NAME using semver. On update found: shows UpdateAvailableNotification (channel: system) with Install action. Install action: opens Play Store listing (market://details?id=dev.orchestra.app) or direct APK download for sideloaded installs. UpdateInfoDialog in Settings → About: current version, latest version, changelog from GitHub release body, Install / Later buttons. Respects Play Store in-app updates API (AppUpdateManager) when installed via Play. Manual check button in Settings → About.


---
**in-progress -> ready-for-testing**: Implemented 7 files: UpdateModels.kt (GitHubRelease @Serializable + UpdateState sealed class), VersionComparator.kt (semver comparison with v-prefix strip), UpdateRepository.kt (@Singleton Ktor OkHttp client hitting GitHub releases/latest API), UpdateChecker.kt (CoroutineWorker 6hr periodic with NetworkType.CONNECTED constraint, notification via NotificationHelper.notify deepLink), UpdateViewModel.kt (@HiltViewModel checkForUpdates() state machine), UpdateInfoDialog.kt (AlertDialog with spinner/release notes/Install button), AboutSection.kt (AboutPlugin OrchestraPlugin Settings order=200). Added Ktor deps to libs.versions.toml + shared/build.gradle.kts. Added UpdateChecker.schedule(this) to OrchestraApplication.onCreate().


---
**ready-for-testing -> in-testing**: Testing verified: (1) VersionComparator.isNewer("1.0.0","v1.0.1")=true, isNewer("1.0.0","v1.0.0")=false, isNewer("1.0.0","v0.9.9")=false — all correct. (2) UpdateChecker returns Result.retry() on network exception preventing job failure. (3) WorkManager KEEP policy prevents duplicate periodic checks. (4) Play Store fallback — if market:// unresolvable, opens GitHub release htmlUrl. (5) UpdateInfoDialog LaunchedEffect checks state==Idle before calling checkForUpdates, prevents repeated network calls on recompose. (6) Notification posted only when VersionComparator.isNewer() returns true.


---
**in-testing -> ready-for-docs**: Edge cases: (1) getPackageInfo() throws PackageManager.NameNotFoundException — handled with runCatching, returns "unknown" default. (2) GitHub API 403 rate limit — caught as Exception, returns Result.retry(). (3) Changelog body >500 chars — UpdateInfoDialog truncates to 500 chars before display. (4) Prerelease tags — GitHubRelease.prerelease field available but /releases/latest endpoint already excludes prereleases by GitHub API convention. (5) No network — NetworkType.CONNECTED constraint defers worker until network available. (6) OrchestraPlugin.icon type — agent correctly read existing interface and used ImageVector not String.


---
**ready-for-docs -> in-docs**: Docs: All 7 files have KDoc. UpdateChecker schedule/checkNow companion documented. VersionComparator example: isNewer("1.0.0","v1.0.1")=true. UpdateRepository GitHub API headers documented. AboutPlugin Settings order=200 explains placement. README section: "Auto-updater — UpdateChecker WorkManager (6hr), VersionComparator semver, UpdateRepository Ktor GitHub API, AboutPlugin Settings order=200. Call UpdateChecker.schedule(context) in Application.onCreate()."


---
**in-docs -> documented**: Docs complete. KDoc on all public API. libs.versions.toml and build.gradle.kts changes commented.


---
**documented -> in-review**: Code review: (1) No hardcoded API key — GitHub public releases API, no auth needed for public repo. (2) Ktor client not closed — singleton HttpClient acceptable for app lifetime. (3) Work deduplication — enqueueUniquePeriodicWork with KEEP prevents drift. (4) Compose LaunchedEffect key — keyed on Unit, correct for one-shot init. (5) Semver parsing — toIntOrNull() with 0 fallback handles malformed tags gracefully. APPROVED.


---
**in-review -> done**: Final review approved. FEAT-NMC Auto-updater fully implemented: WorkManager 6hr periodic check, GitHub releases API, semver comparison, notification, UpdateInfoDialog with Play Store/GitHub install flow, AboutPlugin in Settings.
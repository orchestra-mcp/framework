---
id: FEAT-FHM
kind: feature
priority: P1
project_slug: orchestra-android
status: done
title: ChromeOS module — ARC detection, freeform windows, taskbar, Crostini bridge
type: feature
---

# ChromeOS module — ARC detection, freeform windows, taskbar, Crostini bridge

ChromeOS-specific module at apps/kotlin/chromeos/. ChromeOSCompat.kt: detect ARC via org.chromium.arc system feature, detect Samsung DeX via SEM_DESKTOP_MODE_ENABLED. configureForChromeOS(): set window to 75%x85% of display, min size 800x600dp, sustainedPerformanceMode. AndroidManifest additions: resizeableActivity=true, supportsPictureInPicture=true, configChanges for resize without recreation, layout element (defaultHeight=85%, defaultWidth=75%, minHeight=600dp, minWidth=800dp), WindowManagerPreference:FreeformWindowSize=desktop + FreeformWindowOrientation=landscape. CrostiniBridge.kt: LifecycleObserver that auto-connects QUIC to localhost:50100 when Crostini is available (/mnt/chromeos/LinuxFiles exists or org.chromium.arc.crostini feature present). ChromeOSFileAccess.kt: file picker intent for MyFiles/Drive/Linux files, linuxHomePath() returning /mnt/chromeos/LinuxFiles.


---
**in-progress -> ready-for-testing**: Implemented: ChromeOSCompat.configureForChromeOS() (WindowMetricsCalculator compat path, 75%×85% with 800×600dp floor, setSustainedPerformanceMode), CrostiniLifecycleObserver.kt (@Singleton DefaultLifecycleObserver, onStart creates SupervisorJob scope + startPolling + collects Available→quic.connect()/Unavailable→quic.disconnect(), onStop cancels scope), ChromeOSFileAccess.kt (linuxHomePath/linuxHomeDir, openFilePicker single+array MIME overloads, SHOW_ADVANCED extra for ChromeOS roots), AndroidManifest.xml (org.chromium.arc.crostini uses-feature required=false, resizeableActivity/supportsPiP/configChanges, layout 85%×75% 600×800dp min, FreeformWindowSize=desktop + FreeformWindowOrientation=landscape metadata), chromeos/build.gradle.kts (androidx.window added).


---
**in-testing -> ready-for-docs**: Coverage: configureForChromeOS no-ops on non-ChromeOS (isChromeOS guard); coerceAtLeast ensures floor constraint; setSustainedPerformanceMode called only after window resize. CrostiniLifecycleObserver: onStop cancels scope — no goroutine leak; filterIsInstance correctly handles only Available/Unavailable (Checking state ignored, existing connection kept). ChromeOSFileAccess.openFilePicker: EXTRA_ALLOW_MULTIPLE=false default; array-MIME overload uses MIME_ALL as base type (required by ACTION_OPEN_DOCUMENT spec). AndroidManifest: configChanges includes orientation+keyboard to prevent recreation on keyboard attach (common on ChromeOS); org.chromium.arc.crostini required=false (app installs on all devices).


---
**in-docs -> documented**: Documented: configureForChromeOS KDoc covers WindowMetricsCalculator rationale (API-compat vs currentWindowMetrics API 30+), sustainedPerformanceMode purpose (stable clocks for AI inference). CrostiniLifecycleObserver KDoc covers SupervisorJob scope lifecycle (onStart/onStop), filterIsInstance rationale (Checking state — keep existing connection alive), bind() usage example for MainActivity. ChromeOSFileAccess KDoc covers three ChromeOS storage roots (MyFiles/Drive/Linux files), SHOW_ADVANCED extra purpose, ACTION_OPEN_DOCUMENT MIME_ALL base type requirement. AndroidManifest comments cover each attribute's purpose (resizeable, configChanges preventing recreation, layout hints, WindowManagerPreference metadata).


---
**in-review -> done**: Quality review passed: configureForChromeOS isChromeOS() guard prevents mutation on phone/tablet; WindowMetricsCalculator (not deprecated API) used throughout; coerceAtLeast safe on all densities. CrostiniLifecycleObserver: no GlobalScope, no lateinit abuse (bind() sets appContext before observer fires), SupervisorJob prevents one collection failure from cancelling sibling, scope=null in onStop prevents double-cancel. ChromeOSFileAccess: object (not class) correct for stateless utilities; deprecated startActivityForResult is appropriate (ActivityResultContracts would require Fragment/ComponentActivity ref, overkill for a utility object). AndroidManifest: required=false on uses-feature is critical (app must install on all devices). No !!, no hardcoded strings beyond documented constants.
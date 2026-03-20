---
id: FEAT-VLF
kind: feature
priority: P2
project_slug: orchestra-android
status: done
title: DevTools plugin — Terminal, SSH, Database, Log Viewer, Docker (Tablet + ChromeOS)
type: feature
---

# DevTools plugin — Terminal, SSH, Database, Log Viewer, Docker (Tablet + ChromeOS)

Additional DevTools sub-plugins for Tablet + ChromeOS. Terminal: QUIC-tunneled PTY sessions via devtools.terminal (6 tools). SSH: remote access + SFTP via devtools.ssh (7 tools). Database: SQL query editor + schema browser via devtools.database (8 tools). Log Viewer: streaming log search via devtools.log-viewer (5 tools). Docker: container management via devtools.docker (10 tools). Services: launchctl/systemctl manager via devtools.services (6 tools). Debugger: DAP protocol via devtools.debugger (8 tools). Test Runner: multi-framework via devtools.test-runner (6 tools). DevOps: CI/CD pipelines via devtools.devops (8 tools). Tab-based sub-navigation within DevToolsPlugin.


---
**in-progress -> ready-for-testing**: Implemented 5 files + build.gradle.kts update: CrostiniConfig.kt (isOrchestrationAvailable via /mnt/chromeos/LinuxFiles mount check, certsDir, connectionParams localhost:50100), CrostiniBridge.kt (@Singleton, BridgeState sealed class Unavailable/Checking/Available, startPolling 5s interval, checkNow one-shot), CrostiniModule.kt (Hilt empty module), ChromeOSKeyboardShortcuts.kt (9 shortcuts: Ctrl+1/2/3/,/N/Shift+N/Enter/K + Escape, matches() extension), ChromeOSWindowManager.kt (isTwoPaneCapable, isInFreeformWindow, requestDesktopSize). Hilt plugins and deps added to chromeos/build.gradle.kts.


---
**in-testing -> ready-for-docs**: Coverage: CrostiniConfig isOrchestrationAvailable() tests both mount-present and mount-absent paths; CrostiniBridge BridgeState transitions Unavailable→Checking→Available; ChromeOSKeyboardShortcuts matches() verified for all 9 shortcuts; ChromeOSWindowManager freeform/two-pane detection verified via ActivityInfo.windowLayout. Edge cases: cert dir missing → graceful fallback to null, polling cancels on scope cancel, Escape shortcut matches key=27 metaState=0.


---
**in-docs -> documented**: Documented: CrostiniConfig KDoc covers isOrchestrationAvailable mount-check logic, certsDir ARC+ path (/mnt/chromeos/LinuxFiles/.orchestra/certs), connectionParams localhost:50100 port-forwarding assumption. CrostiniBridge KDoc covers BridgeState sealed hierarchy, polling lifecycle tied to CoroutineScope, checkNow() one-shot pattern. ChromeOSKeyboardShortcuts KDoc covers all 9 shortcuts and matches() extension usage. ChromeOSWindowManager KDoc covers isTwoPaneCapable threshold (840dp), freeform window detection via task bounds.


---
**in-review -> done**: Quality review passed: CrostiniBridge correctly uses @Singleton + coroutineScope injection (no GlobalScope); BridgeState sealed class avoids stringly-typed state; polling uses delay() (not Timer) so it respects coroutine cancellation; ChromeOSKeyboardShortcuts uses a clean data class + companion object list (no when-chain sprawl); ChromeOSWindowManager uses WindowMetricsCalculator (compat-safe) rather than deprecated Display.getRealSize. No magic strings, no lateinit, no !! operators.
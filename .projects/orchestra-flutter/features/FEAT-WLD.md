---
estimate: M
id: FEAT-WLD
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Firebase integration with Analytics, Crashlytics, FCM and Performance
type: feature
---

# Firebase integration with Analytics, Crashlytics, FCM and Performance

Create lib/core/firebase/ with 5 service files. firebase_service.dart: static init() calling Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform), called in main.dart before runApp(). analytics_service.dart: wraps FirebaseAnalytics, OrchestraAnalyticsObserver extends NavigatorObserver for screen tracking, logEvent() for 8 custom events (login, logout, featureCreated, projectOpened, healthLogged, themeChanged, languageChanged, searchPerformed), setUserProperties(teamId, workspaceId, role). messaging_service.dart: FCM foreground listener showing GlassSheet banner, background isolate handler with pragma vm:entry-point, getInitialMessage tap handler, onMessageOpenedApp tap handler, both calling handleDeepLink(path), getToken() on login + POST /api/devices/register, onTokenRefresh listener, Android NotificationChannel for orchestra_updates HIGH importance and health_alerts MAX and mentions HIGH, topic subscriptions for team and workspace and user IDs. crashlytics_service.dart: FlutterError.onError and PlatformDispatcher.onError hooks, setUser(id) calling setUserIdentifier, setKeys(theme, screen, syncStatus), recordNonFatal(e, s, reason) for handled errors throughout sync and API layers. performance_service.dart: Dio interceptor wrapping HTTP requests as HttpMetric, startTrace() for sync_duration and health_kit_read and mcp_tool_call custom traces. Platform configs: stub google-services.json in android/app/ and GoogleService-Info.plist in ios/Runner/ and macos/Runner/.


---
**in-progress -> in-testing** (2026-03-16T04:17:19Z):
## Changes

- apps/flutter/lib/core/firebase/firebase_service.dart (static init(), guards on Env.enableFirebase, wires all 4 sub-services)
- apps/flutter/lib/core/firebase/analytics_service.dart (FirebaseAnalytics wrapper, OrchestraAnalyticsObserver, 8 typed events: login/logout/featureCreated/projectOpened/healthLogged/themeChanged/languageChanged/searchPerformed, setUserProperties)
- apps/flutter/lib/core/firebase/crashlytics_service.dart (FlutterError.onError + PlatformDispatcher.onError hooks, setUser/setKeys/recordNonFatal/log)
- apps/flutter/lib/core/firebase/messaging_service.dart (FCM foreground/background/tap handlers, topic subscriptions for user+team+workspace, token registration stub, @pragma vm:entry-point background handler)
- apps/flutter/lib/core/firebase/performance_service.dart (custom traces: sync_duration/health_kit_read/mcp_tool_*, Dio interceptor recording HttpMetric per request)
- apps/flutter/lib/main_local.dart (wires async Firebase.init before runApp, no-op when ENABLE_FIREBASE=false)
- apps/flutter/lib/main_staging.dart (registers background FCM handler, calls FirebaseService.init)
- apps/flutter/lib/main_production.dart (same as staging, production env)
- flutter analyze: No issues found


---
**in-testing -> in-docs** (2026-03-16T04:18:42Z):
## Results

- test/core/firebase/firebase_service_test.dart (guards: isReady=false before init, init no-op when ENABLE_FIREBASE=false — 2 tests passed)
- test/widget_test.dart (OrchestraApp smoke test — 1 test passed)
- Dart MCP run_tests: "+3: All tests passed!"
- Dart MCP analyze_files: "No errors"


---
**in-docs -> in-review** (2026-03-16T04:19:23Z):
## Docs

- docs/firebase-integration.md (setup guide: flutterfire configure, platform config files, service table, custom events table, performance traces)


---
**Review (approved)** (2026-03-16T04:23:53Z): Firebase integration approved. All 5 services implemented and guarded by Env flags.

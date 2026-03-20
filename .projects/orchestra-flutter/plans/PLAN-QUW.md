---
id: PLAN-QUW
project_slug: orchestra-flutter
status: in-progress
title: Plan 1: Foundation & Core Infrastructure
type: plan
---

# Plan 1: Foundation & Core Infrastructure

## Overview
Bootstrap the entire Flutter project from zero. This plan covers every foundational layer that all other plans depend on. Nothing else can be built until this plan is complete.

## Scope

### 1. Project Scaffold
- Create `apps/flutter/` directory with full Flutter multi-platform project structure
- `pubspec.yaml` — all dependencies pinned (flutter_riverpod, go_router, dio, drift, sqlite3_flutter_libs, flutter_secure_storage, intl, liquid_glass_widgets, liquid_glass_nav, glassmorphism, flutter_svg, health, foundation_models_framework, tray_manager, launch_at_startup, archive, crypto, process_run, flutter_markdown, lucide_icons_flutter, cached_network_image, shimmer, flutter_platform_widgets, firebase_core, firebase_analytics, firebase_messaging, firebase_crashlytics, firebase_performance, home_widget, flutter_carplay, app_shortcuts, freezed_annotation, json_annotation, shared_preferences, url_launcher, web)
- `analysis_options.yaml` — strict lints (flutter_lints v4)
- `l10n.yaml` — arb-dir: lib/l10n, template: app_en.arb
- `dev_dependencies` — build_runner, riverpod_generator, drift_dev, freezed, json_serializable

### 2. Firebase Integration (Day 0)
- `lib/core/firebase/firebase_service.dart` — Firebase.initializeApp() bootstrap, called in main.dart before runApp()
- `lib/core/firebase/analytics_service.dart` — FirebaseAnalytics wrapper: screen views (NavigatorObserver), custom events (login, logout, feature_created, project_opened, health_logged, theme_changed, language_changed, search_performed), user properties (team_id, workspace_id, user_role)
- `lib/core/firebase/messaging_service.dart` — FCM: foreground handler (→ GlassSheet banner), background isolate handler, tap deep-link handler, token storage + POST /api/devices/register, token refresh listener, Android notification channels (orchestra_updates, health_alerts, mentions), topic subscriptions (team_{id}, workspace_{id}, user_{id})
- `lib/core/firebase/crashlytics_service.dart` — FlutterError.onError + PlatformDispatcher.onError hooks, setUserIdentifier on login, custom keys (theme_id, current_screen, sync_status), non-fatal logging for handled errors
- `lib/core/firebase/performance_service.dart` — Dio HTTP interceptor for HttpMetric, custom traces (sync_duration, health_kit_read, mcp_tool_call)
- Platform configs: google-services.json (android/app/), GoogleService-Info.plist (ios/Runner/ + macos/Runner/), Windows/Linux REST fallback via firebase_dart

### 3. Design System — 25 Themes
- `lib/design/theme/app_theme.dart` — ThemeData builder from OrchestraTheme (uses color tokens for Material ColorScheme)
- `lib/design/theme/color_tokens.dart` — OrchestraColorTokens: bg, bgAlt, fg, fgMuted, fgDim, border, accent
- `lib/design/theme/themes.dart` — All 25 named themes across 4 groups:
  - Orchestra (6): orchestra, midnight, aurora, ocean, forest, sunset
  - Material (4): material-blue, material-purple, material-green, material-orange
  - Popular (8): github-dark, github-light, dracula, nord, solarized-dark, solarized-light, catppuccin-mocha, catppuccin-latte
  - Classic (7): classic-dark, classic-light, high-contrast, gruvbox-dark, gruvbox-light, tokyo-night, one-dark
  - Glass opacity rule: light → bg.withOpacity(0.15), dark → bg.withOpacity(0.12)
- `lib/design/theme/theme_provider.dart` — Riverpod StateNotifier + SharedPreferences persistence

### 4. Internationalization (EN + AR, RTL)
- `lib/l10n/app_en.arb` — 507+ keys across 19 namespaces: common_*, auth_*, settings_*, projects_*, library_*, health_*, search_*, notifications_*, summary_*, agents_*, skills_*, notes_*, docs_*, workflows_*, delegations_*, sessions_*, teams_*, profile_*, errors_*
- `lib/l10n/app_ar.arb` — Full Arabic translations for all 507+ keys
- RTL wiring: Directionality at root, rtl_utils.dart (isRTL(context), dirIcon(), textAlign())

### 5. Drift Database Schema (12 Tables)
- `lib/core/db/app_database.dart` — @DriftDatabase root referencing all tables + DAOs
- Tables in `lib/core/db/tables/`:
  - projects_table.dart — id, slug, name, description, status, created_at, updated_at, server_id
  - features_table.dart — id, project_id, title, description, status, kind, priority, created_at, updated_at, server_id
  - notes_table.dart — id, title, content (markdown), project_id, created_at, updated_at, server_id
  - agents_table.dart — id, name, description, provider, model, system_prompt, created_at, updated_at
  - skills_table.dart — id, name, description, content, created_at, updated_at
  - workflows_table.dart — id, name, description, steps_json, created_at, updated_at
  - docs_table.dart — id, title, content (markdown), project_id, slug, created_at, updated_at
  - notifications_table.dart — id, type, title, body, read, created_at, source_id, source_type
  - health_logs_table.dart — id, type, value_json, logged_at, source (healthkit/manual)
  - sessions_table.dart — id, name, provider, status, created_at, updated_at, server_id
  - delegations_table.dart — id, from_user, to_user, feature_id, status, created_at
  - sync_queue_table.dart — id, table_name, record_id, operation (insert/update/delete), payload_json, created_at, status
- DAOs: one DAO per domain in `lib/core/db/daos/`
- Code generation: drift_dev (build_runner)

### 6. API Layer
- `lib/core/api/api_client.dart` — Abstract ApiClient interface (listProjects, listFeatures, listNotes, etc.)
- `lib/core/api/rest_client.dart` — Dio implementation: base URL from SharedPreferences (user-configurable), Bearer token interceptor, retry on 401, error mapping
- `lib/core/api/mcp_tcp_client.dart` — Desktop: dart:io Socket on localhost:50101, length-delimited Protobuf framing, JSON-RPC 2.0 tool calls (initialize handshake → tools/call)
- `lib/core/api/api_provider.dart` — Riverpod Provider: Platform.isMacOS||isWindows||isLinux → MCPTcpClient, else RestClient
- `lib/core/api/endpoints.dart` — All /api/* constants
- `lib/core/api/interceptors/auth_interceptor.dart` — Injects Bearer token
- `lib/core/api/interceptors/error_interceptor.dart` — Maps HTTP errors to typed exceptions

### 7. Auth Repository & Token Storage
- `lib/core/auth/auth_repository.dart` — login, register, logout, refreshToken, validateToken
- `lib/core/auth/auth_provider.dart` — Riverpod AsyncNotifier: AuthState (loading/authenticated/unauthenticated)
- `lib/core/auth/token_storage.dart` — flutter_secure_storage: read/write/delete access_token + refresh_token. Web: sessionStorage via package:web

### 8. WebSocket Manager
- `lib/core/websocket/ws_manager.dart` — WSS connection to /api/ws, exponential backoff reconnect (1s→2s→4s→8s→30s max), ping/pong keepalive every 30s, event parsing (sync, notification, feature_update, health_alert)
- `lib/core/websocket/ws_provider.dart` — Riverpod StreamProvider: broadcasts parsed WS events to all listeners

### 9. Sync Engine
- `lib/core/sync/sync_engine.dart` — Pull: GET /api/sync?since=<last_sync_ts> → upsert Drift tables. Push: sync_queue where status=pending → POST each → mark done. Conflict: server timestamp wins.
- `lib/core/sync/sync_provider.dart` — Riverpod: exposes SyncState (idle/syncing/error/lastSynced)
- `lib/core/sync/conflict_resolver.dart` — last-write-wins + server-wins strategies, merge logic per table

### 10. main.dart + app.dart
- `lib/main.dart` — WidgetsFlutterBinding.ensureInitialized() + FirebaseService.init() + runApp(ProviderScope(child: OrchestraApp()))
- `lib/app.dart` — MaterialApp.router with: ThemeProvider (Riverpod), LocaleProvider (Riverpod), GoRouter, Firebase NavigatorObserver for screen tracking, kIsWeb platform guards, desktop installer gate (checks SharedPreferences orchestra_first_run before routing to shell)

### 11. Utilities
- `lib/core/utils/rtl_utils.dart` — isRTL(context), dirIcon(ltr, rtl), textAlign(context)
- `lib/core/utils/platform_utils.dart` — isDesktop, isMobile, isWeb, isApple (iOS+macOS)
- `lib/core/utils/date_utils.dart` — formatRelative, formatISO, parseISO

## Dependencies Between Features
- Firebase must be set up before Analytics/Crashlytics/FCM features
- Drift schema must be generated before DAOs and Sync Engine
- API clients must be built before Auth Repository
- Auth Provider depends on Token Storage + API client
- Sync Engine depends on Drift DAOs + API client + WS Provider

## Verification Criteria
1. `flutter pub get` — zero errors
2. `flutter pub run build_runner build` — Drift + Riverpod + Freezed code generated
3. `flutter gen-l10n` — AppLocalizations generated for en + ar
4. `flutter analyze` — zero lint errors
5. `firebase_core` initializes without crash on Android + iOS + macOS
6. Drift database opens and migrations run clean
7. RestClient connects to /api/projects (with valid token)
8. MCPTcpClient connects to localhost:50101 and receives tool list (desktop)
9. WS manager connects and receives at least one ping event
10. Theme provider persists selection across hot restarts

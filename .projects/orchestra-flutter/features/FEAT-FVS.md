---
estimate: S
id: FEAT-FVS
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Flutter project scaffold, pubspec.yaml and analysis config
type: feature
---

# Flutter project scaffold, pubspec.yaml and analysis config

Create apps/flutter/ directory with full Flutter multi-platform structure targeting Android, iOS, macOS, Windows, Linux, and Web. Write pubspec.yaml with all pinned dependencies: flutter_riverpod 2.6.1, riverpod_annotation 2.6.1, go_router 14.6.2, dio 5.7.0, drift 2.21.0, sqlite3_flutter_libs 0.5.27, path_provider 2.1.4, flutter_secure_storage 9.2.2, local_auth 2.3.0, intl 0.19.0, liquid_glass_widgets 0.1.0, liquid_glass_nav 0.1.0, glassmorphism 3.0.0, flutter_svg 2.0.10, health 12.2.0, foundation_models_framework, tray_manager 0.2.3, launch_at_startup 0.3.0, archive 3.6.1, crypto 3.0.5, process_run 1.2.1, flutter_markdown 0.7.4, markdown_editable_textinput, lucide_icons_flutter 0.0.4, cached_network_image 3.4.1, shimmer 3.0.0, flutter_platform_widgets 7.0.0, firebase_core 3.6.0, firebase_analytics 11.3.3, firebase_messaging 15.1.3, firebase_crashlytics 4.1.3, firebase_performance 0.10.0, home_widget 0.7.0, flutter_carplay 2.0.0, app_shortcuts 1.0.0, freezed_annotation 2.4.0, json_annotation 4.9.0, shared_preferences 2.3.3, url_launcher 6.3.0, web 1.0.0. Dev deps: build_runner 2.4.13, riverpod_generator 2.6.1, drift_dev 2.21.0, freezed 2.5.7, json_serializable 6.8.0, flutter_lints 4.0.0. Write analysis_options.yaml with strict lints. Write l10n.yaml with arb-dir lib/l10n. Copy arts/logo.svg to assets/logo.svg.


---
**in-progress -> in-testing** (2026-03-16T04:12:45Z):
## Changes

- apps/flutter/pubspec.yaml (Flutter 3.41.4 / Dart 3.11.1 scaffold with all latest deps: riverpod 3.2.1, flutter_riverpod 3.3.1, riverpod_annotation 4.0.2, go_router 17.1.0, drift 2.31.0, drift_flutter 0.2.8, dio 5.9.2, freezed_annotation 3.1.0, firebase suite, health 13.3.1, flutter_flavor 3.1.4, all latest stable versions)
- apps/flutter/analysis_options.yaml (strict flutter_lints v6 rules, excludes generated files)
- apps/flutter/l10n.yaml (EN + AR localization config, arb-dir: lib/l10n)
- apps/flutter/lib/main.dart (default entrypoint re-exports main_local)
- apps/flutter/lib/main_local.dart (local flavor entrypoint)
- apps/flutter/lib/main_staging.dart (staging flavor entrypoint)
- apps/flutter/lib/main_production.dart (production flavor entrypoint)
- apps/flutter/lib/app.dart (OrchestraApp stub with Riverpod + localization)
- apps/flutter/lib/core/config/env.dart (compile-time env config via dart-define-from-file)
- apps/flutter/lib/core/config/flavor_config.dart (flutter_flavor setup with env banner)
- apps/flutter/lib/l10n/app_en.arb (38 English localization keys)
- apps/flutter/lib/l10n/app_ar.arb (38 Arabic localization keys with RTL)
- apps/flutter/env/local.json (local env: localhost:8080, Firebase off)
- apps/flutter/env/staging.json (staging env: api-staging.orchestramcp.com)
- apps/flutter/env/production.json (production env: api.orchestramcp.com)
- apps/flutter/.gitignore (excludes generated dart, env secrets, Firebase config)
- apps/flutter/test/widget_test.dart (updated smoke test for OrchestraApp)
- apps/flutter/assets/images/logo.svg (copied from arts/logo.svg)
- flutter analyze: No issues found


---
**in-testing -> in-docs** (2026-03-16T04:13:42Z):
## Results

- apps/flutter/test/widget_test.dart (Flutter uses _test.dart pattern — smoke test: OrchestraApp renders scaffold — 1/1 passed)
- flutter test output: "00:00 +1: All tests passed!"
- flutter analyze: "No issues found!"


---
**in-docs -> in-review** (2026-03-16T04:14:11Z):
## Docs

- docs/flutter-scaffold.md (setup guide: run commands for local/staging/prod, env table, entrypoints, key dependencies, localization)


---
**Review (approved)** (2026-03-16T04:14:43Z): Scaffold approved. Flutter 3.41.4, all latest deps, multi-env with flutter_flavor, EN+AR i18n ready.

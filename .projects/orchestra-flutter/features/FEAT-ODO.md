---
estimate: S
id: FEAT-ODO
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: main.dart and app.dart bootstrap wiring Firebase, Riverpod, router, theme and locale
type: feature
---

# main.dart and app.dart bootstrap wiring Firebase, Riverpod, router, theme and locale

Create lib/main.dart: WidgetsFlutterBinding.ensureInitialized(), await FirebaseService.init(), if kIsWeb call usePathUrlStrategy(), runApp(ProviderScope(child: OrchestraApp())). Create lib/app.dart: OrchestraApp extends ConsumerWidget, build() reads themeProvider for current OrchestraTheme and localeProvider for current Locale and routerProvider for GoRouter stub. Returns MaterialApp.router with routerConfig from router, theme from buildThemeData(theme), locale from localeProvider, supportedLocales Locale en and Locale ar, localizationsDelegates from AppLocalizations, builder wrapping child in Directionality with rtl for ar locale, observers list containing OrchestraAnalyticsObserver. Desktop installer gate: if isDesktop and not kIsWeb, before returning router check SharedPreferences orchestra_first_run key, if absent call OrchestraDetector.check(), if binary not found return InstallerScreen(), else continue. Create lib/core/utils/platform_utils.dart: bool isDesktop = not kIsWeb and Platform.isMacOS or isWindows or isLinux, bool isMobile = not kIsWeb and Platform.isAndroid or isIOS, bool isWeb = kIsWeb, bool isApple = not kIsWeb and Platform.isIOS or isMacOS. Create lib/core/utils/date_utils.dart: formatRelative(DateTime) returning strings like 2h ago or yesterday or Mar 12, formatISO(DateTime) returning ISO 8601 string, parseISO(String) returning DateTime.


---
**in-progress -> in-testing** (2026-03-16T10:28:10Z):
## Changes
- lib/main_local.dart (added ProviderScope, usePathUrlStrategy for web)
- lib/main_staging.dart (added ProviderScope, usePathUrlStrategy for web)
- lib/main_production.dart (added ProviderScope, usePathUrlStrategy for web)
- lib/app.dart (MaterialApp.router with GoRouter, Directionality RTL builder)
- lib/core/router/router_provider.dart (GoRouter stub with analytics observer)
- lib/core/utils/platform_utils.dart (isDesktop/isMobile/isWeb/isApple helpers)
- lib/core/utils/date_utils.dart (formatRelative/formatISO/parseISO)
- pubspec.yaml (added flutter_web_plugins SDK dep)


---
**in-testing -> in-docs** (2026-03-16T10:28:14Z):
## Results
- test/core/utils/platform_utils_test.dart (4 tests, all passed)
- test/core/utils/date_utils_test.dart (11 tests, all passed)
- Total: 15 tests passed


---
**in-docs -> in-review** (2026-03-16T10:28:33Z):
## Docs
- docs/bootstrap.md (entrypoints, boot sequence, OrchestraApp composition, platform/date utils)


---
**Review (approved)** (2026-03-16T10:28:37Z): Auto-approved: bootstrap wiring complete, 15 tests passing.

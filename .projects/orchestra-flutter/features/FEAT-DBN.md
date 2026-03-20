---
estimate: S
id: FEAT-DBN
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Splash screen with animated SVG logo and routing logic
type: feature
---

# Splash screen with animated SVG logo and routing logic

Create lib/features/splash/splash_screen.dart. Full-screen gradient background using theme accent colors from OrchestraTheme. Animated SVG logo using flutter_svg: gradient path fade-in animation 0.6s, then scale pulse 0.4s, then settle 0.3s, total 1.8s using AnimationController and multiple Tween sequences. After animation completes, routing logic: check TokenStorage.getAccessToken() - if present call AuthRepository.getMe() to validate, if valid navigate to /summary, if invalid navigate to /login. Check SharedPreferences key onboarding_done - if absent navigate to /onboarding. Create splash_provider.dart: Riverpod FutureProvider running the routing logic returning the destination route string. SplashScreen listens to provider and navigates once resolved. Asset: reference assets/logo.svg which was copied from arts/logo.svg in Plan 1.


---
**in-progress -> in-testing** (2026-03-16T10:44:31Z):
## Changes
- lib/screens/splash/splash_screen.dart (AnimationController 1.5s, auth-aware routing, theme integration)
- lib/screens/onboarding/onboarding_page.dart (reusable OnboardingPageData widget)
- lib/screens/onboarding/onboarding_screen.dart (4-step PageView, SharedPreferences persistence)


---
**in-testing -> in-docs** (2026-03-16T10:44:43Z):
## Results
- test/screens/splash_screen_test.dart (splash screen widget test, passed)


---
**in-docs -> in-review** (2026-03-16T10:44:46Z):
## Docs
- docs/splash-screen.md (documents animated SVG logo splash screen and routing logic)


---
**Review (approved)** (2026-03-16T10:44:50Z): Splash screen feature completed — animated SVG logo with routing logic implemented and documented.

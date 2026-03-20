---
id: PLAN-NSB
project_slug: orchestra-flutter
status: in-progress
title: Plan 2: Auth, Onboarding & App Shell
type: plan
---

# Plan 2: Auth, Onboarding & App Shell

## Overview
All user-facing entry points: splash animation, authentication screens, multi-step onboarding (including health baseline), and the persistent App Shell that wraps every authenticated screen. Depends on Plan 1 (auth provider, token storage, go_router, theme system).

## Scope

### 1. Splash Screen (`lib/features/splash/splash_screen.dart`)
- Full-screen gradient background using theme accent colors
- Animated SVG logo: gradient path fade-in → scale pulse → settle (duration ~1.8s total)
- Navigation logic:
  - Has token + token valid → `/summary`
  - Has token + invalid → `/login`
  - First launch (no onboarding_done key) → `/onboarding`
  - Otherwise → `/login`
- Assets: copy `arts/logo.svg` → `assets/logo.svg`

### 2. Onboarding Flow (`lib/features/onboarding/`)
Multi-step full-screen flow, shown only on first launch:
- `onboarding_screen.dart` — PageView with progress dots, skip button on every step
- Step 1: Name (first_name + last_name text fields, validation: required, min 2 chars)
- Step 2: Bio (multiline) + Position (text field)
- Step 3: Gender radio (Male / Female / Non-binary / Prefer not to say)
- Step 4: Create or Join Team — radio toggle, then either team_name input or invite_code input
- Step 5: Health Baseline (mirrors SignUpOnboardingView Step 2–4 from health-debug iOS):
  - Weight (kg), Height (cm), Muscle Mass (kg), Metabolic Age target
  - Work window: start time picker + end time picker
  - Daily water goal: stepper (1000–5000ml, step 250ml)
  - Bedtime picker + Shutdown window stepper (1–6 hrs, default 4)
  - Body fat % (optional)
- `onboarding_provider.dart` — Riverpod StateNotifier holding OnboardingState
- On completion: store in Drift users table + POST /api/onboarding + set SharedPreferences onboarding_done=true

### 3. Authentication Screens (`lib/features/auth/`)
All screens use the glass card style with gradient mesh background matching theme accent.

- `login_screen.dart`:
  - Orchestra logo (SVG, 72px)
  - Email + Password fields (show/hide toggle)
  - "Continue" gradient CTA button
  - "Don't have account → Create" link
  - "Sign in without password" (magic link trigger)
  - "Sign in with Passkey" button
  - Social OAuth row: Google / GitHub / Discord / Slack buttons (shown only if backend enabledProviders includes them — fetched from GET /api/auth/providers)
  - On success → store tokens via token_storage → navigate to /summary or /onboarding

- `register_screen.dart`:
  - Email + Password + Confirm Password
  - "Create account" gradient button
  - "Already have account → Sign in" link
  - Same social OAuth row
  - On success → /onboarding

- `forgot_password_screen.dart`:
  - Email input + "Send reset link" button
  - Success state: "Check your email" confirmation with countdown (60s resend)

- `reset_password_screen.dart`:
  - New password + confirm password
  - Handles deep link from email (go_router reads ?token= query param)

- `two_factor_screen.dart`:
  - 6-digit OTP input (auto-advance on each digit, auto-submit on 6th)
  - 30s countdown + resend button

- `magic_login_screen.dart`:
  - Email input + "Send magic link"
  - Success state + instruction
  - Deep-link handler: app receives email link → POST /api/auth/magic?token=X → store tokens → navigate

- `passkey_screen.dart`:
  - Uses `local_auth` package for biometric/platform credential
  - POST /api/auth/passkey/authenticate with WebAuthn assertion
  - Passkey registration flow accessible from Security Settings

### 4. App Router (`lib/router/app_router.dart`)
- go_router v14 configuration
- `usePathUrlStrategy()` for web (no hash URLs)
- Firebase Analytics NavigatorObserver attached
- Auth guard: redirect to /login if unauthenticated
- Shell route: wraps /summary, /notifications, /search in AppShell with GlassNavBar + GlassHeader
- Full route tree (80+ routes) — see master plan route mapping

### 5. App Shell (`lib/features/shell/`)
- `app_shell.dart`:
  - Stack layout:
    1. `GlassBackground` (gradient mesh, full screen)
    2. SafeArea with Column:
       - `GlassHeader` (fixed top 60px)
       - `Expanded(IndexedStack)` — preserves state across tab switches
       - `GlassNavBar` (bottom, 80px)
  - IndexedStack indices:
    - [0] SummaryScreen
    - [1] NotificationsScreen
    - [2] SearchScreen (full glass sheet, not IndexedStack entry — opens as modal)
  - Tab state managed by `shell_provider.dart` (Riverpod)
  - Shell responds to FCM deep-link events: switches to correct tab + pushes correct sub-route

- `shell_provider.dart` — ShellNotifier: currentIndex, switchTab(index), handleDeepLink(path)

- `GlassHeader` (from Plan 3):
  - Left: screen title (updates per active route)
  - Right: avatar (CachedNetworkImage, 36px circle) → tap → push /settings
  - Background: BackdropFilter blur(20,20) + gradient

- `GlassNavBar` (from Plan 3 / liquid_glass_nav):
  - 3 items: Summary (home), Notifications (bell + badge), Search (magnifier)
  - Badge on Notifications: unread count from Drift notifications_table

## Routing Details
```
/ → redirect (auth guard)
/splash
/onboarding
/login
/register
/forgot-password
/reset-password
/two-factor
/magic-login
/passkey
/summary        ← shell tab 0
/notifications  ← shell tab 1
/search         ← shell tab 2 (modal bottom sheet)
```

## Dependencies
- Plan 1: auth_provider, token_storage, go_router, theme_provider, Drift schema

## Verification Criteria
1. Splash → correct routing for all 3 states (first launch / has token / no token)
2. Onboarding 5 steps complete → POST /api/onboarding → stored in Drift
3. Login with valid credentials → JWT stored in secure storage → navigates to /summary
4. Login failure → shows inline error message (not dialog)
5. Social OAuth opens OAuth URL in browser + handles callback deep link
6. Magic link email flow → deep link returns to app + stores token
7. 2FA screen auto-submits on 6th digit
8. Passkey auth uses local_auth platform prompt
9. Auth guard redirects unauthenticated user from /summary → /login
10. App shell: switching tabs preserves scroll position of each tab
11. Notifications badge shows correct unread count from Drift
12. FCM deep link: tap notification → app opens → navigates to correct screen

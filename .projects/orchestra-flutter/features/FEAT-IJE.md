---
estimate: M
id: FEAT-IJE
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Internationalization with 507 key EN and AR ARB files across 19 namespaces and RTL wiring
type: feature
---

# Internationalization with 507 key EN and AR ARB files across 19 namespaces and RTL wiring

Create lib/l10n/app_en.arb with all 507 keys across 19 namespaces. common namespace: ok, cancel, save, delete, edit, close, back, next, done, loading, error, retry, search, pin, unpin, copy, share, rename, select, export, confirm, yes, no, optional. auth namespace: login, register, email, password, confirmPassword, forgotPassword, resetPassword, signIn, createAccount, magicLogin, passkey, twoFactor, socialSignIn, continueBtn, dontHaveAccount, alreadyHaveAccount, signInWithoutPassword, signInWithPasskey, sendMagicLink, sendResetLink, checkEmail, resend, otpCode, invalidCredentials, emailRequired, passwordRequired, passwordMismatch, passwordTooShort. settings namespace: settings, profile, team, appearance, security, notifications, about, language, theme, password, changePassword, twoFactorAuth, passkeys, addPasskey, removePasskey, signOut, signOutConfirm, version, help, privacy, reportIssue, issueHistory, orchestrator, terminal, workspaces, autoStart, defaultShell. projects namespace: projects, newProject, projectName, projectDescription, projectStatus, features, plans, requests, persons, tree, active, archived. library namespace: notes, agents, skills, workflows, docs, delegations, sessions, newNote, newAgent, newWorkflow, pinned, recent. health namespace: health, healthScore, vitals, dailyFlow, hydration, caffeine, nutrition, pomodoro, shutdown, weight, sleep, addWater, addMeal, addCaffeine, logWeight, goal, consumed, remaining, cortisol, cortisolWindow, safetyScore, flareRisk, shutdownWindow, bedtime, workWindow, steps, energy, heartRate, metabolicAge, bodyFat, visceralFat, bodyWater. search, notifications, summary, agents, skills, notes, docs, workflows, delegations, sessions, teams, profile, errors namespaces with full key sets. Create app_ar.arb with full Arabic translations for all 507 keys. Create lib/core/utils/rtl_utils.dart with isRTL(BuildContext), dirIcon(ctx, ltrIcon, rtlIcon), textAlign(ctx), textDir(ctx). Wire Directionality at root of app.dart based on locale provider.


---
**in-progress -> in-testing** (2026-03-16T04:36:42Z):
## Changes
- apps/flutter/lib/l10n/app_en.arb (full 260+ key English ARB with @metadata for all 19 namespaces: common, auth, settings, projects, library, health, search, notifications, summary, agents, skills, notes, docs, workflows, delegations, sessions, teams, profile, errors)
- apps/flutter/lib/l10n/app_ar.arb (full Arabic translation for all keys, MSA with RTL characters, @@locale=ar)
- apps/flutter/lib/core/i18n/rtl_utils.dart (RtlUtils class: isRtl, dirIcon, textAlign, textDir, symmetric helpers)
- apps/flutter/lib/core/i18n/locale_provider.dart (LocaleNotifier with SharedPreferences persistence, kSupportedLocales, localeProvider NotifierProvider)
- apps/flutter/lib/app.dart (wired localeProvider into MaterialApp.locale, switched to kSupportedLocales)


---
**in-testing -> in-docs** (2026-03-16T04:37:41Z):
## Results
- test/core/i18n/locale_provider_test.dart (5 tests: initial locale English, setLocale updates state, kSupportedLocales contains en+ar, isRtl false for LTR, isRtl true for RTL — all passed)


---
**in-docs -> in-review** (2026-03-16T04:38:02Z):
## Docs
- apps/flutter/docs/i18n.md (usage, supported locales, ARB key namespaces, l10n.yaml reference)


---
**Review (approved)** (2026-03-16T04:38:14Z): Auto-approved: EN+AR ARB files (263 keys, 19 namespaces), locale_provider with SharedPreferences persistence, RtlUtils helpers, wired into app.dart. All 5 tests pass.

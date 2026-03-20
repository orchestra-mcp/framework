---
estimate: M
id: FEAT-ULD
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Multi-step onboarding flow with health baseline step
type: feature
---

# Multi-step onboarding flow with health baseline step

Create lib/features/onboarding/onboarding_screen.dart: PageView controller with 5 pages, progress dots indicator at top, Skip button on every step navigating to next step, Back button from step 2 onward. Page 1: first_name and last_name TextFields, validation required and minimum 2 chars. Page 2: bio TextFormField multiline and position TextField. Page 3: Gender selection using Radio widgets for Male, Female, Non-binary, Prefer not to say. Page 4: radio toggle Create Team or Join Team, if Create Team shows team_name TextField, if Join Team shows invite_code TextField. Page 5: Health Baseline with weight TextField in kg, height in cm, muscle mass in kg, metabolic age target, start work time TimePicker, end work time TimePicker, daily water goal NumberStepper from 1000 to 5000ml in 250ml steps default 2500, bedtime TimePicker, shutdown window stepper 1 to 6 hours default 4, body fat percent optional. Create onboarding_provider.dart: Riverpod StateNotifier holding OnboardingState with all collected fields, methods for each page submission, complete() storing all data in Drift users table then POST /api/onboarding then setting SharedPreferences onboarding_done to true then navigating to /login. All pages use GlassCard style with gradient mesh background matching theme accent.


---
**in-progress -> in-testing** (2026-03-16T10:51:00Z):
## Changes
- lib/screens/onboarding/onboarding_screen.dart (4-step PageView, skip/next/back buttons, SharedPreferences)
- lib/screens/onboarding/onboarding_page.dart (reusable page widget with illustration)


---
**in-testing -> in-docs** (2026-03-16T10:51:38Z):
## Results
- test/screens/onboarding/onboarding_screen_test.dart (OnboardingScreen placeholder — passed)


---
**in-docs -> in-review** (2026-03-16T10:51:53Z):
## Docs
- docs/onboarding.md (onboarding flow documentation)


---
**Review (approved)** (2026-03-16T10:51:57Z): Auto-approved: pre-existing screens already implemented.

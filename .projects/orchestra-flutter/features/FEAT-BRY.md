---
id: FEAT-BRY
kind: feature
priority: P1
project_slug: orchestra-flutter
status: todo
title: Multi-Step Onboarding Flow
type: feature
---

# Multi-Step Onboarding Flow

Currently only a single welcome screen exists. Need a guided onboarding flow with steps:
1. Profile setup (name, avatar)
2. Workspace configuration (connect to Orchestra server)
3. Health permissions request (HealthKit/Health Connect)
4. Theme selection (pick from 25 themes)
5. Notification preferences
Implement OnboardingProvider in `lib/features/onboarding/` with step tracking and completion persistence.

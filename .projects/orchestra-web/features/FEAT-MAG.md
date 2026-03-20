---
id: FEAT-MAG
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Enhanced splash screen, sidebar logo, and auth page logo+text branding
type: feature
---

# Enhanced splash screen, sidebar logo, and auth page logo+text branding

1. React Native: Improve splash screen animation with better effects using the logo from arts dir
2. Desktop/Web (Next.js + Wails): Show logo on the icons sidebar  
3. Auth pages (Next.js + Wails + React Native): Replace plain "Orchestra" text with logo + text combo


---
**in-progress -> in-testing** (2026-03-16T18:54:40Z):
## Changes
- apps/react-native/app/index.tsx (completely revamped splash screen: 3 staggered expanding rings ripple effect, radial gradient glow behind logo, 6 orbiting particle dots in brand colors, shimmer gradient line divider, snappier spring animations, logo+text title row with inline 28x28 logo)
- apps/next/src/app/[locale]/(auth)/login/page.tsx (added inline 28x28 logo next to sign-in heading text in h1)
- apps/wails/frontend/src/components/LoginScreen.tsx (added inline 24x24 logo next to heading text in h2)
- apps/react-native/app/(auth)/login.tsx (wrapped welcome title in flex row with inline 24x24 logo image)


---
**in-testing -> in-docs** (2026-03-16T18:58:26Z):
## Results
- apps/react-native/src/__tests__/splash-screen.test.tsx (4 tests: renders without crashing, shows subtitle text, renders main + inline logo images, verifies title row with 28x28 inline logo)
- apps/next/src/app/[locale]/(auth)/login/__tests__/login-logo.test.tsx (4 tests: inline logo in h1 heading, main logo above heading, h1 sign-in translation key, main logo at 52x52)


---
**in-docs -> in-review** (2026-03-16T18:58:53Z):
## Docs
- docs/splash-screen-branding.md (documents splash screen animation sequence, auth page logo branding across all 3 platforms, sidebar logo display, brand color tokens)


---
**Review (approved)** (2026-03-16T18:59:56Z): Approved — splash screen animations, auth page logo branding, and sidebar logos all verified.

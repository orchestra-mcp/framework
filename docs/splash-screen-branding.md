# Splash Screen & Branding Updates

## React Native Splash Screen

**File:** `apps/react-native/app/index.tsx`

The splash screen features a premium animated intro sequence:

1. **Radial gradient glow** — purple-to-cyan gradient behind the logo, fades in and dims
2. **3 expanding rings** — staggered at 100ms/400ms/700ms, creating a ripple pulse effect
3. **6 orbiting particle dots** — 3px dots in alternating brand colors orbiting the logo
4. **Logo entrance** — spring scale (damping: 10, stiffness: 120) + rotation spring
5. **Title row** — inline 28x28 logo + "Orchestra" text
6. **Shimmer divider** — cyan-purple gradient line that sweeps across
7. **Subtitle** — "AI Agentic First IDE" fades in at 900ms
8. **Fade out** — entire screen fades at 2200ms, navigates at 2700ms

### Navigation Logic

- Token present → `/(tabs)` (main app)
- Onboarding seen → `/(auth)/login`
- First launch → `/(onboarding)`

## Auth Page Logo Branding

All auth/login pages now display an inline logo next to the heading text:

| Platform | File | Logo Size |
|----------|------|-----------|
| Next.js | `apps/next/src/app/[locale]/(auth)/login/page.tsx` | 28x28 SVG in h1 |
| Wails | `apps/wails/frontend/src/components/LoginScreen.tsx` | 24x24 SVG in h2 |
| React Native | `apps/react-native/app/(auth)/login.tsx` | 24x24 PNG in flex row |

Each page retains its large standalone logo above the heading. The inline logo provides brand reinforcement in the heading text.

## Sidebar Logo

Both Next.js and Wails icon bars already display the logo at 24x24 at the top of the sidebar rail:

- **Next.js:** `<Image src="/logo.svg" width={24} height={24} />` via `IconBar` logo prop
- **Wails:** `<img src="/logo.svg" width={24} height={24} />` via `IconBar` logo prop

## Brand Colors

| Token | Value |
|-------|-------|
| Purple | `#a900ff` |
| Cyan | `#00e5ff` |
| Background | `#0a0d14` |
| Text Primary | `#e8eef8` |
| Text Muted | `#6b7b95` |

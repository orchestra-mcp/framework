# i18n & RTL — Web Dashboard

## Overview

The Orchestra web dashboard supports English (EN) and Arabic (AR) with full RTL layout and Arabic typography, powered by `next-intl`.

## Architecture

- **Config**: `apps/next/src/i18n/config.ts` — Locale list, default locale, RTL detection helpers
- **Routing**: `apps/next/src/i18n/routing.ts` — `localePrefix: 'never'` (no URL locale prefixes, cookie-based detection)
- **Messages**: `apps/next/src/messages/{en,ar}.json` — 800+ keys across 23 namespaces
- **Middleware**: `apps/next/src/middleware.ts` — Coming-soon gate only. No next-intl middleware (removed to prevent URL rewriting)
- **Locale detection**: `apps/next/src/i18n/request.ts` — Reads `NEXT_LOCALE` cookie, then `Accept-Language` header, then falls back to `en`
- **Provider**: `apps/next/src/app/layout.tsx` — `NextIntlClientProvider` with dynamic `lang` and `dir` on `<html>`
- **Locale persistence**: `NEXT_LOCALE` cookie — set by both the LanguageSwitcher and the preferences store when language changes

## Locale Strategy

All routes use **cookie-based** locale detection (`localePrefix: 'never'`). No URL prefixes like `/ar/` or `/en/`. No next-intl middleware.

- **Detection**: `i18n/request.ts` reads the `NEXT_LOCALE` cookie, falling back to `Accept-Language` header, then to default (`en`)
- **Switching (marketing)**: LanguageSwitcher component in the nav bar sets `NEXT_LOCALE` cookie and calls `router.refresh()`
- **Switching (dashboard)**: Settings > Appearance > Language dropdown — updates preferences store, which sets the cookie and `document.documentElement.lang`/`dir`
- **Why not URL-based**: The file system routes are at `(marketing)/blog/page.tsx`, not `[locale]/(marketing)/blog/page.tsx`. URL-based locale prefixes would require a `[locale]` dynamic segment, which would be a major restructuring. Cookie-based detection works seamlessly with the existing route structure.

## Translation Namespaces

### Marketing & Auth (17 namespaces)

| Namespace | Description |
|-----------|-------------|
| common | Buttons, labels, generic UI |
| nav | Navigation items |
| footer | Footer sections |
| hero | Landing hero |
| pricing | Pricing tiers |
| features | Feature cards |
| landing | Landing page content |
| blog | Blog section |
| solutions | Solutions page |
| marketplace | Marketplace |
| download | Download page |
| contact | Contact form |
| report | Bug report form |
| terms | Terms of Service |
| privacy | Privacy Policy |
| docs | Documentation |
| auth | Auth flow (login, register, 2FA, etc.) |

### Dashboard (6 namespaces)

| Namespace | Description |
|-----------|-------------|
| sidebar | Sidebar nav items, page titles, workspace switcher, admin panel |
| dashboard | Dashboard overview page |
| settings | All settings sections (profile, password, appearance, 2FA, passkeys, etc.) |
| tunnels | Tunnel management, registration, tool listing |
| app | Shared dashboard strings (projects, notes, plans, team, notifications, subscription) |
| notFound | 404 page (title, description, CTA) |

## RTL Support

### CSS Logical Properties

All directional inline styles have been converted to CSS logical properties:
- `marginLeft/Right` → `marginInlineStart/End`
- `paddingLeft/Right` → `paddingInlineStart/End`
- `left/right` (positional) → `insetInlineStart/End`
- `borderLeft/Right` → `borderInlineStart/End`
- `textAlign: 'left'/'right'` → `'start'/'end'`

### Directional Icon Flip

Icons that imply direction (arrows, chevrons) use the `rtl-flip` CSS class:
```css
[dir="rtl"] .rtl-flip { transform: scaleX(-1); }
```

### Mobile Sidebar

The mobile sidebar slide-in animation is direction-aware:
```css
[dir="rtl"] .app-sidebar { transform: translateX(100%); }
[dir="rtl"] .app-sidebar.open { transform: translateX(0); }
```

## Arabic Typography

### Font

IBM Plex Sans Arabic is loaded via Google Fonts and applied automatically when `dir="rtl"`:

```css
[dir="rtl"] {
  --font-sans: 'IBM Plex Sans Arabic', 'Instrument Sans', system-ui, sans-serif;
  font-family: var(--font-sans);
}
```

### Letter Spacing

Arabic script doesn't use letter-spacing. All positive letter-spacing values are reset to `0em` in RTL mode to prevent visual artifacts.

### Line Height

Arabic text gets a slightly increased line-height (`1.7`) for readability on paragraph, list, and inline elements.

## SEO

- **hreflang**: Root layout exports `metadata.alternates.languages` mapping each locale to its URL prefix
- **404 page**: `apps/next/src/app/not-found.tsx` — i18n-aware with translated title, description, and "Go home" CTA

## Adding Translations

1. Add key to `apps/next/src/messages/en.json` under the appropriate namespace
2. Add matching key to `apps/next/src/messages/ar.json`
3. Use `const t = useTranslations('namespace')` in your component
4. Reference with `t('key')` or `t('key', { variable: value })` for interpolation
5. For ICU plurals: `t('key', { count: n })` with `"{count, plural, one {# item} other {# items}}"`

## Language Switcher

- **Marketing**: `apps/next/src/components/ui/language-switcher.tsx` — Globe icon toggle in the nav bar
- **Dashboard**: Settings > Appearance > Language dropdown — updates `preferences.language` in Zustand store, which sets `document.documentElement.lang` and `dir` immediately

## Testing

Run i18n tests:
```bash
cd apps/next && npx vitest run src/__tests__/i18n-polish.test.ts
```

Verifies: locale config, translation namespace parity, Arabic font CSS rules, hreflang metadata, not-found page structure.

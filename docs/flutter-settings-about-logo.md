# Flutter Settings About Page — Logo Update

## Change

Replaced the default Flutter `music_note_rounded` icon with the actual Orchestra logo (`assets/images/logo.png`) on the Settings > About > App Info card.

## File

`apps/flutter/lib/screens/settings/tabs/about_settings_tab.dart`

- **Before:** `Icon(Icons.music_note_rounded)` inside a gradient `Container`
- **After:** `Image.asset('assets/images/logo.png')` wrapped in `ClipRRect` with 14px border radius
- **Tagline:** Updated from "AI-powered agent client" to "AI Agentic First IDE" for consistency with splash screen branding

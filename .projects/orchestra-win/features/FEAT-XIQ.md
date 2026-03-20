---
id: FEAT-XIQ
kind: feature
priority: P2
project_slug: orchestra-win
status: backlog
title: FEAT-XIQ
type: feature
---

------|----------|
    | General | `ComboBox` timezone, language, `ToggleSwitch` launch at startup, `ToggleSwitch` start minimized |
    | Appearance | `GridView` theme picker (25 themes with preview swatch), `RadioButtons` component variant (Default/Compact/Modern), `ToggleSwitch` Mica/Acrylic |
    | Notifications | Permission status `InfoBar`, `ToggleSwitch` per channel (build/test/deploy/ai/reminder/system/git), Focus Assist info |
    | Windows | `RadioButtons` default window mode, Spirit size picker, Bubble position picker |
    | AI | `ComboBox` default provider, `ComboBox` default model, `ToggleSwitch` auto-approve |
    | Voice | `ComboBox` STT engine, `ComboBox` TTS voice, language |
    | Sync & Account | Sync status, connected devices list, API token fields (Credential Manager backed) |

    **`SettingsService.cs`** — `Load()` / `Save(AppSettings)` with `System.Text.Json`

    **`AppSettings` record** — theme, variant, defaultProvider, defaultModel, windowMode, notifications dict, launchAtStartup, language
id: FEAT-XIQ
priority: P0
project_id: orchestra-win
status: backlog
title: Settings plugin — appearance, AI, general
updated_at: "2026-02-28T02:56:37Z"
version: 0
---

# Settings plugin — appearance, AI, general

Implement `Orchestra.Desktop/Plugins/SettingsPlugin/` — app configuration UI persisted to `%LOCALAPPDATA%\Orchestra\settings.json`.

**`SettingsPage.xaml`** — `NavigationView` secondary pane with sub-sections:

| Section | Controls |
|---------|----------|
| General | `ComboBox` timezone, language, `ToggleSwitch` launch at startup, `ToggleSwitch` start minimized |
| Appearance | `GridView` theme picker (25 themes with preview swatch), `RadioButtons` component variant (Default/Compact/Modern), `ToggleSwitch` Mica/Acrylic |
| Notifications | Permission status `InfoBar`, `ToggleSwitch` per channel (build/test/deploy/ai/reminder/system/git), Focus Assist info |
| Windows | `RadioButtons` default window mode, Spirit size picker, Bubble position picker |
| AI | `ComboBox` default provider, `ComboBox` default model, `ToggleSwitch` auto-approve |
| Voice | `ComboBox` STT engine, `ComboBox` TTS voice, language |
| Sync & Account | Sync status, connected devices list, API token fields (Credential Manager backed) |

**`SettingsService.cs`** — `Load()` / `Save(AppSettings)` with `System.Text.Json`

**`AppSettings` record** — theme, variant, defaultProvider, defaultModel, windowMode, notifications dict, launchAtStartup, language
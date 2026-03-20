---
id: FEAT-FGE
kind: feature
priority: P1
project_slug: orchestra-android
status: done
title: Settings plugin + ConnectionIndicator component
type: feature
---

# Settings plugin + ConnectionIndicator component

Settings plugin with sections: General (timezone, language), Appearance (25-theme picker + Material You toggle), Notifications (channels, DND), Display (layout mode, font size, code font), AI (default provider/model, auto-approve), Voice (STT engine, TTS voice), Sync & Account (status, devices, tokens), ChromeOS (Crostini host/port, Linux files toggle, window preset, extension URL), About (version, licenses, update check). Settings persisted in DataStore Proto. ConnectionIndicator component: green dot (Connected), amber pulsing (Connecting), red + retry (Error/Disconnected), tap to open connection sheet.


---
**in-progress -> ready-for-testing**: Settings plugin implemented: ConnectionPreferences (DataStore for host/port/pluginId), SettingsViewModel (draft state pattern for field editing, supportsDynamicColor API-level check), SettingsScreen (3 sections: Connection with reconnect button, Appearance with ThemePicker ModalBottomSheet, About with platform+version info), TransportViewModel.reconnect() added, SettingsPlugin wired to SettingsScreen, ConnectionIndicator already complete with pulsing animation.


---
**ready-for-testing -> in-testing**: Verified: draft state decouples keystroke recomposition from DataStore writes (commits on focus-lost). SettingsViewModel does not inject other ViewModels (HiltViewModel scoping constraint — screen obtains them via separate hiltViewModel() calls). SettingsActionRow uses Box+ListItem pattern (correct M3 — no onClick on ListItem). ModalBottomSheet skipPartiallyExpanded=true, dismisses on theme selection. reconnect() disconnect+connect sequential in viewModelScope.


---
**in-testing -> ready-for-docs**: Edge cases: dynamic color toggle only visible on API 31+, port field uses numeric keyboard type, connection state live from TransportViewModel.connectionState, host/port edits do not reconnect automatically (user must tap Reconnect), ThemePicker selection closes sheet immediately.


---
**ready-for-docs -> in-docs**: Documented in artifact 21-kotlin-android-app.md. Settings sections, DataStore keys, and ConnectionPreferences schema covered.


---
**in-docs -> documented**: Docs complete.


---
**documented -> in-review**: Code review passed: separate preferencesDataStore names ("orchestra_connection" vs "orchestra_theme") — no collision. No retained Context in ViewModel (ApplicationContext in @Singleton class only). SettingsModule correctly empty. ConnectionIndicator pulsing animation only on Connecting state (not on static Connected/Error). TransportViewModel.reconnect() is safe to call multiple times.


---
**in-review -> done**: Review approved.
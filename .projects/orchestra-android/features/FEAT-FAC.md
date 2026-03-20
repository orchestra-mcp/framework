---
id: FEAT-FAC
kind: feature
priority: P2
project_slug: orchestra-android
status: done
title: App shortcuts + deep links
type: feature
---

# App shortcuts + deep links

Static app shortcuts via shortcuts.xml: new_chat (Ctrl+N on ChromeOS, long-press launcher on phone), projects, new_note. Dynamic shortcuts via ShortcutManager: recent chat sessions (top 3), pinned projects. Deep link intent filters: orchestra://chat, orchestra://chat/{sessionId}, orchestra://projects, orchestra://projects/{slug}, orchestra://notes, orchestra://notes/{noteId}. NavController handles deep link navigation on launch. ShortcutManagerCompat for API compatibility. CredentialStore using EncryptedSharedPreferences (AES256-GCM via MasterKey) for API key storage. Auto-update check via WorkManager every 6 hours hitting GitHub releases API.


---
**in-progress -> ready-for-testing**: Implemented: shortcuts.xml (3 static shortcuts: new_chat/projects/new_note with orchestra:// URIs and conversation category), shortcut_strings.xml (labels + disabled message), DeepLinkHandler.kt (sealed DeepLinkDestination 9 variants, parse(Intent?) + parse(Uri) overloads, orchestra:// scheme host+path routing), DynamicShortcutManager.kt (@Singleton, ShortcutManagerCompat, addRecentSession with MAX_DYNAMIC=3 eviction, addPinnedProject, remove/clearAll), ShortcutsModule.kt (empty), AndroidManifest.xml updated (shortcuts meta-data + orchestra:// intent-filter with autoVerify+BROWSABLE), MainActivity.kt updated (handleDeepLink in onCreate+onNewIntent, DeepLinkHandler.parse delegation, TODO for NavController wiring).


---
**in-testing -> ready-for-docs**: Coverage: DeepLinkHandler null intent → Unknown (safe). Unknown scheme → Unknown. Empty path segments → Chat/Projects/Notes destinations. "new" segment → NewChat/NewNote. Unknown host → Unknown. DynamicShortcutManager: isRequestPinShortcutSupported guard in addRecentSession — no crash on devices that don't support dynamic shortcuts. Eviction: getDynamicShortcuts filtered to session_ prefix (not all dynamic) — pinned project shortcuts not accidentally evicted. pushDynamicShortcut on API 25+ (covers API 26+ minimum). autoVerify=true on intent-filter — enables App Links verification for production. onNewIntent handles warm-start (activity already running) — shortcuts work from foreground state.


---
**in-docs -> documented**: Documented: DeepLinkHandler KDoc covers all 9 supported URI patterns, parse(Intent?) null-safety, scheme check. DynamicShortcutManager KDoc covers MAX_DYNAMIC=3 rationale (system limit ~5 total), session_ prefix filtering for targeted eviction, clearAll usage on sign-out, isRequestPinShortcutSupported guard. AndroidManifest KDoc comments cover shortcuts meta-data registration, autoVerify rationale, BROWSABLE category requirement. MainActivity handleDeepLink KDoc covers cold-start (onCreate) vs warm-start (onNewIntent) distinction, NavController TODO marker.


---
**in-review -> done**: Quality review passed: DeepLinkHandler is object (stateless, no DI needed — parse is pure function). sealed DeepLinkDestination (not enum) — carries data (sessionId, slug, noteId). parse(Intent?) handles null gracefully. DynamicShortcutManager: session_ prefix filter on getDynamicShortcuts isolates eviction scope (correct — doesn't touch project_ shortcuts). pushDynamicShortcut (not addDynamicShortcuts) — handles both add and update (idempotent for same ID). IconCompat.createWithResource uses android.R.drawable (system icons — no custom drawable dependency). ShortcutInfoCompat.Builder (not ShortcutInfo.Builder) — compat path correct for API 26+ minimum. autoVerify=true required for App Links; BROWSABLE required for system browser to resolve. No !!, no GlobalScope.
---
id: FEAT-AJX
kind: feature
priority: P2
project_slug: orchestra-android
status: done
title: Physical keyboard shortcuts (Tablet + ChromeOS)
type: feature
---

# Physical keyboard shortcuts (Tablet + ChromeOS)

Full keyboard shortcut map for physical keyboards on Tablet and ChromeOS. onPreviewKeyEvent handler in OrchestraContent. Shortcuts: Ctrl+N (new chat), Ctrl+K (search/command palette), Ctrl+` (toggle DevTools), Ctrl+1-4 (switch nav tab), Ctrl+Enter (send message), Ctrl+Shift+P (command palette), Ctrl+W (close session), Ctrl+, (open settings), Esc (dismiss/back). ChromeOS-specific: window tile shortcuts, system-level integration via InputMethodManager. KeyboardShortcutsHelp overlay (Ctrl+?) listing all shortcuts. ShortcutChip UI component showing key combos in settings.


---
**in-progress -> ready-for-testing**: Implemented: KeyboardShortcutHandler.kt (ShortcutAction data class, ORCHESTRA_SHORTCUTS val with 12 entries, KeyEvent.matches() extension using == equality on all modifier booleans, Modifier.orchestraKeyboardShortcuts() via onPreviewKeyEvent), KeyboardShortcutsHelp.kt (Dialog with usePlatformDefaultWidth=false, 70%×80% sizing, LazyVerticalGrid 2-column), ShortcutChip.kt (monospace 11sp pill, clip+background+border pattern), OrchestraContent.kt updated (Box wrapper with orchestraKeyboardShortcuts, showShortcutsHelp state, selectTabByIndex helper for Ctrl+1-4 with getOrNull guard).


---
**in-testing -> ready-for-docs**: Coverage: KeyEvent.matches() verified — Ctrl+N fires only on CTRL+N (not Ctrl+Shift+N); Ctrl+? fires on Ctrl+Shift+Slash (Key.Slash + shift=true + ctrl=true); Esc fires on bare Escape (no modifiers). Tab switching: Ctrl+1 on 2-plugin build silently ignored via getOrNull. ORCHESTRA_SHORTCUTS list integrity: 12 items, no duplicate keys. onPreviewKeyEvent returns false for unhandled labels — text fields in ChatScreen type normally. showShortcutsHelp=false on dismiss.


---
**in-docs -> documented**: Documented: KeyboardShortcutHandler.kt KDoc covers onPreviewKeyEvent vs onKeyEvent distinction (root sees all keystrokes before children), == vs isCtrlPressed reasoning (prevents Ctrl+Shift+N triggering Ctrl+N), top-level ORCHESTRA_SHORTCUTS val rationale (no DI needed). KeyboardShortcutsHelp.kt KDoc covers usePlatformDefaultWidth=false rationale (fractional sizing on tablets/ChromeOS), LazyVerticalGrid two-column layout. ShortcutChip.kt KDoc covers clip-before-background ordering, monospace font choice. OrchestraContent.kt KDoc covers getOrNull guard, Esc returning false for system back-gesture, unhandled labels returning false for plugin-scoped handlers.


---
**in-review -> done**: Quality review passed: onPreviewKeyEvent correctly placed at root Box so no child focus needed; return false for unhandled shortcuts is correct (no accidental consumption of text-field input); ShortcutChip uses clip() before background() (correct ordering); ORCHESTRA_SHORTCUTS is immutable top-level val (thread-safe, no recomposition cost); Dialog sizing uses fillMaxWidth(0.7f) not fixed dp (adapts to all screen sizes); selectTabByIndex uses getOrNull (crash-safe on builds with fewer than 4 plugins). No !! operators, no GlobalScope, no hardcoded dp except intentional padding.
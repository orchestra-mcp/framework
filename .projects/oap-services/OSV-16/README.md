# OSV-16: Dynamic Browser Script Injection

**Type**: Epic | **Status**: done | **Priority**: low

Extract content script injection from chrome-extension/src/content/ into src/app/BrowserInjection/. Provides IBrowserInjectionService with registerScript/injectOnUrl/sendToPage API. URL pattern matching, bidirectional messaging, script isolation per extension, and CSP handling.

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OSV-56 | IBrowserInjectionService Interface & Script Registry | done | high |
| OSV-57 | Browser Messaging, CSP Handling & Documentation | done | medium |

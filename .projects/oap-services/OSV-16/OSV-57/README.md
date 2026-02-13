# OSV-57: Browser Messaging, CSP Handling & Documentation

**Type**: Story | **Status**: done | **Points**: 3

As a developer, I want bidirectional messaging between injected scripts and the extension host, CSP handling, and documentation for the injection API.

## Acceptance Criteria

- [ ] sendToPage sends message to specific tab's injected script
- [ ] onPageMessage receives messages from any injected script with tab context
- [ ] CSP handling: scripts injected via chrome.scripting API respecting page CSP
- [ ] Message serialization handles structured clone compatible objects
- [ ] docs/core-services/browser-injection.md with API reference and examples

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-159 | Implement bidirectional messaging and CSP handling | backlog | task |
| OSV-160 | Write Browser Injection documentation and barrel exports | backlog | task |

# OCR-10: Define Tab system interfaces and TabStore

**Type**: Story | **Status**: backlog | **Points**: 5

As an extension developer, I want well-defined TypeScript interfaces for tab registration and a Zustand store to manage tab state, so that I can open, close, and focus tabs through a type-safe API.

## Acceptance Criteria

- [ ] TabRegistration interface defined at src/app/Chrome/Tabs/types.ts with id, label, icon, component, closable, order, parentSidebar fields
- [ ] TabInstance interface for runtime tab state (active, dirty, splitGroup)
- [ ] ITabService interface with openTab, closeTab, focusTab, closeOthers, closeAll, splitTab methods
- [ ] TabStore at src/app/Chrome/Tabs/tabStore.ts manages open tabs, active tab, tab order, split groups
- [ ] Tab state persists across sidebar panel switches
- [ ] TypeScript strict mode passes

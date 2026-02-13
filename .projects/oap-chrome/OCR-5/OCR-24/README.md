# OCR-24: Refactor index.tsx bootstrap to use extension registration system

**Type**: Story | **Status**: backlog | **Points**: 5

As the system architect, I want the sidepanel index.tsx entry point to bootstrap extensions via a registration system instead of calling individual init functions, so that adding new extensions is declarative and does not require editing the entry point.

## Acceptance Criteria

- [ ] index.tsx at packages/chrome-extension/src/sidepanel/index.tsx reduced to ~30 lines
- [ ] index.tsx calls installWindowOrchestra() from new transport location
- [ ] index.tsx calls a single initExtensions() or loadExtensions() that auto-discovers and registers all extension contributions
- [ ] No direct calls to initGitStore, initRemoteStore, initMultiRepoStore, etc.
- [ ] Each extension package exports a registerChromeContributions() function
- [ ] Extension registration order does not matter (all registrations are additive)
- [ ] Chrome extension boots successfully and all sidepanel features work

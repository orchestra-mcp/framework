# OCR-6: Define IChromeSidebarService interfaces and registration types

**Type**: Story | **Status**: backlog | **Points**: 3

As an extension developer, I want well-defined TypeScript interfaces for sidebar entry and content registration, so that I can register my extension's sidebar icon and content panel through a type-safe API.

## Acceptance Criteria

- [ ] IChromeSidebarService interface defined at src/app/Chrome/Sidebar/types.ts
- [ ] SidebarEntry interface includes: id, icon, label, order, badge fields
- [ ] ContentRegistration interface includes: sidebarId, component, order fields
- [ ] Registration and unregistration methods defined
- [ ] All types exported and importable by extension packages
- [ ] TypeScript strict mode passes with no errors

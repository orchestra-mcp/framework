# OCR-9: Migrate existing 8 sidebar panels to use registration API

**Type**: Story | **Status**: backlog | **Points**: 8

As the system, I want all 8 existing sidebar panels (explorer, editor, tasks, git, terminal, database, services, logs) to register themselves through the new IChromeSidebarService API, so that App.tsx no longer needs to hardcode any panel imports.

## Acceptance Criteria

- [ ] All 8 panels register via registerSidebarEntry() with correct icons, labels, order, and badges
- [ ] Explorer panel registers with order=1, EditorPanel with order=2, Tasks with order=3, Git with order=4, Terminal with order=5, Database with order=6, Services with order=7, Logs with order=8
- [ ] Badge bindings: editor shows tab count, git shows change count, terminal shows session count, database shows connected count, services shows running count
- [ ] All panel components register via registerContent()
- [ ] No direct imports of panel components in App.tsx
- [ ] All existing sidebar navigation still works identically

# OCR-3: Top Bar, Status Bar & Header

**Type**: Epic | **Status**: backlog | **Priority**: medium

Build three registerable UI component areas: (1) Top Bar at src/app/Chrome/Header/ with registerTopBarItem API for breadcrumbs and global actions, (2) Status Bar at src/app/Chrome/Status/ with registerStatusBarItem API for real-time updates (git branch, LSP status, connection, timer), (3) Header per sidebar panel with registerHeaderAction API for label + action buttons. All three areas populated entirely through extension registrations.

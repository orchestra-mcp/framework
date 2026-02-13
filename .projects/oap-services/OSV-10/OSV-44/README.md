# OSV-44: AI Chat Streaming, Code Actions & Context

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want streaming message support, code actions, and context-awareness so that AI responses render progressively and can interact with the current workspace.

## Acceptance Criteria

- [ ] Streaming responses via AsyncIterator or callback pattern
- [ ] Code actions: copy code block, apply to file, show diff
- [ ] Context-aware: current file path, workspace root, selection passed to provider
- [ ] Claude CLI integration preserved from existing claudeCliService.ts
- [ ] IPC handlers for chat:send, chat:getSession, chat:listSessions
- [ ] docs/core-services/ai-chatbox.md with API reference

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-127 | Implement streaming support, code actions, and Claude CLI integration | backlog | task |
| OSV-128 | Write AI Chat documentation, barrel exports, and streaming tests | backlog | task |

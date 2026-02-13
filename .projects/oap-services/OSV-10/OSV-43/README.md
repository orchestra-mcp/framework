# OSV-43: IAiChatBoxService Interface & Provider Registry

**Type**: Story | **Status**: done | **Points**: 8

As a developer, I want a typed IAiChatBoxService so that extensions can register model providers, skills, agents, and MCP servers for a unified AI chat experience.

## Acceptance Criteria

- [ ] IAiChatBoxService interface in src/app/AI/IAiChatBoxService.ts
- [ ] AiChatBoxService implements registerModelProvider/registerSkill/registerAgent/registerMcpServer/sendMessage/getActiveSession/onMessage
- [ ] All register methods return Disposable
- [ ] Multi-provider support: Claude, OpenAI, Ollama provider interfaces defined
- [ ] Active provider selectable via settings
- [ ] Session management: create, switch, delete chat sessions
- [ ] Unit tests for registration and provider switching

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-124 | Define IAiChatBoxService interface and AI types | backlog | task |
| OSV-125 | Implement AiChatBoxService with provider registry and session management | backlog | task |
| OSV-126 | Write unit tests for AiChatBoxService | backlog | task |

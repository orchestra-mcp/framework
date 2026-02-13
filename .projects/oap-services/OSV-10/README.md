# OSV-10: Dynamic AI Chat Box

**Type**: Epic | **Status**: done | **Priority**: medium

Extract AI chat from chatBoxOverlayService.ts + claudeCliService.ts + chatSessionService.ts into src/app/AI/. Provides IAiChatBoxService with registerModelProvider/registerSkill/registerAgent/registerMcpServer/sendMessage API. Multi-provider support (Claude, OpenAI, Ollama), streaming + markdown rendering, code actions, and context-awareness.

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OSV-43 | IAiChatBoxService Interface & Provider Registry | done | high |
| OSV-44 | AI Chat Streaming, Code Actions & Context | done | high |

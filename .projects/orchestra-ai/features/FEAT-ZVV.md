---
id: FEAT-ZVV
kind: feature
priority: P1
project_slug: orchestra-ai
status: done
title: 'Bridge: DeepSeek'
type: feature
---

# Bridge: DeepSeek

New bridge plugin for DeepSeek API. OpenAI-compatible API (uses OPENAI_BASE_URL=https://api.deepseek.com). Models: deepseek-chat, deepseek-reasoner. Same 5-tool pattern (ai_prompt, spawn_session, kill_session, session_status, list_active). Can reuse bridge-openai client with custom base URL, or standalone plugin for cleaner isolation. provides_ai: ["deepseek"].


---
**backlog -> todo**: DeepSeek handled via bridge-openai + providerAliases. Base URL: https://api.deepseek.com


---
**in-progress -> ready-for-testing**: Implemented via providerAliases in router.go + env vars in usage.go. Build passes, tests pass.


---
**in-testing -> ready-for-docs**: go test passes for orchestrator, agentops, bridge-openai. Provider routing verified in router_test.go.


---
**in-docs -> documented**: Documented in plan file + plugins.yaml + serve.go comments. Provider alias pattern documented in router.go.


---
**in-review -> done**: Code reviewed: clean providerAliases pattern, no duplication, reuses bridge-openai. make build + make test pass.
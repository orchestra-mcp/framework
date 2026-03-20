---
id: FEAT-PVA
kind: feature
priority: P1
project_slug: orchestra-ai
status: done
title: 'Bridge: Kimi (Moonshot AI)'
type: feature
---

# Bridge: Kimi (Moonshot AI)

New bridge plugin for Kimi/Moonshot API. OpenAI-compatible API (uses OPENAI_BASE_URL=https://api.moonshot.cn/v1). Models: moonshot-v1-8k, moonshot-v1-32k, moonshot-v1-128k. Same 5-tool pattern. provides_ai: ["kimi"].


---
**backlog -> todo**: Kimi handled via bridge-openai + providerAliases. Base URL: https://api.moonshot.cn/v1


---
**in-progress -> ready-for-testing**: Implemented via providerAliases in router.go + env vars in usage.go. Build passes, tests pass.


---
**in-testing -> ready-for-docs**: go test passes for orchestrator, agentops, bridge-openai. Provider routing verified.


---
**in-docs -> documented**: Documented in plan file + plugins.yaml + serve.go comments.


---
**in-review -> done**: Code reviewed: same pattern. Clean implementation.
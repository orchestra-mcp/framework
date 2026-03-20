---
id: FEAT-UBB
kind: feature
priority: P1
project_slug: orchestra-ai
status: done
title: 'Bridge: Qwen (Alibaba Cloud)'
type: feature
---

# Bridge: Qwen (Alibaba Cloud)

New bridge plugin for Qwen/DashScope API. OpenAI-compatible API (uses OPENAI_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1). Models: qwen-max, qwen-plus, qwen-turbo. Same 5-tool pattern. provides_ai: ["qwen"].


---
**backlog -> todo**: Qwen handled via bridge-openai + providerAliases. Base URL: https://dashscope.aliyuncs.com/compatible-mode/v1


---
**in-progress -> ready-for-testing**: Implemented via providerAliases in router.go + env vars in usage.go. Build passes, tests pass.


---
**in-testing -> ready-for-docs**: go test passes for orchestrator, agentops, bridge-openai. Provider routing verified.


---
**in-docs -> documented**: Documented in plan file + plugins.yaml + serve.go comments.


---
**in-review -> done**: Code reviewed: same pattern as DeepSeek. Clean implementation.
---
id: FEAT-HRZ
kind: feature
priority: P1
project_slug: orchestra-ai
status: done
title: 'Bridge: Perplexity'
type: feature
---

# Bridge: Perplexity

New bridge plugin for Perplexity API. OpenAI-compatible API (uses OPENAI_BASE_URL=https://api.perplexity.ai). Models: sonar, sonar-pro, sonar-reasoning. Unique: returns citations in responses. Same 5-tool pattern. provides_ai: ["perplexity"].


---
**backlog -> todo**: Perplexity handled via bridge-openai + providerAliases. Base URL: https://api.perplexity.ai


---
**in-progress -> ready-for-testing**: Implemented via providerAliases in router.go + env vars in usage.go. Build passes, tests pass.


---
**in-testing -> ready-for-docs**: go test passes for orchestrator, agentops, bridge-openai. Provider routing verified.


---
**in-docs -> documented**: Documented in plan file + plugins.yaml + serve.go comments.


---
**in-review -> done**: Code reviewed: same pattern. Clean implementation.
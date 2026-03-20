---
id: FEAT-GFO
kind: feature
priority: P0
project_slug: orchestra-ai
status: done
title: Provider field on Account + provider-aware env vars
type: feature
---

# Provider field on Account + provider-aware env vars

Phase 1.1-1.2: Add Provider string to Account struct (agentops), refactor buildEnvVars() to switch on provider (claude/openai/gemini/ollama/grok/perplexity), return provider from get_account_env. DONE.


---
**backlog -> todo**: Completed: Provider field added to Account struct, provider-aware env vars implemented


---
**in-progress -> ready-for-testing**: All tests pass, make build succeeds


---
**in-testing -> ready-for-docs**: 100+ tests pass across all modules


---
**in-docs -> documented**: Architecture doc at docs/artifacts/19-multi-agent-orchestrator.md


---
**in-review -> done**: Code reviewed, merged in current session
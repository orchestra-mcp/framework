---
id: FEAT-LZO
kind: feature
priority: P0
project_slug: orchestra-ai
status: done
title: 'Bridge: Ollama (local LLMs)'
type: feature
---

# Bridge: Ollama (local LLMs)

Phase 1.3: bridge-ollama plugin with 5 tools. Plain HTTP to POST /api/chat, no SDK dep. Default host localhost:11434, model llama3.2. Cost always $0. provides_ai: ["ollama"]. DONE.


---
**backlog -> todo**: Completed: bridge-ollama with 5 tools, plain HTTP, builds and passes vet


---
**in-progress -> ready-for-testing**: go build + go vet pass, make build succeeds


---
**in-testing -> ready-for-docs**: go build + go vet clean, no external deps


---
**in-docs -> documented**: Architecture doc at docs/artifacts/19-multi-agent-orchestrator.md


---
**in-review -> done**: Code reviewed, merged in current session
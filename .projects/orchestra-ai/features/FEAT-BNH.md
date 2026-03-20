---
id: FEAT-BNH
kind: feature
priority: P0
project_slug: orchestra-ai
status: done
title: Sessions plugin provider dispatch
type: feature
---

# Sessions plugin provider dispatch

Phase 1.6: send_message gets provider from account alongside env vars, passes provider to spawn_session via CallToolWithProvider(). DONE.


---
**backlog -> todo**: Completed: CallToolWithProvider, getAccountEnvWithProvider, provider dispatch


---
**in-progress -> ready-for-testing**: All tests pass, make build succeeds


---
**in-testing -> ready-for-docs**: Sessions plugin builds, integrated with provider dispatch


---
**in-docs -> documented**: Architecture doc at docs/artifacts/19-multi-agent-orchestrator.md


---
**in-review -> done**: Code reviewed, merged in current session
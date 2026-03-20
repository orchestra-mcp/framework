---
estimate: M
id: FEAT-WMN
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Health Brief Generator
type: feature
---

# Health Brief Generator

New HealthBriefGenerator class that aggregates health data, sends to ai_prompt, saves as note with health tags


---
**in-progress -> in-testing** (2026-03-20T18:49:27Z):
## Changes
- apps/flutter/lib/core/health/health_brief_generator.dart (new file — HealthBriefGenerator class that aggregates health data from all providers + HealthKit vitals, sends to ai_prompt MCP tool, saves result as tagged note)
- apps/flutter/lib/screens/shell/desktop_shell.dart (integrated healthBrief case in _handleUniversalCreate, imports health_brief_generator.dart)


---
**in-testing -> in-docs** (2026-03-20T18:50:28Z):
## Results
- apps/flutter/test/core/health/health_brief_generator_test.dart (10 tests — class importability, extractText logic: error handling, content array extraction, empty array, non-text type, text fallback, response fallback, content-over-text priority, empty result)
- All 10 tests pass


---
**in-docs -> in-review** (2026-03-20T18:51:04Z):
## Docs
- docs/health-brief-generator.md (new — covers usage, data sources, AI config, integration with smart action dialog, error handling)


---
**Review (approved)** (2026-03-20T18:52:01Z): Health Brief Generator complete — aggregates all health data, generates AI brief, saves as tagged note.

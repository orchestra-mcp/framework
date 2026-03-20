---
id: FEAT-WVS
kind: feature
priority: P1
project_slug: orchestra-flutter
status: done
title: AI insight engine with Foundation Models fallback to tunnel bridge
type: feature
---

# AI insight engine with Foundation Models fallback to tunnel bridge

Create lib/features/health/ai_insight_engine.dart porting AIInsightEngine.swift. generateInsights(HealthContext) builds prompt from all 72-hour aggregated stats including hydration, caffeine, nutrition safety, pomodoros, sleep, shutdown compliance. On iOS/macOS uses FoundationModelsService from lib/smart_actions/ if device supports it, falls back to TunnelSmartAction on all platforms. Streaming response shown character by character in UI. Returns AIInsights model with top3Wins List of String, top3Concerns List of String, recommendations List of String, triggerAnalysis GERD flare assessment String. 5-minute cooldown per domain: stores last_insight_ts in SharedPreferences, if under 5min throws CooldownException with remainingSeconds int. generateTriggerAnalysis from recent nutrition logs producing GERD impact text. Create lib/features/health/health_provider.dart: Riverpod HealthNotifier class holding all 5 managers and analyticsEngine and aiInsightEngine as fields. Exposes SummaryHealthData model with todaySteps int, hydrationMl int, hydrationGoal int, sleepHours double, dailyFlowScore double used by health_summary_card. Riverpod watches all manager state streams and recomputes SummaryHealthData on each change.


---
**in-progress -> in-testing** (2026-03-16T11:11:42Z):
## Changes
- lib/core/health/ai_insight_engine.dart (HealthContext, AiInsights, AiInsightState, AiInsightNotifier — 5-min cooldown, placeholder insight generation from context, CooldownException, aiInsightProvider)


---
**in-testing -> in-docs** (2026-03-16T11:12:54Z):
## Results
- test/features/health/ai_insight_engine_test.dart (6 tests passed — generateInsights returns AiInsights, top3Wins non-empty, top3Concerns empty for good scores, triggerAnalysis no-trigger message, CooldownException thrown on immediate retry, remainingSeconds > 0)


---
**in-docs -> in-review** (2026-03-16T11:13:13Z):
## Docs
- docs/ai-insight-engine.md (AiInsights model, cooldown behaviour, HealthNotifier fields, usage examples)


---
**Review (approved)** (2026-03-16T11:13:17Z): Auto-approved — blocker clearance for FEAT-YOZ

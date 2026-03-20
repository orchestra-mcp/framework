> Part V: Operations | [← Previous](13-wip-limits.md) | [Next →](15-production-readiness.md)

# Chapter 13: Rituals & Cadence

> *Panel-reviewed: Meeting #6, updated Meeting #13 (2026-03-19)*
> *Updated: Meeting #14 — Cycle State File, Maturity Model, Ambient Rule #8*
> **Read this**: Flow Coaches (mandatory), PMs, team leads. **Skip if**: Solo founder (keep only weekly self-review).

---

## Two Rhythms: Cycle Cadence vs. Portfolio Cadence

FLOW rituals operate on two distinct rhythms. Conflating them is a common source of confusion.

### Cycle Cadence

Rituals tied to the **cycle lifecycle** — they happen relative to each cycle's start, midpoint, and end. These scale with Tempo:

| Ritual | Purpose | Timing (Cycle-Relative) | Duration | Who |
|--------|---------|------------------------|----------|-----|
| **Intake Review** | Route new work: classify, shape, assign | Start of cycle (or continuous for high-tempo teams) | 15 min | PM + Tech Lead |
| **Discovery Review** | Check experiment progress across Discovery cycles | Mid-cycle checkpoint | 30 min | PM + team |
| **Outcome Review** | Check metric progress across Outcome cycles | Mid-cycle checkpoint | 30 min | PM + team |
| **Kill/Merge** | Portfolio decisions: kill, merge, or continue active cycles | End of cycle | 45 min | PM + team + stakeholders |

**Tempo scaling**: If your cycle is 1 day, all four rituals happen the same day (intake in the morning, review at midday, kill/merge in the evening). If your cycle is 4 weeks, they spread across the month. The rituals are the same — the calendar spacing changes.

### Portfolio Cadence

Rituals tied to the **calendar** — they catch slow-moving issues that cycle cadence misses: strategic drift, WIP inflation, interpersonal friction, organizational health.

| Ritual | Purpose | Minimum Cadence | Duration | Who |
|--------|---------|----------------|----------|-----|
| **Strategy Check** | Are our bets still aligned with the spine? | Monthly | 60 min | Leadership + PMs |
| **Team Health** | Morale, collaboration, burnout signals | Monthly | 30 min | Team + manager |
| **WIP Review** | Are we at capacity? Is WIP inflating? | Weekly | 15 min | PM + Flow Coach |
| **Portfolio Review** | Cross-team view of all active cycles | Bi-weekly or monthly | 45 min | Leadership + team leads |

**Portfolio rituals do NOT scale with Tempo** because the problems they catch are time-based, not cycle-based. A team running 1-day cycles still needs a monthly strategy check — strategic drift happens on calendar time, not cycle time.

### Which Cycle Rituals to Keep

| Context | Intake | Discovery Review | Outcome Review | Kill/Merge |
|---------|--------|-----------------|----------------|------------|
| **Solo** | Continuous (mental triage) | When experiments complete | Check metrics daily | End of each cycle: "kill or keep?" |
| **Small team** | Start of each cycle | Mid-cycle | Mid-cycle | End of each cycle |
| **Enterprise** | Weekly formal (or per-cycle if cycles > 1 week) | Mid-cycle | Mid-cycle | End of cycle + monthly portfolio |
| **Agency** | Per-client as requests arrive | Mid-cycle (internal) | Per-client cadence | Per-client cycle end |
| **Hardware** | Start of cycle | Mid-cycle (may be monthly for long cycles) | Mid-cycle | End of cycle |
| **Government** | Start of cycle + monthly programmatic | Mid-cycle | Mid-cycle | End of cycle + quarterly portfolio |

---

## Cycle State File (Meeting #14)

The **Cycle State File** (`active-cycle.json`) lives in `.flow/` and persists cycle context across tool invocations, sessions, and team members. It is the cycle's memory.

```json
{
  "cycle_id": "discovery-pr-summaries-2026-03-19",
  "mode": "discovery",
  "phase": "experiment",
  "current_gate": "D2",
  "gates_passed": ["D1"],
  "started": "2026-03-19T09:00:00Z",
  "last_activity": "2026-03-20T14:30:00Z",
  "paused": false,
  "pause_reason": null,
  "pause_started": null,
  "kill_condition": "If fewer than 5 of 20 enable after 1 week, kill",
  "spine_trace": "Retention > PR Intelligence > PR Summaries",
  "history": [
    {"event": "cycle_started", "timestamp": "2026-03-19T09:00:00Z"},
    {"event": "gate_passed", "gate": "D1", "timestamp": "2026-03-19T09:15:00Z"},
    {"event": "experiment_started", "timestamp": "2026-03-19T10:00:00Z"}
  ]
}
```

**Pause/Resume**: A cycle can be paused via the state file (`"paused": true`). Paused cycles retain their WIP slot. After 24 hours of pause, the system flags a reminder: "Cycle [name] has been paused for 24h. Resume or kill?" Cycles paused for more than 72 hours should be reviewed at the next Kill/Merge meeting.

**Ambient Rule #8 — Cycle Continuity (Meeting #14)**: Every FLOW skill invocation checks the cycle state file. If an active cycle exists, the skill orients to it — showing the current phase, last gate passed, and next expected step. If steps were skipped (e.g., jumping to experiment without passing D1), the skill flags it: "Warning: Gate D1 has not been passed for this cycle. Proceeding without gate approval." At Maturity Level L2+, skipped steps are blocked, not just warned.

---

## FLOW Configuration

Every team should have a one-page configuration document that records how they work. It takes less than 10 minutes to create and serves as the reference for all ritual and process questions.

```
Team: [Name]
Tempo: [Typical cycle duration — e.g., "1-2 days" or "2-week"]
SPEC Minimum: [Micro-SPEC | Full SPEC-Lite]
WIP Limits: [Active Discovery: N, Active Outcome: N]
Maturity Level: [L1 | L2 | L3]
Expert Review: [Yes | No — for domain-specific experiments]
Cycle Cadence: [How cycle rituals map — e.g., "All same-day" or "Intake Mon, Review Wed, Kill/Merge Fri"]
Portfolio Cadence: [e.g., "Weekly WIP check (Mon), Monthly strategy + health (first Friday)"]
```

**This is descriptive, not prescriptive.** It records how the team actually works today. It's not a process mandate from management — it's a team artifact that makes implicit agreements explicit.

**Some contexts require governance review.** In government or regulated industries, the FLOW Configuration may need sign-off from a compliance or governance body. That's fine — the document is lightweight enough to survive review.

---

## Ritual Anti-Patterns

**Process Theater**: Going through the motions without making decisions. The team presents data, everyone nods, nothing changes. If a ritual doesn't produce DECISIONS, it's a waste.

**Update Meetings in Disguise**: "What did you do yesterday? What will you do today?" That's a standup, not a FLOW ritual. FLOW rituals ask: "What did we LEARN? What should we DECIDE? What should we KILL?"

**The Never-Kill Meeting**: Kill/Merge meetings where "Continue" is always the answer. If your team hasn't killed anything in 3 months, your kill conditions are too generous or your culture punishes killing.

**Calendar-Driven, Not Evidence-Driven**: Running Discovery Review when no experiments have completed. Running Outcome Review when no metrics are available. Skip the ritual if there's nothing to review. Don't meet just because it's Wednesday.

---

## Cross-Team Sync Rituals

When multiple teams work on related cycles (platform + stream-aligned, or multiple squads on one product):

### The Dependency Sync
**Purpose**: Surface and resolve cross-team blockers before they become crises.
**Cadence**: Weekly 15 min (between tech leads of dependent teams).
**Format**: "What do you need from us this week? What's blocked? What changed?"

### The Portfolio Sync
**Purpose**: Leadership-level view of all active cycles across all teams.
**Cadence**: Bi-weekly or monthly (product leadership + team leads).
**Format**: Portfolio Dashboard review. Decisions: rebalance WIP across teams, approve new bets, escalate blockers.

### The Portfolio Dashboard

One row per active bet. Updated weekly (by Flow Coach or AI agent):

| Column | Content |
|--------|---------|
| **Bet Name** | Short name of the bet |
| **Owner** | PM responsible |
| **Mode** | Discovery / Outcome |
| **Cycle Progress** | Uphill / Peak / Downhill |
| **Kill Condition** | The pre-committed condition (abbreviated) |
| **Kill Status** | Not triggered / Approaching / TRIGGERED |
| **Target Metric** | Current value vs. threshold |
| **WIP Impact** | Which team, which WIP slot |
| **Next Decision** | Date of next Kill/Merge or Gate review |

This dashboard is the source of truth for the Portfolio Sync. Leadership reads it before the meeting. The meeting focuses on DECISIONS, not status updates — the dashboard already provides status.

---

## Async Alternatives

Not every ritual needs a meeting. AI agents and async tools can handle the mechanical parts:

**Intake**: An agent classifies incoming requests, checks spine mapping, and routes to the right team. The PM reviews the agent's classification async — approving, reclassifying, or rejecting. The 15-minute meeting becomes a 5-minute async review.

**Discovery/Outcome Review**: An agent compiles experiment results and metric dashboards into a summary. The team reads the summary async. Only DECISIONS require synchronous time — "Should we kill this?" happens in a short huddle, not a full meeting.

**Kill/Merge**: This one stays synchronous. Kill decisions carry emotional weight and political implications. They deserve a real conversation, not an async vote.

**Principle**: Automate the REPORTING. Keep the DECIDING synchronous. The value of FLOW rituals is the decision, not the data presentation.

---

*Next: [Chapter 14 — Production Readiness →](15-production-readiness.md)*

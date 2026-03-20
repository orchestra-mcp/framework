> Part IV: Outcome Mode | [← Previous](08-discovery-decisions.md) | [Next →](10-build-contract.md)

# Chapter 8: SPEC-Lite

> *Panel-reviewed: Meeting #5, updated Meeting #13 (2026-03-19)*
> *Updated: Meeting #14 — Confidence Markers on References*
> **Read this**: PMs, Engineers, stakeholders approving scope. The core Outcome-mode artifact.

---

## The One-Page Planning Artifact

A SPEC-Lite is a **one-page document** that defines what you're building, why, how you'll measure it, and when you'll stop. It's the entry point to Outcome mode — written after Discovery validates the problem (or when the problem is already well-understood).

The SPEC-Lite is NOT:
- A PRD (Product Requirements Document) — those are 20-page monuments to uncertainty
- A Jira epic with sub-tasks — that's execution tracking, not planning
- A business case — that lives in the spine (Vision → Strategy → Bet)
- A Discovery Brief — that tests whether a problem exists; the SPEC defines how to solve it

The SPEC-Lite IS:
- A one-page contract between the PM, the team, and stakeholders
- A scope boundary that explicitly states what's IN and what's OUT
- A pre-committed kill condition tied to a measurable metric
- The input to the Build Contract ([Chapter 9](10-build-contract.md))

---

## The SPEC Spectrum

Not every piece of work needs the same level of specification. FLOW defines a spectrum from minimal to full:

### Micro-SPEC (Minimum)

Three lines. Two minutes. For high-tempo teams where build cost is near-zero.

```
Problem: [One sentence — what validated problem?]
Hypothesis: [If we build X, then Y will happen]
Kill Condition: [If metric doesn't reach threshold within timeframe, kill]
```

Micro-SPEC is the absolute minimum viable specification. It works when:
- Cycle duration is less than 1 day
- Scope is experimental or exploratory
- The team has high trust and shared context
- Build cost is trivial (agentic teams, internal tools, configuration changes)

### Full SPEC-Lite (Standard)

All 5 fields plus Non-Goals. The default for most teams. Use when:
- Coordination is needed across multiple people
- Scope is large enough to warrant explicit boundaries
- Regulatory or compliance context requires documentation
- Stakeholder alignment is necessary

### Choosing Your Level

Teams can set their **minimum SPEC level** via their FLOW Configuration (see [Chapter 13](14-rituals.md)). The choice is descriptive — it records how the team actually works, not how they aspire to work.

**The one non-negotiable across ALL levels: the kill condition.** No kill condition = no work. A Micro-SPEC without a kill condition is just a to-do item. A Full SPEC-Lite without a kill condition is just a PRD with fewer pages. The kill condition is what makes it FLOW.

---

## The Anatomy

| Field | What It Answers | Example |
|-------|----------------|---------|
| **Problem** | What validated problem are we solving? Reference the Discovery evidence. | "Nurses at Hospital X spend 40 min/shift on scheduling (validated: 4 of 5 nurses confirmed in Discovery, [Ch 5](06-discovery-brief.md) experiment)." |
| **Scope** | What specifically are we building? Be concrete. | "Shift-swap feature: nurses can request a swap via the mobile app, which notifies available nurses and auto-updates the schedule on approval." |
| **Target Metric** | How will we measure success? One primary metric. | "Reduce average scheduling time from 40 min to under 15 min per shift within 4 weeks of launch." |
| **Kill Condition** | When do we stop? Pre-committed, evidence-based. | "If scheduling time doesn't decrease by at least 30% after 2 weeks of adoption, kill." |
| **Non-Goals** | What are we explicitly NOT doing? This is scope protection. | "Not building: manager override, multi-hospital scheduling, integration with legacy HR system, shift marketplace." |
| **Build Duration Estimate** *(optional)* | How long will the build phase take? Not for project management — for calibrating the observation window. | "~3 days. Observation starts next week." If the build takes 1 hour, observation starts this afternoon. If 1 week, observation starts next week. |

### Why Non-Goals Matter

Non-goals are the most undervalued field. Without them, scope creeps silently: "While we're at it, could we also add manager override? It's just one more button." Non-goals give the PM a pre-written "no": *"Manager override is explicitly a non-goal for this cycle. If you'd like to pursue it, let's create a separate bet and run intake ([Chapter 4](05-intake.md))."*

---

## From Discovery Brief to SPEC-Lite

The transition from Discovery to Outcome is a conceptual shift:

| Discovery Brief | → | SPEC-Lite |
|----------------|---|-----------|
| "We believe nurses have a scheduling problem" | → | "Nurses have a scheduling problem. Here's the solution we'll build." |
| Hypothesis (might be wrong) | → | Scope (we're committing resources) |
| Experiment design | → | Build plan (via Build Contract, [Ch 9](10-build-contract.md)) |
| Kill condition (for learning) | → | Kill condition (for shipping) |
| Success signal (validation) | → | Target metric (outcome) |

The Discovery Brief FEEDS the SPEC-Lite. The validated problem becomes the Problem field. The experiment learnings inform the Scope. The kill condition shifts from "stop learning" to "stop building."

> **Confidence Markers on SPEC References (Meeting #14)**: When the SPEC-Lite's Problem field references Discovery evidence or research, carry the confidence markers forward. A Problem statement grounded in `[verified]` evidence from primary sources is strong. A Problem statement referencing `[VERIFY]`-tagged claims from tertiary sources is weak — and should be flagged at Gate O2. The SPEC inherits the rigor (or weakness) of the research that produced it. See [Chapter 5](06-discovery-brief.md) for the full Research Output Standards.

---

## Writing Kill Conditions That Work

Bad kill conditions are either too vague to act on or too generous to ever trigger:

**Too vague**: "If users don't like it." → How do you measure "like"? This will never trigger a kill.

**Too generous**: "If zero users adopt." → Zero users is such an extreme threshold that by the time it triggers, you've wasted months.

**Just right**: "If fewer than 30% of nurses at Hospital X use shift-swap within 2 weeks of launch, kill." → Specific user group, specific feature, specific metric, specific timeframe.

### Kill Condition Calibration

Setting the right threshold is a skill that improves over time. Four calibration methods:

1. **Baseline-relative**: "X% improvement over current state." Works when you have existing data. "Scheduling time is 45 min. Kill if it doesn't drop by at least 30%."
2. **Minimum viable signal**: "At least N users do Y." Works for new products with no baseline. "If fewer than 5 of 20 beta users enable the feature, kill."
3. **Industry benchmark**: "Our conversion rate should be within Z% of industry average." Works for established markets with known benchmarks.
4. **Compliance-driven**: "The system must meet regulatory threshold X." Not chosen — mandated. Kill is automatic if compliance isn't met.

**Common calibration mistakes:**
- **Too strict**: Kill condition triggers on everything. The team learns nothing because every bet dies after 3 days. Loosen thresholds and lengthen evaluation windows.
- **Too generous**: Kill condition never triggers. The team builds zombie features because the bar is impossibly low ("if literally zero users sign up"). Tighten thresholds.
- **Too vague**: "If users don't like it." Not measurable. Rewrite with specific metrics.
- **Too narrow**: "Exactly 47 users must sign up by Tuesday." Overly specific. Use ranges and reasonable timeframes.

**Your first kill conditions will be wrong.** That's expected. Calibrate after 3 cycles: did the condition trigger when it SHOULD have? Did it miss a project that should have been killed? Over time, the team's threshold-setting improves.

### The Kill Condition Formula

> **"If [metric] doesn't reach [threshold] within [timeframe] after [trigger event], kill."**

Examples:
- "If DAU < 100 within 14 days of launch, kill."
- "If conversion rate < 3% within 1 week of A/B test start, kill."
- "If zero downstream teams integrate within 4 weeks of API availability, kill." (platform)
- "If field pilot unit failure rate > 10% within 30 days of deployment, kill." (hardware)
- "If client NPS for the new feature < 7 within 2 weeks of demo, kill." (agency)

---

## Gate O1: Is the Bet Worth Pursuing?

Before writing a SPEC-Lite, Gate O1 validates the bet itself:

### O1 Checklist
- [ ] **Discovery evidence exists.** The problem is validated, not assumed. (Exception: the problem is well-understood from prior experience or industry knowledge — document the evidence source.)
- [ ] **The bet traces on the spine.** Vision → Strategy → Bet → this cycle.
- [ ] **WIP capacity exists.** The team can take this on without exceeding WIP limits ([Chapter 12](13-wip-limits.md)).
- [ ] **The approach is defined.** You know enough about the solution direction to scope it (not detailed design — just direction).
- [ ] **Stakeholder alignment.** The people who need to support this (leadership, client, partner) are aware and aligned.

## Gate O2: Is the SPEC Ready for a Build Contract?

After writing the SPEC-Lite, Gate O2 validates its quality:

### O2 Checklist
- [ ] **Problem references evidence.** Not "we think users want this" but "Discovery experiment X showed Y."
- [ ] **Scope is bounded.** Clear boundaries. Non-goals are explicit.
- [ ] **Target metric is measurable.** The team can instrument and measure it before building.
- [ ] **Kill condition is pre-committed.** Specific threshold, specific timeframe. Written before emotional attachment.
- [ ] **Non-goals are documented.** At least 3 explicit non-goals that protect scope.
- [ ] **The SPEC fits on one page.** If it's longer, you're over-specifying. Save details for the Build Contract.

---

### Sidebars

**Agency**: The SPEC-Lite doubles as your client-facing scope document. "Here's what we're building (Scope), here's what we're NOT building (Non-Goals), here's how we'll measure success (Target Metric), and here's when we'll stop if it's not working (Kill Condition)." Clients love the clarity. It replaces the ambiguous SOW with a precise, one-page agreement. Price the Outcome cycle based on scope — the SPEC-Lite is the basis for the quote.

**Enterprise**: SPEC-Lite vs. BRD. A Business Requirements Document (BRD) tries to capture everything upfront. A SPEC-Lite captures the MINIMUM needed to start building and measuring. The BRD is a promise of completeness. The SPEC-Lite is a promise of focus. If your organization requires BRDs, treat the SPEC-Lite as the "executive summary" that drives the actual work, and the BRD as the compliance artifact.

**Hardware**: For physical products, the SPEC-Lite Scope should specify whether this cycle produces a functional prototype, a field pilot, or a manufacturing run. Each has radically different cost and timeline implications. The kill condition should account for hardware lead times: "If pre-orders don't reach 500 units within 30 days of announcement, kill the manufacturing run."

---

*Next: [Chapter 9 — The Build Contract →](10-build-contract.md)*

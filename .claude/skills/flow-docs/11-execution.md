> Part IV: Outcome Mode | [← Previous](10-build-contract.md) | [Next →](12-outcome-decisions.md)

# Chapter 10: Execution & Observability

> *Panel-reviewed: Meeting #5 (2026-03-19), updated Meeting #13 (agentic observability timing, Agent-as-Analyst)*
> **Read this**: Everyone involved in an active Outcome cycle.

---

## Cycle Progress Signal

Before diving into execution details, every active cycle should have a visible **progress signal** — three states that show where the team is:

| State | Meaning | Signal |
|-------|---------|--------|
| **Uphill** | Still figuring out the approach. Major unknowns remain. | Early in the cycle. Design decisions being made. Technical spikes in progress. |
| **Peak** | Approach is clear. Major unknowns resolved. Team knows what to build and how. | Architecture decided. Core functionality taking shape. Risks identified. |
| **Downhill** | Executing on a known path toward the kill condition evaluation. | Building, polishing, instrumenting. The question shifts from "what?" to "when?" |

The team updates this at each ritual (weekly or per cycle review). It's a one-word status, not a percentage.

**Why it matters**: If the team is Downhill and the target metric hasn't moved, that's a stronger kill signal than if they're still Uphill. Progress state adds context to metric interpretation.

---

## How Daily Work Happens in FLOW

FLOW doesn't dictate how your team works day-to-day. It provides the decision framework (mode, spine, gates) and the planning artifacts (Brief, SPEC, Contract). Within a cycle, your team uses whatever execution approach works:

- Kanban board with WIP limits? Fine.
- Scrum sprints within the cycle? Fine.
- Pair programming? Fine.
- Shape Up-style hill charts? Fine.
- No formal process, just a Slack channel and a shared doc? Fine for small teams.

The cycle is the FLOW unit. Inside it, you're executing. The Build Contract ([Chapter 9](10-build-contract.md)) defines what you're building and how you'll measure it. Now build it.

---

## Observability-First

The single most important principle of Outcome execution: **instrument before you build.**

Most teams build the feature, ship it, then ask "how do we know if it's working?" By then it's too late — you've already shipped without measurement, and the Kill/Merge decision ([Chapter 11](12-outcome-decisions.md)) becomes guesswork instead of evidence.

### The Observability Sequence

1. **Before coding begins**: Set up the dashboard. Define the metrics from the Build Contract's observability plan. Create empty charts that will fill with data once the feature ships.

2. **During development**: Instrument as you build. Every user action that matters gets a tracking event. Don't instrument everything — instrument what the kill condition and target metric need.

3. **Before rollout**: Verify the dashboard shows real data from staging/testing. The dashboard should be live BEFORE the first real user touches the feature.

4. **After rollout**: The dashboard is the source of truth for Kill/Merge decisions. If it's empty or broken, Gate O4 hasn't passed — stop the cycle and fix observability first.

### Observability Timing for Agentic Builds

When the build phase is hours, observability setup must happen **BEFORE or DURING** the build, not after. An agent can instrument as it builds — make this an explicit instruction in the Build Contract. The traditional sequence (build → instrument → deploy) collapses into a single pass: the agent writes the feature code and the observability code simultaneously. If your Build Contract specifies an observability plan, the agent should treat instrumentation as part of the build definition of done, not a follow-up task.

### Agent-as-Analyst

Agents can process observation data and surface patterns — compile dashboards, flag anomalies, prepare Kill/Merge evidence packages. The human interprets; the agent compiles. This division is important: pattern detection scales with compute, but judgment about what the patterns MEAN requires human context. Use agents to ensure no signal is missed; use humans to decide what signals matter.

---

## What to Track During a Cycle

### Tier 1: Required (Kill/Merge depends on these)

| Metric Type | Example | Why | Who Owns |
|------------|---------|-----|----------|
| **Target metric** (from SPEC-Lite) | "Scheduling time per shift" | THE metric that determines Kill or Merge | **Data Analyst** interprets; **DevOps** instruments |
| **Adoption** | "% of nurses who used shift-swap this week" | No adoption = feature is invisible, metric won't move | **Data Analyst** monitors |
| **Kill condition trigger** | "Has scheduling time decreased by 30%?" | Direct input to the Kill/Merge decision | **Data Analyst** evaluates and presents at Kill/Merge |

### Tier 2: Important (Helps understand WHY the metric moved or didn't)

| Metric Type | Example | Why |
|------------|---------|-----|
| **Funnel completion** | "% who started a swap and completed it" | Identifies where users drop off |
| **Error rate** | "API errors per 100 requests" | A broken feature can't be evaluated on outcomes |
| **Performance** | "Swap request latency p95" | Slow features don't get used |

### Tier 3: Nice-to-Have (For learning, not for Kill/Merge)

| Metric Type | Example | Why |
|------------|---------|-----|
| **User feedback** | "NPS for shift-swap feature" | Qualitative signal |
| **Support tickets** | "Tickets mentioning scheduling" | Trend indicator |
| **Engagement depth** | "Average swaps per nurse per week" | Usage pattern |

Don't over-instrument. Tier 1 is mandatory. Tier 2 is recommended. Tier 3 is for teams with bandwidth.

---

## When to Raise a Flag Mid-Cycle

Not everything waits for the Kill/Merge meeting. Some signals require immediate attention:

**Raise a flag when:**
- The target metric is moving in the WRONG direction (scheduling time is increasing, not decreasing)
- Error rates exceed acceptable thresholds (the feature is broken, not just unused)
- A critical dependency fails (the platform team's API isn't available as promised)
- Scope is creeping beyond the SPEC-Lite boundaries ("Can we also add manager override?")
- The team discovers something that changes the fundamental assumption ("Nurses don't have smartphones")

**Don't raise a flag when:**
- The metric hasn't moved YET but the feature just launched (give it the timeframe from the kill condition)
- Adoption is slow but growing (the kill condition has a threshold — wait for it)
- Someone has an opinion that it's not working (opinions aren't evidence)

### Flag Protocol

1. The person who sees the signal raises it to the PM.
2. The PM evaluates: is this a scope issue, a quality issue, or a fundamental assumption failure?
3. If scope: refer to Non-Goals. "That's out of scope for this cycle."
4. If quality: engineering addresses the bug/performance issue.
5. If fundamental assumption: call an early Kill/Merge review. Don't wait for the scheduled meeting.

---

## Gate O4: Is Observability in Place?

Gate O4 is checked BEFORE the measurement period begins (not before coding — before you start EVALUATING):

### O4 Checklist
- [ ] **Target metric is instrumented.** The dashboard shows real data for the metric from the SPEC-Lite.
- [ ] **Adoption metric is instrumented.** You can see how many users are using the feature.
- [ ] **Dashboard is live.** Not "we'll set it up next week." Live. With data.
- [ ] **Kill condition is evaluable.** Given the dashboard, you can determine whether the kill condition has been triggered.
- [ ] **The team knows where to look.** Everyone — PM, engineering, design — knows the dashboard URL and how to read it.

If O4 fails, the cycle doesn't proceed to its measurement period. Fix observability first. A feature that ships without measurement is a feature that can never be properly evaluated for Kill/Merge.

---

### Sidebars

**Hardware**: Execution on 12-week cycles. Hardware cycles are longer than software because manufacturing takes time. The observability equivalent is field telemetry — sensors reporting performance, failure rates, and usage patterns from deployed units. For products without connectivity (e.g., off-grid solar in rural areas), observability means scheduled field visits to collect data. Budget this into the cycle timeline. Gate O4 for hardware: "Is the field data collection plan in place? Are sensors/logging configured? Is the field team scheduled?"

**Enterprise**: Observability in legacy systems. Older systems may not support modern instrumentation. The Build Contract should specify HOW observability will be achieved — even if it's manual (weekly database queries, log analysis, user surveys). Gate O4 doesn't require automated dashboards — it requires SOME mechanism to evaluate the kill condition.

**Solo**: Your observability might be checking Stripe revenue and Mixpanel events every morning with coffee. That counts. Gate O4 for you: "Can I answer 'is this working?' in under 5 minutes tomorrow morning?"

---

*Next: [Chapter 11 — Outcome Decisions & Gates →](12-outcome-decisions.md)*

# FLOW SPEC-Lite — One-Page Plan for What to Build

> **Trigger**: Work is classified as Outcome (via `/flow-intake`), or Discovery has validated the problem and it's time to define what to build.
> **Reference**: Chapter 8 (SPEC-Lite), Chapter 9 (Build Contract), Chapter 4 (Intake)

## Evaluation Behavioral Rules

These rules override default LLM behavior during all evaluative interactions in this skill:

1. **No affirmative openers.** Never start with "Great!", "You're right!", "Amazing!", "Good thinking!" or similar. Start with substance.
2. **Challenge-first.** Before any positive assessment, identify and state the weakest point in the user's reasoning: "Here's what concerns me about this..."
3. **Your job is to protect the user from their own confirmation bias.** If the evidence is weak, say so directly. If the hypothesis is vague, push for specificity. If the kill condition has a loophole, name it.
4. **Earn praise.** Positive feedback is reserved for genuine rigor — a well-calibrated kill condition, a truly falsifiable hypothesis, evidence that actually supports the claim. Generic encouragement is prohibited.
5. **Tone calibration:**
   - Process compliance (showing up, filling templates): Warm, encouraging
   - Reasoning quality (logic, evidence, assumptions): Neutral, interrogative
   - Gate decisions (pass/fail/kill): Cold, evidence-only
   - Learning capture (retrospectives, archive): Warm, reflective

## What This Skill Does

Guides you through writing a SPEC-Lite — the one-page planning artifact for Outcome mode. It defines what you're building, why, how you'll measure it, and when you'll stop.

> **Coaching note for newcomers**: A SPEC-Lite is NOT a PRD (those are 20-page monuments to uncertainty), a Jira epic (that's execution tracking), or a business case (that lives on the spine). It IS a one-page contract between PM, team, and stakeholders. One page. If it's longer, you're over-specifying — save details for the Build Contract (Ch 9).

## SPEC Spectrum — Choose Your Level

Not all work needs the same planning depth. Choose the SPEC level based on cycle duration and risk:

| SPEC Level | When to Use | Fields | Typical Cycle |
|------------|-------------|--------|---------------|
| **Micro-SPEC** | Build cost near-zero, high-tempo teams, cycle < 1 day | Problem, Hypothesis, Kill Condition (3 lines) | Hours to 1 day |
| **Full SPEC-Lite** | Larger scope, multi-person teams, regulated environments | All fields below (one page) | Days to weeks |

> **Coaching note**: Micro-SPEC is for teams where building IS the experiment — when it's faster to ship and measure than to write a full spec. The kill condition is still NON-NEGOTIABLE at every level. No kill condition = no SPEC at any size.

### Micro-SPEC Template

For high-tempo / agentic teams where build cost approaches zero:

```markdown
## Micro-SPEC — [Title]
**Date**: YYYY-MM-DD
**Build duration estimate**: [hours]

**Problem**: [What validated problem, one line]
**Hypothesis**: [What we believe will happen if we build this]
**Kill Condition**: "If [metric] doesn't reach [threshold] within [timeframe] after [trigger], kill."
```

If the Micro-SPEC passes Gate O2 (adapted: problem has evidence, hypothesis is falsifiable, kill condition is pre-committed), proceed directly to build. No Build Contract needed for Micro-SPECs.

## Step 1 — Check for Discovery Evidence

Ask: "Has this problem been validated through Discovery, or is it well-understood from prior experience?"

- If Discovery was run → reference the validated hypothesis and experiment results
- If prior experience → document the evidence source explicitly
- If neither → **STOP**. Route to `/flow-brief` first. Don't build without evidence.

The transition from Discovery to Outcome:

| Discovery Brief | → | SPEC-Lite |
|----------------|---|-----------|
| "We believe nurses have a scheduling problem" | → | "Nurses have a scheduling problem. Here's what we'll build." |
| Hypothesis (might be wrong) | → | Scope (we're committing resources) |
| Kill condition (for learning) | → | Kill condition (for shipping) |

## Step 2 — Guide Through Each Field

### Field 1: Problem (with evidence reference)

> What validated problem are we solving? Reference the evidence.

Not "we think users want this" but "Discovery experiment showed 4 of 5 nurses confirmed scheduling as a top-3 pain point."

Ask: "What specific, validated problem are you solving? Where's the evidence?"

### Field 2: Scope

> What specifically are we building? Be concrete, bounded, implementable.

The scope must have clear edges. If you can't draw a box around it, it's not shaped enough.

Ask: "In one paragraph, what exactly will you build? Be concrete enough that an engineer could start planning."

### Field 3: Target Metric

> How will we measure success? One primary metric.

One number. Not three, not a dashboard — one primary metric the team rallies around. Secondary metrics are fine for monitoring but the kill decision uses the primary.

Ask: "What single metric will tell you this worked? How will you measure it?"

### Field 4: Build Duration Estimate

> How long will the build phase take?

Ask: "How long do you estimate the build will take? (hours, days, weeks)"

This estimate determines the SPEC level (Micro-SPEC vs Full SPEC-Lite) and informs the observation window for the kill condition. Record it in the SPEC.

### Field 5: Kill Condition

> When do we stop? Pre-committed, evidence-based.

This is where FLOW earns its value. Teach the kill condition formula:

> **"If [metric] doesn't reach [threshold] within [timeframe] after [trigger event], kill."**

### Kill Condition Timeframe — Metric Maturity Table

The observation window in your kill condition must match how fast the metric can produce a reliable signal:

| Metric Type | Minimum Observation Window | Notes |
|-------------|---------------------------|-------|
| Click-through | Hours | Fast signal, high volume needed |
| Activation | Days | First-use behavior, measurable quickly |
| Retention D7 | 1 week | By definition requires 7 days |
| Revenue | 2-4 weeks | Purchase cycles vary by product |
| NPS | 4-8 weeks | Requires sustained usage before meaningful |

> **Coaching note**: Setting a kill condition timeframe shorter than the metric's observation window guarantees a false negative. If you're measuring retention, you CANNOT kill after 3 days. Match the timeframe to the metric, not to your impatience.

**Kill conditions are NON-NEGOTIABLE at every SPEC level** — Micro-SPEC or Full SPEC-Lite. A SPEC without a kill condition is not a SPEC.

### Kill Condition Calibration (4 methods)

Guide the user through the right calibration method:

1. **Baseline-relative**: "X% improvement over current state." Best when you have existing data.
   - Example: "Scheduling time is 45 min. Kill if it doesn't drop by at least 30%."

2. **Minimum viable signal**: "At least N users do Y." Best for new products with no baseline.
   - Example: "If fewer than 5 of 20 beta users enable the feature, kill."

3. **Industry benchmark**: "Within Z% of industry average." Best for established markets.
   - Example: "If conversion rate stays below 2% (industry avg is 3.5%), kill."

4. **Compliance-driven**: "Must meet regulatory threshold X." Not chosen — mandated.
   - Example: "If the system can't process 99.9% of transactions within SLA, kill."

> **Coaching note**: Common mistakes — too strict (everything dies after 3 days), too generous (nothing ever triggers — "if literally zero users sign up"), too vague ("if users don't like it"), too narrow ("exactly 47 users by Tuesday"). Your first kill conditions will be wrong. Calibrate after 3 cycles.

### Field 6: Non-Goals

> What are we explicitly NOT doing? This is your scope protection.

**This skill will not proceed without at least 3 non-goals.** Non-goals are the most undervalued field. Without them, scope creeps silently.

Ask: "Name at least 3 things someone might reasonably expect to be included but that are explicitly OUT of scope."

> **Coaching note**: Non-goals give you a pre-written "no." When someone says "while we're at it, could we also add X?" you respond: "X is explicitly a non-goal for this cycle. If you'd like to pursue it, let's create a separate bet and run intake." This is professional scope management, not obstruction.

## Step 3 — Assemble the SPEC-Lite

```markdown
## SPEC-Lite — [Title]
**Date**: YYYY-MM-DD
**Author**: [Name]
**Spine trace**: [Vision → Strategy → Bet]
**Discovery reference**: [Link to Brief or evidence source]
**Build duration estimate**: [hours/days/weeks]

### Problem
[Validated problem with evidence reference]

### Scope
[What we're building — concrete, bounded]

### Target Metric
[One primary metric with measurement method]

### Kill Condition
"If [metric] doesn't reach [threshold] within [timeframe] after [trigger], kill."

### Non-Goals
1. NOT: [Thing 1]
2. NOT: [Thing 2]
3. NOT: [Thing 3]
```

### Update Cycle State

Create or update `.flow/active-cycle.json`:
- `mode`: "outcome" (or "collapsed" if Micro-SPEC)
- `phase`: "build" (contract not yet written)
- `next_step`: `{ "action": "Write Build Contract", "skill": "/flow-contract" }` (or `{ "action": "Start building", "skill": null }` for Micro-SPEC)
- `kill_condition`: from the SPEC
- `target_metric`: from the SPEC
- `completed_steps`: add "SPEC-Lite written"

## Step 4 — Run Gates O1 and O2

### Gate O1: Is the Bet Worth Pursuing?

- [ ] Discovery evidence exists (problem validated, not assumed)
- [ ] The bet traces on the spine (Vision → Strategy → Bet → this cycle)
- [ ] WIP capacity exists (team can take this on — check Ch 12 limits)
- [ ] The approach is defined (solution direction is clear, not detailed design)
- [ ] Stakeholder alignment (people who need to support this are aware)

### Gate O2: Is the SPEC Ready for a Build Contract?

- [ ] Problem references evidence (not "we think users want this")
- [ ] Scope is bounded (clear boundaries, concrete deliverable)
- [ ] Target metric is measurable (can be instrumented before building)
- [ ] Kill condition is pre-committed (specific threshold + timeframe)
- [ ] Non-goals are documented (at least 3 explicit non-goals)
- [ ] The SPEC fits on one page (if longer, you're over-specifying)

If any item fails, provide specific guidance on how to fix it.

## Step 5 — Chain to Next Skill

> "SPEC-Lite passes O1 and O2. Ready for the Build Contract — the PM writes the SPEC, engineering writes the Contract, then you agree. See Chapter 9 (Build Contract) for the template."

## Client Mode (Agency)

When producing a client-facing scope document, the SPEC-Lite doubles as the SOW:

> "Here's what we're building (Scope), here's what we're NOT building (Non-Goals), here's how we'll measure success (Target Metric), and here's when we'll stop if it's not working (Kill Condition)."

Clients love the clarity. Price the Outcome cycle based on the SPEC-Lite scope.

## Enterprise Sidebar

> **SPEC-Lite vs. BRD**: If your organization requires Business Requirements Documents, treat the SPEC-Lite as the "executive summary" that drives actual work, and the BRD as the compliance artifact. The SPEC-Lite is a promise of focus; the BRD is a promise of completeness. They serve different purposes.

## Hardware Sidebar

> **Hardware SPEC-Lite scope** should specify whether this cycle produces a functional prototype, a field pilot, or a manufacturing run. Each has radically different cost and timeline implications. Kill conditions should account for lead times: "If pre-orders don't reach 500 units within 30 days of announcement, kill the manufacturing run."

---

## Transition Marker

At the end of every skill execution, output this block so the user knows where they are:

```
───── FLOW ─────
✓ Completed: [what was just done — e.g., "Discovery Brief written and D1 passed"]
⟡ Cycle: [cycle name from active-cycle.json, or "No active cycle"] | Phase: [build/observe/decide]
→ Next step: [specific action — e.g., "Design experiment with /flow-experiment"]
────────────────
```

This marker serves as a visual anchor. When the user sees Claude responding WITHOUT this block, they know they are outside FLOW methodology guidance.

## Manual Mode Checklist

If writing a SPEC-Lite without this skill:

- [ ] Verify Discovery evidence exists (or document prior experience)
- [ ] Write Problem with explicit evidence reference
- [ ] Write Scope with clear boundaries (concrete, bounded, implementable)
- [ ] Define one primary Target Metric with measurement method
- [ ] Write Kill Condition using the formula and one of 4 calibration methods
- [ ] Document at least 3 Non-Goals (scope protection)
- [ ] Verify it fits on one page
- [ ] Run Gate O1 (is the bet worth pursuing?)
- [ ] Run Gate O2 (is the SPEC ready for a Build Contract?)
- [ ] If both pass → proceed to Build Contract (Ch 9)
- [ ] If either fails → revise and re-check

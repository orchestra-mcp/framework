# FLOW Intake — Classify and Route Incoming Work

> **Trigger**: New work arrives — an idea, stakeholder request, customer complaint, market signal, technical debt item, or regulatory requirement.
> **Reference**: Chapter 4 (Intake, Classification & Shaping), Chapter 3 (Decision Spine)

## What This Skill Does

Takes a raw request and runs it through the FLOW intake pipeline:
```
Request → Shaping → Classification → Routing → Cycle
```

## Step 1 — Capture the Raw Request

Ask the user to describe the request in plain language. Capture:
- **What**: What is being asked for?
- **Who asked**: Where did this come from? (user, stakeholder, team, market signal)
- **Why now**: What triggered this?

> **Coaching note for newcomers**: Intake is the quality filter that prevents teams from receiving vague, unbounded work. Every piece of work passes through this pipeline — whether it takes 5 minutes (solo founder) or 5 days (enterprise review). The steps are the same; the formality scales.

## Step 2 — Shape It

Shaping answers three questions (done by PM, Tech Lead, or founder — someone with strategic context):

1. **What's the boundary?** What's in scope? What's explicitly NOT in scope?
2. **Where's the risk?** What could go wrong? What's the biggest unknown?
3. **What mode does this need?** Is the primary risk building the wrong thing (Discovery) or failing to ship (Outcome)?

Help the user articulate boundaries. Show the difference:

| Unshaped | Shaped |
|----------|--------|
| "We need a loyalty program" | "We believe repeat customers will increase 15% with a points system at checkout. Out of scope: tiered rewards, partner integrations. Key risk: will users notice?" |

> **Coaching note**: Shaping is NOT solution design, estimation, or a committee activity. One or two people shape; the team executes. In agencies, shaping workshops are billable ($2K-5K for a half-day producing 3-5 shaped bets).

## Step 3 — Classify

Apply the mode decision from Chapter 2:

> "Is the primary risk that we build the wrong thing, or that we fail to ship the right thing?"

Use these classification questions:
1. Do we have evidence that users want this? (No → Discovery)
2. Have we tested the approach before? (No → Discovery)
3. Can we define a target metric right now? (No → Discovery)
4. Is the main risk execution, not direction? (Yes → Outcome)
5. Has someone shaped this with clear boundaries? (No → back to shaping)

**Three classifications:**
- **Discovery** — We don't know if the problem is real or the solution is right → Write a Discovery Brief
- **Outcome** — Evidence exists, problem is validated, approach is defined → Write a SPEC-Lite (or Micro-SPEC for quick experiments)
- **Operational** — Incident, bug, maintenance → Bypass the spine. Track separately. If operational work exceeds 20% of capacity, that's a signal worth investigating as a bet.

### Collapsed Mode — When Build IS the Experiment

When execution leverage is high (agentic teams, low-code, rapid prototyping) and build cost approaches zero, the Discovery/Outcome boundary collapses:

> "If it's cheaper to build and measure than to design an experiment about building, then building IS the experiment."

In Collapsed Mode:
- Discovery and Outcome merge into a single cycle
- Use a **Micro-SPEC** (Problem, Hypothesis, Kill Condition — 3 lines) as the planning artifact
- The "experiment" is shipping the feature to real users and measuring
- Kill conditions and observation windows still apply — speed doesn't remove the need for evidence
- Route here when build cost is under ~1 day AND the metric has a fast observation window (hours to days)

**Execution Leverage as a Routing Factor**: When classifying, also ask: "How expensive is it to just build this?" If the answer is "a few hours with an agent," consider Collapsed Mode instead of a separate Discovery phase. The classification questions still apply — but the routing changes.

> **WARNING — Political Awareness (Ch 19)**: If a senior stakeholder's request is being classified as Discovery, frame it diplomatically. Don't say "your idea needs validation." Say: "I'd recommend a 2-week experiment to validate [hypothesis]. The earliest start date given our current WIP is [date]. If the experiment validates, we move to Outcome immediately." That's not rejection — it's professional intake.

## Step 4 — Check Spine Trace

Every non-operational cycle must trace to the Decision Spine (Ch 3):

```
Vision → Strategy → Bet → This Cycle
```

Ask: "Which bet does this trace to?" If it doesn't trace:
- Can we create a new bet under an existing strategy? → Do it
- No strategy fit? → Either off-strategy (reject) or signals a strategy gap (escalate)

> **Coaching note**: The spine is a spectrum of formality. Solo founders keep it mental. Enterprise teams document it formally. Agencies have split spines — the client owns Vision/Strategy, you own Bet/Cycle. The principle is the same: can you explain WHY this work matters in terms of strategy?

## Step 5 — Check WIP Capacity

Before routing, check current WIP against limits (Ch 12):

| Team Size | Discovery WIP | Outcome WIP | Total |
|-----------|--------------|-------------|-------|
| Solo (1) | 1 | 1 | 1-2 |
| Small (3-8) | 1-2 | 1-2 | 2-3 |
| Medium (10-20) | 2-3 | 2-3 | 4-5 |
| Large (25+) | 3-4 | 3-5 | 6-8 |

If at capacity: "You want to start this? What are you willing to stop?" Force the trade-off.

## Step 6 — Route

Assign to the right team and produce an **Intake Record**:

```markdown
## Intake Record — [Date]
**Request**: [One-line summary]
**Source**: [Who asked, why now]
**Classification**: Discovery / Outcome / Operational
**Spine trace**: [Vision → Strategy → Bet]
**Routed to**: [Team/person]
**Next artifact**: Discovery Brief / SPEC-Lite / Ops ticket
**WIP check**: [Current/Limit] — PASS/FAIL
```

File this in the appropriate `tracks/*/tasks.md`.

## Step 7 — Chain to Next Skill

Based on classification:
- **Discovery** → "Ready to write the Discovery Brief? Run `/flow-brief`"
- **Outcome** → "Ready to write the SPEC-Lite? Run `/flow-spec`"
- **Collapsed Mode** → "Build cost is near-zero — write a Micro-SPEC and ship. Run `/flow-spec` (Micro-SPEC path)"
- **Operational** → Track separately, no further FLOW skills needed

## Variant Notes

| Context | Intake Adaptation |
|---------|-------------------|
| **Agentic/High-Tempo** | Collapsed Mode likely applies. Build IS the experiment. Use Micro-SPEC. Intake takes minutes, not hours. |
| **Solo** | Intake is your thinking before coding. Classification happens in your head. 5 minutes. |
| **Agency** | Client intake is relationship management (billable). Internal intake is classification. Separate the two. |
| **Enterprise** | Weekly 30-min Intake Review meeting. Multi-team routing needs a TPM to coordinate. |
| **Government** | Monthly programmatic intake + weekly project intake. Formal submission → review → approval. |
| **Hardware** | Classification has higher stakes — Discovery experiments cost thousands. Be thorough. |

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

If running intake without this skill:

- [ ] Capture the raw request (what, who asked, why now)
- [ ] Shape it (boundary, risk, mode)
- [ ] Classify: Discovery / Outcome / Collapsed Mode / Operational
- [ ] Check execution leverage — is build cost near-zero? Consider Collapsed Mode
- [ ] Check spine trace — does it connect to an active bet?
- [ ] Check WIP limits before accepting
- [ ] Route to the right team/person
- [ ] Produce an intake record
- [ ] If Discovery → write Discovery Brief (Ch 5)
- [ ] If Outcome → write SPEC-Lite (Ch 8)
- [ ] If senior stakeholder request classified as Discovery → frame diplomatically (Ch 19)

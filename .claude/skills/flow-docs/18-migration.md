> Part VI: Adoption | [← Previous](17-roles.md) | [Next →](19-organizational-change.md)

# Chapter 17: Migration to FLOW

> *Panel-reviewed: Meeting #7, updated Meeting #13 (2026-03-19)*
> *Updated: Meeting #14 — Maturity Model Progression, Evaluation Tone*
> **Read this**: PMs, Flow Coaches, team leads planning FLOW adoption. Find your starting framework.

---

## Starting Point Assessment

Before migrating, answer honestly: where is your team today?

| Question | Signal |
|----------|--------|
| Do you have a way to distinguish learning work from building work? | If no → you need modes ([Chapter 2](02-mental-model.md)) |
| Can you trace any piece of work to a strategic goal? | If no → you need the spine ([Chapter 3](03-decision-spine.md)) |
| Can your team say "no" to new requests with confidence? | If no → you need intake + admission control ([Chapter 4](05-intake.md)) |
| When was the last time you killed a feature or project? | If never → you need kill conditions |
| How many things are "in progress" right now? | If >5 per team → you need WIP limits ([Chapter 12](13-wip-limits.md)) |

---

## Migration by Starting Framework

### From Scrum
**What maps directly**: Sprint cadence → Outcome cycle cadence. Sprint Review → Outcome Review. Product Backlog → Intake queue.
**What changes**: Add mode classification — not everything is a user story. Discovery work gets a Discovery Brief, not a PBI. Sprint goals now include kill conditions. Velocity tracking is replaced by target metric tracking.
**What's new**: Discovery mode, kill conditions, the Decision Spine, shaping.
**Migration path**: Keep running sprints. Start by adding mode classification to refinement. After at least 2 cycles with classification, write your first Discovery Brief for an uncertain item. After 2 more cycles with Briefs, add kill conditions to sprint goals. After 2 cycles with kill conditions, run your first Kill/Merge meeting. Most teams complete this in 8-16 weeks, but the milestone is cycle count, not calendar time.

### From SAFe
**What maps directly**: PI Planning → spine alignment. WSJF → intake classification. ARTs → team topology.
**What changes**: Add team-level Discovery mode (SAFe's "Explore" state is portfolio-level — bring it down). Replace WSJF deprioritization with pre-committed kill conditions that actually stop work.
**What's new**: Discovery Briefs, kill conditions at team level, Build Contracts, simplified gate structure.
**Migration path**: At your next PI Planning, classify each feature as Discovery or Outcome. Pilot FLOW's artifacts with one squad for one PI. Complete at least 3 full cycles with FLOW artifacts before expanding to other squads. Most teams complete this in 8-16 weeks, but the milestone is cycle count, not calendar time.

### From Shape Up
**What maps directly**: Shaping → FLOW shaping ([Chapter 4](05-intake.md)). Betting table → spine check. 6-week cycles → Outcome cycles (flex the length).
**What changes**: Make shaping a team activity, not senior-only. Add evidence-based kill conditions alongside appetite (whichever triggers first). Add formal Discovery mode for uncertain work.
**What's new**: Discovery Briefs (shaping produced bets — FLOW adds hypothesis testing), Gate structure, Build Contract, Learning Archive.
**Migration path**: In your next cycle, add a kill condition to each pitch. After at least 2 cycles with kill conditions, run a Discovery cycle for the next uncertain pitch instead of shaping and betting directly. Most teams complete this in 8-16 weeks, but the milestone is cycle count, not calendar time.

### From Waterfall / PRINCE2
**What maps directly**: Stage gates → FLOW gates. Feasibility study → Discovery mode. SOW → Build Contract. Change Control Board → Kill/Merge + intake authority.
**What changes**: Introduce shorter cycles WITHIN your existing stages. Instead of one long feasibility → build → test sequence, run multiple Discovery and Outcome cycles within each stage.
**What's new**: Mode classification, kill conditions, experiment hierarchy, WIP limits.
**Migration path**: In your next project stage, run one Discovery cycle (2-4 weeks) instead of a 3-month feasibility study. Use the Discovery Brief format. Complete at least 2 Discovery cycles before expanding FLOW to Outcome phases. Most teams complete this in 8-16 weeks, but the milestone is cycle count, not calendar time.

### From Kanban
**What maps directly**: Flow-based execution stays. Board stays. WIP limits (you already have these!).
**What changes**: Add mode classification to your board ("Discovery" and "Outcome" columns or tags). Add kill conditions to cards. Add spine mapping ("why is this card on the board?").
**What's new**: Discovery Briefs, SPEC-Lites, gates, Kill/Merge ritual.
**Migration path**: Add a "Mode" tag to your board. After at least 2 cycles with mode tagging, write a Discovery Brief for the most uncertain card. After 2 more cycles with Briefs, run your first Kill/Merge review. Most teams complete this in 8-16 weeks, but the milestone is cycle count, not calendar time.

### From Nothing (No Methodology)
**What maps directly**: Your intuition maps to FLOW's informal/mental mode. Your gut feeling about what to build? That's an implicit hypothesis. Your sense that something isn't working? That's an untriggered kill condition.
**What changes**: Make the implicit explicit. Write down your spine (vision, strategy, bet). Write a minimum Discovery Brief (3 fields) before starting. Set kill conditions before building.
**What's new**: Everything. But start small.
**Migration path**: First cycle — write your spine on a sticky note. Next cycle — write a minimum Brief for your next idea. Next cycle — set a kill condition. Next cycle — review: should you keep going or kill it? Complete at least 2 full build-observe-decide cycles before considering yourself "doing FLOW." Most teams complete this in 8-16 weeks, but the milestone is cycle count, not calendar time.

---

## Adoption Gates

Migration milestones are measured by cycle count and demonstrated understanding, not calendar time. A team must pass each gate before advancing to the next phase.

### Gate 1: Classification Fluency
**Cycle requirement**: Complete at least 3 cycles where all new work is explicitly classified as Discovery or Outcome.
**Understanding test**: Team can articulate why they classified work as Discovery vs Outcome. Ask any team member: "Why is this Discovery and not Outcome?" If they can't explain, they're labeling, not classifying.

### Gate 2: Kill Discipline
**Cycle requirement**: Complete at least 2 cycles with pre-committed kill conditions AND made at least one kill decision.
**Understanding test**: Team has made at least one kill decision and can explain the reasoning. Ask: "Walk me through your last kill. What triggered it? What did the 30-minute inspection reveal?" If they can't, they haven't internalized kill discipline.

### Gate 3: Rhythm Awareness
**Cycle requirement**: Complete at least 3 full build-observe-decide cycles at a consistent pace.
**Understanding test**: Team can describe their Tempo and how they determined it. Ask: "What's your cycle rhythm and why?" They should reference their observation requirements, coordination overhead, and execution leverage — not just "we picked two weeks."

### Gate 4: Full Integration
**Cycle requirement**: Complete at least 2 cycles using the full FLOW artifact set (Briefs, SPECs, Build Contracts, gates).
**Understanding test**: Team self-corrects when they slip into old patterns without coaching intervention.

### Maturity Model Progression (Meeting #14)

The four adoption gates map to the FLOW Maturity Model ([Chapter 2](02-mental-model.md)):

| Adoption Gate | Maturity Level | Enforcement |
|--------------|---------------|-------------|
| Gate 1 (Classification Fluency) | **L1 — Learning** | Advisory. Gates educate, don't block. |
| Gate 2 (Kill Discipline) | **L1 → L2 transition** | Kill conditions become enforced. |
| Gate 3 (Rhythm Awareness) | **L2 — Practicing** | Gates block. Ambient rules warn. Cycle state file active. |
| Gate 4 (Full Integration) | **L2 → L3 transition** | Full enforcement. Anti-sycophancy on evaluations. |
| Sustained (5+ cycles post-Gate 4) | **L3 — Fluent** | Structured gate interrogation. Self-correcting team. |

Teams declare their maturity level in the FLOW Configuration ([Chapter 14](14-rituals.md)). The level is self-assessed but should be validated by a Flow Coach or peer team. Claiming L3 while rubber-stamping all kill decisions is a form of Process Theater (Anti-Pattern #1, [Chapter 20](21-anti-patterns.md)).

### Evaluation Tone Calibration (Meeting #14)

As teams progress through maturity levels, the tone of evaluation shifts. This matters for coaches, agents, and anyone facilitating gates:

- **Process guidance** (how to write a better Brief, how to structure a kill condition): **warm tone**. Encouraging, educational, supportive. "Here's how to make this hypothesis more falsifiable."
- **Decision evaluation** (does this pass the gate? should this be killed?): **cold tone**. Objective, evidence-focused, unflinching. "This kill condition was triggered. The data supports termination."

Mixing these tones is dangerous. Warm tone on decisions leads to sycophancy — "This is a great effort, and the metrics are close, so let's continue." Cold tone on process leads to hostility — "This Brief is poorly written. Rejected." Calibrate deliberately.

> **Speed Adoption Warning**: Going through FLOW motions fast with agentic tools does not mean you have internalized the methodology. A team that runs 5 cycles in a day has not necessarily adopted FLOW — they may have just gone through the motions at speed. Adoption is measured by the quality of decisions made, not the quantity of cycles completed. If your kill decisions are all "continue," your Discovery Briefs are copy-paste, and your retrospectives surface no surprises — you are performing process theater at high speed. Slow down. Reflect on each cycle. Speed without judgment is waste at scale.

---

## Role Transformation — Cycle by Cycle

Changing methodology is one thing. Changing how people see their jobs is another. Here's a phased approach:

**Phase 1 — Awareness** (complete at least 1 cycle): Share [Chapter 16](17-roles.md) (Roles & Team Topology) with the team. Each person reads their "From → To" transformation. Facilitate a discussion: "What excites you? What scares you?" Address the fear head-on: nobody is being replaced. Expertise is being redirected.

**Phase 2 — First Practice** (complete at least 2 cycles): Each function practices their new role:
- QA defines a quality kill condition (instead of writing test cases)
- Data Analyst interprets one experiment result (instead of pulling numbers)
- Designer designs one experiment (instead of creating mockups for handoff)
- DevOps instruments one metric (instead of waiting for "ready to deploy")
- BA writes one Discovery Brief section (instead of a requirements doc)

**Phase 3 — Integration** (complete at least 3 cycles): The team runs complete cycles with everyone in their FLOW functions. The Flow Coach facilitates gates and enforces the "no handoffs" principle. Debrief after: "What worked? What was awkward? What do we need more practice on?"

**Phase 4 — Normalization** (ongoing): FLOW functions feel natural. The "From → To" table starts to feel like "old way vs. how we work now." The team self-corrects when they slip into old patterns ("Wait — we're doing a handoff. Let's collaborate instead.")

> Most teams complete Phases 1-3 in 8-16 weeks, but the milestone is cycle count and demonstrated understanding, not calendar time.

**Critical success factor**: Leadership must visibly support role transformation. If a QA engineer defines a quality kill condition and gets told "just write the test cases," the transformation dies. [Chapter 18](19-organizational-change.md) covers the organizational change management needed.

---

## Common Migration Failures

**1. Big Bang Adoption**: Trying to adopt all of FLOW at once. Start with ONE concept (modes, or kill conditions, or spine). Add the rest incrementally.

**2. Process Without Culture**: Adding FLOW artifacts without changing the culture around killing. If killing is punished, kill conditions are theater.

**3. Renaming Without Changing**: Calling your sprint a "cycle" and your backlog an "intake queue" without actually classifying work by mode or setting kill conditions.

**4. Pilot Without Support**: Running a FLOW pilot on one team without leadership awareness. When the pilot team kills a feature, leadership asks "why did you stop working?" Cover: [Chapter 18](19-organizational-change.md).

**5. All Discovery, No Outcome**: Teams fall in love with Discovery because learning feels safe and productive without shipping. If your team hasn't entered Outcome mode in 6 weeks, they're avoiding the hard part.

---

## The 30-Day Health Check

After 30 days of FLOW adoption, check:

- [ ] **Mode classification is happening.** New work is explicitly labeled Discovery or Outcome.
- [ ] **At least one Discovery Brief was written.** The team has tried structured learning.
- [ ] **At least one kill condition was set.** The team has pre-committed to stopping.
- [ ] **At least one kill was executed** (or the team has work they WOULD kill). Killing is normalized.
- [ ] **WIP is visible.** The team knows how many concurrent cycles they have.
- [ ] **The spine exists.** Someone can trace any active work to a strategy.

If 4+ items are checked: you're on track. If 2-3: push harder on the missing items. If 0-1: the migration hasn't started — go back to Phase 1.

---

*Next: [Chapter 18 — Organizational Change: Selling FLOW →](19-organizational-change.md)*

> Part I: Foundation | [← Previous](01-why-flow.md) | [Next →](03-decision-spine.md)

# Chapter 2: The Core Mental Model

> *Panel-reviewed: Meeting #2 (2026-03-19) — 9 agree, 2 modify-accept*
> *Updated: Meeting #13 — Tempo, Invariants/Variables, Cycle Phases*
> *Updated: Meeting #14 — Maturity Model, Cycle State*
> **Read this**: Everyone. Core concepts for all of FLOW.

---

## Two Modes: Discovery and Outcome

Every piece of product work is in one of two modes:

**Discovery** — the primary risk is building the wrong thing. You don't yet know whether the problem is real, the solution is right, or the approach will work. The goal is **learning**, not shipping. The output is **evidence**, not code.

**Outcome** — the primary risk is failing to ship the right thing. You have evidence that the problem is real and the approach is sound. Now you need to execute. The goal is **shipping**, not learning. The output is **working product**, measured by a target metric.

This is FLOW's foundational insight: **the mode you're in determines the process you follow.** Discovery mode has its own artifacts (Discovery Brief), its own gates (D1-D3), and its own ritual (Discovery Review). Outcome mode has different artifacts (SPEC-Lite, Build Contract), different gates (O1-O5), and different rituals (Outcome Review, Kill/Merge).

Most methodologies don't distinguish modes. Scrum treats a "research spike" and a "build user login" the same way — both are backlog items estimated in story points. Shape Up shapes everything into pitches, whether the team is exploring a new market or building a known feature. SAFe puts both exploratory and delivery work through the same PI Planning ceremony.

FLOW says: **the work tells you which mode to use.** You don't decide your process once and apply it to everything. You read the uncertainty level and select the mode that matches.

---

## Tempo

Tempo is the team's natural rhythm of **build → observe → decide**. It answers the question: *how fast can this team complete one full cycle of learning or shipping?*

Four factors determine tempo:

1. **Execution leverage** — how much output per unit of effort? A solo developer with Claude Code ships features in hours. A 42-person bank team ships features in weeks.
2. **Observation requirements** — how long must you wait to see results? A/B tests need traffic. Hardware needs field deployment. Some metrics are instant; others take weeks.
3. **Coordination overhead** — how many people must align before work moves? Solo = zero overhead. Cross-department = days of alignment.
4. **External constraints** — regulatory review cycles, client approval gates, manufacturing lead times.

**Teams discover their tempo — it is not assigned.** A team that tries to run 1-week cycles when their observation window is 3 weeks will produce meaningless data. A team running 4-week cycles when they could learn in 2 days is wasting time.

### Tempo Comparison

| Team | Context | Tempo | Why |
|------|---------|-------|-----|
| **Carlos** | Solo founder + Claude Code | ~1 day | High execution leverage (agents), instant observation (live metrics), zero coordination |
| **Sara** | 42-person bank division | 3–4 weeks | Low execution leverage (approvals, dependencies), slow observation (compliance review), high coordination |
| **Amara** | Hardware IoT startup | Months | Physical prototyping, field deployment for observation, supplier coordination |

> **Sidebar — Solo/Agent context**: When agents compress build time toward zero, tempo is dominated by observation and decision time. Carlos doesn't need shorter cycles — he needs better observation infrastructure.

> **Sidebar — Enterprise context**: Sara's tempo isn't "slow." It's *correct* for her constraints. Forcing weekly sprints on a team with 3-week regulatory review cycles creates theater, not speed.

Tempo is explored further in [Chapter 6](07-cycle-engine.md) (cycle calibration) and [Chapter 17](18-migration.md) (discovering your tempo during adoption).

---

## The Mode Decision

Ask this question about any piece of work:

> **"Is the primary risk that we build the wrong thing, or that we fail to ship the right thing?"**

If the answer is **"build the wrong thing"** → Discovery mode.
If the answer is **"fail to ship"** → Outcome mode.
If the answer is **"both"** → split the work. Known parts go to Outcome. Unknown parts go to Discovery. They run in parallel.

This question is the entry point to FLOW. Every intake classification, every cycle kickoff, every mode transition starts here.

---

## Mode Relationship Patterns

The relationship between Discovery and Outcome varies by context. FLOW recognizes six patterns:

```mermaid
graph LR
    subgraph "Sequential"
        S1[Discovery] --> S2[Outcome]
    end
    subgraph "Parallel"
        P1[Discovery] -.-> P3[Converge]
        P2[Outcome] -.-> P3
    end
    subgraph "Collapsed"
        C1["Discovery + Outcome<br/>(simultaneous)"]
    end
```

### 1. Sequential
**Discovery → Outcome.** Learn first, build second. No overlap.

*When*: High cost of building wrong (hardware, regulated products, irreversible decisions). Amara's solar controller: a $5,000 prototype means you discover before you manufacture.

*Cadence*: Discovery cycle completes fully. Gate D3 passes. Outcome cycle begins.

### 2. Parallel
**Discovery on unknowns + Outcome on knowns, simultaneously.**

*When*: Parts of the work are understood, parts aren't. Priya's hospital scheduling module: the data model is known (Outcome), but the nurse UX is uncertain (Discovery). Both run concurrently.

*Cadence*: Two tracks, one initiative. Discovery Brief for the unknowns. SPEC-Lite for the knowns. They converge when Discovery produces evidence.

### 3. Collapsed
**Discovery through building.** The act of shipping IS the experiment.

*When*: Solo founders, tiny teams, consumer products where you can ship to a small audience cheaply. Carlos ships a feature to 50 users on Monday, watches metrics Tuesday, iterates or kills Wednesday. His Discovery and Outcome are the same activity.

*Cadence*: Rapid cycles (days, not weeks). Kill conditions are metric thresholds, not experiment results.

### 4. Oscillating
**Alternating between modes within a cycle.** Build, test, learn, adjust, build more.

*When*: Creative work where the artifact IS the experiment. Dmitri's game studio: build the dodge mechanic, playtest, learn it doesn't feel right, redesign, build again. The cycle oscillates between "is this fun?" (Discovery) and "ship the level" (Outcome).

*Cadence*: Fluid. Mode switches happen daily or even hourly. No formal gate — the team reads the signal and shifts.

### 5. Governance-Gated
**Formal approval required to transition from Discovery to Outcome.**

*When*: Regulated environments, large enterprises, government programs. James's insurance company: a Discovery phase produces a feasibility report. A review board examines the evidence. They formally approve transition to Outcome — or they don't.

*Cadence*: Discovery cycle → Gate review (board/committee) → Outcome cycle. The gate is an organizational event, not just a team decision.

*Who convenes the gate review*: Typically a governance body (project board, change advisory board, or designated decision authority). Evidence required: completed Discovery Brief with experiment results, risk assessment, resource estimate, and compliance impact analysis. The decision must be documented for audit trail.

### 6. Client-Gated
**The client approves the mode transition.**

*When*: Agency and outsourcing work. Rawan's client engagement: the Discovery phase produces findings and recommendations. The client reviews: "Yes, proceed to building" or "No, investigate further" or "Pivot direction."

*Cadence*: Discovery deliverable → Client review → Outcome cycle. The client is the gate. Budget approval often coincides with mode transition.

---

## Mode Selects Process

A common misconception: "FLOW replaces my current process." It doesn't. **Mode selects process.**

If you're in Discovery mode, FLOW provides the Discovery process: Brief → Experiment → Learn → Decide.
If you're in Outcome mode, FLOW provides the Outcome process: SPEC → Contract → Build → Review → Decide.

But within each mode, your team can use whatever execution approach works:
- Kanban boards for task tracking? Fine.
- Daily standups? Fine.
- Pair programming? Fine.
- Shape Up-style appetites within Outcome cycles? Fine.

FLOW operates one level above your daily execution process. It decides WHAT KIND of work you're doing (learning or shipping) and provides the appropriate artifacts and gates. It doesn't dictate HOW you code, HOW you design, or HOW you run your daily work.

This is what makes FLOW adoptable alongside existing methods.

> **Key insight: You don't replace Scrum. You add a layer above it.** "This sprint, are we in Discovery or Outcome mode? Let's use the right artifacts." The same applies to Kanban, Shape Up, SAFe, or any execution framework. FLOW is the decision layer. Your existing tools are the execution layer.

---

## FLOW Invariants vs FLOW Variables

FLOW scales from a solo founder to a 500-person enterprise. What changes between these contexts? **Less than you think.** The core machinery is identical. Only the parameters adjust.

### Invariants (unchanged at any tempo)

These are non-negotiable. Remove any one, and you're no longer doing FLOW:

| Invariant | Why it's fixed |
|-----------|---------------|
| **Discovery/Outcome classification** | The mode question ("wrong thing vs. fail to ship?") applies at every scale. Skipping it is how teams build features nobody wants. |
| **Decision Spine mapping** | Every cycle must trace to a strategic bet. Without this, work drifts from strategy — regardless of team size. |
| **Kill conditions** | Every cycle has a pre-committed condition that stops the work. Without kill conditions, sunk-cost bias takes over. |
| **Gates** | Quality checkpoints (D1–D3, O1–O5) ensure work meets evidence or quality thresholds before progressing. |
| **WIP limits** | Capacity is finite. This is physics, not policy. A solo developer has WIP limits just as much as a 50-person team. |
| **Observe before Decide** | You cannot skip measuring. Deciding without observation is guessing. This holds whether observation takes 5 minutes or 5 weeks. |

### Variables (scale with team context)

These adapt to your tempo and team shape:

| Variable | Fast tempo (solo/agent) | Slow tempo (enterprise/hardware) |
|----------|------------------------|----------------------------------|
| **Cycle duration** | Days | Weeks to months |
| **Documentation depth** | Micro-SPEC (a few lines) | Full SPEC-Lite (detailed artifact) |
| **Ritual cadence** | Informal, async, per-cycle | Formal ceremonies, scheduled reviews |
| **Build phase duration** | Approaches zero (agents do the building) | Weeks (large teams, dependencies) |
| **Migration timeline** | Repetition-based (10–15 cycles to internalize) | Same — repetition-based, not calendar-based |

> **Key insight**: Migration speed is measured in **cycles completed**, not weeks elapsed. Carlos at 1-day tempo internalizes FLOW in 2 weeks (15 cycles). Sara at 3-week tempo takes ~9 months (15 cycles). Same learning curve — different clock speed. See [Chapter 17](18-migration.md).

### Maturity Model (Meeting #14)

FLOW enforcement intensity scales with adoption maturity. Not every team needs — or can handle — full rigor from day one:

| Level | Name | What it means | Enforcement |
|-------|------|--------------|-------------|
| **L1** | Learning | Team is new to FLOW. Process is advisory. | Suggestions and nudges. Gates are educational, not blocking. Kill conditions are recommended but not enforced. |
| **L2** | Practicing | Team has completed 5+ cycles. Process is expected. | Gates block progression if failed. Kill conditions are enforced. Ambient rules fire warnings. |
| **L3** | Fluent | Team has internalized FLOW. Process is reflexive. | Full enforcement. Structured gate interrogation with evidence ratings. Anti-sycophancy rules active on evaluations. |

Teams self-assess their level and declare it in their FLOW Configuration ([Chapter 14](14-rituals.md)). Progression is based on demonstrated understanding, not calendar time — see [Chapter 17](18-migration.md) for adoption gates that map to L1→L2→L3.

### Cycle State as Infrastructure (Meeting #14)

FLOW cycles persist across tool invocations via an `active-cycle.json` state file in the `.flow/` directory. This file tracks the current cycle's mode, phase, active gate, and history — ensuring that context is never lost between sessions. The state file is the cycle's memory: it knows what gate you passed, what experiment you ran, and what decision is pending. See [Chapter 14](14-rituals.md) for the file format and [Chapter 19](20-ai-agents.md) for how agents use it.

---

## Cycle Phases: Build → Observe → Decide

Every FLOW cycle — Discovery or Outcome — decomposes into three phases:

1. **Build** — produce the thing. In Discovery, this is running the experiment. In Outcome, this is shipping the increment.
2. **Observe** — measure the result. Collect evidence (Discovery) or metrics (Outcome). No interpretation yet — just data.
3. **Decide** — read the evidence and choose: continue, pivot, kill, or merge. This is where kill conditions are evaluated and the Decision Spine is consulted.

```
┌─────────┐    ┌─────────┐    ┌─────────┐
│  Build   │───▶│ Observe  │───▶│ Decide  │
└─────────┘    └─────────┘    └─────────┘
     ▲                              │
     └──────────────────────────────┘
              next cycle
```

### When Agents Compress Build

As AI agents take over more of the Build phase, something important happens:

**Cycle Duration ≈ Observe + Decide**

Build time approaches zero. The cycle doesn't get shorter — it gets *rebalanced*. All the team's time goes to observation and decision-making. This is actually the **healthy state**: humans spend 100% of their time learning and deciding, not building.

> **Sidebar — Solo/Agent context**: Carlos with Claude Code already lives here. His "build" is a prompt. His cycle time is dominated by "did users engage?" (Observe) and "should I iterate or kill?" (Decide). If your Build phase is still the bottleneck, you haven't leveraged agents yet.

> **Sidebar — Enterprise context**: Sara's Build phase won't compress to zero anytime soon — coordination overhead, compliance checks, and integration testing dominate. But *within* each developer's work, agents are compressing individual build tasks. The enterprise benefit: more cycles per quarter, not shorter cycles.

The cycle engine is detailed in [Chapter 6](07-cycle-engine.md). Gates and kill conditions that govern the Decide phase are in [Chapter 5](06-kill-conditions.md) and [Chapter 8](09-gates.md).

---

## Comparison Matrix

| Concept | Scrum | Shape Up | SAFe | Kanban | Lean Startup | FLOW |
|---------|-------|----------|------|--------|-------------|------|
| **Modes** | None (all work = backlog items) | Shaping vs. Building (structured, senior-only) | Explore vs. Exploit (portfolio level) | None | Build-Measure-Learn (single loop) | Discovery vs. Outcome (explicit, gated) |
| **Cadence** | Fixed sprints (1-4 weeks) | Fixed cycles (6 weeks) + cool-down | PI = 8-12 weeks, sprints within | Continuous | Continuous | Flexible cycles (2-4 weeks typical) |
| **Kill mechanism** | Sprint cancellation (rare, stigmatized) | Appetite runs out (time-based) | WSJF deprioritization | WIP limits (indirect) | Pivot or persevere | Kill conditions (evidence-based, pre-committed) |
| **Traceability** | Product Goal → Sprint Goal | Appetite → Pitch | Strategic Themes → Epics → Features | None formal | Vision → Strategy → Experiments | Vision → Strategy → Bet → Cycle (Decision Spine) |
| **Key artifacts** | Product Backlog, Sprint Backlog | Pitch, Fat Marker Sketch | PI Objectives, Features, Enablers | Cards on board | Lean Canvas, Experiment Cards | Discovery Brief, SPEC-Lite, Build Contract |
| **Roles** | PO, SM, Developers | Shapers, Builders | RTE, PO, System Architect, many | Team (minimal roles) | CEO, CTO (small teams) | PM, Engineer, Designer, Flow Coach |
| **Team topology** | One cross-functional team | Small teams (2-3 + shaper) | ARTs, trains, squads | Flexible | Small team | Stream-aligned, Platform, Enabling, Complicated-subsystem |
| **Governance** | Sprint Review (team level) | Betting Table (leadership) | PI Planning, I&A, System Demo | Visual board | Pivot meetings | Gates (D1-D3, O1-O5), Kill/Merge ritual |

### If You're Coming From...

**Scrum**: The biggest change is classifying work by mode. Not everything is a "user story." Discovery work gets a Discovery Brief, not a story. Outcome work gets a SPEC-Lite, not a PBI. Your sprint cadence can stay — but sprint goals now include kill conditions. Detailed migration in [Chapter 17](18-migration.md).

**Shape Up**: You're already close. Your "shaping" maps to FLOW's intake + shaping. Your "betting table" maps to spine check + admission control. The additions: Discovery mode makes shaping a full team activity (not only seniors), and kill conditions ADD an evidence-based stopping mechanism alongside appetite. A team can keep appetite (time limit) AND use kill conditions (evidence limit) — whichever triggers first stops the work. This is an evolution, not a replacement. Detailed migration in [Chapter 17](18-migration.md).

**SAFe**: SAFe provides portfolio-level governance that many enterprises need. FLOW adds team-level decision clarity within that governance. Your PI Planning maps to spine alignment. Your WSJF maps to intake classification. The additions: explicit Discovery mode for uncertain work (SAFe's "Explore" portfolio state brought down to team level), and pre-committed kill conditions that stop work based on evidence (not just WSJF reprioritization). You can run FLOW's mode classification and kill conditions within SAFe's existing ceremony — adding decision quality without disrupting your governance structure. Detailed migration in [Chapter 17](18-migration.md).

**Kanban**: FLOW adds structure that Kanban intentionally avoids. Your flow-based execution stays — FLOW doesn't require sprints. The addition: mode classification (are you learning or shipping?), kill conditions (when does this card get pulled from the board permanently?), and the Decision Spine (why is this card on the board at all?). Detailed migration in [Chapter 17](18-migration.md).

**Lean Startup**: You share DNA. Build-Measure-Learn IS Discovery mode. FLOW formalizes it with artifacts (Discovery Brief), gates (D1-D3), and explicit transition to Outcome mode. The upgrade: Lean Startup doesn't have a structured building phase — once you "learn," you just... keep iterating. FLOW says: once evidence is sufficient, switch to Outcome mode with a SPEC, Contract, and kill conditions. Detailed migration in [Chapter 17](18-migration.md).

**Waterfall / PRINCE2**: FLOW adds structured learning to your delivery process. Your stage gates map to FLOW gates. Your feasibility studies map to Discovery mode. The upgrade: instead of a single long feasibility → build → test → deploy sequence, FLOW introduces shorter cycles with evidence checkpoints. You can run FLOW cycles within your existing PRINCE2 stages — adding agility without abandoning governance. Detailed migration in [Chapter 17](18-migration.md).

---

*Next: [Chapter 3 — The Decision Spine →](03-decision-spine.md)*

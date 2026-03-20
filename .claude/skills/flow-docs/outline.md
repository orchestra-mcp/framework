# FLOW — The Methodology for the Agentic Era

> Approved Documentation Outline (v0.2 — Panel-Reviewed)

---

## Part I: Foundation

### [Chapter 1: Why FLOW Exists](01-why-flow.md)
- The universal problem: teams build before they understand what to build, and can't stop what's failing
- The FLOW thesis: methodology should optimize for **decisions**, not delivery velocity
- Three decision capabilities: decide what to learn (Discovery), decide what to build (Outcome), decide what to stop (Kill)
- The AI accelerator: agents supercharge FLOW's decision engine — but FLOW works without them
- Who FLOW is for: product teams building under uncertainty (any size, any domain)
- **Reading paths**: Solo founder? Small team? Enterprise? Agency? Hardware? Government? Start here
- **Anti-pattern teaser**: 3 common failures FLOW prevents (preview of [Ch 20](21-anti-patterns.md))

### [Chapter 2: The Core Mental Model](02-mental-model.md)
- **Tempo**: the team's natural build-observe-decide rhythm (execution leverage × observation requirements × coordination overhead × external constraints)
- **FLOW Invariants vs Variables**: what never changes (modes, spine, kills, gates, WIP, observe-before-decide) vs what scales (cycle duration, doc depth, cadence, build time, migration pace)
- **Cycle Phases**: Build → Observe → Decide — explicit decomposition; agents compress Build toward zero
- Two modes: **Discovery** (learning) vs. **Outcome** (shipping) — the core distinction
- The mode decision: "Is the primary risk that we build the wrong thing, or that we fail to ship the right thing?" (answer can be "both")
- **Mode relationship patterns**: sequential (hardware), parallel (software), collapsed (solo), oscillating (creative), governance-gated (enterprise/gov), client-gated (agency)
- Mode transition formality spectrum: informal → team-level → PM-level → leadership-level → governance-level
- Why mode SELECTS process (not "mode vs. process")
- **Comparison matrix**: single-page table — Scrum, Shape Up, SAFe, Kanban, Lean, Waterfall, FLOW — covering modes, cadence, kill mechanism, traceability, artifacts, roles, team topology, governance integration
- Short "if you're coming from X" summaries (one paragraph each, additive framing — "FLOW adds X" not "X is broken")
- *Sidebars: Solo (modes collapse — discovery through building), Hardware (modes are strictly sequential), Agency (client gates the mode switch), Enterprise (governance-gated transitions)*

### [Chapter 3: The Decision Spine](03-decision-spine.md)
- Vision → Strategy → Bet → Cycle: the full traceability chain
- Why "Bet" — signals intellectual honesty about uncertainty (we might be wrong)
- **Contextual alternatives** (main-text callout): Government/formal contexts may use "Investment Hypothesis" or "Commitment"; Enterprise may use "Initiative" — semantics are the same
- Spine mapping as a **spectrum**: informal/mental (solo founders) → team-owned → PM-owned → leadership-reviewed → governance-gated
- Admission control: default is "nothing enters without a spine trace" — explicit exception for operational/incident work
- **Platform spine topology**: branching spines where one platform bet enables N downstream bets
- **Mapping your hierarchy**: examples for enterprise (6 levels → 4), solo (3 levels → 4), agency (partial spine — client owns Vision/Strategy, you own Bet/Cycle)
- Maintaining the spine as strategy evolves
- *Sidebars: Government (maps to National Vision → Sector Strategy → Program → Project), Platform (one bet enables N downstream bets), Agency (split spine across organizational boundaries)*

---

## Part II: How Work Enters

### [Chapter 4: Intake, Classification & Shaping](05-intake.md)
- The intake funnel: idea → classification → routing
- Classification: is this Discovery or Outcome? New work or existing cycle?
- **Shaping**: the strategic framing activity — who decides what's worth pursuing and how to frame it
- Routing: which team, which track, which project?
- The intake ritual: daily or real-time?
- Handling urgent requests that bypass the funnel
- Saying no: how FLOW helps you reject work with confidence
- *Sidebars: Solo (intake = your Notion inbox), Agency (client intake vs. internal intake), Enterprise (multi-team intake coordination)*

---

## Part III: Discovery Mode

### [Chapter 5: The Discovery Brief](06-discovery-brief.md)
- What a Discovery Brief is (and isn't)
- The anatomy: Problem Statement, Hypothesis, Experiment Design, Kill Condition, Success Signal
- Writing good hypotheses: "We believe [users] have [problem] because [evidence]"
- The difference between a Discovery Brief and a SPEC-Lite
- **Template included**
- Gate D1: Is this brief ready to pursue?
- *Sidebars: Agency (Discovery Brief as paid deliverable — scoping and pricing it), Hardware (Discovery Brief for physical product hypotheses)*

### [Chapter 6: Experiments](07-experiments.md)
- The experiment hierarchy: conversation → prototype → concierge → wizard of oz → production code
- Production code is the **most expensive** validation — always a last resort
- Designing the smallest, cheapest, fastest experiment
- The Experiment Log: what was tested, what happened, what was decided
- **Template included**
- Common experiment anti-patterns
- Gate D2: Has the experiment been designed properly?
- *Sidebars: Hardware (the experiment hierarchy shifts — prototypes cost thousands, conversations and mockups carry more weight), Solo (experiments you can run alone in a weekend)*

### [Chapter 7: Discovery Decisions & Gates](08-discovery-decisions.md)
- The four outcomes: Continue, Refine, Pivot, Stop
- When to switch from Discovery to Outcome mode
- Gate D3: Is there enough evidence to switch modes?
- The Discovery Review ritual: weekly check on all active Discovery cycles
- Archiving learnings: what to keep when you kill a Discovery cycle
- *Sidebars: Agency (when the client wants to skip Discovery), Enterprise (Discovery decisions in risk-averse cultures)*

---

## Part IV: Outcome Mode

### [Chapter 8: SPEC-Lite](09-spec-lite.md)
- The one-page planning artifact
- **SPEC Spectrum**: Micro-SPEC (3 fields: Problem, Hypothesis, Kill Condition) → Full SPEC-Lite (5+ fields)
- Anatomy: Problem, Scope, Target Metric, Kill Condition, Non-Goals
- Writing kill conditions that are actually useful
- SPEC-Lite vs. PRD: why less is more
- **Template included**
- Gate O1: Is the bet worth pursuing?
- Gate O2: Is the SPEC ready for a Build Contract?
- *Sidebars: Agency (SPEC-Lite as client-facing scope doc), Enterprise (SPEC-Lite vs. BRD)*

### [Chapter 9: The Build Contract](10-build-contract.md)
- The mandatory product-engineering agreement
- What it contains: scope, observability plan, rollout strategy, definition of done
- Why it exists: aligning on *how* before diving into *what*
- The PM writes the SPEC, engineering writes the Contract — then they agree
- **Template included**
- Gate O3: Is the Build Contract complete?
- *Sidebars: Government (Build Contract parallels Statement of Work), Platform (Build Contract for API changes with downstream impact)*

### [Chapter 10: Execution & Observability](11-execution.md)
- Building within the cycle: how daily work happens in FLOW
- Observability-first: you can't evaluate what you can't measure
- The metric dashboard: what to track during a cycle
- When to raise a flag mid-cycle (scope creep, blocked, metric not moving)
- Gate O4: Is observability in place?
- *Sidebars: Hardware (execution on 12-week cycles — adapting the model), Enterprise (observability in legacy systems)*

### [Chapter 11: Outcome Decisions & Gates](12-outcome-decisions.md)
- The Kill/Merge meeting: the most important ritual in FLOW
- Three outcomes: Kill (stop and learn), Merge (ship to production), Continue (extend with justification)
- Evidence-based decisions: what data you need to kill or merge
- **Kill/Merge Decision Record template included**
- Gate O5: Kill, Merge, or Continue?
- The Outcome Review ritual: weekly check on active Outcome cycles
- Archiving: what to keep when you kill or merge
- **Learning Archive template included**
- *Sidebars: Agency (kill conditions when the client is paying), Enterprise (kill decisions in committee cultures)*

---

## Part V: Operations

### [Chapter 12: WIP Limits](13-wip-limits.md)
- Why unbounded work-in-progress kills teams
- How to set WIP limits (per team, per mode, per person, **per bottleneck type**)
- The WIP check: enforcing limits before accepting new work
- What to do when you're at capacity (queue, trade, or kill)
- WIP limits in practice: real examples
- *Sidebars: Solo (your WIP limit is 1-2), Agency (WIP across multiple client projects), Platform (WIP across dependency graph)*

### [Chapter 13: Rituals & Cadence](14-rituals.md)
- **Two rhythms**: Cycle Cadence (per-cycle, scales with Tempo) vs Portfolio Cadence (calendar-based, weekly/monthly minimums)
- **FLOW Configuration**: team one-pager (Tempo, SPEC minimum, WIP limits, cadences)
- Intake Review, Discovery Review, Outcome Review, Kill/Merge
- Ritual anti-patterns: when meetings become process theater
- Async alternatives: can rituals work asynchronously with AI agents?
- **Cross-team sync rituals**: how platform and dependent teams coordinate
- *Sidebars: Solo (which rituals to keep — maybe just weekly Kill/Merge with yourself), Agency (per-client cadence vs. internal cadence)*

### [Chapter 14: Production Readiness](15-production-readiness.md)
- The exploration → production gate
- What "production ready" means in FLOW
- Feature flags and blast radius management
- The handoff: from exploration track to core product
- Post-merge monitoring: when is it truly done?
- *Sidebars: Hardware (production readiness = manufacturing readiness review), Platform (API versioning and breaking change protocol)*

### [Chapter 15: FLOW in Regulated Environments](16-regulated-environments.md)
- Integrating FLOW with existing governance frameworks (PRINCE2, PMI, ISO)
- FLOW gates as evidence for compliance requirements
- Audit trails: how FLOW artifacts satisfy regulatory documentation
- Change control: how kill/merge decisions map to change advisory boards
- Compliance documentation: what to keep, what format, who signs off
- *Sidebars: Government (benefits realization — measuring citizen outcomes, vendor management across procurement cycles), Healthcare (HIPAA/DISHA documentation), Financial services (SAMA/regulatory review integration)*

---

## Part VI: Adoption

### [Chapter 16: Roles & Team Topology](17-roles.md)
- **Product Manager**: owns the SPEC, drives Discovery, writes kill conditions
- **Engineer**: owns the Build Contract, drives Outcome execution, writes observability
- **Designer**: owns experiment design (Discovery) and UX validation (Outcome)
- **Tech Lead**: owns architecture decisions and production readiness
- **Flow Coach** (was Delivery Manager / Scrum Master): facilitates rituals, enforces WIP limits, guards gates
- How roles shift between Discovery and Outcome modes
- **Team types**: stream-aligned, platform, enabling, complicated-subsystem
- How FLOW applies differently to each team type
- *Sidebars: Solo (you are all roles — which hat matters most when), Platform (the platform PM's unique challenges)*

### [Chapter 17: Migration to FLOW](18-migration.md)
- Starting point assessment: where is your team today?
- **From Scrum**: what maps, what changes, what's new
- **From SAFe**: simplifying without losing governance
- **From Shape Up**: adding Discovery mode and kill conditions
- **From Waterfall/PRINCE2**: introducing cycles within stages
- **From Kanban**: adding structure without killing flow
- **From nothing**: building methodology from scratch
- **Repetition-based milestones** (cycle count, not calendar weeks) with adoption gates that test understanding
- Common migration failures and how to prevent them
- The 30-day health check: "are we doing it right?"
- *Sidebars: Agency (migrating per-client vs. company-wide), Enterprise (phased rollout across teams)*

### [Chapter 18: Organizational Change — Selling FLOW](19-organizational-change.md)
- The political reality: methodology adoption is a political act
- How to pitch FLOW to skeptical leadership
- The 30-day proof: what metrics to show after the first month
- **Measuring FLOW success**: leading indicators (cycle time, kill rate, experiment count) and lagging indicators (outcomes achieved, waste reduced)
- Surviving a culture that punishes killing
- What to do when leadership overrides a kill condition
- Transformation failure modes and how to avoid them
- *Sidebars: Enterprise (executive sponsor playbook), Government (ministerial buy-in strategy), Agency (selling FLOW to clients as a value-add)*

### [Chapter 19: FLOW in the Agentic Era](20-ai-agents.md)
- **The Execution Cost Revolution**: when building becomes nearly free, the bottleneck shifts to judgment
- **Three Agent Roles**: Builder (collapses build time), Analyst (processes observation data), Facilitator (runs rituals and gates)
- **The Leverage Spectrum**: fully agentic → partially agentic → minimally agentic
- **Tempo Impact**: how agents compress cycles by compressing the build phase; metric maturity table
- **The Bottleneck Shift**: Theory of Constraints — when builds are fast, where does the constraint move?
- **Decision Authority**: what agents can do vs. what humans must do (mechanics vs. judgment)
- **The Comprehension Review**: understanding agent-built code, not just reviewing it
- **Agentic Walkthrough**: complete FLOW cycle with agents as builders (contrast with Ch 3)
- *Sidebars: Solo (agent as your entire team), Enterprise (AI governance and trust), Agency (client education on agentic speed), Hardware (agents don't speed up physics)*

---

## Part VII: Reference

### [Chapter 20: Anti-Patterns Catalog](21-anti-patterns.md)
- **Process Theater**: going through the motions without learning
- **Discovery Avoidance**: jumping to Outcome because building feels productive
- **Zombie Cycles**: cycles that never get killed despite no evidence of progress
- **Scope Creep by Consensus**: expanding scope because everyone has "one more thing"
- **WIP Inflation**: accepting new work without killing old work
- **7 Agentic Anti-Patterns**: Premature Confidence, Experiment Overload, Judgment Fatigue, Context Collapse, Dependency Whiplash, Maintenance Debt, Speed Inequality
- **Gate Skipping**: treating gates as optional when under pressure
- **Metric Gaming**: choosing metrics that always look green
- **The Infinite Discovery**: using "we need more data" to avoid shipping decisions

### [Chapter 21: Glossary](22-glossary.md)
- Complete A-Z terminology reference
- Cross-references between related terms
- Disambiguation of similar concepts (SPEC vs. Brief, Kill vs. Pause, etc.)

### [Chapter 22: Adaptation Guides](23-adaptation-guides.md)
- **Solo Founders**: complete guide to FLOW alone (consolidated from all chapter sidebars)
- **Agency & Client Work**: complete guide to FLOW in outsourcing (consolidated)
- **Hardware & Physical Products**: complete guide to FLOW with long iteration cycles
- **Enterprise**: complete guide to FLOW at 50+ people with multiple teams
- **Government**: complete guide to FLOW in public sector (benefits realization, vendor management, bilingual docs)

---

*Document version: 0.3 (Meeting #13: Agentic Speed backport)*
*Approved: 2026-03-19 — Meeting #1 (structure), Meeting #13 (Tempo, agentic era concepts)*
*Agent: Waddah (وضّاح)*

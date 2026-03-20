> Part VII: Reference | [← Previous](21-anti-patterns.md) | [Next →](23-adaptation-guides.md)

# Chapter 21: Glossary

> *Panel-reviewed: Meeting #8, updated Meeting #13 (2026-03-19)*
> *Updated: Meeting #14 — New terms added*
> **Read this**: When you encounter an unfamiliar FLOW term. Use as reference, not sequential reading.

---

## A-Z Terminology Reference

**Anti-Sycophancy** — (Meeting #14) Behavioral rules preventing agents and coaches from validating weak work. At gates, the evaluator's job is to challenge, not confirm. Key rules: never soften kill recommendations, flag confidence gaps, ask structured interrogation questions. Applies at all maturity levels but enforced strictly at L2+. ([Chapter 19](20-ai-agents.md), [Chapter 20](21-anti-patterns.md))

**Admission Control** — The principle that nothing enters active development without a valid spine trace. Work must map to Vision → Strategy → Bet → Cycle. Exception: operational/incident work. ([Chapter 3](03-decision-spine.md))

**Bet** — A specific hypothesis the team is investing in, sitting between Strategy and Cycle on the Decision Spine. "We believe X will happen if we do Y." Intentionally named "Bet" to signal uncertainty. Contextual alternatives: Investment Hypothesis (government), Strategic Initiative (enterprise). ([Chapter 3](03-decision-spine.md))

**Build Contract** — A mandatory agreement between product (PM) and engineering before Outcome execution begins. Contains: scope reference, technical approach, observability plan, rollout strategy, definition of done, risks, dependencies. Gate O3 checks its completeness. ([Chapter 9](10-build-contract.md))

**Cascade Effect** — When killing a platform bet affects downstream teams whose bets depend on it. Platform kill decisions are portfolio events, not single-team decisions. ([Chapter 3](03-decision-spine.md))

**Classification** — The act of determining whether incoming work is Discovery (learn first) or Outcome (build now). Part of the intake pipeline. ([Chapter 4](05-intake.md))

**Confidence Markers** — (Meeting #14) Tags applied to factual claims in research and experiment results: `[verified]` (confirmed from primary source), `[likely]` (supported by secondary sources), `[VERIFY]` (unconfirmed, requires validation). Claims tagged `[VERIFY]` must not be the sole basis for kill conditions. ([Chapter 5](06-discovery-brief.md), [Chapter 19](20-ai-agents.md))

**Collapsed Mode** — A mode relationship pattern where Discovery and Outcome happen simultaneously — the act of building IS the experiment. Common for solo founders and tiny teams shipping to small audiences. ([Chapter 2](02-mental-model.md))

**Comprehension Review** — Post-build review ensuring the team understands agent-built code. Not code review (which checks correctness) — comprehension review checks understanding. Strongly recommended for Micro-SPEC experiments, required for Full SPEC features. ([Chapter 19](20-ai-agents.md))

**Continue** — One of five Discovery/Outcome decision outcomes. The kill condition wasn't triggered, but the success signal wasn't reached either. Evidence is inconclusive. Requires justification, a revised plan, and a shorter deadline. Maximum 2 continues per cycle. (Chapters [7](08-discovery-decisions.md), [11](12-outcome-decisions.md))

**Cycle** — The bottom level of the Decision Spine. A bounded unit of work — either a Discovery cycle (learning) or an Outcome cycle (shipping). ([Chapter 3](03-decision-spine.md))

**Cycle State** — (Meeting #14) Persistent state file (`active-cycle.json` in `.flow/`) that tracks the current cycle's mode, phase, gate history, and activity. Ensures context continuity across tool invocations and sessions. Supports pause/resume. Read by Ambient Rule #8 (Cycle Continuity). ([Chapter 2](02-mental-model.md), [Chapter 14](14-rituals.md), [Chapter 19](20-ai-agents.md))

**Cycle Cadence** — Rituals tied to the cycle (intake, review, kill/merge). Scales with Tempo — faster teams run these more frequently. Contrast with Portfolio Cadence, which is calendar-bound. ([Chapter 14](15-production-readiness.md))

**Cycle Phases** — The three explicit phases within every FLOW cycle: Build → Observe → Decide. When agents compress Build toward zero, Cycle Duration ≈ Observe + Decide. ([Chapter 2](02-mental-model.md))

**Decision Spine** — The traceability chain: Vision → Strategy → Bet → Cycle. Every piece of work traces upward. If it can't trace, it shouldn't exist. ([Chapter 3](03-decision-spine.md))

**Domain Expert Agent** — (Meeting #14) An agent configured with domain-specific knowledge that serves the Expert Review Gate. Built via the `/flow-expert` blueprint. Challenges experiment designs, rates research confidence, flags domain pitfalls. Does not replace human experts for novel or high-stakes decisions. ([Chapter 6](07-experiments.md), [Chapter 16](17-roles.md), [Chapter 19](20-ai-agents.md))

**Discovery Brief** — A one-page hypothesis document for Discovery mode. Full version (5 fields): Problem Statement, Hypothesis, Experiment Design, Kill Condition, Success Signal. Minimum version (3 fields): Hypothesis, Kill Condition, Experiment. ([Chapter 5](06-discovery-brief.md))

**Discovery Mode** — One of FLOW's two modes. Used when the primary risk is building the wrong thing. The goal is learning, not shipping. Output is evidence, not code. ([Chapter 2](02-mental-model.md))

**Evaluation Tone** — (Meeting #14) The deliberate calibration of communication style during evaluations. Warm tone for process guidance (coaching, teaching, improving artifacts). Cold tone for decision evaluation (gate pass/fail, kill recommendations). Mixing tones undermines both — warm on decisions leads to sycophancy, cold on process leads to hostility. ([Chapter 17](18-migration.md), [Chapter 19](20-ai-agents.md))

**Expert Review Gate** — (Meeting #14) An optional quality insertion point between D2 and D3 for domain-specific validation. A domain expert reviews experiment design and results for domain-specific validity. Not a formal FLOW gate (no checklist) — a structured consultation. Teams declare usage in their FLOW Configuration. ([Chapter 6](07-experiments.md), [Chapter 16](17-roles.md))

**Escalate** — The fifth Discovery/Outcome decision outcome. Discovery revealed that the problem exceeds the team's mandate, authority, or capability. The work must be re-scoped at a higher organizational level. ([Chapter 7](08-discovery-decisions.md))

**Execution Leverage** — How much output per unit of human input. High with agentic tooling, lower without. Affects Tempo but does not change FLOW's core logic. ([Chapter 19](20-ai-agents.md))

**Experiment Hierarchy** — A principle-based menu (not a ladder) of experiment types ordered by typical cost: conversation, desk research, mockup, prototype, concierge, wizard of oz, limited build. "Always choose the cheapest experiment that can validly answer your question." ([Chapter 6](07-experiments.md))

**Experiment Log** — A record of every experiment: date, hypothesis, type, cost, results, interpretation, decision, next action. Prevents re-running experiments and preserves institutional memory. ([Chapter 6](07-experiments.md))

**FLOW Configuration** — Team one-pager declaring Tempo, SPEC minimum, WIP limits, Cycle Cadence, and Portfolio Cadence. Descriptive, not prescriptive — it documents how the team actually works, not how they aspire to work. ([Chapter 14](15-production-readiness.md))

**FLOW Invariants** — The parts of FLOW that never change regardless of speed: Discovery/Outcome classification, Decision Spine, kill conditions, gates, WIP limits, observe-before-decide. ([Chapter 2](02-mental-model.md))

**FLOW Variables** — The parts of FLOW that scale with team context: cycle duration, documentation depth, ritual cadence, build duration, migration pace. ([Chapter 2](02-mental-model.md))

**Flow Coach** — The role that facilitates rituals, enforces WIP limits, and guards gates. Previously known as Delivery Manager, Scrum Master, or Agile Coach. Does not make product or technical decisions. ([Chapter 16](17-roles.md))

**Gate** — A quality checkpoint in FLOW. Discovery gates: D1 (Brief readiness), D2 (Experiment design), D3 (Mode switch evidence). Outcome gates: O1 (Bet approval), O2 (SPEC readiness), O3 (Build Contract), O4 (Observability), O5 (Kill/Merge decision). (Chapters [5](06-discovery-brief.md)-[11](12-outcome-decisions.md))

**Governance-Gated** — A mode relationship pattern where formal organizational approval is required to transition between Discovery and Outcome. Common in enterprise, government, and regulated environments. ([Chapter 2](02-mental-model.md))

**Intake** — The process by which work enters the FLOW system. Pipeline: Request → Shaping → Classification → Routing → Cycle. ([Chapter 4](05-intake.md))

**Kill Condition** — A pre-committed statement of what failure looks like, written BEFORE work begins. When the condition is met, the work stops (after a 30-minute inspection to validate the condition). Kill conditions are set for both Discovery Briefs and SPEC-Lites. (Chapters [1](01-why-flow.md), [5](06-discovery-brief.md), [8](09-spec-lite.md))

**Kill/Merge Meeting** — The most important ritual in FLOW. Reviews active Outcome cycles and makes one of three decisions per cycle: Kill, Merge, or Continue. Evidence-driven, not opinion-driven. ([Chapter 11](12-outcome-decisions.md))

**Learning Archive** — Institutional memory. Every completed cycle (Killed or Merged) produces an archive entry: artifacts, decision, surprises, transferable insights. Searchable by future teams. Shared between Discovery ([Chapter 7](08-discovery-decisions.md)) and Outcome ([Chapter 11](12-outcome-decisions.md)). (Chapters [7](08-discovery-decisions.md), [11](12-outcome-decisions.md))

**Maturity Model** — (Meeting #14) Three-level scale of FLOW enforcement intensity: L1 (Learning — advisory), L2 (Practicing — enforced gates and kill conditions), L3 (Fluent — full enforcement with anti-sycophancy and structured interrogation). Teams self-assess and declare in FLOW Configuration. Progression based on demonstrated understanding, not calendar time. ([Chapter 2](02-mental-model.md), [Chapter 17](18-migration.md), [Chapter 19](20-ai-agents.md))

**Merge** — Kill/Merge decision outcome. The evidence says the feature is working. Ship it to production. ([Chapter 11](12-outcome-decisions.md))

**Micro-SPEC** — Minimum viable planning artifact — three fields: Problem, Hypothesis, Kill Condition. For high-tempo teams where build cost is near-zero. Kill condition is mandatory even at this level. ([Chapter 8](09-spec-lite.md))

**Mode** — One of two operating states in FLOW: Discovery (learning) or Outcome (shipping). The mode determines which artifacts, gates, and rituals apply. ([Chapter 2](02-mental-model.md))

**Mode Relationship Patterns** — Six ways Discovery and Outcome relate: Sequential, Parallel, Collapsed, Oscillating, Governance-Gated, Client-Gated. ([Chapter 2](02-mental-model.md))

**Non-Goals** — An explicit list of what's OUT of scope in a SPEC-Lite. The primary defense against scope creep. If someone requests something in Non-Goals, it goes through intake as new work. ([Chapter 8](09-spec-lite.md))

**Observability** — The ability to measure whether a feature is achieving its target metric. Must be instrumented BEFORE the measurement period begins. Gate O4 checks this. ([Chapter 10](11-execution.md))

**Observation Floor** — The minimum observation window before a kill/merge decision, determined by metric maturity and domain constraints (not build speed). Click-through data matures in hours; retention in weeks; revenue in months. Prevents premature decisions when build speed outpaces data maturity. (Chapters [7](08-discovery-decisions.md), [19](20-ai-agents.md))

**Outcome Mode** — One of FLOW's two modes. Used when the primary risk is failing to ship the right thing. The goal is shipping, not learning. Output is working product measured by a target metric. ([Chapter 2](02-mental-model.md))

**Pivot** — One of five Discovery decision outcomes. The problem is real but the approach is wrong. Change direction significantly. Write a new Discovery Brief for the pivoted direction. ([Chapter 7](08-discovery-decisions.md))

**Platform Spine Topology** — A branching spine structure for platform teams. One platform bet enables N downstream bets from other teams. Kill conditions are based on downstream adoption. ([Chapter 3](03-decision-spine.md))

**Portfolio Cadence** — Rituals tied to the calendar (strategy check, team health, WIP review). Has minimums: weekly for teams, monthly for portfolios. Does not scale with Tempo — even the fastest teams review strategy no more than weekly. ([Chapter 14](15-production-readiness.md))

**Production Readiness** — The gate between exploration (feature-flagged, limited audience) and production (available to all users). Checklist includes: feature flag removed, monitoring in place, runbook exists, rollback plan tested. ([Chapter 14](15-production-readiness.md))

**Research Provenance** — (Meeting #14) Source type attribution on research claims: primary (direct data), secondary (interpreted data), tertiary (aggregated/opinion). Primary sources carry the most weight in Discovery decisions. Agent training data is always tertiary. ([Chapter 5](06-discovery-brief.md), [Chapter 19](20-ai-agents.md))

**Refine** — One of five Discovery decision outcomes. The direction is right but the hypothesis needs adjustment. Narrow the scope. Revise the Brief. Run a targeted follow-up experiment. ([Chapter 7](08-discovery-decisions.md))

**Routing** — Assigning classified work to a team. Includes spine check (does it trace?), team assignment (who has expertise and capacity?), and priority setting. ([Chapter 4](05-intake.md))

**Shaping** — The strategic framing activity that happens between "someone had an idea" and "the team starts working." Defines boundaries, risks, and the mode the work should enter. Not solution design. Not estimation. ([Chapter 4](05-intake.md))

**SPEC-Lite** — A one-page planning artifact for Outcome mode. Fields: Problem (with evidence reference), Scope, Target Metric, Kill Condition, Non-Goals. Gates O1 and O2 check its readiness. ([Chapter 8](09-spec-lite.md))

**Spine Check** — Validating that a piece of work traces through the Decision Spine (Vision → Strategy → Bet → Cycle). The intake pipeline runs this before accepting work. ([Chapter 3](03-decision-spine.md))

**Stop** — One of five Discovery decision outcomes. The hypothesis is invalidated. The work stops. This is success, not failure — the team learned something valuable. ([Chapter 7](08-discovery-decisions.md))

**Strategy** — The second level of the Decision Spine. 2-3 strategic themes the team/organization is pursuing right now. Strategies are more stable than bets but less permanent than vision. ([Chapter 3](03-decision-spine.md))

**Strategic Mapping Theater** — Anti-pattern. When spine mapping becomes a justification exercise rather than genuine traceability. Work maps to broad strategic pillars instead of specific bets. ([Chapter 20](21-anti-patterns.md))

**Success Signal** — In a Discovery Brief, the specific measurable outcome that indicates the hypothesis is validated (not just "not killed"). Distinct from Kill Condition — the kill condition says when to stop; the success signal says what "good" looks like. ([Chapter 5](06-discovery-brief.md))

**Transition Marker** — (Meeting #14) A visual block displayed at the end of every FLOW skill invocation showing: action completed, current position in the cycle, next step, and any warnings. Backed by the Cycle State File. Provides orientation and continuity across sessions. ([Chapter 4](04-first-cycle.md), [Chapter 19](20-ai-agents.md))

**Target Metric** — In a SPEC-Lite, the single primary metric that determines whether the Outcome cycle succeeded. Must be measurable and instrumented. ([Chapter 8](09-spec-lite.md))

**Tempo** — The team's natural rhythm of build-observe-decide, determined by execution leverage, observation requirements, coordination overhead, and external constraints. Teams discover their tempo — it is not assigned by management. ([Chapter 2](02-mental-model.md))

**Vision** — The top level of the Decision Spine. Why this product/team/company exists. What future are you creating? Rarely changes. ([Chapter 3](03-decision-spine.md))

**WIP Limit** — The maximum number of concurrent cycles a team can carry. Prevents context switching, zombie cycles, and quality erosion. Enforced by the Flow Coach. ([Chapter 12](13-wip-limits.md))

---

## Disambiguation

**Discovery Brief vs. SPEC-Lite**: Brief tests WHETHER a problem exists (hypothesis → experiment → evidence). SPEC-Lite defines HOW to solve a validated problem (scope → metric → kill condition). Brief comes first. SPEC follows when evidence is sufficient.

**Kill vs. Stop vs. Pause**: Kill = permanent. The work is done. Archive it. Stop = same as Kill (the formal term in Discovery decisions). Pause = not a FLOW concept. FLOW doesn't pause — you either continue (with justification) or kill. "Pause" is typically a symptom of WIP Inflation (anti-pattern #5).

**Bet vs. Hypothesis**: Bet = strategic level (Decision Spine). A bet is an investment direction. Hypothesis = tactical level (Discovery Brief). A hypothesis tests whether a bet's assumptions are correct. One bet may generate multiple hypotheses.

**Shaping vs. Discovery**: Shaping = framing the question (boundaries, risks, mode). Discovery = answering the question (experiments, evidence, decisions). Shaping happens before classification. Discovery happens after classification.

**Mode vs. Process**: Mode = the type of work (learning or shipping). Process = how you execute daily (Kanban, standups). FLOW selects the mode. Your existing process handles execution within the mode.

**Micro-SPEC vs. SPEC-Lite vs. Full SPEC**: Micro-SPEC = 3 fields (Problem, Hypothesis, Kill Condition) for near-zero build cost experiments. SPEC-Lite = 5 fields (adds Scope, Target Metric, Non-Goals) for standard Outcome cycles. Full SPEC = complete specification for high-stakes or regulated work. The appropriate level scales with risk and investment, not team preference.

---

*Next: [Chapter 22 — Adaptation Guides →](23-adaptation-guides.md)*

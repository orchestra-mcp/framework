> Part VII: Reference | [← Previous](22-glossary.md)

# Chapter 22: Adaptation Guides

> *Panel-reviewed: Meeting #8, updated Meeting #13 (2026-03-19)*
> **Read this**: Find YOUR context (Solo, Agency, Hardware, Enterprise, Government) and read that section.

---

## How to Use These Guides

Each guide consolidates the sidebars from all previous chapters into a complete reference for a specific context. If you're a solo founder, read the Solo guide and you'll see every FLOW adaptation relevant to you — without hunting through 21 chapters.

These guides are NOT replacements for the main chapters. They're quick-reference summaries with links back to the full treatment.

---

## Solo Founders (Team of 1-2)

### Your FLOW in 5 Minutes
1. **Spine**: Write it on a sticky note. Vision, Strategy, Bet. Update when it changes.
2. **Mode**: Your mode is almost always Collapsed — you discover by building. That's valid.
3. **Brief**: Use the Micro-SPEC. Problem, Hypothesis, Kill Condition. 2 minutes.
4. **Experiment**: Your experiment IS shipping to users. Track one metric. Set one threshold.
5. **Kill**: If the metric doesn't hit, kill it. No renegotiation. Move to the next bet.
6. **WIP**: Your limit is 1-2 active bets. Don't juggle 5 half-built features.
7. **AI Agent**: Your agent is your entire team — Builder, Analyst, and Flow Coach. It builds, you decide.

### Your Tempo
With agentic tooling (Claude Code, Cursor, etc.), your Tempo is likely **1-3 days** per full cycle. Build in minutes-hours, observe for hours-days, decide in minutes. Your bottleneck is NOT build capacity — it's observation (waiting for real user data) and decision quality (are you killing honestly?). Watch for Judgment Fatigue if you're making 5+ kill/merge decisions per week.

### Your Roles
You are all 10 functions ([Ch 16](17-roles.md)). The three that matter most daily: Decision Maker (PM hat — "should I build this?"), Builder (Engineer hat — directing the agent), and Signal Provider (Support hat — "what are users telling me?"). The Agent Operator skill — effectively directing AI agents — is your superpower.

### What to Skip
- Build Contract ([Ch 9](10-build-contract.md)) — you ARE product and engineering
- Team rituals ([Ch 13](14-rituals.md)) — your ritual is a weekly self-review: "kill or keep?"
- Regulated environments ([Ch 15](16-regulated-environments.md)) — unless you're in fintech/healthtech
- Team topology ([Ch 16](17-roles.md)) — you're the whole team
- Organizational change ([Ch 18](19-organizational-change.md)) — nobody to convince but yourself

### What to Read
[Ch 1](01-why-flow.md) (Why FLOW), [Ch 2](02-mental-model.md) (Modes — focus on Collapsed), [Ch 3](03-decision-spine.md) (Spine — mental/informal), [Ch 5](06-discovery-brief.md) (Brief — minimum 3-field), [Ch 6](07-experiments.md) (Experiments — your code IS the experiment), [Ch 12](13-wip-limits.md) (WIP — your limit is 1-2).

---

## Agency & Client Work

### Your FLOW in 5 Minutes
1. **Spine**: Client owns Vision and Strategy. You own Bet and Cycle. Construct the upper spine from client conversations if they don't provide it.
2. **Mode**: Classify every client request. Some need Discovery (paid deliverable), some are Outcome (build to spec).
3. **Discovery as Revenue**: Discovery Brief = paid deliverable ("Discovery Phase: $10K-20K for validated hypothesis"). Shaping = billable workshop ($3K-5K).
4. **SPEC-Lite as Scope Doc**: Your one-page client-facing scope agreement. Problem, Scope, Metric, Kill Condition, Non-Goals. Replaces ambiguous SOWs.
5. **Kill Conditions with Clients**: Reframe as risk management. "This protects your investment — we stop early if the approach isn't working."
6. **WIP**: Measured per team, not per client. 4 clients with 3 WIP limit means one client queues.
7. **Mode Transition**: Client-gated. Client approves moving from Discovery to Outcome.

### Your Roles in FLOW
| Your Title | FLOW Function | Key Shift |
|-----------|---------------|-----------|
| Project Coordinator | Flow Coach | From tracking tasks to facilitating decisions and guarding gates |
| Account Manager | Intake Authority (client-facing) | From relationship management to strategic intake |
| Developer | Builder | Same — but co-owns Build Contract |
| Designer | Experiment Architect | From client mockups to experiment design |
| QA | Quality Intelligence | From test scripts to quality kill conditions |

### Client Education on Agentic Speed
When your team uses agentic tools, clients will notice builds are fast. Two problems arise:
1. **"Charge me less"** — they equate time with cost. Your value is the outcome, not the hours. The SPEC-Lite scope doc helps: "This is what we're delivering, this is how we measure success."
2. **"Change scope every day"** — they see speed and want constant pivots. Explain: the build is fast, but the observation window is fixed. Changing scope mid-observation invalidates the experiment. Use the metric maturity table to show why 2 weeks of data is 2 weeks regardless of build speed.

### What Changes for Agencies
- **Intake happens at two levels**: Client-facing (relationship management) and internal (classification and routing)
- **Kill authority**: You can't kill what the client paid for — but you can present evidence and recommend stopping. Frame kills as fiduciary responsibility.
- **Multiple cadences**: Each client may have different ritual schedules. Your internal cadence (weekly triage) is separate from client cadences.
- **Learning Archive**: Critical for agencies — knowledge walks out the door when projects end. Archive EVERYTHING.
- **Discovery avoidance is YOUR biggest risk**: Clients say "just build it." Your job is to sell learning before building.
- **Agent-built demos**: Agents can generate demo artifacts after each build — video, interactive prototype, slide deck. Clients love fast turnaround on demos. But demos are not evidence of value.

### What to Read
All chapters — but read every agency sidebar. Especially: [Ch 4](05-intake.md) (dual-level intake), [Ch 5](06-discovery-brief.md) (Discovery as deliverable), [Ch 8](09-spec-lite.md) (SPEC-Lite as scope doc), [Ch 11](12-outcome-decisions.md) (killing when client pays), [Ch 18](19-organizational-change.md) (selling FLOW to clients).

---

## Hardware & Physical Products

### Your FLOW in 5 Minutes
1. **Modes are Sequential**: Discover FIRST, build SECOND. You can't iterate cheaply on hardware.
2. **Experiment Hierarchy shifts**: Conversation ($0) → desk research ($0) → digital mockup ($200) → simulation ($500) → functional prototype ($5K) → field pilot ($15K) → manufacturing run ($50K+).
3. **Cost tracking matters**: Every Experiment Log entry must include cost. Hardware experiments are expensive — knowing what you spent is essential for ROI decisions.
4. **Cycles are longer**: 12-week cycles are normal. Adjust ritual cadence: monthly Discovery Review, monthly Outcome Review, quarterly Kill/Merge.
5. **Production Readiness = Manufacturing Readiness**: Supply chain confirmed, quality assurance process defined, field support plan in place.
6. **Kill conditions save SERIOUS money**: A $5,000 killed prototype is better than a $500,000 failed manufacturing run.

### What Changes for Hardware
- **"Building" includes manufacturing**: FLOW's "product teams building under uncertainty" explicitly includes physical products.
- **Feature flags don't exist**: The hardware equivalent is a limited production run (100 units) before the full order (10,000).
- **Field testing replaces A/B testing**: You can't split-test a solar panel. Field pilots with small deployments are your experiment mechanism.
- **Observability means field telemetry**: Sensors, scheduled field visits, or customer surveys. Not dashboards in real-time.

### What to Read
[Ch 1](01-why-flow.md)-[3](03-decision-spine.md) (Foundation), [Ch 5](06-discovery-brief.md)-[6](07-experiments.md) (Discovery + Experiments — read hardware sidebars carefully), [Ch 10](11-execution.md) (Execution on long cycles), [Ch 14](15-production-readiness.md) (Manufacturing readiness).

---

## Enterprise (30+ People, Multiple Teams)

### Your FLOW in 5 Minutes
1. **Spine is governance**: Vision → Strategy → Bet → Cycle maps to your planning hierarchy. Map your 6 levels down to 4.
2. **Intake needs a coordinator**: A Technical Program Manager or intake lead who routes cross-team work.
3. **Gates are governance events**: Gate reviews are formal, documented, and attended by decision authorities.
4. **Mode transitions are leadership-reviewed**: Governance-gated pattern. The PM proposes, leadership approves.
5. **WIP is portfolio-level**: Each squad has its own limit. Portfolio WIP = sum of squad limits. Leadership respects the total.
6. **Kill decisions need political cover**: Evidence-based gates give PMs the data to justify kills. Frame as investment protection.
7. **Cross-team dependencies**: Platform spine topology. Dependency syncs. Portfolio syncs. [Chapter 13](14-rituals.md) rituals.

### Your Roles in FLOW
| Your Title | FLOW Function | Key Shift |
|-----------|---------------|-----------|
| Business Analyst | Discovery Specialist | From gathering requirements to validating hypotheses |
| QA Engineer | Quality Intelligence Specialist | From test cases to quality kill conditions |
| DevOps / SRE | Evidence Infrastructure Owner | From pipeline maintenance to observability ownership |
| Data Analyst | Evidence Interpreter | From pulling data on request to presenting Kill/Merge evidence |
| Compliance Officer | Gate Advisor | From post-hoc review to embedded gate advisor |
| Scrum Master | Flow Coach | From facilitating ceremonies to guarding gates and enforcing kills |
| Technical Writer | Knowledge Architect | From documenting builds to curating learnings |
| Solution Architect | Build Contract Co-Owner | From upfront design to embedded technical advisor |

### Multi-Tempo Coordination
In enterprise, different teams will have different Tempos. A team with agentic tooling may run 1-day cycles while a team doing compliance work runs 4-week cycles. This creates coordination challenges:
- **Dependency Whiplash**: Fast teams iterate on APIs that slow teams depend on. Mitigation: API contract versioning + dependency WIP limits.
- **Speed Inequality**: Fast teams feel elite, slow teams feel pressured. Mitigation: Tempo is self-assessed, never compared across teams. No "agentic leaderboard."
- **Portfolio Cadence** keeps everyone synchronized regardless of individual Tempo. The monthly portfolio review is where all teams align.

### What Changes for Enterprise
- **Organizational Change ([Ch 18](19-organizational-change.md)) is your most important chapter**: Without executive sponsorship, FLOW won't survive the organizational antibodies.
- **Regulated Environments ([Ch 15](16-regulated-environments.md))**: Map FLOW gates to your compliance framework. FLOW evidence satisfies audit requirements.
- **Team Topology ([Ch 16](17-roles.md))**: Different team types use FLOW differently. Stream-aligned teams use it directly. Platform teams need branching spines. Enabling teams lean toward Discovery mode.
- **Migration ([Ch 17](18-migration.md))**: Start with one pilot squad. Expand based on evidence. Don't do Big Bang.
- **FLOW Configuration per squad**: Each squad declares its Tempo, SPEC minimum, and WIP limits. Portfolio leadership reviews configurations quarterly.

### What to Read
All chapters — enterprise readers need the full methodology. Focus especially on: [Ch 3](03-decision-spine.md) (Spine mapping), [Ch 4](05-intake.md) (Intake authority), [Ch 12](13-wip-limits.md) (WIP), [Ch 15](16-regulated-environments.md) (Regulated), [Ch 16](17-roles.md) (Topology), [Ch 17](18-migration.md)-[18](19-organizational-change.md) (Migration + Change).

---

## Government & Public Sector

### Your FLOW in 5 Minutes
1. **Spine maps naturally**: National Vision → Sector Strategy → Program (Bet) → Project Deliverable (Cycle).
2. **"Bet" → "Investment Hypothesis"**: Use language your ministry will adopt. The concept is the same.
3. **Discovery = Feasibility Study**: You already do feasibility. FLOW adds structure (Brief, experiments, gates) and evidence requirements.
4. **Gates coexist with PRINCE2/PMI**: FLOW gates operate WITHIN existing stage gates, not instead of them. Multiple FLOW cycles per PRINCE2 stage.
5. **Benefits realization built in**: Target metrics = benefits. Post-merge monitoring = benefits realization tracking.
6. **Vendor management**: Build Contract specifies vendor responsibilities. Kill/Merge Record documents vendor delivery against Contract.
7. **Delegation of authority**: Not everything goes to the minister. Define which mode transitions need which approval level.

### Your Roles in FLOW
| Your Title | FLOW Function | Key Shift |
|-----------|---------------|-----------|
| Business Analyst | Discovery Specialist | From requirements to evidence-based hypotheses |
| Solution Architect | Build Contract Co-Owner | From HLD/LLD to embedded technical advisor |
| Change Manager | Flow Coach | From stakeholder comms to decision facilitation |
| Compliance / Audit | Gate Advisor | From post-review to embedded gate advisor |
| Program Manager | Decision Maker (portfolio level) | From milestone tracking to Kill/Merge governance |

### What Changes for Government
- **Formal documentation**: All FLOW artifacts (Briefs, SPECs, Contracts, Decision Records) become compliance documents. Retention per regulatory requirements.
- **Procurement constraints**: Vendor selection takes months. You can't pivot vendors mid-cycle. The spine and kill conditions must account for contractual commitments.
- **Multi-vendor coordination**: Multiple consulting firms + government staff. The Build Contract must specify which vendor owns which component.
- **Benefits realization**: Government measures citizen outcomes (adoption, satisfaction, cost savings), not revenue. Target metrics must reflect public value.
- **Arabic-first documentation**: If required, all FLOW artifacts should be producible in Arabic. Use bilingual templates.

### What to Read
[Ch 1](01-why-flow.md)-[3](03-decision-spine.md) (Foundation — spine mapping is your entry point), [Ch 15](16-regulated-environments.md) (Regulated environments — your core chapter), [Ch 17](18-migration.md) (Migration from PRINCE2), [Ch 18](19-organizational-change.md) (Ministerial buy-in).

---

*Document version: 1.1 (Meeting #13: Agentic Speed backport)*
*Total chapters: 23*
*Total words: ~40,000*
*Completed: 2026-03-19*
*Agent: Waddah (وضّاح)*

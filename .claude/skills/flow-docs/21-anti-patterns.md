> Part VII: Reference | [← Previous](20-ai-agents.md) | [Next →](22-glossary.md)

# Chapter 20: Anti-Patterns Catalog

> *Panel-reviewed: Meeting #8, updated Meeting #13 (2026-03-19)*
> *Updated: Meeting #14 — Sycophantic Validation, Mode Amnesia*
> **Read this**: Everyone, especially Flow Coaches. Recognize these patterns in your team and fix them.

---

## How to Use This Catalog

Each anti-pattern follows a structure: **Name** → **What it looks like** → **Why it happens** → **What to do about it**. If your team recognizes themselves in any of these, that's not a failure — it's self-awareness. The fix is always actionable.

---

## 1. Process Theater
**What it looks like**: The team fills out Discovery Briefs, runs "experiments," holds rituals — but nothing changes. Briefs are filed and forgotten. Experiments confirm what the team already decided to build. Kill/Merge meetings always result in "Continue."

**Why it happens**: The team adopted FLOW's artifacts without adopting its mindset. They're performing process, not making decisions.

**What to do**: The Flow Coach asks one question at every ritual: "What DECISION did we make today?" If the answer is "none," the ritual failed. Cancel the next one until there's something to decide.

---

## 2. Discovery Avoidance
**What it looks like**: Every new item gets classified as Outcome. "We already know what to build." The team writes SPEC-Lites for features they've never validated. Discovery mode is technically available but never used.

**Why it happens**: Building feels productive. Learning feels slow. Engineers want to code, PMs want to ship, stakeholders want deliverables. Discovery feels like delay.

**What to do**: Track the ratio of Discovery to Outcome classifications. If it's less than 20% Discovery, the team is probably building before understanding. Challenge: "What evidence do we have that users want this? None? That's a Discovery Brief, not a SPEC-Lite."

---

## 3. Zombie Cycles
**What it looks like**: Cycles that have been "in progress" for months. Nobody actively works on them, but they haven't been killed. They sit on the board, consuming a WIP slot, occasionally getting "one more sprint" of effort.

**Why it happens**: Killing is emotionally hard. The team invested time and effort. The stakeholder who requested it is still around. Nobody wants to be the one to pull the plug.

**What to do**: WIP limits force the conversation. "We're at capacity. To start this new bet, which of these zombies are you willing to kill?" Also: institute a "maximum continue" rule — a cycle can be continued at most twice ([Chapter 11](12-outcome-decisions.md)). After two continues, it's Kill or Merge. No third extension.

---

## 4. Scope Creep by Consensus
**What it looks like**: "While we're at it, could we also add...?" Each addition is small. The team agrees because each one seems reasonable. After 4 weeks, the scope is 3x the original SPEC-Lite.

**Why it happens**: Individual additions feel cheap. Nobody tracks the cumulative impact. The Non-Goals field is either absent or not enforced.

**What to do**: Enforce Non-Goals ruthlessly. Every "could we also" request is checked against Non-Goals. If it's listed there: "That's a non-goal for this cycle. File it as a new intake item ([Chapter 4](05-intake.md))." If Non-Goals are empty, the SPEC-Lite doesn't pass O2.

---

## 5. WIP Inflation
**What it looks like**: The team starts new work without killing old work. The WIP count grows: 3 → 5 → 8. "Everything is important." Everything is in progress. Nothing is finishing.

**Why it happens**: Starting is easier than stopping. New requests come with urgency and enthusiasm. Old work comes with fatigue and uncertainty.

**What to do**: Hard WIP limits. No exceptions. "We're at 5 of 5. You want to start this? What dies?" The Flow Coach owns this enforcement. If leadership demands an exception, document it as a WIP override ([Chapter 18](19-organizational-change.md)).

---

## 6. Gate Skipping
**What it looks like**: "We don't have time for gate checks. Let's just start building." The team writes a Brief but skips D1. They write a SPEC but skip O2. They build without a Contract (O3 skipped). They ship without observability (O4 skipped).

**Why it happens**: Under pressure, process feels like overhead. "We already know this is right." Pressure comes from deadlines, stakeholders, or the team's own impatience.

**What to do**: Gates are not optional. The Flow Coach blocks work that hasn't passed the relevant gate. "This SPEC has no kill condition. O2 doesn't pass. We're not starting until it does." If leadership overrides, document the gate skip and track outcomes — gate-skipped features typically have lower adoption and higher waste.

---

## 7. Metric Gaming
**What it looks like**: The team chooses metrics that always look green. "We'll measure page views" (guaranteed to be non-zero). Kill conditions are set at impossibly low thresholds. Success is declared on vanity metrics that don't reflect actual value.

**Why it happens**: The team is optimizing for the appearance of success, not actual success. Often driven by a culture that punishes failure ([Chapter 18](19-organizational-change.md)).

**What to do**: Target metrics must be reviewed at Gate O2. The Flow Coach (or a peer PM) challenges: "Is this metric actually meaningful? Would you change direction based on this number?" If not, it's the wrong metric. Kill conditions should be set at thresholds that would ACTUALLY cause the team to stop — not at levels that can never be reached.

---

## 8. The Infinite Discovery
**What it looks like**: "We need more data." The team runs experiment after experiment without ever transitioning to Outcome mode. Discovery feels safe because you're always "learning" without the risk of building something that fails.

**Why it happens**: Discovery avoids the accountability of shipping. Learning is intellectually satisfying. Building is scary because it can fail publicly.

**What to do**: Time-box Discovery cycles. Maximum 4 weeks per Discovery cycle. If 3 experiments over 4 weeks haven't produced enough evidence to pass Gate D3, it's either: (a) the hypothesis is too vague (refine it), (b) the evidence will never be sufficient (accept uncertainty and move to Outcome), or (c) the team is avoiding the transition (call it out).

---

## 9. Strategic Mapping Theater
**What it looks like**: Every piece of work traces to the spine — on paper. But the mappings are reverse-engineered to justify work that's already decided. "This CEO pet project maps to 'customer excellence'." Technically true, meaninglessly broad.

**Why it happens**: Spine mapping becomes a justification exercise when the culture rewards starting work and punishes questioning it. People learn to write mappings that pass admission control without genuine strategic alignment.

**What to do**: The spine check should be SPECIFIC. Not "this maps to customer excellence" but "this maps to Bet: 'Nurses will adopt scheduling if we reduce clicks by 50%' under Strategy: 'Win Hospital X renewal.'" If the mapping is a vague strategic pillar, it's theater. Push for the specific bet.

---

## 10. The Solo Hero Discovery
**What it looks like**: One person (usually the PM or founder) runs Discovery alone. They design experiments, interpret results, and decide to transition to Outcome without the team's input. The team finds out they're building something when the SPEC appears.

**Why it happens**: Speed. It's faster for one person to think than for a team to discuss. But it breaks the shared understanding that makes Outcome execution smooth.

**What to do**: Discovery artifacts (Briefs, Experiment Logs) must be shared with the team — even in small teams. The minimum: share the Brief at D1, share experiment results at the Discovery Review, make the D3 decision collaboratively. Solo founders are exempt (they ARE the team), but any team of 2+ must involve the team.

---

## 11. Kill Condition Renegotiation
**What it looks like**: The kill condition triggers. The team says: "But wait, maybe the metric was wrong. Let's revise the condition and extend." The revision always makes the condition easier to meet. The cycle continues indefinitely.

**Why it happens**: Sunk cost. Emotional attachment. Fear of looking like the team that "failed."

**What to do**: The 30-minute inspection ([Chapter 1](01-why-flow.md)) is the ONLY mechanism for questioning a triggered kill condition. The inspection evaluates whether the DATA was valid, not whether the team WANTS to continue. If the data is valid, the kill stands. If renegotiation happens outside the inspection framework, the Flow Coach flags it as this anti-pattern.

---

## Agentic Anti-Patterns

The following anti-patterns are caused specifically by high execution leverage — when agentic tooling compresses build time, new failure modes emerge that traditional process never encountered.

---

## 12. Premature Confidence
**What it looks like**: The team ships fast and assumes speed equals progress. 10 features in production, no evidence any of them work. Dashboards show deployment counts, not outcome metrics. The team feels productive because things are moving.

**Why it happens**: Shipping fast creates the illusion of progress. When build cost approaches zero, the feedback loop between "we built it" and "it works" gets conflated. The dopamine of deployment replaces the discipline of observation.

**What to do**: Institute an **Observation Floor** — a minimum observation window before any kill/merge decision, determined by metric maturity and domain constraints (not build speed). Click-through data matures in hours; retention in weeks; revenue in months. No decision before the floor, regardless of how fast the build was.

**Mitigation**: Every merge decision must reference observation data that has matured past the Observation Floor for its metric type.

---

## 13. Experiment Overload
**What it looks like**: Cheap experiments lead to too many running simultaneously. The team launches 15 experiments into observation, but nobody is analyzing the data. Results pile up unreviewed. Kill conditions trigger silently because nobody is watching.

**Why it happens**: When experiments are cheap to run, the bottleneck shifts from build capacity to observation capacity. Teams calibrate WIP limits to how fast they can build, not how fast they can learn.

**What to do**: Calibrate WIP limits to **observation capacity**, not build capacity. The constraint is: "How many concurrent experiments can this team meaningfully observe and decide on?" If the answer is 5, the WIP limit is 5 — even if the team could build 20 in the same period.

**Mitigation**: WIP limits must account for observation queue depth, not just active build slots.

---

## 14. Judgment Fatigue
**What it looks like**: The team faces 5 kill/merge decisions per week instead of 1. Decision quality degrades. Teams start rubber-stamping continues. Kill meetings become perfunctory. The rigor that made early decisions good erodes under volume.

**Why it happens**: Faster cycles produce more decision points per unit of time. Human judgment doesn't scale linearly with execution speed.

**What to do**: Set a recommended maximum decision frequency — guidance: approximately 5 major kill/merge decisions per team per week. Batch decisions where possible (e.g., review all cycles at a single weekly Kill/Merge meeting rather than ad-hoc). If decision volume exceeds capacity, slow down cycle starts — the team is building faster than it can think.

**Mitigation**: Track decision quality (reversal rate, regret rate) alongside decision volume. If reversals spike, reduce cycle concurrency.

---

## 15. Context Collapse
**What it looks like**: An agent builds code the team didn't write. It works. Weeks later, a bug appears. Nobody has the intuition to find it because nobody wrote the code. Debugging takes 10x longer than it would have if a human had built it. The team is shipping code they don't understand.

**Why it happens**: Agentic tools produce working code without transferring understanding. The team skips the learning that normally happens during implementation. When things break, institutional knowledge is absent.

**What to do**: Institute a **Comprehension Review** — the team must demonstrate understanding of agent-built code before it passes Gate O4. This is not code review (which checks correctness) — it's comprehension review (which checks understanding). Scale with SPEC level: Micro-SPEC experiments need lighter review; Full SPEC features need thorough walkthroughs.

**Mitigation**: No agent-built code passes O4 without at least one team member who can explain how it works and where it might break.

---

## 16. Dependency Whiplash
**What it looks like**: Multiple teams shipping 10x faster means API contracts change 10x faster. Team A builds against Team B's API on Monday; by Tuesday it's changed twice. Integration breaks constantly. Teams spend more time adapting to upstream changes than building their own features.

**Why it happens**: High execution leverage amplifies coordination overhead. When everyone ships faster, the surface area of change per unit of time explodes. Dependency management designed for weekly releases breaks at daily or hourly release speeds.

**What to do**: Enforce **API contract versioning** with explicit deprecation windows. Add **dependency WIP limits** — cap the number of breaking changes a platform team can introduce per cycle. Downstream teams pin to contract versions and upgrade on their own cycle, not reactively.

**Mitigation**: Platform teams must version APIs and hold contracts stable for a minimum window proportional to downstream team cycle times.

---

## 17. Maintenance Debt
**What it looks like**: The team builds 10 features in a week, kills 7, but the 3 survivors need ongoing maintenance. Next week: 3 more survivors. The maintenance surface grows faster than the team's capacity to maintain. Eventually, the team spends more time maintaining than building.

**Why it happens**: Kill decisions account for build cost (already sunk) and outcome metrics, but not future maintenance cost. Every merge is an implicit maintenance commitment, and that commitment accumulates.

**What to do**: Include **maintenance cost** in every kill/continue/merge decision. Before merging, ask: "What does maintaining this feature cost per cycle?" Factor that into WIP capacity — every merged feature reduces available WIP for new work. If the team is maintenance-saturated, the correct action is to kill existing features before building new ones.

**Mitigation**: Track maintenance load as a percentage of team capacity. When it exceeds 40%, freeze new cycle starts until load is reduced.

---

## 18. Speed Inequality
**What it looks like**: Some teams adopt agentic tools faster than others. Fast teams ship 10x more. Management starts comparing teams. "Why can't Team B keep up with Team A?" Slow teams feel pressured, cut corners, skip gates. Fast teams feel elite, resist process that "slows them down."

**Why it happens**: Execution leverage varies across teams based on domain complexity, tooling maturity, team composition, and organizational constraints. Management treats output volume as a productivity metric without accounting for these differences.

**What to do**: Tempo is self-assessed, never compared across teams. There is no "agentic leaderboard." Each team's FLOW Configuration ([Chapter 14](15-production-readiness.md)) declares its own Tempo based on its context. Management reviews portfolio health (outcomes and signals), not throughput volume.

**Mitigation**: Ban cross-team velocity comparisons. Review teams on outcome quality and decision rigor, not cycle count.

---

## 19. Sycophantic Validation (Meeting #14)
**What it looks like**: The agent (or coach) agrees with everything the team presents. "Great hypothesis!" "Strong kill condition!" "This Brief looks solid!" Gate checks pass with no pushback. Kill/Merge meetings produce unanimous continues with the agent reinforcing the team's existing beliefs.

**Why it happens**: Agents are trained to be helpful, and helpfulness is often conflated with agreement. Human coaches face social pressure — challenging a PM's Brief feels confrontational. The path of least resistance is validation. Over time, the team learns that gates are rubber stamps, not quality filters.

**What to do**: Implement the anti-sycophancy behavioral rules from [Chapter 19](20-ai-agents.md): challenge don't validate, never soften kill recommendations, ask the three gate questions with evidence ratings. For human coaches: adopt the evaluation tone calibration — warm on process, cold on decisions. Track gate failure rates — if gates never fail, the evaluator isn't doing their job.

**Mitigation**: At L2+, every gate evaluation must include at least one challenge question and one evidence rating below "Strong." If the evaluator can't find a single weakness, they haven't looked hard enough.

---

## 20. Mode Amnesia (Meeting #14)
**What it looks like**: The team starts a Discovery cycle, runs an experiment, gets excited about early results, and starts building a production feature without passing D3 or writing a SPEC. Or: an agent assists with a Brief in one session, but the next session starts fresh with no knowledge of the active cycle. The FLOW context is lost between skill invocations.

**Why it happens**: Without persistent state, every interaction is a blank slate. The agent doesn't know a cycle is active. The team forgets they're in Discovery and slips into Outcome behavior. The mode boundary — the most important structural decision in FLOW — dissolves.

**What to do**: Use the Cycle State File (`active-cycle.json`) to persist context between sessions. Every FLOW skill invocation reads the state file and orients to the active cycle. If no state file exists but the team is clearly mid-cycle, the first action is to reconstruct state. At L2+, Ambient Rule #8 (Cycle Continuity) flags skipped steps and missing gate passages.

**Mitigation**: The state file is infrastructure, not optional. If a team is using FLOW skills without a state file, they're at L1 (advisory) by definition — regardless of what their Configuration claims.

---

*Next: [Chapter 21 — Glossary →](22-glossary.md)*

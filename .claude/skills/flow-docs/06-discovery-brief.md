> Part III: Discovery Mode | [← Previous](05-intake.md) | [Next →](07-experiments.md)

# Chapter 5: The Discovery Brief

> *Panel-reviewed: Meeting #4 (2026-03-19) — 7 agree, 4 modify-accept*
> *Updated: Meeting #14 — Research Output Standards, Anti-Sycophancy*
> **Read this**: PMs, BAs, Designers — anyone writing or reviewing Discovery Briefs.

---

## What a Discovery Brief Is

A Discovery Brief is a **one-page hypothesis document** that defines what you're trying to learn, how you'll learn it, and when you'll stop. It's the first artifact in Discovery mode — written after intake classifies work as "we need to learn before we build."

The Discovery Brief is NOT:
- A requirements document (it doesn't say WHAT to build)
- A project plan (it doesn't say HOW LONG it takes)
- A business case (it doesn't justify ROI)
- A SPEC-Lite (that comes later, in Outcome mode, after you've learned)

The Discovery Brief IS:
- A falsifiable hypothesis
- A designed experiment
- A pre-committed kill condition
- A shared understanding of what "learning" means for this work

It draws from the Lean UX hypothesis format ("We believe [capability] will result in [outcome]. We will know when [signal]") and adds FLOW's distinctive contribution: the kill condition and the gate mechanism.

> **Cross-reference**: Learnings from Discovery Briefs are archived via [Chapter 7](08-discovery-decisions.md) (Discovery Decisions) and feed into the shared Learning Archive covered in [Chapter 11](12-outcome-decisions.md) (Outcome Decisions).

---

## The Anatomy

Shaping ([Chapter 4](05-intake.md)) identified the boundary, the risk, and the mode. Now refine that into a falsifiable document. In enterprise contexts, the **Business Analyst** (Discovery Specialist — see [Ch 16](17-roles.md)) is often the primary author of the Discovery Brief, drawing on stakeholder evidence and domain expertise. In smaller teams, the PM writes it. The risk identified during shaping becomes the **Hypothesis**. The boundary becomes the **Problem Statement**. The mode (Discovery) tells you to write a Brief, not a SPEC-Lite.

### Full Discovery Brief (5 fields — for teams)

| Field | What It Answers | Example |
|-------|----------------|---------|
| **Problem Statement** | What problem are we investigating? Who has it? What evidence suggests it exists? | "Hospital nurses at 3 partner sites report spending 40+ minutes per shift on schedule coordination. Evidence: 12 support tickets in Q1, 3 customer escalations." |
| **Hypothesis** | What do we believe? Structured as: "We believe [users] have [problem] because [reason]." | "We believe nurses spend excessive time on scheduling because the current system requires manual WhatsApp coordination across 3 shift groups." |
| **Experiment Design** | How will we test this hypothesis? What's the cheapest valid experiment? | "Shadow 5 nurses at Hospital X for 2 days each. Record time spent on scheduling activities. Interview each nurse about pain points." |
| **Kill Condition** | When do we stop? What evidence would prove us wrong? | "If fewer than 3 of 5 nurses cite scheduling as a top-3 pain point, OR if average scheduling time is under 15 minutes/shift, we kill this hypothesis." |
| **Success Signal** | What does validated look like? Not "it works" — specific, measurable. | "4+ of 5 nurses cite scheduling as top-3 pain. Average scheduling time exceeds 30 min/shift. At least 2 describe a workaround they've built (signal of unmet need)." |

### Minimum Discovery Brief (3 fields — for solo founders and collapsed mode)

| Field | Example |
|-------|---------|
| **Hypothesis** | "Developers on teams of 5-20 will pay $29/month for AI code reviews if accuracy exceeds 80%." |
| **Kill Condition** | "If fewer than 5 of 20 beta users continue after the free trial, kill it." |
| **Experiment** | "Offer free 2-week trial to 20 developers from my Discord community. Track daily active usage and post-trial conversion." |

The minimum Brief works when one person holds all the context. The full Brief works when multiple people need to align — the Problem Statement and Success Signal prevent the team from having different mental models of what they're investigating.

---

## Writing Good Hypotheses

A hypothesis is not a wish. It's a structured belief that can be proven wrong.

**Bad hypothesis**: "Users will love our scheduling feature."
- Can't be falsified (what does "love" mean?)
- No specific user segment
- No causal mechanism

**Good hypothesis**: "We believe nurses at hospitals with 50+ beds have difficulty managing shift schedules because they currently coordinate via WhatsApp groups with 15+ participants."
- Specific user segment (nurses, 50+ bed hospitals)
- Specific problem (difficulty managing shift schedules)
- Causal mechanism (WhatsApp groups with 15+ participants)
- Falsifiable (observe whether they actually use WhatsApp for this, measure the difficulty)

### The Hypothesis Formula

> **"We believe [specific users] have [specific problem] because [observable reason]. We will test this by [experiment]. We will know we're wrong if [kill condition]."**

---

## Discovery Brief vs. SPEC-Lite

These two artifacts serve different modes:

| | Discovery Brief | SPEC-Lite |
|---|----------------|-----------|
| **Mode** | Discovery (learning) | Outcome (shipping) |
| **Purpose** | Test a hypothesis | Ship a solution |
| **Output** | Evidence (validated or invalidated) | Working product |
| **Key question** | "Is this problem real?" | "Can we solve this problem with this approach?" |
| **Kill condition** | "Stop if the hypothesis is wrong" | "Stop if the metric doesn't move" |
| **When to use** | Before you know what to build | After you know what to build |

The transition: a validated Discovery Brief produces evidence. That evidence feeds into a SPEC-Lite. "We now KNOW nurses spend 40 min/shift on scheduling. The SPEC says: reduce it to 10 min with an automated shift-swap feature. Kill if adoption < 30% in 4 weeks."

---

## Gate D1: Is This Brief Ready to Pursue?

Before the team invests time in an experiment, the Brief passes through Gate D1:

### D1 Checklist

- [ ] **Problem is specific.** Not "users are unhappy" but "nurses at Hospital X spend 40 min/shift on scheduling."
- [ ] **Hypothesis is falsifiable.** There exists a realistic experimental outcome that would DISPROVE the hypothesis.
- [ ] **Experiment is designed.** The team knows what they'll do, who they'll talk to, and what they'll measure.
- [ ] **Experiment is the cheapest valid option.** The team has considered whether a conversation, desk research, or mockup could answer the question before building a prototype.
- [ ] **Kill condition is pre-committed.** Written before the experiment starts. Specific. Measurable. The team agrees that if this condition is met, they stop.
- [ ] **Success signal is defined** (full Brief only). The team knows what "validated" looks like — not just "not killed."
- [ ] **Spine traces.** The hypothesis connects to an active bet on the Decision Spine.

If any item fails, the Brief goes back for revision. Gate D1 is a quality filter, not a bureaucratic hurdle — a Brief with a vague hypothesis wastes the team's experiment time.

> **Anti-Sycophancy at D1 (Meeting #14)**: When an agent or coach evaluates a Discovery Brief at Gate D1, they must **challenge, not validate**. The evaluator's job is to find weaknesses — vague hypotheses, generous kill conditions, experiments that confirm rather than test. If the Brief passes too easily, the gate isn't working. Evaluation tone at gates should be warm on process guidance ("here's how to improve this hypothesis") but cold on the pass/fail decision ("this kill condition is too generous — it won't trigger even if the hypothesis is wrong"). See [Chapter 19](20-ai-agents.md) for the full anti-sycophancy behavioral rules.

---

## Research Output Standards (Meeting #14)

When a Discovery Brief references research — desk research, competitive analysis, market data, or any claim about the world — the research must meet three standards:

### Confidence Markers

Every factual claim carries a confidence tag:

| Marker | Meaning | When to use |
|--------|---------|-------------|
| **[verified]** | Confirmed from a primary or authoritative source | Official statistics, direct quotes, published data |
| **[likely]** | Supported by multiple secondary sources or strong inference | Industry reports, consistent analyst estimates |
| **[VERIFY]** | Unconfirmed — requires validation before acting on it | Single-source claims, hearsay, outdated data |

Claims tagged `[VERIFY]` must not be used as the sole basis for a kill condition or success signal. They can inform hypothesis direction but require validation before the team commits resources.

### Research Provenance

Every claim must attribute its source type:

- **Primary source**: Direct data (your own analytics, first-party interviews, official filings)
- **Secondary source**: Interpreted data (industry reports, news articles, analyst estimates)
- **Tertiary source**: Aggregated or opinion-based (blog posts, social media, unverified claims)

Primary sources carry the most weight in Discovery decisions. A hypothesis grounded entirely in tertiary sources should be treated with skepticism at Gate D1.

### "What Could Be Wrong?" — Mandatory Self-Critique

Every research section in a Discovery Brief must include a brief "What Could Be Wrong?" paragraph: what assumptions does this research rest on? What biases might be present? What would invalidate these findings? This is not optional — it is a structural requirement. Research without self-critique is advocacy, not investigation.

---

*Sidebars:*

*Agency: The Discovery Brief is a paid deliverable. Scope it as "Discovery Phase — deliverable is a validated/invalidated hypothesis with experiment results and recommendation." Price range: $5K-20K depending on experiment complexity. The client pays for LEARNING, not building. Frame it as risk reduction: "This $10K Discovery Phase could save you $200K in wasted development."*

*Hardware: A hardware Discovery Brief may reference desk research, CAD simulations, or teardown analysis as experiments — not just user conversations. The hypothesis might be about technical feasibility ("We believe this controller design can handle 50°C ambient temperature") not just user desirability.*

---

*Next: [Chapter 6 — Experiments →](07-experiments.md)*

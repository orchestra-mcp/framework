> Part III: Discovery Mode | [← Previous](06-discovery-brief.md) | [Next →](08-discovery-decisions.md)

# Chapter 6: Experiments

> *Panel-reviewed: Meeting #4 (2026-03-19) — 7 agree, 4 modify-accept*
> *Updated: Meeting #14 — Confidence Markers, Provenance, Expert Review Gate*
> **Read this**: Designers (Experiment Architects), PMs, Engineers. **Skip if**: You're only doing Outcome-mode work right now.

---

## The Experiment Principle

> **Always choose the cheapest experiment that can validly answer your question.**

This is the only rule. Everything else is context-specific guidance.

Production code is the most expensive way to learn something. A conversation is usually the cheapest. Between them lies a spectrum of experiment types, each with different cost, speed, and fidelity trade-offs. The right experiment depends on what you're trying to learn, not on a prescribed sequence.

---

## Experiment Types (Menu, Not Ladder)

The following experiment types are ordered by TYPICAL cost, but the right choice depends on your question. Sometimes a prototype is cheaper than a survey. Sometimes a conversation answers what a prototype can't.

### Conversation ($0 — hours)
Talk to users, customers, stakeholders, or domain experts. Ask open-ended questions. Listen for problems, workarounds, and emotional signals.

*Best for*: Validating whether a problem exists. Understanding user language and mental models. Early-stage hypotheses.

*Not valid for*: "Would you use this?" questions (people say yes to everything). Usability testing. Performance questions.

### Desk Research ($0 — hours to days)
Analyze existing data: analytics, support tickets, competitor products, academic papers, market reports, internal databases.

*Best for*: Quantifying a known problem. Understanding market landscape. Finding evidence that already exists.

*Not valid for*: Novel problems nobody has studied. User behavior in your specific context.

### Mockup / Wireframe ($0-500 — hours to days)
Create visual representations of a potential solution. Can be paper sketches, Figma prototypes, or digital renders.

*Best for*: Testing whether users understand a concept. Getting feedback on information architecture. Stakeholder alignment.

*Not valid for*: "Does this FEEL right?" questions (needs interaction). Performance validation. Emotional response testing.

### Clickable Prototype ($500-2K — days to a week)
A functional-looking but non-functional prototype. Users can click through flows but no real logic executes.

*Best for*: Usability testing. Flow validation. Stakeholder buy-in before building.

*Not valid for*: Performance testing. Integration validation. "Will users come back?" questions.

### Concierge ($0-1K — days to weeks)
Manually deliver the value that your product would automate. You ARE the product. No code required.

*Best for*: Validating whether users want the VALUE, regardless of the delivery mechanism. Testing willingness to pay.

*Not valid for*: Scale testing. Technical feasibility. Products where the experience IS the technology (games, AI tools).

### Wizard of Oz ($1K-5K — weeks)
Users interact with what looks like a product, but a human is operating it behind the scenes.

*Best for*: Testing the full user experience before building the backend. Validating workflows.

*Not valid for*: Performance-sensitive products. Products where latency matters. Long-term retention testing.

### Limited Build / MVP ($5K-50K — weeks to months)
Build the smallest functional version of the product that real users can use. Instrumented for measurement.

*Best for*: Retention and engagement testing. Real-world behavior (not stated preferences). Willingness to pay at scale.

*Not valid for*: If cheaper experiments could answer the question. This is a LAST RESORT, not a starting point.

### Context-Specific Experiment Types

**Hardware / Physical Products:**

| Type | Typical Cost | Duration | Valid For |
|------|-------------|----------|----------|
| Conversation | $0 | Hours | Problem validation |
| Desk research | $0 | Days | Market sizing, competitor analysis |
| Digital mockup / CAD render | $200-500 | Days | Stakeholder alignment, visual testing |
| Simulation / thermal analysis | $500-2K | Days-weeks | Technical feasibility without physical build |
| Functional prototype | $3K-10K | 4-12 weeks | Real-world performance testing |
| Field pilot | $10K-50K | Months | User adoption in actual environment |
| Manufacturing run | $50K+ | Months | Scale validation |

**Gaming / Creative:**

| Type | Typical Cost | Duration | Valid For |
|------|-------------|----------|----------|
| Paper prototype / tabletop test | $0 | Hours | Core mechanic validation |
| Greybox prototype (no art) | $1K-3K | Days-weeks | "Is this fun?" testing |
| Vertical slice | $10K-30K | Weeks-months | Full experience validation for one level/section |
| Playtest with target audience | $1K-5K | Days | Emotional response, difficulty tuning |

**Agency / Client Work:**

| Type | Typical Cost (to client) | Duration | Valid For |
|------|--------------------------|----------|----------|
| Stakeholder interview | $1K-3K | Days | Understanding real requirements |
| Competitive analysis | $2K-5K | Week | Market positioning |
| Clickable prototype | $3K-8K | 1-2 weeks | Client buy-in, user testing |
| Limited build | $15K-50K | 2-6 weeks | Market validation |

---

## Designing the Right Experiment

When choosing an experiment, ask:

1. **What specific question am I answering?** Not "is this a good idea?" but "will nurses use a shift-swap button on their phone during a shift?"

2. **What's the cheapest way to get a VALID answer?** Valid = the experiment actually tests the hypothesis. A survey asking "would you use this?" is cheap but not valid for behavior prediction.

3. **What's my kill condition?** Define it before the experiment starts. Write it into the Discovery Brief.

4. **Do I need PERMISSION to run this?** In regulated environments, experiments involving real users or real data may require approval — ethics review, data privacy clearance, or regulatory sandbox authorization. If permission is denied, REDESIGN the experiment with synthetic data or simulated inputs. Don't abandon the hypothesis — find a permissible way to test it.

5. **Does this experiment span teams?** If so, the team with the hypothesis owns the Experiment Log. Supporting teams document their contribution in their own logs with a cross-reference.

---

## The Experiment Log

Every experiment produces a record. The log prevents: re-running experiments that already have answers, losing institutional memory when people leave, and making decisions without evidence.

### Log Entry Fields

| Field | Content |
|-------|---------|
| **Date** | When the experiment ran |
| **Hypothesis** | What we were testing (reference the Discovery Brief) |
| **Experiment type** | Which type from the menu above |
| **Cost** | What it cost (time, money, resources) — especially important for hardware |
| **What happened** | Raw results, observations, data |
| **What we learned** | Interpretation — what does this mean? |
| **Decision** | Continue, Refine, Pivot, Stop, or Escalate |
| **Next action** | What happens next based on the decision |

### Confidence Markers and Provenance on Results (Meeting #14)

Experiment results must carry the same rigor as research claims. When logging results:

- Tag quantitative findings with confidence markers: `[verified]` for instrumented metrics, `[likely]` for estimated or sampled data, `[VERIFY]` for self-reported or anecdotal evidence.
- Attribute provenance: did the finding come from direct measurement (primary), from user interviews (secondary), or from inference (tertiary)?
- Include a "What Could Be Wrong?" line in the "What we learned" field: what assumptions does your interpretation rest on? What would make this result misleading?

These standards prevent the team from treating weak evidence as strong evidence at decision time. See [Chapter 5](06-discovery-brief.md) for the full Research Output Standards.

### Expert Review Gate (Meeting #14)

For experiments that touch specialized domains (medical, legal, financial, regulatory, scientific), an optional **Expert Review Gate** can be inserted between D2 and D3. A domain expert — internal or external — reviews the experiment design and results for domain-specific validity. This is not a FLOW gate (it doesn't have a checklist) — it's a quality insertion point. The expert validates: "Is this experiment measuring what you think it's measuring, given the domain's constraints?" Teams declare whether they use Expert Review in their FLOW Configuration. See [Chapter 16](17-roles.md) for the Domain Expert role.

### Log Anti-Patterns

- **Empty "What we learned"**: Recording data without interpretation. "5 of 8 users clicked the button" means nothing without "which suggests the button placement works but the label confused 3 users."
- **Missing cost**: Especially harmful for hardware teams. If you can't see how much each experiment cost, you can't improve experiment efficiency.
- **Retroactive kill conditions**: Adding the kill condition AFTER seeing results. This defeats the purpose. If the condition wasn't in the Brief, don't pretend it was.

---

## Gate D2: Is the Experiment Well-Designed?

Before spending time and money on an experiment, validate its design. D2 builds on D1 — it re-confirms that the experiment and kill condition are sound (from the Brief), and adds NEW criteria specific to execution readiness: sample quality, duration, permissions, and logging.

### D2 Checklist

- [ ] **The experiment answers the hypothesis.** There's a clear logical connection between what you'll do and what you'll learn.
- [ ] **It's the cheapest valid option.** You've considered cheaper alternatives. If a conversation could answer this, you're not building a prototype.
- [ ] **Sample is appropriate.** You're testing with representative users, not friends and family (unless your product IS for friends and family).
- [ ] **Duration is defined.** The experiment has a start date and an end date. Open-ended experiments are not experiments — they're activities.
- [ ] **Kill condition is specific and measurable.** "If users don't like it" fails. "If fewer than 3 of 10 complete the onboarding flow" passes.
- [ ] **Permission is secured** (if needed). Regulatory, ethical, or organizational approvals are in place.
- [ ] **The log is set up.** You know where you'll record results and who's responsible for logging.

---

## Common Experiment Anti-Patterns

**Building when you should be talking.** You don't need a prototype to learn whether nurses have a scheduling problem. You need 5 conversations.

**Testing solutions before validating problems.** "Let's build a scheduling app and see if nurses use it" skips the question "do nurses actually have a scheduling problem?" Always validate the problem before testing the solution.

**Experiments with no kill condition.** "Let's try it and see what happens" is not an experiment. It's an activity. Without a pre-committed kill condition, you'll always find a reason to continue.

**Choosing the experiment you WANT to build, not the experiment you NEED to run.** Engineers love building prototypes. But if a conversation could answer the question, the prototype is waste — satisfying the builder, not the learner.

**Running the same experiment twice.** Check the Experiment Log before designing a new experiment. Someone may have already tested this hypothesis. Standing on previous evidence is more efficient than re-running tests.

---

*Next: [Chapter 7 — Discovery Decisions & Gates →](08-discovery-decisions.md)*

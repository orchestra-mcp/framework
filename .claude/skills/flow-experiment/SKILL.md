# FLOW Experiment — Design the Cheapest Valid Test

> **Trigger**: A Discovery Brief has passed Gate D1. Now design the specific experiment to test the hypothesis.
> **Reference**: Chapter 6 (Experiments), Chapter 7 (Discovery Decisions)

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

## The Core Principle

> **Always choose the cheapest experiment that can validly answer your question.**

Production code is the most expensive way to learn something. A conversation is usually the cheapest. The right experiment depends on what you're trying to learn, not on a prescribed sequence.

### Collapsed Mode — When Building IS the Experiment

When build cost approaches zero (agentic tooling, no-code platforms, existing infrastructure), the experiment hierarchy collapses. If building a working prototype takes less time than designing a mockup, **building IS the experiment**. Don't force artificial cheapness when the "expensive" option is actually cheaper.

> **Key signal**: If your team can ship a functional version in hours using AI-assisted development, skip the mockup/wireframe/prototype stages and go straight to a limited build. The build IS your cheapest valid test. Log it with `execution_leverage: high` to track this pattern.

## Step 1 — Review the Hypothesis

Read the Discovery Brief. Extract:
- The specific hypothesis being tested
- The kill condition (already pre-committed)
- The success signal (what validated looks like)

Ask: "What specific question does this experiment need to answer?"

> **Coaching note for newcomers**: An experiment is not "let's try it and see." It's a structured test with a specific question, a defined method, and a pre-committed kill condition. Without a kill condition, it's an activity, not an experiment.

## Step 2 — Check the Learning Archive

Before designing a new experiment, search for prior related work:
- Check `tracks/*/ideas.md` and `tracks/*/decisions.md` for past learnings
- Check project files in `projects/` for prior Discovery cycles
- Ask: "Has anyone tested something similar before?"

> **Coaching note**: Standing on previous evidence is more efficient than re-running tests. The Learning Archive (Ch 11) exists to prevent duplicate experiments. Even partial results from a related hypothesis can inform your design.

## Step 3 — Show the Experiment Menu

Present the options ordered by typical cost, with context-specific recommendations:

### Software / Digital Products

| Type | Cost | Duration | Best For |
|------|------|----------|----------|
| **Conversation** | $0 | Hours | Validating whether a problem exists |
| **Desk Research** | $0 | Hours-days | Quantifying a known problem with existing data |
| **Mockup / Wireframe** | $0-500 | Hours-days | Testing if users understand a concept |
| **Clickable Prototype** | $500-2K | Days-week | Usability testing, flow validation |
| **Concierge** | $0-1K | Days-weeks | Validating value — YOU are the product |
| **Wizard of Oz** | $1K-5K | Weeks | Full UX testing with human backend |
| **Limited Build / MVP** | $5K-50K | Weeks-months | Retention, real behavior, willingness to pay |

### Hardware / Physical Products

| Type | Cost | Duration | Best For |
|------|------|----------|----------|
| **Conversation** | $0 | Hours | Problem validation |
| **Desk Research** | $0 | Days | Market sizing, competitor analysis |
| **Digital Mockup / CAD** | $200-500 | Days | Stakeholder alignment |
| **Simulation / Analysis** | $500-2K | Days-weeks | Technical feasibility without physical build |
| **Functional Prototype** | $3K-10K | 4-12 weeks | Real-world performance testing |
| **Field Pilot** | $10K-50K | Months | User adoption in actual environment |

### Agency / Client Work

| Type | Client Cost | Duration | Best For |
|------|-------------|----------|----------|
| **Stakeholder Interview** | $1K-3K | Days | Understanding real requirements |
| **Competitive Analysis** | $2K-5K | Week | Market positioning |
| **Clickable Prototype** | $3K-8K | 1-2 weeks | Client buy-in, user testing |
| **Limited Build** | $15K-50K | 2-6 weeks | Market validation |

Recommend the cheapest valid option. Ask: "Could a conversation answer this before we build anything?"

## Step 4 — Design the Specific Experiment

Guide through these questions:

1. **What specific question are you answering?** Not "is this a good idea?" but "will nurses use a shift-swap button during a shift?"

2. **Who are you testing with?** Representative users, not friends and family (unless that IS your audience). Define the sample.

3. **How long will it run?** Set a start date and end date. Open-ended experiments are activities, not experiments.

4. **What will you measure?** Define the specific metrics BEFORE starting. Connect to the kill condition.

5. **What permission do you need?** In regulated environments, ethics review, data privacy, or regulatory sandbox authorization may be required. If permission is denied, redesign with synthetic data — don't abandon the hypothesis.

6. **Where will you log results?** Set up the Experiment Log entry template now.

> **Coaching note — common anti-patterns** (Ch 6):
> - Building when you should be talking
> - Testing solutions before validating problems
> - Experiments with no kill condition
> - Choosing the experiment you WANT to build, not the one you NEED to run

## Step 5 — Produce the Experiment Design

```markdown
## Experiment Design — [Title]
**Date**: YYYY-MM-DD
**Discovery Brief**: [Reference]
**Experiment type**: [From menu]
**Estimated cost**: [Time + money]
**Duration**: [Start → End]
**Build duration**: [Expected time to build/create the experiment — e.g., "2 hours", "3 days", "2 weeks"]
**Execution leverage**: [none | low | medium | high] — how much agentic/AI tooling accelerates this experiment (high = build cost near-zero, collapsed mode applies)

### Question
[Specific question this answers]

### Method
[What you'll do, step by step]

### Sample
[Who, how many, how recruited]

### Metrics
[What you'll measure — connected to kill condition]

### Kill Condition
[Copied from Discovery Brief]

### Permission Required
[Yes/No — if yes, status]

### Log Location
[Where results will be recorded]
```

### Update Cycle State

Update `.flow/active-cycle.json`:
- `phase`: "build" (experiment designed, ready to run)
- `next_step`: `{ "action": "Run experiment, then check Gate D2", "skill": "/flow-gate" }`
- `completed_steps`: add "Experiment designed"

## Research Output Standards

When this skill produces or references research (desk research, market analysis, competitive analysis, regulatory research, domain-specific claims), the following standards apply:

### Confidence Markers

Tag all factual claims with confidence levels:
- **[verified]** — well-established facts, multiple corroborating sources, within general knowledge
- **[likely]** — probably accurate but based on limited sources, or domain-specific claims that may have changed
- **[VERIFY]** — regulatory claims, specific numbers/statistics, legal requirements, medical claims, financial regulations, market size figures — anything where being wrong has consequences

At the end of any research section, include a **Verification Checklist**:

```
### Claims Requiring Verification
- [ ] [Claim 1] — [why it needs verification]
- [ ] [Claim 2] — [why it needs verification]
```

### Research Provenance

Every research claim must note its source type:
- **Training data** — from the model's knowledge (static, may be outdated — note the risk)
- **Web search** — from live search (current but potentially unreliable — include URL)
- **User-provided** — from documents or context the user shared (reliable but scoped)
- **Inference** — the model's synthesis or reasoning (not a source — label it clearly)

Include a **Provenance Summary** at the end of research sections:

```
### Source Provenance
| Claim Category | Source Type | Reliability | Notes |
|---------------|------------|-------------|-------|
| [e.g., Market size] | [Web search] | [Medium] | [URL, date accessed] |
| [e.g., Regulatory requirement] | [Training data] | [Low — may be outdated] | [Verify with authority] |
```

### Self-Critique: "What Could Be Wrong?"

Every research output MUST end with a self-critique section:

```
### What Could Be Wrong With This Research?
- **Assumptions not validated**: [list assumptions made without evidence]
- **Potentially outdated**: [claims based on training data that may have changed]
- **Domain blind spots**: [areas where domain expertise would change the analysis]
- **Geographic/regulatory gaps**: [jurisdictions, markets, or conditions not covered]
- **Missing perspectives**: [stakeholders, user segments, or viewpoints not represented]
```

This section is mandatory — skipping it is an anti-pattern. If the agent cannot identify any weaknesses, that itself is a red flag: state "Unable to identify weaknesses — this research should be independently reviewed."

## Step 6 — Run Gate D2

Before spending time and money, validate the experiment design:

### D2 Checklist
- [ ] The experiment answers the hypothesis (clear logical connection)
- [ ] It's the cheapest valid option (cheaper alternatives considered)
- [ ] Sample is appropriate (representative users, not convenience sample)
- [ ] Duration is defined (start date and end date)
- [ ] Kill condition is specific and measurable
- [ ] Permission is secured (if needed)
- [ ] The log is set up (where and who records results)

If any item fails, give specific guidance on how to fix it.

## Step 7 — Chain to Next Skill

> "Experiment design passes D2. Run the experiment. When it completes, run `/flow-gate` to check D3 — that's where you'll decide: Continue, Refine, Pivot, Stop, or Escalate."

## Hardware Sidebar

> **Cost warning**: Hardware experiments at the prototype level ($3K-10K) and above are significant investments. Before committing, verify that conversation and desk research experiments have been exhausted. A $200 CAD render can sometimes answer what a $5K functional prototype would. Timelines are also longer — plan for 4-12 weeks for functional prototypes, months for field pilots.

## Solo Sidebar

> **Experiments you can run alone in a weekend**: 5 customer conversations ($0, 2 hours), landing page smoke test ($50, 1 day), concierge delivery to 3 users ($0, 1 weekend), competitor teardown analysis ($0, half day). You don't need a team or budget to validate a hypothesis.

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

If designing an experiment without this skill:

- [ ] Review the hypothesis from the Discovery Brief
- [ ] Check Learning Archive for prior related experiments
- [ ] Choose experiment type from the menu (cheapest valid option)
- [ ] Define the specific question being answered
- [ ] Define the sample (who, how many)
- [ ] Set start and end dates (no open-ended experiments)
- [ ] Define metrics connected to the kill condition
- [ ] Check if permission is required (regulated environments)
- [ ] Set up the Experiment Log entry
- [ ] Run Gate D2 checklist (Ch 6)
- [ ] If D2 passes → run the experiment → then run Gate D3
- [ ] If D2 fails → revise design and re-check

# Discovery-Driven Outcome Flow — Orchestra MCP

> At the inception stage, the primary goal is discovering a valuable problem and validating a viable solution, not scaling delivery.
>
> **Learning Speed > Delivery Speed.** The fastest team is not the one that builds most — it is the one that invalidates wrong ideas fastest.

---

## 0. Three Operating Modes

Orchestra projects operate in one of three modes. Each mode has a different decision spine, pace, and success metric.

```
  ┌──────────────┐      ┌──────────────┐      ┌──────────────┐
  │  DISCOVERY    │─────→│   OUTCOME    │─────→│    SCALE     │
  │  (inception)  │      │  (PMF search)│      │   (growth)   │
  └──────────────┘      └──────────────┘      └──────────────┘
   Velocity =            Velocity =            Velocity =
   Learning Speed        Delivery Speed        Throughput
   × Clarity             × Quality             × Reliability
   × Focus               × User Impact         × Efficiency
```

| Mode | Purpose | Primary Unit | Success Metric |
|------|---------|-------------|----------------|
| **Discovery** | Validate problem hypotheses | Experiment | Learning signals |
| **Outcome** | Build validated features | Feature (7-state workflow) | User outcomes |
| **Scale** | Optimize and grow | Feature + Infrastructure | Business metrics |

Set the mode with `set_project_mode`. Check readiness to transition with `check_transition_signals`.

---

## 1. The Discovery Decision Spine

In Discovery Mode, the decision spine changes from the standard feature flow:

```
  Vision
     ↓
  User Problem Hypotheses     ← "We believe [target user] struggles with [problem]"
     ↓
  Experiments                  ← interviews, prototypes, landing pages, mocks
     ↓
  Validated Outcomes           ← signals confirm or deny the hypothesis
     ↓
  Tasks (Features)             ← only after experiments indicate real demand
```

**Policy rule:** No development task should start unless it supports a problem-validation experiment.

---

## 2. Discovery Cycles

Discovery Mode operates in **Discovery Cycles** — time-boxed 1–2 week sprints focused on learning, not building.

```
  ┌─────────────────────────────────────────────┐
  │            DISCOVERY CYCLE (1-2 weeks)       │
  │                                              │
  │   Discover → Test → Learn → Refine           │
  │                                              │
  │   Each cycle answers ONE question:           │
  │   • Do users experience this problem?        │
  │   • Is this problem painful enough to solve? │
  │   • Would users trust this solution?         │
  └─────────────────────────────────────────────┘
```

### Cycle Lifecycle

| Status | Meaning |
|--------|---------|
| `active` | Cycle is in progress — hypotheses and experiments are being worked |
| `completed` | Cycle ended with learnings and a decision (continue / pivot / stop) |
| `cancelled` | Cycle was cancelled before completion |

### Tools

| Tool | Purpose |
|------|---------|
| `create_discovery_cycle` | Start a new time-boxed cycle with a goal |
| `get_discovery_cycle` | View cycle details, linked hypotheses and experiments |
| `list_discovery_cycles` | List all cycles, optionally filter by status |
| `update_discovery_cycle` | Adjust title, goal, or dates |
| `complete_discovery_cycle` | End a cycle with learnings and decision |
| `delete_discovery_cycle` | Remove a cycle |

---

## 3. Hypotheses

A hypothesis is a testable statement about a user problem. It's the atomic unit of Discovery Mode.

### The Discovery Brief (SPEC-Lite)

Each hypothesis captures a 1-page Discovery Brief:

| Field | Example |
|-------|---------|
| **Problem** | Startup founders struggle to understand legal risks in contracts |
| **Target User** | Early-stage startup founders signing vendor agreements |
| **Assumption** | Founders would pay for automated risk insights if they trusted the output |

### Hypothesis Lifecycle

```
  untested ──→ testing ──→ validated
                  │              │
                  │              └──→ (spawn features)
                  │
                  ├──→ invalidated
                  │
                  └──→ refined ──→ (new HYPO created)
```

| Status | Meaning |
|--------|---------|
| `untested` | Hypothesis created but no experiments started |
| `testing` | At least one experiment is running (set automatically) |
| `validated` | Evidence confirms the hypothesis |
| `invalidated` | Evidence disproves the hypothesis |
| `refined` | Pivoted — a new hypothesis was created from this one |

### Tools

| Tool | Purpose |
|------|---------|
| `create_hypothesis` | Define a problem hypothesis with target user and assumption |
| `get_hypothesis` | View hypothesis details, linked experiments, validation history |
| `list_hypotheses` | List all, filter by status or cycle |
| `update_hypothesis` | Revise problem statement, target user, or assumption |
| `validate_hypothesis` | Mark as validated with evidence summary |
| `invalidate_hypothesis` | Mark as invalidated with reason |
| `refine_hypothesis` | Pivot: create a new refined hypothesis, mark original as refined |

---

## 4. Experiments

An experiment tests a hypothesis through user interaction. Experiment before engineering.

### Experiment Kinds

| Kind | Description |
|------|-------------|
| `interview` | User interviews to understand the problem |
| `landing-page` | Landing page to test interest and conversion |
| `prototype` | Clickable prototype to test usability |
| `concierge` | Manual service simulating the product experience |
| `survey` | Structured questionnaire for quantitative data |
| `ab-test` | A/B comparison of approaches |
| `mock` | AI-generated mock outputs to test reactions |
| `other` | Custom experiment type |

### Experiment Lifecycle

```
  draft ──→ running ──→ completed ──→ (spawn features)
               │
               └──→ abandoned (kill condition triggered?)
```

| Status | Meaning |
|--------|---------|
| `draft` | Experiment defined but not yet started |
| `running` | Experiment is actively collecting signals |
| `completed` | Experiment finished with outcome summary |
| `abandoned` | Experiment stopped (optionally with kill condition) |

### Validation Signals

While an experiment is running, record signals — observable evidence from the field:

| Signal Type | Examples |
|-------------|----------|
| `user` | Interview confirmations, problem intensity, willingness to try |
| `behavior` | Prototype usage, test conversions, early engagement |
| `market` | Willingness to pay, pilot commitments, inbound interest |

Each signal records: metric, expected value, actual value, and confidence level (low/medium/high).

### Kill Conditions

Every experiment defines a kill condition upfront — the threshold at which you stop and abandon:

> "If fewer than 3 of 10 users show interest, abandon this direction."

When abandoning an experiment, you can flag `kill_triggered: true` to track that the kill condition was met.

### Tools

| Tool | Purpose |
|------|---------|
| `create_experiment` | Define an experiment with question, method, success signal, kill condition |
| `get_experiment` | View experiment details, signals, and outcome |
| `list_experiments` | List all, filter by status, hypothesis, cycle, or kind |
| `update_experiment` | Revise method or criteria (draft only) |
| `start_experiment` | Move from draft to running |
| `record_signal` | Record a validation signal (user/behavior/market) |
| `complete_experiment` | Complete with outcome summary |
| `abandon_experiment` | Stop the experiment, optionally flag kill condition |
| `spawn_feature_from_experiment` | Create a feature from a completed experiment |

---

## 5. The Bridge: Discovery → Delivery

When an experiment validates a hypothesis, the learnings can be turned into engineering work:

```
  Hypothesis (validated)
       ↓
  Experiment (completed)
       ↓
  spawn_feature_from_experiment
       ↓
  Feature (todo) ──→ 7-state delivery workflow
       │
       └── Labels: experiment:EXPR-XXX, hypothesis:HYPO-XXX
```

`spawn_feature_from_experiment` creates a standard `FeatureData` with:
- Labels linking back to the source experiment and hypothesis
- Default description referencing the experiment outcome
- Standard `todo` status — enters the existing gated delivery workflow

For larger validated outcomes, use the existing **Plan** system:
1. `create_plan` with description referencing validated hypotheses
2. `breakdown_plan` to create multiple features with dependencies
3. Work each feature through the 7-state lifecycle

---

## 6. Weekly Discovery Review

At the end of each cycle (or weekly), run a structured Discovery Review to decide what happens next.

### Review Questions

1. **What did we learn about the problem?** (captured in experiment outcomes)
2. **What surprised us about users?** (`surprises` field)
3. **What assumptions were wrong?** (`wrong_about` field)
4. **Should we pivot, continue, or stop?** (per-item decisions)

### Per-Item Decisions

For each hypothesis and experiment, the team decides:

| Decision | Meaning | Follow-up |
|----------|---------|-----------|
| `continue` | Keep going with current direction | No action needed |
| `refine` | Adjust the hypothesis | → `refine_hypothesis` |
| `pivot` | Major direction change | → `refine_hypothesis` (new problem statement) |
| `stop` | Abandon this direction | → `invalidate_hypothesis` or `abandon_experiment` |

### Tools

| Tool | Purpose |
|------|---------|
| `create_discovery_review` | Start a review session for a cycle |
| `record_review_decisions` | Record surprises, wrong assumptions, and per-item decisions |
| `get_discovery_review` | View review details and decisions |

---

## 7. Transition Signals: Discovery → Outcome

Use `check_transition_signals` to analyze whether the project is ready to move from Discovery to Outcome mode.

### Readiness Criteria

| Signal | Threshold |
|--------|-----------|
| Validated hypotheses | ≥ 1 hypothesis marked as validated |
| Completed experiments | ≥ 1 experiment with outcome |
| Behavior signals | ≥ 1 behavior signal recorded |
| No active kills outweighing completions | Completed experiments > kill-triggered experiments |

### Transition Indicators

The tool returns a structured assessment. When all checks pass:

```
Recommendation: Ready to transition to Outcome Mode.
Use `set_project_mode` to switch.
```

After switching to Outcome Mode:
- Discovery Cycles → Outcome Cycles (regular feature delivery)
- Hypotheses → validated problems become feature descriptions
- Experiments → completed experiments spawn features
- The policy defined in `16-feature-driven-workflow.md` becomes active

---

## 8. Discovery Dashboard

`get_discovery_status` provides a comprehensive view:

- Current project mode
- Active cycles count
- Hypothesis counts by status (untested / testing / validated / invalidated / refined)
- Experiment counts by status and kind
- Total signals collected
- Kill conditions triggered
- Features spawned from experiments

Can be scoped to a specific cycle with `cycle_id`.

---

## 9. Complete Tool Reference (31 tools)

### Discovery Cycles (6)
| Tool | Required Params | Optional Params |
|------|----------------|-----------------|
| `create_discovery_cycle` | project_id, title, goal, start_date, end_date | |
| `get_discovery_cycle` | project_id, cycle_id | |
| `list_discovery_cycles` | project_id | status |
| `update_discovery_cycle` | project_id, cycle_id | title, goal, start_date, end_date |
| `complete_discovery_cycle` | project_id, cycle_id, learnings, decision | |
| `delete_discovery_cycle` | project_id, cycle_id | |

### Hypotheses (7)
| Tool | Required Params | Optional Params |
|------|----------------|-----------------|
| `create_hypothesis` | project_id, title, problem, target_user, assumption | cycle_id, labels |
| `get_hypothesis` | project_id, hypothesis_id | |
| `list_hypotheses` | project_id | status, cycle_id |
| `update_hypothesis` | project_id, hypothesis_id | title, problem, target_user, assumption |
| `validate_hypothesis` | project_id, hypothesis_id, summary | |
| `invalidate_hypothesis` | project_id, hypothesis_id, reason | |
| `refine_hypothesis` | project_id, hypothesis_id, title, problem, target_user, assumption | cycle_id |

### Experiments (9)
| Tool | Required Params | Optional Params |
|------|----------------|-----------------|
| `create_experiment` | project_id, hypothesis_id, title, kind, question, method, success_signal, kill_condition | cycle_id, labels |
| `get_experiment` | project_id, experiment_id | |
| `list_experiments` | project_id | status, hypothesis_id, cycle_id, kind |
| `update_experiment` | project_id, experiment_id | title, method, success_signal, kill_condition |
| `start_experiment` | project_id, experiment_id | |
| `record_signal` | project_id, experiment_id, signal_type, metric, expected, actual, confidence | |
| `complete_experiment` | project_id, experiment_id, outcome | |
| `abandon_experiment` | project_id, experiment_id, reason | kill_triggered |
| `spawn_feature_from_experiment` | project_id, experiment_id, title | description, priority, kind |

### Discovery Reviews (3)
| Tool | Required Params | Optional Params |
|------|----------------|-----------------|
| `create_discovery_review` | project_id, cycle_id, title | |
| `record_review_decisions` | project_id, review_id, surprises, wrong_about, items (JSON) | |
| `get_discovery_review` | project_id, review_id | |

### Project Mode (3)
| Tool | Required Params | Optional Params |
|------|----------------|-----------------|
| `set_project_mode` | project_id, mode | |
| `get_project_mode` | project_id | |
| `check_transition_signals` | project_id | |

### Discovery Reporting (1)
| Tool | Required Params | Optional Params |
|------|----------------|-----------------|
| `get_discovery_status` | project_id | cycle_id |

---

## 10. Storage Layout

Discovery data is stored alongside existing features in the project directory:

```
.projects/{slug}/
    project.json              ← mode field added (discovery/outcome/scale)
    features/                 ← existing feature files
    plans/                    ← existing plan files
    hypotheses/               ← NEW: HYPO-XXX.md
    experiments/              ← NEW: EXPR-XXX.md
    discovery-cycles/         ← NEW: DISC-XXX.md
    discovery-reviews/        ← NEW: DREV-XXX.md
```

Each file uses the standard Orchestra format: YAML frontmatter (metadata) + Markdown body (narrative content, evidence trail, signal log).

---

## 11. Example Workflow

```
1. set_project_mode(mode="discovery")

2. create_discovery_cycle(
     title="Week 1: Contract Risk Discovery",
     goal="Determine if founders need automated contract risk insights",
     start_date="2026-03-11", end_date="2026-03-25")

3. create_hypothesis(
     title="Contract risk blindspot",
     problem="Startup founders struggle to understand legal risks in contracts",
     target_user="Early-stage founders signing vendor agreements",
     assumption="Founders would upload contracts for automated risk insights",
     cycle_id="DISC-ABC")

4. create_experiment(
     hypothesis_id="HYPO-XYZ",
     title="Founder interview round 1",
     kind="interview",
     question="Would founders upload contracts to get automated risk insights?",
     method="Interview 10 startup founders, show mock output",
     success_signal="5 of 10 founders express willingness to upload a real contract",
     kill_condition="Fewer than 3 users show interest",
     cycle_id="DISC-ABC")

5. start_experiment(experiment_id="EXPR-DEF")

6. record_signal(
     experiment_id="EXPR-DEF",
     signal_type="user",
     metric="willingness to upload contract",
     expected="5 of 10",
     actual="7 of 10",
     confidence="high")

7. complete_experiment(
     experiment_id="EXPR-DEF",
     outcome="7 of 10 founders said they would upload. Strong signal.")

8. validate_hypothesis(
     hypothesis_id="HYPO-XYZ",
     summary="7/10 founders confirmed willingness. Problem is real and painful.")

9. spawn_feature_from_experiment(
     experiment_id="EXPR-DEF",
     title="Contract risk analysis MVP",
     priority="P1")
   → Creates FEAT-GHI in todo status, ready for delivery workflow

10. complete_discovery_cycle(
      cycle_id="DISC-ABC",
      learnings="Founders urgently need contract risk insights. 7/10 validation rate.",
      decision="continue")

11. check_transition_signals(project_id="my-project")
    → "Ready to transition to Outcome Mode"

12. set_project_mode(mode="outcome")
    → Project now uses standard feature delivery workflow
```

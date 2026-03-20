# FLOW Status — Active Cycles Dashboard

> **Trigger**: User asks "what's active?", "show status", "WIP check", "dashboard", or "are we over capacity?"
> **Reference**: Chapter 12 (WIP Limits), Chapter 13 (Rituals & Cadence), Chapter 11 (Outcome Decisions)

## What This Skill Does

Reads active cycle data from project files and track task files, then produces a real-time status dashboard showing all active FLOW cycles, WIP status, and flags requiring attention.

## Step 1 — Gather Data

Read the following sources in parallel:
1. **All `tracks/*/tasks.md`** — scan for active (unchecked) tasks with `*project:*` tags
2. **All `projects/*.md`** — read project status, health signals, current phase
3. **`manifest.json`** — cross-reference people, projects, and tracks

Extract for each active cycle:
- **Name**: The cycle/task/project name
- **Mode**: Discovery or Outcome (infer from artifact type — Brief = Discovery, SPEC = Outcome)
- **Cycle Phase**: Build (constructing the artifact/experiment), Observe (measuring results in production/field), Decide (evaluating evidence at a gate) — every cycle is in exactly one phase at any time
- **Progress**: Uphill (starting, gathering evidence), Peak (key decision point), Downhill (executing/completing)
- **Kill condition**: What it is and whether it's been evaluated recently
- **Target metric**: Current value vs. target (if available)
- **Owner**: Who's accountable
- **Age**: How long the cycle has been active (display as Day N or Week N based on team Tempo — use days for Lightning/Sprint tempos, weeks for March/Expedition)

## Step 2 — Display the Dashboard

### Active Cycles

```
| Cycle | Mode | Phase | Progress | Owner | Age | Kill Condition Status |
|-------|------|-------|----------|-------|-----|----------------------|
| [Name] | Discovery/Outcome | Build/Observe/Decide | Uphill/Peak/Downhill | [Person] | Day N / Week N | Active / Triggered / Not set |
```

### WIP Status

Show current vs. limits:

```
Discovery: [N] / [Limit]  [OK / OVER]
Outcome:   [N] / [Limit]  [OK / OVER]
Total:     [N] / [Limit]  [OK / OVER]
```

Reference WIP limits from Chapter 12:

| Team Size | Discovery | Outcome | Total |
|-----------|----------|---------|-------|
| Solo (1) | 1 | 1 | 1-2 |
| Small (3-8) | 1-2 | 1-2 | 2-3 |
| Medium (10-20) | 2-3 | 2-3 | 4-5 |
| Large (25+) | 3-4 | 3-5 | 6-8 |

### Portfolio View (for leadership)

If the user has multiple projects, show a portfolio summary:

```
| Project | Mode | Status | Signal | Tempo | Active Cycles | Overdue |
|---------|------|--------|--------|-------|---------------|---------|
| [Name] | [Mode] | active/paused | green/yellow/red | Lightning/Sprint/March/Expedition | N | N |
```

> **Coaching note for newcomers**: The portfolio view is how leadership monitors without micromanaging. Green projects are invisible — they're working. Yellow gets a glance. Red gets intervention. This is the FLOW principle: manage by exception, not by status update.
>
> **Tempo context**: The Tempo column shows the team's natural cycle rhythm. A project with Lightning tempo (1-3 day cycles) that hasn't updated in a week is very different from a March-tempo project (4-6 week cycles) in the same state. Always interpret age and staleness relative to the project's Tempo.

## Step 3 — Flag Issues

Scan for and prominently display:

### Overdue Cycles
Cycles that have been active longer than their planned duration or have missed deadlines.

> "Cycle [Name] has been active for [N] days with no progress update. Consider running `/flow-gate` to evaluate."

### Triggered Kill Conditions
Any cycle where the kill condition has been met but no decision has been made.

> "WARNING: Kill condition triggered on [Cycle Name] — [condition details]. This requires immediate action. Run `/flow-gate` for O5 or D3."

### WIP Violations
Current WIP exceeds limits.

> "WIP VIOLATION: You have [N] active cycles against a limit of [Limit]. You must kill or merge something before starting new work. What are you willing to stop?"

### Zombie Cycles
Cycles with no activity for 7+ days that haven't been explicitly paused.

> "Zombie alert: [Cycle Name] has had no activity for [N] days. Is this still alive? If not, run `/flow-gate` to formally kill it and free the WIP slot."

### Missing Kill Conditions
Active cycles that don't have a documented kill condition.

> "No kill condition found for [Cycle Name]. This is an anti-pattern (Ch 20). Every cycle needs a pre-committed stop condition."

### Stale Gates
Cycles that should have passed a gate by now but haven't.

> "[Cycle Name] has been in Discovery for [N] days without passing D2. Is the experiment designed?"

## Step 3b — Pause/Resume Cycle

If the user says "pause", "pause flow", "I need to do something else", or "flow pause":

1. Set `paused: true` and `paused_at: [timestamp]` in `.flow/active-cycle.json`
2. Silence all ambient reminders and hook notifications
3. Confirm: "FLOW cycle paused. Reminders silenced. Say 'resume flow' or run `/flow-status` to pick back up."

If the user says "resume", "resume flow", "pick up where I left off", or "flow resume":

1. Set `paused: false` and clear `paused_at` in `.flow/active-cycle.json`
2. Re-enable ambient reminders
3. Show the current cycle state: "Resumed: [cycle name] | Phase: [phase] | Next: [next step]"

**Auto-remind after 24 hours of pause**: If `paused_at` is more than 24 hours ago and the user starts a new session, gently remind: "Your FLOW cycle [name] has been paused for [N] hours. Resume with `/flow-status resume` or kill it with `/flow-kill`."

## Step 4 — Variant Displays

| Context | Dashboard Adaptation |
|---------|---------------------|
| **Solo** | Simplified — just show your 1-2 active cycles and whether kill conditions are approaching. Skip portfolio view. |
| **Agency** | Group by client. Show per-client WIP. Flag client-facing deadlines. |
| **Enterprise** | Group by team. Show cross-team dependencies. Flag dependency blockers. |
| **Hardware** | Show longer timelines (weeks/months, not days). Flag cost commitments at each stage. |

## Step 5 — Chain to Action

Based on flags:
- **Kill conditions triggered** → "Run `/flow-gate` to process the kill/merge decision"
- **WIP violations** → "You need to kill or merge something. Which cycle should we evaluate? Run `/flow-gate`"
- **Zombie cycles** → "Let's clean up. Which of these should be formally killed?"
- **No flags** → "All clear. [N] active cycles within WIP limits. Next gate check due: [date/cycle]"

> **Coaching note**: The dashboard is a DECISION tool, not a reporting tool. If nothing on it drives a decision, it's working correctly — green is invisible. When something turns yellow or red, that's the dashboard earning its keep.

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

If building a status dashboard without this skill:

- [ ] Read all `tracks/*/tasks.md` for active tasks with project tags
- [ ] Read all `projects/*.md` for project status and health signals
- [ ] List each active cycle: name, mode, progress, owner, age
- [ ] Calculate WIP: count active Discovery and Outcome cycles vs. limits
- [ ] Check for overdue cycles (past planned duration)
- [ ] Check for triggered kill conditions (met but no decision made)
- [ ] Check for WIP violations (over limit)
- [ ] Check for zombie cycles (no activity 7+ days, not paused)
- [ ] Check for missing kill conditions (active cycles without one)
- [ ] Flag all issues prominently
- [ ] If kill conditions triggered → run Gate O5 or D3 immediately
- [ ] If WIP violated → force a trade-off decision before accepting new work

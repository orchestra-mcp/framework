# FLOW — Intelligent Methodology Router

> **Trigger**: User says anything FLOW-related — "I have an idea", "how do I...", "what's active", "run a gate", etc.
> This is the single entry point. Detect intent and route to the right skill.

## Step 0 — First-Time Detection

Check if `.flow/` directory exists in the current project root.

**If `.flow/` does NOT exist**: This project hasn't been initialized with FLOW yet. Route to `/flow-init`:

> "I notice FLOW hasn't been set up in this project yet. Let me initialize it — this creates the `.flow/` directory, adds ambient rules to your CLAUDE.md, and calibrates your team's tempo. Takes about 5 minutes."
>
> Then invoke `/flow-init`.

**If `.flow/` exists**: Read `.flow/config.yaml` for team context (Tempo, WIP limits, SPEC minimum). Use this context for all routing decisions below.

## Step 1 — Check for Active FLOW State

Read `.flow/config.yaml` for team Tempo and WIP limits.
Scan `.flow/cycles/` for active cycle documents.
Check WIP: count active cycles vs. limits from config.

## Step 2 — Detect Intent

Parse the user's message and match to the closest intent:

| Intent Signal | Route To | What It Does |
|---------------|----------|--------------|
| "I have an idea", "new request", "someone asked for..." | `/flow-intake` | Classify and route incoming work |
| "write a brief", "hypothesis", "we believe...", "discovery" | `/flow-brief` | Write a Discovery Brief |
| "design an experiment", "test this", "cheapest way to validate" | `/flow-experiment` | Design the smallest valid experiment |
| "write a spec", "what should we build", "scope this" | `/flow-spec` | Write a SPEC-Lite one-page plan |
| "check a gate", "gate review", "is this ready", "D1", "O2" | `/flow-gate` | Run a quality checkpoint |
| "what's active", "show status", "dashboard", "WIP" | `/flow-status` | Show active cycles and WIP |
| "kill", "merge", "stop this", "should we continue" | `/flow-gate` (with kill/merge context) | Evidence-based kill/merge decision |
| "what does X mean", "explain", "teach me", "how does FLOW..." | Coach mode (inline) | Explain concepts with chapter refs |
| "are we doing this right", "health check", "adoption" | Coach mode (inline) | Assess FLOW adoption health |
| "tempo", "speed", "cycles too long", "cycles too short", "rhythm", "how fast", "cadence" | `/flow-tempo` | Discover the team's natural cycle rhythm |
| "how we work", "team setup", "operating agreement", "configuration", "team agreement", "working agreement" | `/flow-config` | Generate the team's FLOW Configuration one-pager |
| "init flow", "set up flow", "bootstrap flow", "add flow", "start using flow", "initialize" | `/flow-init` | Bootstrap FLOW in a new project |
| "domain expert", "build expert", "expert validation", "domain review" | `/flow-expert` | Build a Domain Expert agent for validation |
| "pause flow", "resume flow", "unpause" | `/flow-status` (pause/resume mode) | Pause or resume the active cycle |

## Step 3 — For Newcomers

If the user seems unfamiliar with FLOW (no state files, asks "what is FLOW?", first interaction):

> **FLOW is a product methodology built for the agentic era.** It replaces Scrum/SAFe/Shape Up with a decision-optimized system. The core idea:
>
> 1. **Two modes**: Discovery (learning) and Outcome (shipping) — never confuse the two
> 2. **Kill conditions**: Every piece of work has a pre-committed condition to stop if it's not working
> 3. **Decision Spine**: Vision → Strategy → Bet → Cycle — every cycle traces back to strategy
> 4. **Gates**: Quality checkpoints that prevent waste before it happens
>
> *Reference: Chapter 1 (Why FLOW Exists), Chapter 2 (Core Mental Model)*

Then ask: **"What are you trying to do? I can help you classify new work, write a brief, design an experiment, scope a build, or check a gate."**

## Step 4 — Route with Context

When routing to a sub-skill, pass relevant context:
- If the user mentioned a specific project, include the project slug
- If there's an active Discovery cycle, mention it when routing to `/flow-experiment`
- If WIP is at capacity (check via `/flow-status` logic), warn before routing to `/flow-intake`

> **Coaching note**: FLOW is context-adaptive. Solo founders collapse Discovery and Outcome (Ch 2). Agencies split the spine with clients (Ch 3). Hardware teams run sequential modes (Ch 2). Enterprise adds governance gates (Ch 15). Always ask about context if unclear.

## Step 5 — If Intent Is Unclear

Ask ONE question:

> "Are you trying to (a) bring new work into the system, (b) move existing work forward, or (c) learn about FLOW?"

Then route based on the answer.

## Variant Notes

| Context | Key Difference |
|---------|---------------|
| **Solo founder** | Modes collapse. Brief can be 3 fields. WIP limit is 1-2. Skip rituals except weekly kill/merge with yourself. |
| **Enterprise (30+)** | Add governance gates. Intake authority matrix applies. WIP per team. |
| **Agency** | Client owns Vision/Strategy on the spine. Discovery is a paid deliverable ($5K-20K). |
| **Hardware** | Modes are strictly sequential. Experiments cost thousands. Timelines are weeks, not days. |
| **Government** | Maps to PRINCE2 stages. Benefits realization required. Bilingual documentation. |

*Reference: Chapter 22 (Adaptation Guides) for complete context-specific guidance.*

---

## Manual Mode Checklist

If running FLOW routing without this skill:

- [ ] Check if the request is new work or existing cycle progress
- [ ] Determine: Discovery (need to learn) or Outcome (need to ship)?
- [ ] Verify spine trace — does this connect to Vision → Strategy → Bet?
- [ ] Check WIP capacity before accepting new work
- [ ] Choose the right artifact: Discovery Brief (Ch 5) or SPEC-Lite (Ch 8)
- [ ] Identify the next gate to run
- [ ] Note the user's FLOW experience level and adapt guidance accordingly

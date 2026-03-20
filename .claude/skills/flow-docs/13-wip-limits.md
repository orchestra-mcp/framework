> Part V: Operations | [← Previous](12-outcome-decisions.md) | [Next →](14-rituals.md)

# Chapter 12: WIP Limits

> *Panel-reviewed: Meeting #6, updated Meeting #13 (2026-03-19)*
> **Read this**: Flow Coaches, PMs, Leadership. The capacity enforcement mechanism.

---

## Why Unbounded Work-in-Progress Kills Teams

When everything is in progress, nothing is finished. WIP inflation is the silent killer of product teams:

- **Context switching**: Each additional concurrent cycle adds 20-30% overhead. Three cycles don't take 3x — they take 4-5x because of switching costs.
- **Zombie cycles**: Without WIP limits, old work never dies. New work enters, old work lingers. The team carries 8 "active" cycles, 3 of which haven't been touched in weeks.
- **Decision avoidance**: Starting new work is easier than killing old work. WIP limits force the kill decision: "You want to start this? What are you willing to stop?"
- **Quality erosion**: Teams stretched across too many cycles cut corners on observability, testing, and documentation. The cycles that ship are half-measured.

WIP limits are not about working less. They're about **finishing more**.

---

## How to Set WIP Limits

### Per Team

| Team Size | Discovery WIP | Outcome WIP | Total WIP |
|-----------|--------------|-------------|-----------|
| Solo (1) | 1 | 1 | 1-2 |
| Small (3-8) | 1-2 | 1-2 | 2-3 |
| Medium (8-15) | 2-3 | 2-3 | 3-5 |
| Large (15-30) | 3-4 | 3-5 | 5-8 |
| Enterprise (30+) | Per squad (see squad limits) | Per squad | Sum of squads |

### Per Mode

Discovery cycles are typically lighter than Outcome cycles (fewer people, shorter duration). A team might carry 2 Discovery cycles and 1 Outcome cycle simultaneously — but not 2 Outcome cycles and 3 Discovery cycles.

**Rule of thumb**: Outcome WIP ≤ Discovery WIP. Building consumes more resources than learning.

### Per Person

Individual WIP matters too. A PM managing 5 concurrent cycles doesn't manage any of them well. Recommended individual limits:
- **PM**: 2-3 active cycles (across Discovery and Outcome)
- **Engineer**: 1 active cycle (context switching kills engineering output)
- **Designer**: 1-2 active cycles

---

## The WIP Check

Before accepting new work, run the WIP check:

1. **Count active cycles**: How many Discovery and Outcome cycles are in progress?
2. **Compare to limit**: Are we at or over the limit?
3. **If at capacity**: The new work WAITS or something DIES. Options:
   - **Queue**: Add to the intake queue. It enters when a slot opens.
   - **Trade**: Kill or pause an existing cycle to make room.
   - **Reject**: The work doesn't enter the system. It goes back to the requester.
4. **If under capacity**: The new work enters. Update the count.

### The WIP Question

When someone asks to start new work:

> **"We're at [N] of [limit] cycles. To start this, which of these would you like to stop: [list active cycles]?"**

This question transforms WIP limits from a bureaucratic constraint into a prioritization tool. It forces the requester to confront trade-offs instead of just adding work.

---

## WIP Limits in Practice

### For Solo Founders
Your WIP limit is effectively 1-2. You can't context-switch between 5 projects. Pick one bet, run one cycle, finish it or kill it, then move to the next. The most common solo founder mistake: 3 half-built features instead of 1 finished one.

### For Agencies
WIP is measured per team, not per client. If your team has a WIP limit of 3 and you have 4 active client projects — one of them is in queue or you're over capacity. The hard conversation: "Client D's project starts when Client A's cycle completes, not before."

WIP across multiple client projects requires explicit prioritization. When two clients both want "urgent" work, WIP limits force the agency PM to rank them — a politically difficult but operationally necessary decision.

### For Platform Teams
Platform WIP must account for downstream dependencies. A platform cycle that enables 3 downstream teams' cycles is consuming WIP in multiple places. Count it as 1 platform WIP slot but acknowledge the organizational WIP impact.

### For Enterprise
WIP limits apply at the squad level, not the organization level. Each squad has its own WIP limit. The portfolio-level WIP limit is the sum of all squad limits — and the leadership team must respect it. "We have 5 squads with 3 WIP each = 15 total portfolio WIP. We currently have 14 active. We can start one more."

---

## Bottleneck-Based WIP Calibration

The team-size tables above are starting points, but the real WIP limit should be calibrated to your team's **bottleneck** — the constraint that actually limits throughput.

### The Bottleneck Shift

In pre-agentic teams, the bottleneck is usually **build capacity**. You can only build so many things at once, so WIP is limited by how many things you can build simultaneously.

In agentic teams, build capacity explodes. An AI-augmented team can ship 10 features in a day. But the bottleneck **shifts to observation and decision capacity**. You can build 10 features in a day, but can you meaningfully observe 10 experiments at once? Can you make 10 kill/continue decisions with proper evidence? Probably not.

**WIP limits must follow the bottleneck, not the build capacity.** As teams adopt agentic tools, their WIP limits may actually need to DECREASE — not because they're building less, but because observation and decision-making become the constraint.

### WIP Calibration by Bottleneck Type

| Bottleneck | WIP Limit Based On | Example |
|---|---|---|
| **Build capacity** | Team size x concurrent work | 3 engineers → 3 active cycles |
| **Observation capacity** | Metrics the team can monitor | 2 analysts → 4-5 active experiments |
| **Decision capacity** | PM decision bandwidth | 1 PM → max 5 kill/merge decisions per week |
| **External constraints** | Regulatory/approval pipelines | 2 concurrent compliance reviews |

### How to Find Your Bottleneck

Ask: "If we started one more cycle right now, what would break first?"

- **"We don't have engineers to build it"** → Build capacity bottleneck. Classic WIP limit by team size applies.
- **"We couldn't watch the metrics properly"** → Observation capacity bottleneck. Limit WIP to what you can observe, not what you can build.
- **"The PM couldn't make another kill/continue decision this week"** → Decision capacity bottleneck. Limit WIP to decision bandwidth.
- **"We're waiting on legal/compliance for the last two"** → External constraint bottleneck. Limit WIP to the external pipeline's throughput.

Most teams have multiple bottlenecks. Calibrate to the tightest one.

---

## WIP Limit Anti-Patterns

**WIP Inflation**: Gradually increasing the limit because "we're special." You're not. Stick to the limit.

**WIP in Name Only**: Setting a limit of 5 but tracking 8 cycles as "active." If it's active, it counts. If it doesn't count, it's not active — kill it.

**The Parking Lot**: Creating a "paused" status to pretend work isn't in progress. Paused cycles still consume mental bandwidth and still block the WIP slot. If you pause it, either kill it or accept it counts toward WIP.

**The VIP Exception**: "The CEO's project doesn't count toward WIP." Yes, it does. Especially the CEO's project. If it's important enough for the CEO, it's important enough to justify killing something else.

---

*Next: [Chapter 13 — Rituals & Cadence →](14-rituals.md)*

> Part IV: Outcome Mode | [← Previous](09-spec-lite.md) | [Next →](11-execution.md)

# Chapter 9: The Build Contract

> *Panel-reviewed: Meeting #5 (2026-03-19), updated Meeting #13 (Build Complete checkpoint, sub-day builds)*
> **Read this**: Engineers, Tech Leads, DevOps, PMs. Joint ownership document.

---

## The Product-Engineering Agreement

The Build Contract is a **mandatory agreement between product and engineering** that must exist before any Outcome cycle execution begins. The PM writes the SPEC-Lite (what and why). Engineering writes the Build Contract (how).

The Build Contract is NOT:
- An estimate ("it'll take 3 sprints") — it's an agreement on approach
- A technical design doc — those are internal to engineering
- A plan that can't change — it's a starting agreement that gets updated if the approach shifts

The Build Contract IS:
- Engineering's commitment to how they'll build, measure, and ship
- The observability plan (what gets instrumented)
- The rollout strategy (how it reaches users)
- The definition of done (when engineering considers it complete)

### Why It Exists

Without a Build Contract, PM and engineering have different mental models of what "done" means:
- PM thinks "done" = users are using it successfully
- Engineering thinks "done" = code is merged and tests pass
- QA thinks "done" = no critical bugs in staging
- Nobody thinks about observability until someone asks "is anyone using this?"

The Build Contract aligns everyone BEFORE building starts. It takes 1-2 hours to write and prevents weeks of misalignment.

---

## The Anatomy

| Field | Owner | Content |
|-------|-------|---------|
| **Scope Reference** | PM | Link to the SPEC-Lite. "We're building [scope] to achieve [target metric]." |
| **Technical Approach** | Engineering (+ Solution Architect in enterprise) | High-level architecture. "We'll add a shift-swap endpoint to the scheduling API, a new mobile screen, and a push notification flow." |
| **Observability Plan** | Engineering + DevOps/SRE | What gets instrumented. "Track: swap requests initiated, swap requests accepted, time-to-swap, scheduling time per shift (the target metric)." DevOps owns the instrumentation infrastructure. |
| **Rollout Strategy** | Engineering + DevOps + Product Marketing | How it reaches users. "Feature flag for Hospital X first (week 1-2). If metrics hold, expand to all hospitals (week 3-4)." Product Marketing co-owns the launch narrative and positioning. |
| **Definition of Done** | Joint (all functions) | When the cycle is complete. "Code merged, feature flag live, observability dashboards active, Hospital X onboarded, launch communications sent." |
| **Known Risks** | Engineering + Compliance | "Integration with legacy shift system may require a data migration. If migration takes >3 days, flag for scope reduction." Compliance flags regulatory risks early. |
| **Dependencies** | Engineering | "Requires push notification service (owned by Platform team). Liam's team confirmed availability." |

---

## Writing an Observability Plan

Observability is not optional. If you can't measure it, you can't evaluate the kill condition.

The observability plan answers: **"What data will we have to decide Kill, Merge, or Continue at the end of this cycle?"**

### Minimum Viable Observability

1. **The target metric** from the SPEC-Lite must be instrumented. If the SPEC says "reduce scheduling time to under 15 min," the system must measure scheduling time per shift.

2. **Adoption metrics**: How many users are using the feature? Daily active users, feature activation rate, retention after first use.

3. **Quality metrics**: Error rates, latency, crash rates for the new feature.

4. **A dashboard**: Before the cycle ends, a dashboard exists where anyone can see the target metric, adoption, and quality in real-time.

### What "No Observability" Looks Like

The team builds a scheduling feature. It ships. The PM asks: "How many nurses are using it?" Engineering: "Um... we can check the database?" That's not observability. That's archaeology.

Gate O4 ([Chapter 10](11-execution.md)) checks that observability is in place before the cycle's measurement period begins.

---

## Gate O3: Is the Build Contract Complete?

### O3 Checklist
- [ ] **SPEC-Lite is referenced.** The Contract links to the approved SPEC-Lite (Gate O2 passed).
- [ ] **Technical approach is described.** Engineering has outlined how they'll build it (not detailed design — high-level approach).
- [ ] **Observability plan exists.** The target metric, adoption metrics, and quality metrics are defined. Instrumentation approach is specified.
- [ ] **Rollout strategy is defined.** Feature flag, staged rollout, or full launch — the approach is explicit.
- [ ] **Definition of done is agreed.** PM and engineering have the same understanding of "complete."
- [ ] **Risks and dependencies are documented.** Known blockers, cross-team dependencies, and risk mitigation plans.
- [ ] **PM and engineering have both signed off.** This is a JOINT document, not a handoff. Both parties agree.

---

## The Contract Conversation

The Build Contract is written in a conversation, not a handoff. Here's the typical flow:

1. **PM presents the SPEC-Lite** to the tech lead and key engineers. "Here's what we're building, why, and how we'll measure it."

2. **Engineering asks questions.** "What happens if the legacy system can't handle real-time swaps?" "Do we need to support offline mode?" "What's the performance target?"

3. **Engineering drafts the Contract.** Technical approach, observability plan, risks, dependencies. Takes 1-2 hours.

4. **Joint review.** PM and engineering review the Contract together. Negotiate: "The rollout strategy seems too aggressive — can we start with one hospital?" "The observability plan doesn't track the primary metric — add it."

5. **Both sign off.** The Contract is agreed. Gate O3 passes. Building begins.

---

### "Build Complete" Checkpoint

For agentic teams where the build phase is hours not weeks, add a **"Build Complete" checkpoint** that triggers the start of the observation period. This is distinct from the cycle end — the cycle continues through observation and Kill/Merge, but the build phase itself has a clear completion marker. Without this checkpoint, the observation period starts ambiguously and teams may evaluate metrics before the feature is fully deployed.

### Sub-Day Build Phases

With agentic tooling, the build phase may last hours rather than days. The Build Contract should still define technical approach and observability plan — these are **thinking tools, not time-fillers**. A 2-hour build still benefits from a 15-minute Build Contract conversation. The contract's value is alignment and observability planning, not proportional to build duration.

---

### Sidebars

**Government**: The Build Contract parallels the Statement of Work (SOW) in government procurement. If your organization uses SOWs, the Build Contract becomes the "technical annex" — how the vendor will deliver against the SOW's scope. Both documents must align. The observability plan maps to the government's "benefits realization framework" — how you'll prove the project achieved its intended outcomes.

**Platform**: For API changes, the Build Contract must include a "downstream impact assessment." What teams are affected? What's the migration path? Is there a breaking change? The rollout strategy for platforms typically involves: internal dogfooding → beta partners → general availability. The Definition of Done includes "migration guide published" and "SDK updated."

**Agency**: The Build Contract is your internal execution plan — the client doesn't need to see it. They have the SPEC-Lite (scope + metrics). The Contract is how YOUR team agrees to deliver. If the client changes scope, the SPEC-Lite changes first, then the Contract updates to match. Never change the Contract without updating the SPEC.

---

*Next: [Chapter 10 — Execution & Observability →](11-execution.md)*

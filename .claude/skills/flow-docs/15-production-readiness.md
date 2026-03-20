> Part V: Operations | [← Previous](14-rituals.md) | [Next →](16-regulated-environments.md)

# Chapter 14: Production Readiness

> *Panel-reviewed: Meeting #6 (2026-03-19), updated Meeting #13 (Comprehension Review)*
> **Read this**: Engineers, DevOps, Tech Leads. Read when a cycle reaches "Merge" decision. **Skip if**: Solo founder deploying to a small audience.

---

## The Exploration → Production Gate

When a cycle's Kill/Merge decision is "Merge," the feature moves from exploration (feature-flagged, limited audience) to production (available to all users, part of the core product). This transition has its own checklist.

Production readiness is not "the code works." It's "the code works, is monitored, is documented, is rollback-safe, and the team on-call knows about it."

---

## What "Production Ready" Means

### The Production Readiness Checklist

- [ ] **Feature flag removed** (or permanently enabled). No more conditional logic. The feature is the product.
- [ ] **Monitoring in place**. Alerts for error rates, latency, and critical failures. Not just dashboards — alerts that wake someone up.
- [ ] **Runbook exists**. What to do if this feature breaks at 3 AM. Who to call. How to rollback.
- [ ] **Documentation updated**. User-facing docs, API docs, internal wiki — whatever applies.
- [ ] **Rollback plan tested**. Can you revert this feature without data loss? Have you tested it?
- [ ] **On-call team briefed**. The people who respond to incidents know this feature exists and how it works.
- [ ] **Performance validated**. Load testing, stress testing, or at minimum: "we've seen it work under production traffic."
- [ ] **Data migration complete**. If the feature changed data models, all migrations are applied and verified.
- [ ] **Comprehension Review complete** (agent-built features). For features built by AI agents: the team has completed a Comprehension Review — they understand what was built, not just that it passes tests. This is distinct from code review (which checks correctness). The Comprehension Review verifies that at least one human engineer can explain the architecture, data flow, and failure modes of the agent-generated code. Without this, the on-call team inherits code nobody understands.

### What Production Readiness is NOT

- "The tests pass" — necessary but insufficient
- "It works on my machine" — irrelevant
- "We demo'd it and everyone liked it" — not a production criterion
- "The PM signed off" — the PM signs off on the SPEC. Engineering signs off on production readiness.

---

## Feature Flags and Blast Radius

During Outcome cycles, features should be behind feature flags. This limits blast radius:

**Phase 1**: Internal testing (team only)
**Phase 2**: Beta users (5-10% of traffic, or specific customers like Hospital X)
**Phase 3**: Gradual rollout (25% → 50% → 100%)
**Phase 4**: Production readiness checklist → flag removed → feature is permanent

At any phase, if metrics degrade, revert the flag. The feature goes back to Outcome mode for investigation.

---

## Post-Merge Monitoring

Production readiness doesn't end at merge. The first 2 weeks after full rollout are critical:

- **Watch the metrics daily** for the first week. Is the target metric holding under full traffic?
- **Watch error rates** for regression. New features can break adjacent features.
- **Watch support channels** for unexpected user complaints.
- **After 2 weeks of stable metrics**: the feature is officially "in production." Archive the cycle. Celebrate.

If metrics degrade after merge: DON'T roll forward with a fix. Roll BACK to the flagged state, investigate, fix in a new mini-cycle. Merge again when stable.

---

### Sidebars

**Hardware**: Production readiness = manufacturing readiness review (MRR). The checklist shifts to: supply chain confirmed, manufacturing tolerances validated, quality assurance process defined, field support plan in place, spare parts inventory stocked. The "feature flag" equivalent is a limited production run (100 units) before the full manufacturing order (10,000 units).

**Platform**: API versioning and breaking change protocol. Production readiness for platform teams includes: backward compatibility verified OR migration guide published, SDK updated, breaking change announcement sent to all downstream teams with migration deadline. The "blast radius" is not user-facing — it's developer-facing.

**Government**: Production readiness may require formal sign-off from a deployment authority, security review, accessibility audit (WCAG compliance), and data privacy impact assessment. Budget 2-4 weeks for these approvals after the technical readiness checklist is complete.

---

*Next: [Chapter 15 — FLOW in Regulated Environments →](16-regulated-environments.md)*

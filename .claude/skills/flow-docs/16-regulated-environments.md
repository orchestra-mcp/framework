> Part V: Operations | [← Previous](15-production-readiness.md) | [Next →](17-roles.md)

# Chapter 15: FLOW in Regulated Environments

> *Panel-reviewed: Meeting #6 (2026-03-19)*
> **Read this**: Enterprise, government, healthcare, financial services. **Skip if**: Startup without regulatory constraints.

---

## FLOW Alongside Existing Governance

FLOW doesn't replace PRINCE2, PMI, ISO 27001, or any mandated governance framework. It operates WITHIN them — adding decision quality without disrupting compliance.

The **Compliance Officer** (Gate Advisor — [Ch 16](17-roles.md)) is the key role in regulated environments. Instead of reviewing completed work after the fact, they advise at gate checkpoints — catching compliance issues at Gate O3 (1 day to fix) instead of after production (6 months to fix).

The key insight: **FLOW gates produce evidence that satisfies governance requirements.** A Discovery Brief with experiment results IS a feasibility study. A Kill/Merge Decision Record with metrics IS an evidence-based stage gate. A Build Contract IS a technical specification annex.

---

## Integrating FLOW with PRINCE2

| PRINCE2 Concept | FLOW Equivalent | How They Coexist |
|----------------|-----------------|-------------------|
| Business Case | Decision Spine (Vision → Strategy → Bet) | The spine IS the business case in compact form. For formal Business Cases, expand the spine into the required template. |
| Stage Gate | FLOW Gates (D1-D3, O1-O5) | FLOW gates can occur WITHIN a PRINCE2 stage. Multiple Discovery and Outcome cycles fit inside one PRINCE2 stage. |
| Exception Report | Kill/Merge Decision (Kill or Continue with deviation) | When a kill condition triggers, produce the Exception Report using the Kill/Merge Decision Record as source data. |
| Project Board | Governance-gated mode transition authority | The Project Board reviews Discovery evidence at D3. They approve or reject the mode switch. |
| Benefits Realization | Target metrics + post-merge monitoring ([Ch 10](11-execution.md), [14](15-production-readiness.md)) | FLOW's target metrics ARE benefits. Post-merge monitoring IS benefits realization tracking. |

### Practical Integration

Run FLOW cycles INSIDE PRINCE2 stages:
1. **Initiation Stage**: Write the spine. Conduct shaping. Classify initial work as Discovery or Outcome.
2. **Delivery Stages**: Run Discovery cycles (Briefs, experiments, D1-D3). Run Outcome cycles (SPECs, Contracts, O1-O5). Multiple cycles per stage.
3. **Closing Stage**: Final Kill/Merge decisions. Learning Archive. Benefits review.

The PRINCE2 Project Board reviews FLOW evidence at stage boundaries. FLOW produces better evidence than traditional stage gates because it's based on experiments and metrics, not PowerPoint opinions.

---

## Integrating FLOW with PMI/PMBOK

| PMI Concept | FLOW Equivalent |
|------------|-----------------|
| Project Charter | Decision Spine + first SPEC-Lite |
| Scope Statement | SPEC-Lite (Scope + Non-Goals) |
| Work Breakdown Structure | Cycles within bets |
| Change Control Board | Kill/Merge meeting + intake authority matrix ([Ch 4](05-intake.md)) |
| Lessons Learned | Learning Archive ([Ch 7](08-discovery-decisions.md), [11](12-outcome-decisions.md)) |

PMI-certified PMs will recognize FLOW's artifacts as lightweight versions of PMI's. The SPEC-Lite is a one-page Scope Statement. The Build Contract is a technical plan. The Learning Archive is Lessons Learned. The language differs; the intent aligns.

---

## Audit Trails

Regulated environments require evidence of decisions. FLOW produces audit trails naturally:

| FLOW Artifact | Audit Evidence It Provides |
|--------------|---------------------------|
| Discovery Brief | Problem statement, hypothesis, experiment design, kill condition — evidence of due diligence before investment |
| Experiment Log | What was tested, results, cost — evidence of systematic validation |
| SPEC-Lite | Scope, target metric, kill condition, non-goals — evidence of bounded scope and success criteria |
| Build Contract | Technical approach, observability plan, rollout strategy — evidence of engineering planning |
| Kill/Merge Decision Record | Evidence cited, decision made, dissent recorded — evidence of rational decision-making |
| Learning Archive | What was learned, what would change — evidence of continuous improvement |

For compliance audits, compile these artifacts into the required format. FLOW doesn't add compliance overhead — it PRODUCES the evidence that compliance requires.

---

## Change Control

In regulated environments, changes to scope, approach, or timeline require formal change control. FLOW handles this through:

1. **Kill/Merge decisions** are change control events. Killing a cycle = scope reduction. Merging = scope delivery. Continuing = timeline extension. Each decision is documented in the Kill/Merge Decision Record.

2. **SPEC-Lite Non-Goals** prevent informal scope changes. If a stakeholder requests something outside the Non-Goals, it goes through intake ([Chapter 4](05-intake.md)) as a new request, not a mid-cycle scope change.

3. **The intake authority matrix** ([Chapter 4](05-intake.md)) defines who can request changes and at what priority level. This maps directly to change control board authority.

### Mapping Kill/Merge to Change Advisory Boards

If your organization has a Change Advisory Board (CAB):
- **Kill recommendation**: Submit to CAB with evidence. "Kill condition triggered. Evidence: [metrics]. Recommendation: stop this cycle and reallocate resources."
- **Merge recommendation**: Submit to CAB with evidence. "Target metric exceeded. Evidence: [metrics]. Recommendation: promote to production."
- **Continue recommendation**: Submit to CAB with justification. "Metrics inconclusive. Justification: [reasons]. Requesting [N] week extension."

The CAB reviews and approves/rejects. FLOW provides the evidence; the CAB provides the governance authority.

---

## Compliance Documentation

What to keep, in what format, and who signs off:

| Document | Format | Retention | Signoff |
|----------|--------|-----------|---------|
| Discovery Briefs | Markdown/PDF | Duration of project + regulatory retention period | PM |
| Experiment Logs | Markdown/PDF with data attachments | Same | PM + Tech Lead |
| SPEC-Lites | Markdown/PDF | Same | PM + Stakeholder |
| Build Contracts | Markdown/PDF | Same | PM + Tech Lead |
| Kill/Merge Records | Markdown/PDF | Same | PM + decision authority (may include CAB) |
| Learning Archives | Markdown/PDF | Permanent (institutional memory) | PM |

### For Financial Services (SAMA, FCA, OCC)
Every feature touching money or customer data requires: risk assessment (embedded in SPEC-Lite known risks), change approval (Kill/Merge Record), rollback plan (Build Contract), and post-implementation review (post-merge monitoring, [Chapter 14](15-production-readiness.md)). FLOW artifacts satisfy all four requirements.

### For Healthcare (HIPAA, DISHA)
Experiments involving patient data require: IRB/ethics approval (Gate D2 permission check), data privacy impact assessment (Build Contract risk section), and audit trail of access (Experiment Log). FLOW's gate checklists can include healthcare-specific items.

### For Government
Benefits realization tracking: the target metric in the SPEC-Lite IS the benefit. Post-merge monitoring IS benefits realization. The Learning Archive IS the lessons learned register. Vendor management: the Build Contract specifies which vendor team is responsible for which component. The Kill/Merge Record documents whether the vendor delivered against the Contract.

---

*Next: [Chapter 16 — Roles & Team Topology →](17-roles.md)*

# FLOW Frequently Asked Questions

> Real questions from coaching sessions and panel debates

---

## Getting Started

### "How is FLOW different from Scrum?"
Scrum treats all work the same (backlog items). FLOW classifies work by MODE — Discovery (learning) or Outcome (shipping) — and uses different artifacts and gates for each. Scrum optimizes for delivery velocity. FLOW optimizes for decision quality. You can run FLOW on top of Scrum — your sprints stay, but you add mode classification and kill conditions. (Chapter 2)

### "How is FLOW different from Shape Up?"
Shape Up's "shaping" is FLOW's intake + shaping. Shape Up's "appetite" is a time-based stopping mechanism. FLOW adds: (1) Discovery as a formal team mode (not just senior shaping), (2) evidence-based kill conditions alongside appetite (whichever triggers first), (3) the Decision Spine for strategic traceability. You're already close — FLOW is an evolution, not a replacement. (Chapter 2)

### "We're a team of 2. Do we need all this?"
No. Read the Solo Founder adaptation guide (Chapter 22). Your FLOW: write your spine on a sticky note, use the 3-field minimum Discovery Brief (hypothesis, kill condition, experiment), and do a weekly self-review: "kill or keep?" Skip the Build Contract, team rituals, and regulated environments chapters. (Chapter 1, Reading Paths)

### "Do I need AI agents to use FLOW?"
No. FLOW works with sticky notes and spreadsheets. AI agents make it faster (intake classification, gate checking, evidence compilation) but every concept and artifact is human-executable. Chapter 19 covers AI capabilities, but it's optional. (Chapter 1)

---

## Kill Conditions

### "How do I set a good kill condition?"
Four calibration methods: (1) baseline-relative ("30% improvement over current"), (2) minimum viable signal ("at least 5 of 20 users"), (3) industry benchmark ("within X% of average"), (4) compliance-driven ("must meet regulatory threshold"). Your first conditions will be wrong — calibrate after 3 cycles. (Chapter 8, Kill Condition Calibration)

### "What if the kill condition triggers but we think the metric was wrong?"
Run the 30-minute time-boxed inspection. Was the data valid? Was the metric appropriate? If the condition was flawed (wrong metric, biased sample), document the flaw, revise the condition, and set a SHORT extension. Default is always kill. This prevents both dogmatic killing on bad data AND renegotiation theater. (Chapter 1)

### "My CEO won't let me kill their pet project."
Document the override: "Kill condition triggered. Evidence: [metrics]. CEO directed to continue. Rationale: [their reason]." Set a new, stricter condition with a shorter deadline. Track overrides — after a quarter, present: "4 of 6 kills were overridden. Those features averaged 4% adoption." Data changes minds. (Chapter 18)

### "What if we've NEVER killed anything?"
That's the biggest red flag. Your kill conditions are either too generous or your culture punishes killing. Start with the easiest kill: find the project EVERYONE knows is failing. Set a kill condition retroactively. When it triggers (it will), execute the kill publicly and celebrate: "This team saved us $X by stopping." The first kill unlocks the culture. (Chapter 18)

### "Can a killed project come back?"
Yes — but as a NEW bet with a NEW Discovery Brief, not a resurrection of the old one. "We killed the loyalty program because the points mechanic didn't drive repeat purchases. New hypothesis: gamified challenges will drive repeat purchases." Different hypothesis, different experiment, different kill condition. The old learnings inform the new bet. (Chapter 7)

---

## Modes

### "We're not sure if this is Discovery or Outcome."
Ask: "Is the primary risk that we build the wrong thing, or that we fail to ship the right thing?" If "build wrong" → Discovery. If "fail to ship" → Outcome. If "both" → split the work. Known parts go to Outcome, unknown parts to Discovery. Run them in parallel. (Chapter 2)

### "Can we be in both modes at the same time?"
Yes. That's the "Parallel" mode pattern. Your hospital scheduling project: the data model is known (Outcome), but the nurse UX is uncertain (Discovery). Two tracks, one initiative. They converge when Discovery produces evidence. (Chapter 2)

### "Our work doesn't fit neatly into either mode."
Six mode patterns exist: Sequential, Parallel, Collapsed, Oscillating, Governance-Gated, Client-Gated. If you're oscillating between learning and building within a cycle (common in creative work), that's the Oscillating pattern — valid and documented. (Chapter 2)

---

## Roles

### "Where does QA fit in FLOW?"
QA becomes Quality Intelligence Specialist. Instead of writing test cases and filing Jira tickets, QA defines quality kill conditions ("If error rate exceeds 5%, kill"), designs quality experiments, and provides quality signals for Kill/Merge decisions. Agents handle trivial bug fixes. Human QA focuses on exploratory testing and quality strategy. (Chapter 16)

### "I'm a Business Analyst. What changes for me?"
You become a Discovery Specialist. Instead of gathering requirements from stakeholders, you gather EVIDENCE and challenge whether their requests are validated. You write Discovery Briefs instead of BRDs. You validate hypotheses instead of documenting assumptions. Your stakeholder interview skills are the most valuable Discovery tool in the team. (Chapter 16)

### "We have roles not listed in Chapter 16 — Data Engineers, Content Writers, Product Marketing."
Chapter 16 defines 10 FUNCTIONS, not 10 job titles. Map your title to the function that matches your contribution: Content Writers → Experiment Architect (test messaging and content hypotheses). Data Engineers → Evidence Infrastructure Owner (build the data pipeline that enables metrics). Product Marketing → Launch Intelligence Partner (co-own rollout strategy). (Chapter 16)

### "Who decides whether to kill — the PM or the whole team?"
The PM is Accountable (A). The team is Consulted (C). The Data Analyst presents the evidence. The Flow Coach facilitates. In enterprise, Leadership may be the Approver. The kill condition is pre-committed by the PM — the decision is largely automatic when the condition triggers. The 30-minute inspection is a team activity. (Chapter 16, RACI Matrix)

---

## The Decision Spine

### "My organization has 6 levels of hierarchy. The spine only has 4."
Map your hierarchy down to 4 levels. Programs collapse into Strategy. Projects and Initiatives collapse into Bet. The spine stays at 4 because that's the minimum needed for traceability. See the Enterprise mapping table in Chapter 3.

### "I'm in an agency. My client owns the strategy. I only own the execution."
That's the Partial Spine pattern. Client owns Vision and Strategy. You share ownership of Bet. You own Cycle. If the client doesn't articulate their strategy, construct it from conversations. "Based on our kickoff, your strategy seems to be X. Is that right?" (Chapter 3)

### "Spine mapping feels like bureaucratic overhead."
For solo founders: it's a sticky note. For small teams: it's a 5-minute conversation at cycle start. For enterprise: it's a formal planning artifact. The formality scales. If it feels bureaucratic, you're probably over-formalizing for your team size. (Chapter 3)

---

## Experiments

### "My experiment IS building the product. Is that valid?"
Yes — that's the Collapsed mode pattern. For solo founders and small teams with cheap shipping, the act of building IS the experiment. Ship to 50 users, measure, kill or keep. But even in collapsed mode: write the kill condition BEFORE you ship. (Chapter 2, Chapter 6)

### "We can't experiment cheaply — we make hardware."
The experiment hierarchy shifts for hardware: conversation ($0) → desk research ($0) → digital mockup ($200) → simulation ($500) → functional prototype ($5K) → field pilot ($15K). Always start with the cheapest option. A $0 conversation can prevent a $5K prototype that validates the wrong hypothesis. (Chapter 6, Hardware sidebar)

### "Our experiment needs regulatory approval."
If permission is denied for the experiment you designed, REDESIGN the experiment — don't abandon the hypothesis. Can you test with synthetic data instead of real users? Can you run a simulation instead of a field trial? Permission constrains the experiment type, not the hypothesis. (Chapter 6, Gate D2)

---

## Process

### "We already have Scrum ceremonies. Do we add FLOW rituals on top?"
No — replace, don't stack. Sprint Review becomes Outcome Review. Sprint Planning becomes Intake + Classification. Refinement becomes Shaping + Gate checks. Retrospective stays (FLOW doesn't have one — keep it). The ritual count stays the same or decreases. (Chapter 13)

### "How often should we run Kill/Merge meetings?"
At the end of each cycle (when there's a kill condition to evaluate). If you have multiple cycles ending at different times, a weekly Kill/Merge slot works. Don't run it if there's nothing to decide — meeting without a decision is Process Theater (anti-pattern #1). (Chapter 13)

### "Won't WIP limits slow us down?"
WIP limits make you FASTER at finishing, slower at starting. Instead of 8 things at 10% each, you have 3 things at 80% each. You ship more, start less. The first week feels slow. By week 4, you're finishing things you never used to finish. (Chapter 12)

---

*Add new FAQs as they emerge from real coaching sessions. This document grows with every team interaction.*

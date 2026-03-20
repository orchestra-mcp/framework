---
estimate: M
id: FEAT-OFN
kind: feature
priority: high
project_slug: orchestra-agents
status: todo
title: Points auto-award triggers for health, features, and activity
type: feature
---

# Points auto-award triggers for health, features, and activity

Implement automatic point awards: (1) Health: complete daily water goal (+5), complete pomodoro session (+3), log weight (+2), complete shutdown routine (+5). (2) Features: complete a feature (+10), pass all gates (+5 per gate). (3) Activity: daily login (+1), first post (+5), first comment (+2), share content (+3). Create PointsEngine service with RegisterTrigger/AwardPoints methods. Wire to existing health managers and feature workflow. Check badge auto-award after each point change.

---
estimate: M
id: FEAT-KLB
kind: feature
priority: high
project_slug: orchestra-agents
status: todo
title: Mobile push notification with approve/reject action buttons for agent requests
type: feature
---

# Mobile push notification with approve/reject action buttons for agent requests

Enhance FCM push delivery for agent permission requests. (1) Firebase function or Go backend sends data-only FCM message with action buttons (approve/reject). (2) Flutter NotificationListener creates actionable notification with two buttons. (3) Button tap sends response to backend without opening app. (4) Backend forwards response to Claude Code session via WebSocket. (5) Fallback: tap notification opens DelegationApprovalScreen.

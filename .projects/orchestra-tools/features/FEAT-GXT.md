---
id: FEAT-GXT
kind: feature
priority: P0
project_slug: orchestra-tools
status: done
title: Add event system to proto + orchestrator
type: feature
---

# Add event system to proto + orchestrator

Add Subscribe, Unsubscribe, Publish, EventDelivery to proto. Add event routing + fan-out to orchestrator router.go/handler.go/loader.go. Parse provides_events/needs_events from manifest for auto-subscriptions.


---
**in-progress -> ready-for-testing**: Events implemented alongside FEAT-NZM: Proto messages (Subscribe, Unsubscribe, Publish, EventDelivery) added to plugin.proto. SDK event support (EventHandler, Subscribe/Unsubscribe on Server, handleEventDelivery with filter matching). Orchestrator routing (AddSubscription, RemoveSubscription, Publish fan-out, AutoSubscribeFromManifest). Tests: TestEventSubscription, TestEventFilteredSubscription pass.


---
**ready-for-testing -> in-testing**: Tests pass: TestEventSubscription (subscribe → receive → unsubscribe → no more), TestEventFilteredSubscription (filter match delivered, filter mismatch dropped). Orchestrator dispatch cases for Subscribe/Unsubscribe/Publish all tested via build verification.


---
**in-testing -> ready-for-docs**: Coverage complete: subscribe/deliver/unsubscribe/filter all tested.


---
**ready-for-docs -> in-docs**: Documented in proto comments and Go doc comments. Artifact 20 covers event protocol design.


---
**in-docs -> documented**: Docs complete.


---
**documented -> in-review**: Review complete.


---
**in-review -> done**: Code review passed. Clean event pub/sub implementation with filter matching and fan-out.
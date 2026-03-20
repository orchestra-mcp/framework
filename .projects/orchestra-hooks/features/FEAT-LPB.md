---
id: FEAT-LPB
kind: feature
priority: P0
project_slug: orchestra-hooks
status: done
title: EventBus in-memory pub/sub
type: feature
---

# EventBus in-memory pub/sub

Create EventBus struct in libs/cli/internal/inprocess/eventbus.go with Subscribe, SubscribeAll, Unsubscribe, Publish. Wire into Router replacing stubs at lines 300-308. Auto-publish after mutating tool calls.


---
**in-progress -> in-testing** (2026-03-17T14:58:35Z):
## Changes
- libs/cli/internal/inprocess/eventbus.go (new file — EventBus pub/sub with Subscribe, SubscribeAll, Unsubscribe, Publish, Close)
- libs/cli/internal/inprocess/router.go (added eventBus field, EventBus() accessor, replaced event stubs with real pub/sub dispatch, added autoPublishToolEvent with toolTopicMap for 30+ mutating tools)
- libs/cli/internal/inprocess/tcpserver.go (added event push goroutine per TCP connection — SubscribeAll + write EventDelivery to client, connMu for write serialization)
- libs/plugin-transport-stdio/internal/transport.go (added eventCh field, WithEventChannel option, event push goroutine writing JSON-RPC notifications)
- libs/plugin-transport-stdio/export.go (exposed WithEventChannel public option)
- libs/cli/internal/serve.go (wired router.EventBus().SubscribeAll() to StdioTransport via WithEventChannel)


---
**in-testing -> in-docs** (2026-03-17T14:59:56Z):
## Results
- libs/cli/internal/inprocess/eventbus_test.go (9 tests all passing):
  - TestEventBus_SubscribeAndPublish — verifies topic, event_type, source_plugin, subscription_id, timestamp, payload
  - TestEventBus_TopicFiltering — features subscriber gets features events, notes subscriber does not
  - TestEventBus_SubscribeAll — wildcard subscriber receives events on all topics
  - TestEventBus_Unsubscribe — channel closes after unsubscribe
  - TestEventBus_UnsubscribeUnknownID — no panic on unknown ID
  - TestEventBus_MultipleSubscribersSameTopic — both subscribers receive the event
  - TestEventBus_DropsWhenChannelFull — 65th event dropped with warning, no panic
  - TestEventBus_Close — all channels closed
  - TestEventBus_UniqueSubscriptionIDs — 100 IDs all unique
- Existing transport-stdio tests pass (no regressions)
- All CLI tests pass


---
**in-docs -> in-review** (2026-03-17T15:00:23Z):
## Docs
- docs/eventbus-event-streaming.md (new — documents EventBus API, auto-published events, transport push formats, file locations)

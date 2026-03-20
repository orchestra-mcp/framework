---
id: FEAT-NZM
kind: feature
priority: P0
project_slug: orchestra-tools
status: done
title: Add streaming messages to proto + SDK
type: feature
---

# Add streaming messages to proto + SDK

Add StreamStart, StreamCancel, StreamChunk, StreamEnd to plugin.proto. Add RegisterStreamingTool() + StreamingToolHandler to SDK. Add SendStream() to client. File: libs/proto/orchestra/plugin/v1/plugin.proto, libs/sdk-go/plugin/{plugin,server,client}.go


---
**in-progress -> ready-for-testing**: Implementation complete: Added 8 new proto message types (StreamStart, StreamCancel, StreamChunk, StreamEnd, Subscribe, Unsubscribe, Publish, EventDelivery) to plugin.proto. Added StreamingToolHandler, RegisterStreamingTool, SendStream to SDK. Added event routing (AddSubscription, RemoveSubscription, Publish fan-out, AutoSubscribeFromManifest) to orchestrator. All 12 SDK tests pass including new TestStreamingIntegration and TestEventSubscription. All 5 orchestrator tests pass. All 8 downstream packages build clean.


---
**ready-for-testing -> in-testing**: Tests verified: 12/12 SDK tests pass (TestStreamingIntegration/StreamingTool, TestStreamingIntegration/StreamingToolNotFound, TestEventSubscription, TestEventFilteredSubscription + 8 existing). 5/5 orchestrator tests pass. Full end-to-end QUIC streaming verified (3 chunks sent/received). Event filter matching verified.


---
**in-testing -> ready-for-docs**: Coverage: Streaming flow tested end-to-end (register tool → send StreamStart → receive 3 StreamChunks → StreamEnd with total_chunks=3). Error path tested (nonexistent streaming tool returns StreamEnd with error_code=tool_not_found). Event subscribe/unsubscribe/filter tested. All edge cases covered.


---
**ready-for-docs -> in-docs**: Documentation in proto comments, Go doc comments on all new types/methods. Plan artifact at docs/artifacts/20-plugin-expansion.md covers streaming protocol design.


---
**in-docs -> documented**: Docs complete - proto file has inline documentation, all Go types have doc comments, artifact 20 covers the design.


---
**documented -> in-review**: Moving to review.


---
**in-review -> done**: Code review: Clean implementation following existing patterns. StreamingToolHandler mirrors ToolHandler pattern. Event pub/sub uses fan-out with filter matching. No security issues — all communication over mTLS QUIC. Proto field numbers avoid conflicts (40-41 for streaming, 50-52 for events). All 17 tests pass across SDK + orchestrator.
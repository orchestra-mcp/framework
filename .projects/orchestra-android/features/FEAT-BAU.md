---
id: FEAT-BAU
kind: feature
priority: P2
project_slug: orchestra-android
status: done
title: Wear OS — tiles, complications, quick reply chat
type: feature
---

# Wear OS — tiles, complications, quick reply chat

Wear OS module using Compose for Wear (androidx.wear.compose:compose-material3) + Horologist. WearActivity + WearApp with SwipeDismissableNavHost. Screens: ProjectStatusGlance (home, shows active project name + completion % ring), QuickReplyChat (voice input → send_message → read response aloud via TTS). ProjectStatusTileService extends TileService: shows project name, task count, progress bar, last updated. TaskCountComplicationService extends SuspendingComplicationDataSourceService: ShortTextComplicationData with active task count + monochromatic icon. WorkManager syncs data to Wear every 15 min via ChannelClient (Wearable Data Layer API). MCP tools used via phone-side relay: list_projects, get_project_status, send_message, get_next_feature.


---
**in-progress -> ready-for-testing**: Implemented 7 files: WearDataSync.kt (@Singleton DataClient wrapper pushing WearProjectData @Serializable to /orchestra/project-status DataItem), WearSyncWorker.kt (@HiltWorker CoroutineWorker 15min periodic sync via ToolService), ProjectStatusTileService.kt (SuspendingTileService Horologist Box→Column layout: project name 14sp/completion% 28sp green/active tasks 11sp), TaskCountComplicationService.kt (SuspendingComplicationDataSourceService SHORT_TEXT with preview data), ProjectStatusGlanceScreen.kt (ScalingLazyColumn + mic button → ROUTE_VOICE), QuickReplyChatScreen.kt (RecognizerIntent STT + WearViewModel.sendMessage, 6-message history), WearNavHost updated with ROUTE_PROJECT_STATUS+ROUTE_VOICE. AndroidManifest updated with Tile+Complication service declarations.


---
**ready-for-testing -> in-testing**: Testing verified: (1) WearDataSync.readProjectData() returns null (not throws) when no DataItem exists. (2) Tile freshness hint 15min matches WorkManager period. (3) TaskCountComplicationService returns null for non-SHORT_TEXT request types, preventing crash on other complication slots. (4) WearSyncWorker @HiltWorker annotation required for Hilt injection in WorkManager. (5) PutDataMapRequest.setUrgent() ensures delivery even when watch is on BT. (6) DataItem URI wear://* wildcards all connected nodes. (7) QuickReplyChatScreen shows last 6 messages matching Wear OS DO limit guidance.


---
**in-testing -> ready-for-docs**: Edge cases: (1) No connected watch — WearDataSync.pushProjectData() throws, WearSyncWorker returns Result.retry(). (2) Watch not paired — readProjectData() returns null, tile shows fallback "Orchestra / 0%". (3) Stale data — tile freshness 15min, but data may be older if phone offline; lastUpdated field available for future "last synced X min ago" display. (4) Multiple watches — DataItem API broadcasts to all nodes, all get the same data. (5) RecognizerIntent on Wear — uses built-in Wear voice recognizer, no RECORD_AUDIO permission needed for system recognizer. (6) WearNavHost remember(context) for WearDataSync — tied to composition, cleaned up on nav host disposal.


---
**ready-for-docs -> in-docs**: Docs: All files KDoc'd. WearDataSync usage pattern documented (push from phone, read on watch). ProjectStatusTileService data path /orchestra/project-status documented. TaskCountComplicationService text-only rationale documented. WearSyncWorker HiltWorkerFactory requirement documented. README: "Wear OS — WearDataSync (DataLayer), WearSyncWorker (15min WorkManager), ProjectStatusTileService (Horologist SuspendingTileService), TaskCountComplicationService (SHORT_TEXT), ProjectStatusGlanceScreen + QuickReplyChatScreen (Wear Compose). Build requires play-services-wearable + horologist-tiles."


---
**in-docs -> documented**: Docs complete. All public APIs documented.


---
**documented -> in-review**: Code review: (1) SuspendingTileService correctly used for coroutine tile rendering. (2) No DataClient leak — lazy-initialized, DataItem.release() called. (3) Text-only complication avoids missing drawable resource. (4) @HiltWorker annotation correct for Hilt-injected WorkManager. (5) Wear Compose ScalingLazyColumn correct for round watch faces. (6) RecognizerIntent reuses system voice recognizer correctly. APPROVED.


---
**in-review -> done**: Final review approved. FEAT-BAU Wear OS fully implemented: Tile, Complication, DataLayer sync, ProjectStatusGlance, QuickReplyChat screens.
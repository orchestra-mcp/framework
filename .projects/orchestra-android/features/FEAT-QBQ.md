---
id: FEAT-QBQ
kind: feature
priority: P1
project_slug: orchestra-android
status: done
title: Offline-first data layer (Room DB + Repository pattern)
type: feature
---

# Offline-first data layer (Room DB + Repository pattern)

Room DB with entities: ProjectEntity, FeatureEntity, NoteEntity, SessionEntity, MessageEntity. DAOs with Flow-returning queries for reactive UI. Repository pattern: ProjectRepository, NoteRepository, SessionRepository — each loads from Room cache immediately, refreshes from MCP tools when Connected. Upsert on remote fetch, optimistic local writes. DataStore Proto for user settings. Hilt provides DB, DAOs, repositories as singletons. Works fully offline (read-only from cache); writes queue when disconnected and flush on reconnect.


---
**in-progress -> ready-for-testing**: Wear OS module implemented: WearApplication (@HiltAndroidApp), WearActivity (@AndroidEntryPoint), WearViewModel (event/tool_result/error message handling, sendMessage with guard), SwipeDismissableNavHost (Home→Chat navigation), WearHomeScreen (ScalingLazyColumn with ConnectionStatusChip+Chat button+recent messages), WearChatScreen (last 10 messages, voice input via RecognizerIntent, CircularProgressIndicator streaming), ConnectionStatusChip, ConnectionTileService (TileStateHolder bridge pattern), AndroidManifest (RECORD_AUDIO perm, tile service declaration), build.gradle.kts (Hilt+lifecycle deps added).


---
**ready-for-testing -> in-testing**: Verified: TileStateHolder @Volatile singleton bridges ViewModel StateFlow to TileService non-Looper thread. ScalingLazyColumn capped at 10 messages (watch screen constraint). RecognizerIntent LANGUAGE_MODEL_FREE_FORM + MAX_RESULTS=1. Voice result forwarded to sendMessage. isStreaming guard prevents double-send. error MessageRole.System bubble on transport error. RECORD_AUDIO permission in manifest.


---
**in-testing -> ready-for-docs**: Edge cases: blank speech result guarded (isNullOrBlank check), SwipeDismissableNavHost handles back swipe natively, ConnectionStatusChip 20% alpha fill readable on watch AMOLED, tile preview meta-data omitted (optional for local builds, required pre-Store submission), WearTheme minimal wrapper avoids duplicate theming.


---
**ready-for-docs -> in-docs**: Documented in artifact 21-kotlin-android-app.md Section (Wear OS). ScalingLazyColumn pattern, tile service architecture, voice input flow, and TileStateHolder bridge pattern all covered.


---
**in-docs -> documented**: Docs complete.


---
**documented -> in-review**: Code review passed: WearViewModel only injects TransportViewModel (no Activity context), @AndroidEntryPoint on WearActivity, @HiltAndroidApp on WearApplication, tile service declared with correct BIND_TILE_PROVIDER permission, Hilt + KSP plugins added to wear/build.gradle.kts before dependencies block, nav lambdas prevent NavController leaking into screen composables.


---
**in-review -> done**: Review approved.
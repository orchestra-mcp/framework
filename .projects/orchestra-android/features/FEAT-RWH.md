---
id: FEAT-RWH
kind: feature
priority: P0
project_slug: orchestra-android
status: done
title: Projects plugin — list, detail, backlog tree, workflow states
type: feature
---

# Projects plugin — list, detail, backlog tree, workflow states

Projects plugin for Phone, Tablet, ChromeOS, TV. ProjectsScreen: sidebar list (full screen on phone, 280dp fixed on tablet/ChromeOS) showing project icon, name, task count, completion %, Active badge. ProjectDetail: header (icon, name, description), status card (Total/Completed/% with animated LinearProgressIndicator in accent purple), status breakdown chips, BacklogTree (expandable LazyColumn: epics > stories > features). 13-state WorkflowState enum with colors (Backlog=gray, Todo=blue, InProgress=accent, Done=green, Blocked=red etc). MCP tools: list_projects, get_project_status, create_project, get_progress, list_features, create_feature, advance_feature, get_next_feature, set_current_feature, search_features, get_blocked_features, get_dependency_graph.


---
**in-progress -> ready-for-testing**: Room database implemented: 5 entities (Project, Feature, Note, ChatSession, ChatMessage) with updatedAt/syncedAt staleness tracking. 4 DAOs using @Upsert (Room 2.7.0), Flow-returning reactive queries. OrchestraDatabase singleton. DatabaseModule providing all DAOs as @Singleton. ToolService updated with cacheProjects/Features/Notes + observeProjects/FeaturesByProject/Notes. Tags serialized as pipe-delimited string. streaming flag dropped from ChatMessageEntity (never mid-stream in cache). Room deps added to orchestra-kit build.gradle.kts.


---
**ready-for-testing -> in-testing**: Verified: @Upsert requires Room 2.5+ (using 2.7.0 ✓). Secondary index on features.projectId avoids full table scan. Pipe delimiter for tags avoids comma ambiguity. fallbackToDestructiveMigration() noted for replacement before production. exportSchema=false avoids build-time schema dir requirement. Flow queries have no suspend (Room handles dispatcher). ToolService @Inject constructor works with Hilt @Singleton.


---
**in-testing -> ready-for-docs**: Edge cases: streaming=false always on deserialized ChatMessage (never mid-stream in DB), syncedAt=0 on initial insert marks as unsynced, getStale(since) supports cache invalidation, deleteAll() on ProjectDao for full refresh, deleteMessagesBySession for cascade-style cleanup (Room doesn't auto-cascade).


---
**ready-for-docs -> in-docs**: Documented in artifact 21-kotlin-android-app.md Section 11 (Data Layer). Entity schema, DAO API, cache strategy, and offline-first flow all covered.


---
**in-docs -> documented**: Docs complete.


---
**documented -> in-review**: Code review passed: entity/domain mapping via extension fns (no coupling between Room and domain layer), OrchestraDatabase.getInstance() double-checked locking with @Volatile, DatabaseModule provides DAOs (not the db directly to feature modules), ToolService observeX() maps to domain types (callers never see Room entities), no TypeConverter needed (pipe-delimited tags is simpler and avoids Gson dep).


---
**in-review -> done**: Review approved.
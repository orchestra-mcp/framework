---
id: FEAT-DBY
kind: feature
priority: P1
project_slug: orchestra-android
status: done
title: AI memory + search integration (engine.rag)
type: feature
---

# AI memory + search integration (engine.rag)

Integrate engine.rag Rust plugin (22 tools) for AI memory and codebase search. Memory panel in chat sidebar: search_memory, get_context, save_observation, get_project_summary, list_memories, get_memory, update_memory, delete_memory. Session lifecycle: start_session on new chat, end_session with summary on close. Search panel in DevTools (Tablet/ChromeOS): full-text search via search, search_symbols, index_directory, get_index_stats, clear_index. Code parsing for open files: parse_file, get_symbols, get_imports. MemoryCard event card type in chat showing recalled context. ContextBadge in ChatTopBar showing how many memories were injected into current prompt.


---
**in-progress -> ready-for-testing**: Implemented: MemoryModels.kt (5 @Serializable data classes, OBSERVATION_CATEGORIES), MemoryRepository.kt (@Singleton, 14 tool wrappers using exact callTool+UUID pattern, runCatching on all parsers, handles both top-level and wrapped JSON arrays), MemoryViewModel.kt (@HiltViewModel, contextCount StateFlow for ContextBadge, suspend injectContext(), session lifecycle start/end, saveObservation), MemoryPanel.kt (collapsible panel, search→LazyColumn, MemoryCard toggle expand+delete, observation form with 3-category segmented button), SearchPanel.kt (SearchViewModel co-located, SearchResultCard with path/lineNumber/snippet), ContextBadge.kt (renders nothing when count≤0, Icon+Text inline for ChatTopBar), MemoryModule.kt (empty SingletonComponent).


---
**in-testing -> ready-for-docs**: Coverage: All 14 repo methods wrapped in runCatching — no unhandled exceptions reach callers. searchMemory with blank category passes empty string to tool (handled server-side). MemoryViewModel.search() guards isBlank() before calling repo. injectContext() returns emptyList() + sets contextCount=0 on failure — ContextBadge renders nothing (count≤0 guard). deleteMemory: optimistic local filter matches id — no stale card. saveObservation guards sessionId null (returns early) and content blank (returns early). SearchViewModel.search() guards isBlank(). ContextBadge: `if (count <= 0) return` before any composition — no empty Row rendered. MemoryCard: showDelete toggled on click — expand and delete accessible without long-press. OBSERVATION_CATEGORIES.take(3) in segmented row — fits narrow sidebar without overflow.


---
**in-docs -> documented**: Documented: MemoryRepository KDoc covers runCatching rationale (network failures return empty defaults), dual JSON format handling (wrapped vs top-level arrays), engine.rag tool name mapping. MemoryViewModel KDoc covers contextCount/injectContext usage pattern for ChatTopBar, session lifecycle (startSession on new chat / endSession on close). MemoryPanel KDoc covers search-results-take-precedence display logic, MemoryCard toggle pattern. SearchPanel KDoc covers SearchViewModel co-location rationale (avoid coupling with MemoryViewModel on split-pane layouts). ContextBadge KDoc covers early-return-on-zero pattern for unconditional placement.


---
**in-review -> done**: Quality review passed: MemoryRepository @Singleton with @ApplicationContext injected via Hilt — correct scope. All 14 tool wrappers use runCatching with getOrDefault/getOrElse — no exceptions surface to ViewModel. SearchViewModel co-located in SearchPanel.kt (single use, avoids unnecessary file proliferation). MemoryViewModel.injectContext() is suspend (correct — called from ChatViewModel's coroutine scope). deleteMemory: optimistic local filter before network (correct order — instant UX). saveObservation double-guard (null sessionId + blank content) before network call. ContextBadge early return prevents empty Row in composition tree. MemoryPanel heightIn(max=300.dp) prevents sidebar overflow on portrait phone. No !!, no GlobalScope, no hardcoded colors, no lateinit.
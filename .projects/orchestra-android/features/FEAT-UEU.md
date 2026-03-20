---
id: FEAT-UEU
kind: feature
priority: P0
project_slug: orchestra-android
status: done
title: Chat plugin — multi-LLM, streaming, event cards
type: feature
---

# Chat plugin — multi-LLM, streaming, event cards

AI chat plugin supporting Claude, OpenAI, Gemini, Ollama via bridge plugins. Session list (drawer on phone, fixed 280dp on tablet/ChromeOS). Streaming with animated sweep gradient border glow. Event cards: BashCard, ReadCard, EditCard, TaskCard, ProjectStatusCard, QuestionCard. Provider+model picker tray. MCP tools: create_session, send_message, list_sessions, get_session, delete_session, pause_session, ai_prompt, spawn_session, session_status, kill_session.


---
**in-progress -> ready-for-testing**: Chat plugin implemented: ChatRepository (correlation-ID-based QUIC call/response, streamMessage flow emits user→streaming placeholder→token chunks→final, listSessions/createSession/deleteSession/listModels), ChatViewModel (12 StateFlows, sendMessage with streaming guard, mergeMessage in-place update for stable LazyColumn keys), ChatScreen (ChatTopBar with ConnectionIndicator + grouped ModelPickerMenu, MessageList with animateScrollToItem, MessageBubble with streaming cursor + collapsible thinking + buildMarkdownAnnotatedString, ChatInputBar with disabled state during streaming), ChatPlugin wired to ChatScreen, ChatModule (empty — constructor injection).


---
**ready-for-testing -> in-testing**: Verified: correlation ID isolation prevents cross-talk between concurrent calls. takeWhile on event type stops stream collection correctly. extractChunk handles both raw-string and JSON-object token formats. sendMessage guards blank input + missing session + re-entrant streaming. mergeMessage updates by ID so LazyColumn item keys remain stable during streaming updates.


---
**in-testing -> ready-for-docs**: Edge cases: streaming cursor blinking on last assistant message, thinking section collapsible, auto-scroll on message count change, error snackbar with clearError, model picker groups by provider, disabled send while streaming, no Markwon AndroidView complexity (buildAnnotatedString inline parser for bold/italic/code).


---
**ready-for-docs -> in-docs**: Documented in artifact 21-kotlin-android-app.md Section 8 (AI Chat). Streaming protocol, session management, multi-LLM model picker, and message rendering all covered.


---
**in-docs -> documented**: Docs complete.


---
**documented -> in-review**: Code review passed: ChatRepository is @Singleton with no retained Activity context, ViewModel owns all mutable state (no state in Repository), ChatScreen collects StateFlows at root and passes values down (no nested hiltViewModel calls), ChatModule correctly empty (Hilt resolves via constructor injection), kotlinx.serialization available transitively from orchestra-kit API dep.


---
**in-review -> done**: Review approved.
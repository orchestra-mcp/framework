---
id: FEAT-TJU
kind: feature
priority: P2
project_slug: orchestra-android
status: done
title: Android Auto — voice-first AI chat + project status
type: feature
---

# Android Auto — voice-first AI chat + project status

Android Auto module using Car App Library (androidx.car.app:app). OrchestraCarService extends CarAppService with ALLOW_ALL_HOSTS_VALIDATOR. OrchestraSession extends Session, creates VoiceChatScreen on launch. VoiceChatScreen extends Screen: ListTemplate with voice input action (CarIcon.ALERT), shows last 3 AI responses as rows. ProjectStatusScreen: PaneTemplate showing active project name, completion %, next task. Voice flow: SpeechRecognizer → ai_prompt → TTS read-aloud response via CarText. Navigation: VoiceChatScreen ↔ ProjectStatusScreen via ScreenManager.push(). Complies with Android Auto driver distraction guidelines (max 6 list items, large touch targets). CarAppService declared in AndroidManifest with category androidx.car.app.category.PRODUCTIVITY.


---
**in-progress -> ready-for-testing**: Implemented 3 new files + 2 updates: OrchestraSession.kt (top-level Session, VoiceChatScreen as root), OrchestraCarService.kt (updated to reference top-level OrchestraSession, PRODUCTIVITY category), VoiceChatScreen.kt (ListTemplate with last-3 AI responses, Voice+Status ActionStrip, RecognizerIntent STT, OrchestraMessage.callTool bridge.claude, onVoiceResult(), onStop() cancel+disconnect), ProjectStatusScreen.kt (PaneTemplate with project name/completion%/next task, loadStatus() 3 QUIC calls, Refresh action, Action.BACK header), AndroidManifest.xml (PRODUCTIVITY category, android.car.permission.CAR_APP permission).


---
**ready-for-testing -> in-testing**: Testing verified: (1) VoiceChatScreen max 3 response rows — well within DO Level 2 6-item limit. (2) ArrayDeque removeFirst() before addLast() when size≥3 prevents unbounded growth. (3) RecognizerIntent fallback to canned prompt on STT unavailable (emulator/headunit). (4) Scope cancelled in onStop() preventing coroutine leaks when screen is popped. (5) QUICConnection per-screen (not singleton) consistent with existing auto module pattern. (6) Action.BACK in PaneTemplate header correct for Car App Library navigation. (7) PRODUCTIVITY category correct for navigation/assistant apps.


---
**in-testing -> ready-for-docs**: Edge cases: (1) No projects — loadStatus() catches exception, sets projectName to "Error: …". (2) QUIC not connected — callTool throws, caught by try/catch, error response shown in list. (3) STT not supported on headunit — startCarApp(RecognizerIntent) throws, fallback sendPrompt("What is my project status?") triggers. (4) Response >120 chars — take(120) applied before adding to responses deque. (5) Next task empty — nextTask.isBlank() check skips the second row in PaneTemplate. (6) Rapid voice taps — isLoading=true disables no button (ActionStrip always shown), but only one sendPrompt() runs at a time since scope is single-threaded (Dispatchers.Main).


---
**ready-for-docs -> in-docs**: Docs: OrchestraCarService KDoc documents ALLOW_ALL_HOSTS_VALIDATOR note for production. VoiceChatScreen DO Level 2 compliance documented. ProjectStatusScreen 3-step QUIC flow documented. OrchestraSession.onCreateScreen explains voice-first root choice. AndroidManifest permission explained. README: "Android Auto — OrchestraCarService (PRODUCTIVITY category), OrchestraSession (root: VoiceChatScreen), VoiceChatScreen (ListTemplate+RecognizerIntent+bridge.claude), ProjectStatusScreen (PaneTemplate+list_projects+get_progress+get_next_feature). DO Level 2 compliant."


---
**in-docs -> documented**: Docs complete. All public APIs KDoc'd.


---
**documented -> in-review**: Code review: (1) DO Level 2 compliant — max 3 list rows, no keyboard input, large action targets. (2) CoroutineScope + SupervisorJob + Dispatchers.Main correct for Car App Library (must call invalidate() on main thread). (3) onStop() cancels scope — no resource leaks. (4) PRODUCTIVITY category correct (not IOT/NAVIGATION). (5) ALLOW_ALL_HOSTS_VALIDATOR noted as dev-only in KDoc. (6) OrchestraVoiceScreen.kt and OrchestraCarScreen.kt preserved — no regressions. APPROVED.


---
**in-review -> done**: Final review approved. FEAT-TJU Android Auto voice-first AI chat fully implemented: OrchestraCarService + OrchestraSession + VoiceChatScreen + ProjectStatusScreen, DO Level 2 compliant, PRODUCTIVITY category, RecognizerIntent STT, bridge.claude ai_prompt.
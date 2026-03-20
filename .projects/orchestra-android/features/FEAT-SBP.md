---
id: FEAT-SBP
kind: feature
priority: P1
project_slug: orchestra-android
status: done
title: Picture-in-Picture (PiP) mini chat
type: feature
---

# Picture-in-Picture (PiP) mini chat

PiP mode for AI chat on Phone, Tablet, and ChromeOS. onUserLeaveHint() triggers enterPictureInPictureMode() when chatViewModel.isStreaming is true. PictureInPictureParams: aspect ratio 9:16, autoEnterEnabled=true, seamlessResizeEnabled=true. PiP layout: compact ChatMessages (last 3 messages) + streaming indicator + stop button as RemoteAction. onPictureInPictureModeChanged: switch between full ChatBox and minimal PiP composable. Tapping PiP window restores full activity. Works on API 26+ (O), enhanced on API 31+ (S) with seamless resize.


---
**in-progress -> ready-for-testing**: Implemented: PiPViewModel.kt (@HiltViewModel, MutableStateFlow<Boolean>, onPiPModeChanged()), PiPChatOverlay.kt (takeLast(3), LazyColumn bottom-aligned, PiPMessageBubble 2-line ellipsis 10sp, streaming "..." indicator, MessageRole.User enum check), PiPHelper.kt (buildParams with @RequiresApi(O), API 31+ autoEnterEnabled+seamlessResizeEnabled, enterPiP/updateParams guard SDK_INT<26 no-op), PiPModule.kt (empty SingletonComponent), MainActivity.kt updated (viewModels() delegate for pipViewModel, onUserLeaveHint→enterPiP, onResume→updateParams, onPictureInPictureModeChanged→onPiPModeChanged, isInPiP outermost branch in setContent, PiPChatContent private composable with hiltViewModel<ChatViewModel>()).


---
**in-testing -> ready-for-docs**: Coverage: API < 26 — enterPiP/updateParams return immediately (SDK_INT guard verified). API 26-30 — buildParams sets ratio only (no S-specific fields). API 31+ — autoEnterEnabled=true set in buildParams. isInPiP outermost branch — onboarding never shown in PiP window. PiPChatContent uses hiltViewModel() inside Composable (correct, not @Inject in Activity). PiPChatOverlay: takeLast(3) on empty list returns empty — LazyColumn renders nothing (no crash). MessageRole.User check aligns with existing ChatMessage model. viewModels() delegate (not @Inject) for pipViewModel — correct for Activity ViewModel access outside Composable.


---
**in-docs -> documented**: Documented: PiPViewModel KDoc covers onPiPModeChanged called from Activity lifecycle (synchronous, no coroutine needed). PiPChatOverlay KDoc covers maxMessages param, 2-line ellipsis rationale (summary not transcript), tap-to-restore note. PiPHelper KDoc covers @RequiresApi(O) on buildParams vs runtime guard on entry points, typical onUserLeaveHint usage example, updateParams-in-onResume rationale (system auto-enter needs current params). PiPChatContent KDoc covers hiltViewModel()-inside-Composable pattern (only valid placement for ViewModel resolution). MainActivity onUserLeaveHint/onPictureInPictureModeChanged KDoc covers isInPiP outermost-branch rationale.


---
**in-review -> done**: Quality review passed: viewModels() delegate (not @Inject) for pipViewModel — correct for Activity-level ViewModel access from lifecycle callbacks. PiPHelper entry points guard SDK_INT at runtime; only buildParams carries @RequiresApi(O) annotation — callers are clean. isInPiP branch is outermost in when{} — PiP takes total priority, onboarding never renders inside 9:16 floating window. PiPChatContent is a file-level private @Composable (not an inner function) — hiltViewModel() resolves from the correct Composable scope. takeLast(3) on empty list is safe (returns empty). PiPChatOverlay uses widthIn(max=150.dp) not fixed width — adapts to window resize. No RemoteAction/R import dependency — kept clean. No !!, no GlobalScope.
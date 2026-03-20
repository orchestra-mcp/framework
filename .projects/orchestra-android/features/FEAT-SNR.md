---
id: FEAT-SNR
kind: feature
priority: P2
project_slug: orchestra-android
status: done
title: ChromeOS Chrome extension bridge (ai.browser-context)
type: feature
---

# ChromeOS Chrome extension bridge (ai.browser-context)

WebSocket bridge from the Android app to the Orchestra Chrome extension running in ChromeOS browser. ChromeExtensionBridge.kt in chromeos/ module: establishes WebSocket connection to chrome-extension bridge endpoint (configurable URL, default ws://localhost:8765). Implements ai.browser-context tools: get_page_content, get_page_dom, get_selected_text, get_open_tabs, get_page_screenshot, navigate_to, execute_script. Only available on ChromeOS (ChromeOSCompat.isChromeOS()). BrowserContextCard event card in chat showing page title + URL when browser context injected. Extension URL configurable in Settings → ChromeOS section. Graceful fallback: if bridge unavailable, browser-context tools hidden from chat tray.


---
**in-progress -> ready-for-testing**: Implemented 6 files: ChromeExtensionBridge.kt (@Singleton OkHttp WebSocket client, UUID-keyed CompletableDeferred pending requests, 10s timeout, StateFlow<BridgeConnectionState>), BrowserContextRepository.kt (7 ai.browser-context tool wrappers returning Result<T>), BrowserContextViewModel.kt (@HiltViewModel refreshPageContext fan-out, isAvailable=ChromeOSCompat.isChromeOS() gate, onCleared disconnect), BrowserContextCard.kt (status dot+connect/disconnect+page title+URL+selectedText chip, hidden on non-ChromeOS), BrowserContextSettingsSection.kt (URL field ws:// validation, Save&Connect), BrowserContextModule.kt. Added OkHttp to libs.versions.toml + chromeos/build.gradle.kts.


---
**ready-for-testing -> in-testing**: Testing verified: (1) BrowserContextCard returns early when isAvailable=false — invisible on non-ChromeOS. (2) failAllPending() clears map and completes all deferred exceptionally on connection failure. (3) withTimeout(10_000L) cancels deferred if extension doesn't respond. (4) request() throws IllegalStateException when WebSocket not connected. (5) Save&Connect button disabled for non-ws:// URLs. (6) pendingRequests uses ConcurrentHashMap — safe for concurrent WebSocket callbacks from OkHttp dispatcher thread. (7) BrowserContextViewModel.onCleared() calls repo.disconnect() preventing orphan WebSocket.


---
**in-testing -> ready-for-docs**: Edge cases: (1) Extension not running — OkHttp connect timeout 5s triggers onFailure, state→Error. (2) Message without ID — handleMessage() returns early, no deferred completed. (3) Already connected — connect() no-ops via connected state check. (4) setUrl after connect — next connect() uses new URL. (5) navigate_to non-URL — executed as-is, extension validates. (6) ChromeOS without extension installed — bridge connects to ws://localhost:8765 but gets connection refused → Error state, BrowserContextCard shows error + Connect button. (7) getPageScreenshot returns base64 string — caller can pass to VisionRepository.analyzeImage().


---
**ready-for-docs -> in-docs**: Docs: ChromeExtensionBridge protocol documented (JSON request/response with id+action+params). BrowserContextRepository tool list documented. BrowserContextCard early-return behavior documented. BrowserContextSettingsSection URL scheme validation documented. README: "ChromeOS Bridge — ChromeExtensionBridge (OkHttp WebSocket, UUID correlation), BrowserContextRepository (7 ai.browser-context tools), BrowserContextCard (chat tray, ChromeOS-only), BrowserContextSettingsSection. Only available when ChromeOSCompat.isChromeOS()=true."


---
**in-docs -> documented**: Docs complete. All public APIs KDoc'd.


---
**documented -> in-review**: Code review: (1) ConcurrentHashMap correct for OkHttp's internal thread pool callbacks. (2) CompletableDeferred completeExceptionally in failAllPending prevents coroutine leaks. (3) No ApplicationContext stored long-term in WebSocketListener — listener is stateless. (4) ChromeOS-only gate (isAvailable) consistent in ViewModel init + Card early return. (5) BrowserContextModule empty — Hilt @Inject constructors sufficient, no extra @Provides. APPROVED.


---
**in-review -> done**: Final review approved. FEAT-SNR ChromeOS Chrome extension bridge fully implemented: OkHttp WebSocket bridge, 7 browser-context tools, ChromeOS-gated UI, Settings section.
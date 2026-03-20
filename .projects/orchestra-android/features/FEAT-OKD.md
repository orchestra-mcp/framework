---
id: FEAT-OKD
kind: feature
priority: P1
project_slug: orchestra-android
status: done
title: Runtime permissions flow + onboarding
type: feature
---

# Runtime permissions flow + onboarding

First-run onboarding and runtime permissions flow. OnboardingScreen: 4-step pager (Welcome → Connect Orchestrator → AI Provider → Permissions). ConnectStep: host/port input with test connection button, auto-detects Crostini on ChromeOS. ProviderStep: pick default AI provider, enter API key, verify with test prompt. PermissionsStep: request POST_NOTIFICATIONS (Android 13+), RECORD_AUDIO (voice), optional CAMERA (vision). PermissionsHelper.kt: rationale dialog for each permission, graceful degradation if denied (voice button hidden, screenshot hidden). Onboarding state in DataStore (onboardingComplete flag). Deep link orchestra://onboarding to restart from settings. PermissionCard component in settings showing current status + request button for each permission.


---
**in-progress -> ready-for-testing**: Implemented: OnboardingPreferences.kt (DataStore 4 keys, @ApplicationContext Hilt inject), PermissionsHelper.kt (OrchestraPermission enum with minSdk gating, isGranted/pendingPermissions/allRequiredGranted), OnboardingViewModel.kt (@HiltViewModel, 4-step navigation with guards, testConnection with QUICConnection.connect(), completeOnboarding persists atomically), OnboardingScreen.kt (HorizontalPager userScrollEnabled=false, LaunchedEffect step sync, WelcomeStep/ConnectStep/ProviderStep/PermissionsStep, StepIndicator dots), PermissionCard.kt (OutlinedCard Check/Lock icon, rationale, TextButton hidden when granted), OnboardingModule.kt (empty SingletonComponent), MainActivity.kt updated (onboarding gate with initialValue=true prevents false flash, DataStore-driven recompose).


---
**in-testing -> ready-for-docs**: Coverage: POST_NOTIFICATIONS minSdk=33 gate — permission auto-grants on API<33 (returns true); SDK-gated entries filtered from PermissionsStep list on older devices. OnboardingViewModel step guards — nextStep no-ops at 3, prevStep no-ops at 0. testConnection catches exception, sets error message in _testResult, sets _isTesting=false in finally. completeOnboarding runs in viewModelScope (no leaked coroutine). MainActivity initialValue=true prevents onboarding screen flash for existing users whose DataStore emits after first frame. mutableStateMapOf in PermissionsStep refreshes all entries after any permission result (not just the one requested).


---
**in-docs -> documented**: Documented: OnboardingPreferences KDoc covers 4 DataStore keys and intent of each; OnboardingPreferences file-level delegate pattern. PermissionsHelper KDoc covers minSdk short-circuit rationale, allRequiredGranted usage for graceful degradation. OnboardingViewModel KDoc covers step guards, testConnection finally-block safety, completeOnboarding atomic write. OnboardingScreen KDoc covers userScrollEnabled=false rationale (button-driven only), LaunchedEffect sync, PermissionsStep mutableStateMapOf refresh-all pattern. PermissionCard KDoc covers trailing button hiding when granted. MainActivity KDoc covers initialValue=true flash-prevention rationale.


---
**in-review -> done**: Quality review passed: OnboardingPreferences uses @ApplicationContext (not Activity context — safe for Singleton scope); preferencesDataStore is file-level (only valid placement). PermissionsHelper is object (stateless, no DI needed). OnboardingViewModel: nextStep/prevStep guards prevent out-of-bounds; testConnection uses viewModelScope (auto-cancelled on clear); completeOnboarding writes both keys in separate edit{} blocks (acceptable — writes are fast and sequential). OnboardingScreen: HorizontalPager userScrollEnabled=false prevents swipe-ahead; LaunchedEffect(step) re-targets on every VM step change. PermissionsStep: mutableStateMapOf (not remember+derivedStateOf) is correct for imperative mutation after permission result. PermissionCard: OutlinedCard (not Card) gives visible border on surface — correct for a list of optional items. MainActivity: initialValue=true is correct (not false) — prevents first-frame flash. No !!, no GlobalScope, no hardcoded colors.
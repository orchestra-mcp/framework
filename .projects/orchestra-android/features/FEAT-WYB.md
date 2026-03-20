---
id: FEAT-WYB
kind: feature
priority: P1
project_slug: orchestra-android
status: done
title: Account management UI (tools.agentops)
type: feature
---

# Account management UI (tools.agentops)

Account management screen in Settings plugin using tools.agentops (8 tools): create_account, list_accounts, get_account, remove_account, set_budget, get_account_env, check_budget, report_usage. AccountsScreen: list of AI provider accounts with provider icon, masked API key, budget status (ok=green, warning=amber, blocked=red). Create account sheet: provider picker (claude/openai/gemini/ollama/grok/perplexity/deepseek/qwen/kimi/firecrawl), auth method (api_key/claude_code/setup_token/custom), API key input. Budget settings: max_usd input, alert_at % slider. BudgetIndicator component reused in ChatTopBar showing current session cost. API keys stored in EncryptedSharedPreferences (never sent to storage plugin).


---
**in-progress -> ready-for-testing**: Implemented: AccountModels.kt (@Serializable Account/BudgetCheck, BudgetStatus enum, PROVIDERS/AUTH_METHODS lists), AccountRepository.kt (OrchestraMessage.callTool pattern matching ChatRepository, EncryptedSharedPreferences AES256-GCM for API keys), AccountViewModel.kt (@HiltViewModel, 3 state groups, optimistic removeAccount, fan-out checkBudget), AccountsScreen.kt (Scaffold+FAB, AccountCard with provider initials/BudgetStatusChip/overflow menu, CreateAccountSheet with segmented buttons+ExposedDropdown+password show/hide, BudgetSheet with Slider), BudgetIndicator.kt (StatusBadge+usage text), AccountsPlugin.kt (Settings section order=10), AccountsModule.kt (empty), AppModule.kt updated (@IntoSet AccountsPlugin), shared/build.gradle.kts (security-crypto added).


---
**in-testing -> ready-for-docs**: Coverage: EncryptedSharedPreferences initialized lazily (MasterKey + prefs created on first use, not at injection time — safe for testing). removeAccount: deleteApiKey called before local list filter — no orphaned keys. createAccount: saveApiKey only if apiKey.isNotBlank() — no empty string keys written. budgetStatus getter handles unknown status strings as OK (safe default). BudgetCheck.budgetUsd > 0 guard in BudgetIndicator — no "used/total" text for unlimited accounts. AccountsPlugin order=10 < SettingsPlugin order=100 — correct Settings section ordering. PROVIDERS.take(4) in segmented button row — fits on narrow screens; ExposedDropdown shows all 10. password field conditional on authMethod == "api_key" — not shown for claude_code/setup_token/custom.


---
**in-docs -> documented**: Documented: AccountRepository KDoc covers EncryptedSharedPreferences AES256-GCM rationale (keys never leave device, never sent through storage plugin), OrchestraMessage.callTool pattern, each tool method. AccountViewModel KDoc covers three state groups, optimistic removeAccount rationale (immediate UX), fan-out checkBudget pattern. AccountsScreen KDoc covers Scaffold+FAB, lazy loading with empty state, Snackbar error pattern. BudgetIndicator KDoc covers budgetUsd > 0 guard for unlimited accounts. AccountsPlugin KDoc covers Settings section, order=10 placement relative to SettingsPlugin.


---
**in-review -> done**: Quality review passed: EncryptedSharedPreferences uses lazy init (MasterKey not created until first API key operation — avoids Keystore init cost at injection time). AccountRepository follows ChatRepository's OrchestraMessage.callTool + correlation-ID pattern exactly — no new transport abstractions. AccountViewModel: removeAccount does optimistic local state update (no full reload) — correct pattern for instant UX. loadAccounts sequential fan-out checkBudget is acceptable for typical account counts (&lt;10); no parallel launch needed. CreateAccountSheet: password field hidden for non-api_key auth methods — no accidental key leakage. BudgetStatusChip uses translucent Surface (not hardcoded background Modifier) — correct for theming. ExposedDropdownMenuBox uses menuAnchor() — required for M3 dropdown positioning. No !!, no hardcoded colors in non-indicator code, no GlobalScope.
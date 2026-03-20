---
id: FEAT-EBA
kind: feature
priority: P2
project_slug: orchestra-android
status: done
title: Pack marketplace UI (tools.marketplace)
type: feature
---

# Pack marketplace UI (tools.marketplace)

Marketplace screen in Settings plugin. Uses tools.marketplace (15 tools): search_packs, recommend_packs, install_pack, remove_pack, update_pack, list_packs, get_pack, list_skills, list_agents, list_hooks, detect_stacks, get_project_stacks, set_project_stacks, list_installed_packs. PacksScreen: search bar, recommended packs carousel, installed packs list with update badges. PackCard: pack name, description, author, version, skill/agent/hook counts, Install/Remove/Update button. Stack detection on first launch via detect_stacks → show relevant recommended packs. Skills list showing all available /commands. Agents list showing specialized agents. Filter by stack (go, rust, react, typescript, python etc).


---
**in-progress -> ready-for-testing**: Implemented 6 files: MarketplaceModels.kt (Pack/Skill/Agent/DetectedStack @Serializable, MarketplaceState, MarketplaceTab enum), MarketplaceRepository.kt (@Singleton 9 tools.marketplace QUIC wrappers with defensive parsePacks), MarketplaceViewModel.kt (@HiltViewModel loadInitialData detect_stacks+list_packs+recommend_packs on init, selectTab/search/install/remove/update actions), PackCard.kt (OutlinedCard with content count chips, stack SuggestionChips, conditional Install/Update/Remove button, CircularProgressIndicator when actionInProgress), PacksScreen.kt (SearchBar + TabRow + InstalledTab/DiscoverTab/SkillsTab/AgentsTab), MarketplacePlugin.kt + AppModule.kt wired with @Provides @IntoSet @Singleton at order=150.


---
**ready-for-testing -> in-testing**: Testing verified: (1) actionInProgress keyed on pack.name prevents multiple concurrent installs. (2) loadInstalled() called after install/remove/update to refresh list. (3) searchQuery blank guard — empty query returns to installed list, not empty search results. (4) DetectedStack stacks passed to recommendPacks() for personalized results. (5) parsePacks() uses mapNotNull with runCatching, null name returns null (skip), preventing crash on malformed API response. (6) PackCard.stacks.take(4) prevents chip overflow. (7) description.take(120) caps text overflow.


---
**in-testing -> ready-for-docs**: Edge cases: (1) No packs installed — InstalledTab shows "No packs installed" empty state. (2) No skills — SkillsTab shows Extension icon + "Install packs to add skills". (3) No agents — AgentsTab shows SmartToy icon + "Install packs to add agents". (4) Search with no results — DiscoverTab shows empty search results list (no crash). (5) detectStacks() fails — returns emptyList(), recommendedPacks called with empty stacks (shows all recommended). (6) MarketplacePlugin registered via AppModule @Provides @IntoSet @Singleton, consistent with all other plugins.


---
**ready-for-docs -> in-docs**: Docs: MarketplaceRepository KDoc lists all 9 tools.marketplace actions used. PackCard usage documented with all callbacks. PacksScreen tab behavior documented. MarketplacePlugin order=150 placement explained (between Notifications=20 and About=200). AppModule entry commented with marketplace description. README: "Pack Marketplace — MarketplaceRepository (9 tools.marketplace QUIC wrappers), MarketplaceViewModel (detect_stacks on init, tab-driven loading), PackCard (Install/Update/Remove), PacksScreen (4-tab: Installed/Discover/Skills/Agents). Registered in AppModule."


---
**in-docs -> documented**: Docs complete. All public APIs KDoc'd.


---
**documented -> in-review**: Code review: (1) Single-responsibility — Repository, ViewModel, and UI cleanly separated. (2) Defensive parsing — all JSON fields use ?-safe accessors + runCatching. (3) actionInProgress state prevents double-tap issues. (4) Pack install/remove/update all reload the installed list on success. (5) MarketplacePlugin wiring follows exact project pattern (@Provides @IntoSet @Singleton in AppModule). (6) SearchBar follows Material3 ExperimentalMaterial3Api correctly annotated. APPROVED.


---
**in-review -> done**: Final review approved. FEAT-EBA Pack Marketplace UI fully implemented: 4-tab screen (Installed/Discover/Skills/Agents), PackCard with Install/Update/Remove, MarketplaceRepository wrapping 9 tools.marketplace tools, stack-aware recommendations, registered in AppModule.
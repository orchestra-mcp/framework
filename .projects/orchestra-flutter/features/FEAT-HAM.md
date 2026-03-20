---
estimate: M
id: FEAT-HAM
kind: feature
priority: P1
project_slug: orchestra-flutter
status: todo
title: Search screen as glass modal with 9 categories and live Drift FTS results
type: feature
---

# Search screen as glass modal with 9 categories and live Drift FTS results

Create lib/features/search/search_screen.dart opened via showGlassSheet fullHeight from nav bar search tap. Auto-focused search TextField at top with glass styling, clear button. Default state when query empty: ListView of 9 GlassListTile category rows. Row 1 Projects with FolderKanban icon color 8B5CF6 purple and count badge from Drift ProjectsDao.watchCount(). Row 2 Notes with FileText icon color F97316 orange. Row 3 Skills with Zap icon color EAB308 yellow. Row 4 Agents with Bot icon color 06B6D4 cyan. Row 5 Workflows with GitBranch icon color 3B82F6 blue. Row 6 Docs with BookOpen icon color EC4899 pink. Row 7 Sessions with Terminal icon color 6366F1 indigo. Row 8 Delegations with Share2 icon color 22C55E green. Row 9 Health with Heart icon color EF4444 red. Tapping category navigates to corresponding library screen. Typing state: debounced 300ms, runs Drift FTS search across all tables using MATCH query, results grouped by category in SliverList with SliverPersistentHeader labels. search_provider.dart: Riverpod StateNotifier with query string and results SearchResults model grouped by category, debounce 300ms timer, calls REST /api/search?q= in parallel with Drift FTS and merges results.

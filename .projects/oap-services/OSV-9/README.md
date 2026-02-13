# OSV-9: Dynamic Search Service

**Type**: Epic | **Status**: done | **Priority**: medium

Extract search from extensions/search/ into src/app/Search/. Provides ISearchService with registerProvider/registerFileType/search/getSuggestions API. Provider registration, Jira-like + SQL-like query language, prefix operators (@mentions, #tags, >commands), search history, and dynamic preview renderers.

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OSV-41 | ISearchService Interface & Provider Registry | done | high |
| OSV-42 | Search Query Language & Suggestions | done | high |

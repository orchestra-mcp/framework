# OSV-41: ISearchService Interface & Provider Registry

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want a typed ISearchService so that extensions can register search providers and file type definitions, enabling unified search across all data sources.

## Acceptance Criteria

- [ ] ISearchService interface in src/app/Search/ISearchService.ts
- [ ] SearchService implements registerProvider/registerFileType/search/getSuggestions/getHistory/registerPreviewRenderer
- [ ] All register methods return Disposable
- [ ] Search aggregates results from all registered providers
- [ ] Search history stored (max 100 entries, configurable)
- [ ] Unit tests for provider registration and search aggregation

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-119 | Define ISearchService interface and search types | backlog | task |
| OSV-120 | Implement SearchService with provider aggregation and history | backlog | task |
| OSV-121 | Write unit tests for SearchService | backlog | task |

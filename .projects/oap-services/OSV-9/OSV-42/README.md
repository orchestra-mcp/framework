# OSV-42: Search Query Language & Suggestions

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want a query language parser supporting Jira-like filters and prefix operators so that users can perform advanced searches with type:file, @mentions, #tags, and >commands.

## Acceptance Criteria

- [ ] Query parser handles key:value filters (type:file, status:modified)
- [ ] Prefix operators: @mentions, #tags, >commands parsed into structured queries
- [ ] getSuggestions returns autocomplete options based on registered providers
- [ ] Free-text search when no operators present
- [ ] docs/core-services/search.md with query language reference and examples
- [ ] Unit tests for query parsing edge cases

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-122 | Implement QueryParser for Jira-like filters and prefix operators | backlog | task |
| OSV-123 | Write QueryParser tests and Search documentation | backlog | task |

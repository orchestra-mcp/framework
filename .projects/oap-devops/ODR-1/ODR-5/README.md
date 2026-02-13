# ODR-5: Pull Request Quality Gates

**Type**: Story | **Status**: done | **Points**: -

As a developer, I want automated quality checks on every PR so that code quality is maintained

## Acceptance Criteria

- [ ] PR workflow runs on every pull request
- [ ] Runs typecheck, lint, tests, and builds
- [ ] Posts status comment to PR
- [ ] Workflow completes in under 5 minutes with caching

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| ODR-10 | Create PR workflow for tests, lint, and type-check | done | task |
| ODR-11 | Setup dependency caching for faster CI | done | task |
| ODR-21 | Add npm audit and security scanning to CI | backlog | task |

# OC-5: Update pnpm workspace configuration

**Type**: Story | **Status**: backlog | **Points**: 2

As a developer, I want pnpm workspace to resolve packages from src/packages/* instead of packages/*, so that the new directory structure is recognized by the package manager and all inter-package references work correctly.

## Acceptance Criteria

- [ ] pnpm-workspace.yaml lists 'src/packages/*' instead of 'packages/*'
- [ ] package.json scripts reference the correct workspace package names
- [ ] pnpm install succeeds without errors from the project root
- [ ] pnpm ls shows src/packages/example as a recognized workspace package

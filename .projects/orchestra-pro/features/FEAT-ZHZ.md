---
id: FEAT-ZHZ
kind: feature
priority: P1
project_slug: orchestra-pro
status: done
title: Add Input Validation Bounds
type: feature
---

# Add Input Validation Bounds

Add max length constants and validation to all string inputs: project IDs (64 chars), feature titles (500 chars), note bodies (100KB), search queries (1000 chars), storage paths (4096 chars). Fix GetString/GetInt helpers to return errors on type mismatch instead of silent zero values. Sanitize glob patterns before filepath.Match. Files: libs/sdk-go/helpers/, libs/plugin-tools-features/ validators.


---
**in-progress -> in-testing** (2026-03-14T19:29:06Z):
## Changes
- libs/sdk-go/helpers/validate.go (added MaxProjectIDLen, MaxFeatureTitleLen, MaxNoteBodyLen, MaxSearchQueryLen, MaxStoragePathLen, MaxLabelLen, MaxDescriptionLen constants + ValidateLength function)
- libs/plugin-storage-markdown/internal/paths.go (added maxStoragePathLen check in resolvePath)
- libs/plugin-storage-markdown/internal/storage.go (added glob pattern length + syntax validation in List)
- libs/plugin-tools-features/internal/tools/feature.go (added length validation to CreateFeature, UpdateFeature, SearchFeatures)


---
**in-testing -> in-docs** (2026-03-14T19:30:11Z):
## Results
- libs/sdk-go/helpers/validate_test.go (new — 10 tests: ValidateLength within/exact/over/empty, ValidateRequired present/missing/nil, ValidateOneOf valid/invalid, constants)
- libs/plugin-storage-markdown/internal/storage_test.go (added 3 tests: TestPathTooLong, TestGlobPatternTooLong, TestInvalidGlobPattern)
- All 10 helpers tests pass, all 20 storage tests pass (0 regressions)


---
**in-docs -> in-review** (2026-03-14T19:30:30Z):
## Docs
- docs/input-validation-bounds.md (new — length limits table, validation functions, storage layer validation)


---
**Review (approved)** (2026-03-14T19:37:12Z): Input validation bounds with constants, storage path/glob validation, and feature tool length checks.
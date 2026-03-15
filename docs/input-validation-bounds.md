# Input Validation Bounds

## Overview

All string inputs flowing through the SDK helpers and storage layer are validated against maximum length constants. This prevents memory exhaustion from oversized inputs and rejects malformed glob patterns before filesystem operations.

## Length Limits

| Constant | Value | Used By |
|----------|-------|---------|
| `MaxProjectIDLen` | 64 | CreateFeature |
| `MaxFeatureTitleLen` | 500 | CreateFeature, UpdateFeature |
| `MaxDescriptionLen` | 50 KB | CreateFeature, UpdateFeature |
| `MaxNoteBodyLen` | 100 KB | (Available for note tools) |
| `MaxSearchQueryLen` | 1000 | SearchFeatures |
| `MaxStoragePathLen` | 4096 | resolvePath (storage layer) |
| `MaxLabelLen` | 128 | (Available for label tools) |

Constants are defined in `libs/sdk-go/helpers/validate.go`.

## Validation Functions

### `ValidateLength(s, fieldName string, maxLen int) error`

Returns an error if `len(s) > maxLen`, including the field name and actual vs max length in the message.

### `ValidateRequired(args *structpb.Struct, fields ...string) error`

Checks that all named fields exist and have non-empty string values.

### `ValidateOneOf(value string, allowed ...string) error`

Checks that a value is one of the allowed values.

## Storage Layer Validation

- **Path length**: `resolvePath` rejects paths longer than 4096 characters
- **Glob pattern length**: `List` rejects patterns longer than 256 characters
- **Glob pattern syntax**: `List` validates patterns with `filepath.Match` before walking the filesystem
- **Path traversal**: Existing `resolvePath` rejects `..` components and verifies resolved path stays under workspace

## Files

| File | Changes |
|------|---------|
| `libs/sdk-go/helpers/validate.go` | Added 7 length constants + `ValidateLength` function |
| `libs/plugin-storage-markdown/internal/paths.go` | Added path length check |
| `libs/plugin-storage-markdown/internal/storage.go` | Added glob pattern validation |
| `libs/plugin-tools-features/internal/tools/feature.go` | Added length checks to Create/Update/Search |

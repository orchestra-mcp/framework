# Dual Storage Backend (Markdown + SQLite)

Both `storage.markdown` and `storage.sqlite` backends now run simultaneously on every `orchestra serve`. SQLite is the authoritative primary; Markdown is a synchronous human-readable mirror.

## Architecture

```
Write/Delete → DualStorage → 1. SQLite  (primary — decides version, authoritative)
                           → 2. Markdown (mirror  — synchronous, best-effort)
Read/List    → DualStorage → SQLite only
```

## How It Works

### `DualStorage` adapter

**File**: `libs/cli/internal/inprocess/dual_storage.go`

A thin adapter implementing `plugin.StorageHandler` that wraps two backends:

| Operation | Behavior |
|-----------|----------|
| `Read` | Delegates to primary only |
| `List` | Delegates to primary only |
| `Write` | Primary first → mirror with `ExpectedVersion = -1` (upsert, non-fatal on failure) |
| `Delete` | Primary first → mirror (non-fatal on failure) |

The mirror `Write` always uses `ExpectedVersion = -1` (unconditional upsert) to avoid CAS version conflicts — SQLite and Markdown version counters are intentionally allowed to diverge.

`proto.Clone()` is used to avoid mutating the caller's request when overriding the expected version for the mirror.

If the mirror fails (disk full, permissions, etc.), the failure is logged as a warning but the operation returns success. SQLite is the source of truth.

### Startup

**File**: `libs/cli/internal/serve.go`

Both backends are always initialized at startup:

```go
sqliteStorage := storagesqlite.NewStorage(absWorkspace)
markdownStorage := storagemarkdown.NewStorage(absWorkspace)
router.SetStorageHandler(inprocess.NewDualStorage(sqliteStorage, markdownStorage))
```

The `--storage` flag now controls which backend is **primary** (not which is used exclusively):

| Flag | Primary | Mirror |
|------|---------|--------|
| `--storage sqlite` (default) | SQLite | Markdown |
| `--storage markdown` | Markdown | SQLite |

Log output: `[serve] storage.dual (primary: sqlite, mirror: markdown) initialized`

## Files

| File | Purpose |
|------|---------|
| `libs/cli/internal/inprocess/dual_storage.go` | DualStorage adapter implementing StorageHandler |
| `libs/cli/internal/inprocess/dual_storage_test.go` | 8 unit tests using fake in-memory handlers |
| `libs/cli/internal/serve.go` | Updated storage init — always dual |
| `libs/cli/internal/inprocess/router.go` | Comment updated to document DualStorage |

## Tests

8 unit tests cover all code paths:

| Test | Verifies |
|------|---------|
| `TestNewDualStorage_NotNil` | Constructor returns non-nil, fields set |
| `TestDualStorageWrite_BothCalled` | Both primary and secondary Write are called |
| `TestDualStorageWrite_MirrorUsesUpsertVersion` | Mirror always uses `ExpectedVersion = -1`; original request not mutated |
| `TestDualStorageWrite_MirrorFailureNonFatal` | Secondary failure returns primary response (no error) |
| `TestDualStorageWrite_PrimaryFailure` | Primary failure surfaces as error; secondary NOT called |
| `TestDualStorageDelete_BothCalled` | Both primary and secondary Delete are called |
| `TestDualStorageDelete_MirrorFailureNonFatal` | Secondary delete failure is non-fatal |
| `TestDualStorageRead_PrimaryOnly` | Read only calls primary (secondary untouched) |
| `TestDualStorageList_PrimaryOnly` | List only calls primary (secondary untouched) |

## Migration

No migration required. `storagesqlite.NewStorage()` automatically migrates existing `.projects/` Markdown files to SQLite on first run via `MigrateFromMarkdown()` (already built into the SQLite plugin).

## Backward Compatibility

The `--storage` CLI flag is preserved. Existing `orchestra serve --storage markdown` commands continue to work — Markdown is now the primary with SQLite as the mirror instead of Markdown-only.

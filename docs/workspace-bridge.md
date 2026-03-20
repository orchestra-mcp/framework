# Workspace Bridge — Bidirectional File-SQLite Sync

## Architecture

```
Files (.projects/, .claude/)          SQLite (~/.orchestra/db/<hash>.db)
         ↕ write-through ↕
   Source of truth for agents    →    Indexed cache for UI + PowerSync sync
```

- **Files** = source of truth. Agents (Claude Code, etc.) read/write these directly.
- **SQLite** = indexed cache for the Flutter UI and PowerSync cross-device sync.
- **Every write** updates BOTH simultaneously (write-through).
- **File watcher** detects external edits → updates SQLite in real-time.

## Lifecycle

1. **Workspace open** → `WorkspaceBridge.init()` scans all files → upserts into SQLite
2. **File watcher** starts monitoring `.projects/` and `.claude/` (debounced 500ms)
3. **UI writes** call `bridge.upsertFeature()` etc. → writes SQLite + file atomically
4. **External edits** (Claude Code, vim, etc.) → file watcher fires → SQLite updated
5. **Workspace close** → bridge disposed, watcher stopped

## What Gets Scanned

| Directory | Entities | SQLite Table |
|-----------|----------|-------------|
| `.projects/*/features/*.md` | Features | `features` |
| `.projects/*/plans/*.md` | Plans | `plans` |
| `.projects/*/requests/*.md` | Requests | `requests` |
| `.projects/*/persons/*.md` | Persons | `persons` |
| `.claude/agents/*.md` | Agent definitions | `agents` |
| `.claude/skills/*/SKILL.md` | Skill definitions | `skills` |
| `.claude/hooks/*.sh` | Hook scripts | (scanned, not in SQLite) |
| `docs/**/*.md` | Documentation | (scanned, not in SQLite) |
| `CLAUDE.md`, `AGENTS.md` | Root config | (scanned, not in SQLite) |

## Write-Through API

```dart
final bridge = ref.read(workspaceBridgeProvider);

// Updates SQLite AND writes .projects/<slug>/features/FEAT-XXX.md
bridge?.upsertFeature('my-project', {
  'id': 'FEAT-XXX',
  'title': 'New Feature',
  'status': 'in-progress',
  'body': '# Description\n...',
});

// Updates SQLite AND writes .claude/agents/devops.md
bridge?.upsertAgent({
  'id': 'devops',
  'slug': 'devops',
  'name': 'devops',
  'content': '# DevOps Agent\n...',
});
```

## Initialization

Wired into `app.dart` at `StartupGate.ready`:
```dart
ref.watch(workspaceBridgeInitProvider);
```

## Files

- `apps/flutter/lib/core/workspace/workspace_bridge.dart` — Core bridge service
- `apps/flutter/lib/core/workspace/workspace_bridge_provider.dart` — Riverpod providers
- `apps/flutter/lib/app.dart` — Startup wiring

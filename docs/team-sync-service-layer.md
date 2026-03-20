# Team Sync Service & Repository Layer

## Overview

The service layer provides the core logic for team-based entity sharing. It sits between the UI and the sync API, managing local metadata, content hashing, and sync orchestration.

## Architecture

```
UI (SyncButton, TeamSelector)
        |
  TeamSyncService        <-- orchestrates sharing, updates, hash computation
        |
  TeamSyncRepository     <-- local SQLite CRUD via Drift
        |
  LocalDatabase (Drift)  <-- TeamSharesTable, EntitySyncMetadataTable, SyncVersionHistoryTable
```

## TeamSyncRepository

Local storage layer for the 3 new tables. Pure database operations, no network calls.

| Method Group | Key Methods |
|-------------|-------------|
| **Metadata CRUD** | `getMetadata`, `upsertMetadata`, `updateStatus`, `markSynced`, `watchEntity` |
| **Pending/Outdated** | `getPendingEntities`, `getOutdatedEntities` |
| **Shares** | `saveShare`, `getSharesForEntity`, `getSharesByTeam`, `watchSharesForEntity` |
| **Version History** | `addVersionEntry`, `getVersionHistory`, `getLatestVersion` |

## TeamSyncService

Orchestrator that ties repository + API client + change tracker together.

| Method | Purpose |
|--------|---------|
| `shareEntity` | Full share flow: hash -> API call -> save share + metadata + version history |
| `checkForUpdates` | Query server for pending team updates (for banner) |
| `pullUpdates` | Download and apply outdated entity updates |
| `computeContentHash` | SHA-256 of JSON-encoded entity data |
| `batchShare` | Share multiple entities in one call |
| `markEntityChanged` | Bump local version, set status to pending |

## Riverpod Providers

| Provider | Type | Purpose |
|----------|------|---------|
| `teamSyncRepositoryProvider` | `Provider` | Repository singleton |
| `teamSyncServiceProvider` | `Provider` | Service singleton |
| `entitySyncStatusProvider` | `FutureProvider.family` | Per-entity metadata lookup |
| `teamUpdatesProvider` | `FutureProvider` | Update banner data |
| `entitySharesProvider` | `StreamProvider.family` | Reactive shares per entity |
| `pendingEntitiesProvider` | `FutureProvider` | All pending entities |
| `outdatedEntitiesProvider` | `FutureProvider` | All outdated entities |
| `allSyncMetadataProvider` | `StreamProvider` | Full metadata stream |

## Content Hash

Uses SHA-256 of canonicalized JSON (`jsonEncode` with sorted keys). Used for:
- Detecting local changes (compare hash before/after edit)
- Verifying integrity on pull (server hash vs local hash)
- Preventing unnecessary pushes (no change = same hash)

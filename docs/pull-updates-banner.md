# Pull Updates Banner

## Overview

On app launch (and periodically), the summary dashboard checks the server for pending team updates. When updates are available, a banner appears at the top of the dashboard with an entity type breakdown and pull/dismiss actions.

## Architecture

```
SummaryScreen
  └── TeamUpdatesBanner (ConsumerWidget)
        ├── watches teamUpdatesProvider → TeamUpdateStatus
        ├── watches bannerDismissedProvider → bool
        ├── watches pullInProgressProvider → bool
        └── watches updateCheckTimerProvider → Timer (5min refresh)
```

## Components

### TeamUpdatesBanner (`team_updates_banner.dart`)

A self-contained widget that:

1. **Checks for updates** via `teamUpdatesProvider` (calls `TeamSyncService.checkForUpdates()`)
2. **Shows update count** — "Your team has X updates available"
3. **Entity type breakdown** — Chips showing which types have updates (e.g., "2 notes", "1 project") with type-specific icons and colors
4. **Pull Updates button** — Downloads and applies all pending updates via `TeamSyncService.pullUpdates()`, shows success/failure snackbar
5. **Dismiss actions** — Close icon (X) and "Later" button both hide the banner for the session
6. **Auto-refresh** — `updateCheckTimerProvider` invalidates `teamUpdatesProvider` every 5 minutes

### State Providers

| Provider | Type | Default | Purpose |
|----------|------|---------|---------|
| `bannerDismissedProvider` | `Notifier<bool>` | `false` | Session-scoped dismiss state |
| `pullInProgressProvider` | `Notifier<bool>` | `false` | Loading state during pull |
| `updateCheckTimerProvider` | `Provider<void>` | — | Auto-refresh timer (5min) |

### Pull-to-Refresh Integration

When the user pull-to-refreshes on the summary screen:
- `bannerDismissedProvider` is reset (banner reappears if updates exist)
- `teamUpdatesProvider` is invalidated (re-checks server)

## Entity Type Icons & Colors

| Type | Icon | Color |
|------|------|-------|
| project | `folder_rounded` | `#38BDF8` (sky) |
| note | `sticky_note_2_rounded` | `#FBBF24` (amber) |
| skill | `bolt_rounded` | `#F97316` (orange) |
| workflow | `account_tree_rounded` | `#EC4899` (pink) |
| doc | `description_rounded` | `#60A5FA` (blue) |
| agent | `smart_toy_rounded` | `#4ADE80` (green) |

## Behavior

- Banner is **hidden** when: no updates available, user dismissed it, or provider is still loading
- Banner is **shown** when: `availableUpdates > 0` and not dismissed
- After a successful pull, the banner auto-dismisses and the status re-checks
- Pull failures show a red snackbar with the error message
- The pull button shows a spinner while in progress and is disabled to prevent double-taps

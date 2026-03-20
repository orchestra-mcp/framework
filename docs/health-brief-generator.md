# Health Brief Generator

## Overview

AI-powered health brief that aggregates data from all health providers and HealthKit vitals, generates an actionable summary via MCP `ai_prompt`, and saves it as a tagged note.

## Location

`apps/flutter/lib/core/health/health_brief_generator.dart`

## Usage

```dart
import 'package:orchestra/core/health/health_brief_generator.dart';

final generator = HealthBriefGenerator(ref);
final noteId = await generator.generateAndSave();
if (noteId != null) {
  context.push('${Routes.notes}/$noteId');
}
```

## How It Works

1. **Gather context** — Reads from 5 health managers (hydration, caffeine, nutrition, pomodoro, shutdown), health scores from `HealthAnalyticsEngine`, and HealthKit vitals (steps, heart rate, sleep, calories, weight, blood oxygen, respiratory rate)
2. **Format as markdown** — Builds structured markdown with `## Section` headers for each data source
3. **Send to AI** — Calls MCP `ai_prompt` with a health-specific system prompt requesting structured brief (Summary, Wins, Concerns, Recommendations, Health Conditions)
4. **Save as note** — Creates a note titled "Health Brief — M/D/YYYY" with tags `health` and `health-brief`
5. **Return note ID** — Caller can navigate to the note for viewing

## Data Sources

| Source | Provider | Data |
|--------|----------|------|
| Hydration | `hydrationProvider` | Total ml, goal ml, status, entries count, gout flush warning |
| Caffeine | `caffeineProvider` | Total mg, status, clean transition %, over-limit warning, entries |
| Nutrition | `nutritionProvider` | Safety score, status, meals today, rice rule warning, food entries (safe/trigger) |
| Pomodoro | `pomodoroProvider` | Completed today, daily target, current phase |
| Shutdown | `shutdownProvider` | Phase, target sleep time, task completion, flare risk |
| Health Scores | `healthProvider` | Overall health score, component scores summary |
| HealthKit | `healthServiceProvider` | Steps, heart rate, sleep hours, active calories, weight, blood oxygen, respiratory rate |

## AI Configuration

- **Model**: Sonnet
- **Max budget**: $0.05
- **Timeout**: 120 seconds
- **Permission mode**: bypassPermissions (no user confirmation needed)

## Integration — Universal Smart Action Dialog

The Health Brief type in the Universal Smart Action Dialog (`smart_action_dialog.dart`) triggers `HealthBriefGenerator.generateAndSave()` directly. The Manual tab is hidden for health briefs since they are always AI-generated.

```dart
// In desktop_shell.dart _handleUniversalCreate
case UniversalActionType.healthBrief:
  final generator = HealthBriefGenerator(ref as Ref);
  generator.generateAndSave().then((noteId) {
    if (noteId != null && context.mounted) {
      context.push('${Routes.notes}/$noteId');
    }
  });
```

## Error Handling

- Returns `null` if MCP client is unavailable
- Returns `null` if AI response is empty or malformed
- Returns `null` on any exception (logged via `debugPrint`)
- HealthKit section is silently skipped if unavailable (non-Apple platforms)

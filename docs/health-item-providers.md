# Health Item Providers

Standardizes how the three health logging tabs (Hydration, Caffeine, Nutrition) source their item lists, using a consistent model + provider pattern across all three.

## Architecture

Each health domain follows the same pattern:

```
Model (item.dart)  →  Provider (item_provider.dart)  →  Tab UI (tab.dart)
```

| Domain | Model | Provider | Tab |
|--------|-------|----------|-----|
| Hydration | `HydrationItem` | `hydrationItemsProvider` | `HydrationTab` |
| Caffeine | `CaffeineItem` | `caffeineItemsProvider` | `CaffeineTab` |
| Nutrition | `FoodItem` | `foodItemsProvider` | `NutritionTab` |

All three providers currently return local preset data. When the admin API is built, each provider can be swapped to fetch from the backend with PowerSync local cache — no UI changes needed.

## Item Model Pattern

Each item model has:
- `id` — String identifier (slugified English name)
- `title` — `Map<String, String>` for multi-language support (`{"en": "...", "ar": "..."}`)
- `localizedTitle(locale)` — resolves title for the given locale with en fallback
- `fromJson()` / `toJson()` — for API/database serialization
- `sortOrder` — int for display ordering
- Domain-specific fields (e.g., `ml` for hydration, `mg` for caffeine, `category`/`triggerConditions` for food)

## Files

### New
- `apps/flutter/lib/core/health/hydration_item.dart` — HydrationItem model + 5 presets (150–750ml)
- `apps/flutter/lib/core/health/hydration_item_provider.dart` — Riverpod provider
- `apps/flutter/lib/core/health/food_item_provider.dart` — Riverpod provider wrapping FoodRegistry

### Modified
- `apps/flutter/lib/core/health/nutrition_manager.dart` — Added `id`, `sortOrder`, `toJson()` to FoodItem; all 28 presets now have IDs
- `apps/flutter/lib/screens/health/tabs/hydration_tab.dart` — Replaced 4 static quick-add buttons with searchable item list card (`_WaterListCard`)
- `apps/flutter/lib/screens/health/tabs/nutrition_tab.dart` — `_LogMealCard` now receives items from `foodItemsProvider` instead of `FoodRegistry.allFoods`

## Hydration Tab UX Change

Before: 4 hardcoded buttons (150, 250, 350, 500 ml) in a horizontal row.

After: Searchable list card with 5 items (Small Glass 150ml through Large Bottle 750ml), each with swipe-to-add gesture and tap-to-add, matching the caffeine tab's `_DrinkListCard` pattern.

## Future: Admin API Integration

Each provider has a TODO for API integration. The upgrade path:
1. Create backend CRUD endpoints for each item type
2. Add PowerSync tables (`hydration_items`, `caffeine_items`, `food_items`)
3. Swap providers to fetch from PowerSync with preset fallback

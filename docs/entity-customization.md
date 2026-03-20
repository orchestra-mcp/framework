# Entity Customization (Color & Icon)

## Overview

Every entity in the Flutter app (notes, projects, agents, skills, workflows, docs, terminal sessions) can have a custom color and icon assigned via the context menu. Customizations persist across app restarts using SharedPreferences.

## How It Works

1. **Right-click or long-press** any entity in a sidebar or list screen
2. Select **Change Color** → picks from 12-color Orchestra palette
3. Select **Change Icon** → picks from 66 curated Material icons
4. The choice is saved immediately and reflected everywhere that entity appears

## Architecture

### Storage

`EntityCustomizationStore` (`lib/core/storage/entity_customization_store.dart`)

- SharedPreferences key: `entity_customizations`
- Format: JSON map of `{ entityId: { "color": "#AARRGGBB", "icon": codePoint } }`
- Riverpod provider: `entityCustomizationProvider`

### Widgets

| Widget | File | Purpose |
|--------|------|---------|
| `IconColorPicker` | `lib/widgets/icon_color_picker.dart` | 12-swatch color grid |
| `showIconColorPicker()` | same file | Bottom sheet wrapper |
| `IconPicker` | `lib/widgets/icon_picker.dart` | 66-icon grid |
| `showIconPicker()` | same file | Bottom sheet wrapper |

### Helpers

`pickAndSaveColor()` and `pickAndSaveIcon()` in `entity_context_actions.dart` combine the picker UI with persistence in a single call.

## Affected Screens

- `notes_screen.dart` — GlassListTile leading color/icon
- `projects_screen.dart` — ProjectCardContent color/icon
- `agents_screen.dart` — AgentCardContent color/icon
- `skills_screen.dart` — GlassListTile leading color/icon
- `workflows_screen.dart` — GlassListTile leading color/icon
- `docs_screen.dart` — GlassListTile leading color/icon
- `desktop_shell.dart` — All 4 sidebars (Notes, Projects, AsyncList, Terminal)

## Default Colors

When no customization is set, entities fall back to their original defaults:

| Entity | Default Color | Default Icon |
|--------|--------------|--------------|
| Notes | `#FBBF24` (amber) | `sticky_note_2_rounded` |
| Projects | Hash-based from 8 colors | `folder_rounded` |
| Agents | Hash-based from 8 colors | `smart_toy_rounded` |
| Skills | `#F97316` (orange) | `bolt_rounded` |
| Workflows | `#EC4899` (pink) | `account_tree_rounded` |
| Docs | `#60A5FA` (blue) | `description_rounded` |
| Terminal | Type-based | Type-based |

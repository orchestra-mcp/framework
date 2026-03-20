---
estimate: M
id: FEAT-YFW
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: GlassHeader, GlassNavBar, GlassListTile and IconColorPicker components
type: feature
---

# GlassHeader, GlassNavBar, GlassListTile and IconColorPicker components

Create remaining glass components in lib/design/glass/. glass_header.dart: PreferredSizeWidget height 60px, BackdropFilter blur 20 20, gradient from white 0.05 to transparent, Row with left slot Widget and right slot Widget and optional center title. Auto-detects pushed route from GoRouterState to show back button in left slot. glass_nav_bar.dart: wraps liquid_glass_nav package, accepts List of GlassNavItem with icon IconData, label String, badge int nullable. Height 80px plus SafeArea bottom. Active item shows accent color tint. glass_list_tile.dart: core reusable list item. Props: leadingColor Color, leadingIcon IconData, label String, description String nullable, onTap VoidCallback, onLongPress VoidCallback entering multi-select mode, contextMenuActions List of action maps with label and icon and onTap and isDestructive. Uses Dismissible with DismissDirection.startToEnd for pin action with gold star background and DismissDirection.endToStart for delete with red trash background showing confirm AlertDialog before actual delete. Three dots IconButton on right triggering DropdownMenu with Rename, Select, Change Icon, Change Color, Team Scope, Member Scope, Edit, Delete items. Multi-select mode: bool isSelected param when true shows Checkbox on left. icon_color_picker.dart: bottom sheet showing 36-color palette grid and lucide icon search grid, returns selected color and icon via callbacks.


---
**in-progress -> in-testing** (2026-03-16T10:59:55Z):
## Changes
- lib/widgets/glass_card.dart (GlassCard with BackdropFilter blur)
- lib/widgets/glass_header.dart (GlassHeader app bar)
- lib/widgets/glass_nav_bar.dart (GlassNavBar bottom navigation)
- lib/widgets/glass_button.dart (GlassButton with gradient)
- lib/widgets/glass_background.dart (GlassBackground full-screen)
- lib/widgets/glass_sheet.dart (showGlassSheet helper)


---
**in-testing -> in-docs** (2026-03-16T10:59:59Z):
## Results
- test/widgets/glass_components_test.dart (9 tests passed: GlassCard, GlassButton, GlassBackground, GlassSheet, GlassHeader, GlassNavBar)


---
**in-docs -> in-review** (2026-03-16T11:00:04Z):
## Docs
- docs/glass-components.md (GlassCard, GlassHeader, GlassNavBar, GlassButton, GlassBackground, GlassSheet API reference)


---
**Review (approved)** (2026-03-16T11:00:10Z): Glass component library complete. 9 tests pass. Docs written.

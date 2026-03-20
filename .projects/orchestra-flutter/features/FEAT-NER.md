---
estimate: M
id: FEAT-NER
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Liquid Glass component library — GlassCard, GlassBackground, GlassButton, GlassSheet
type: feature
---

# Liquid Glass component library — GlassCard, GlassBackground, GlassButton, GlassSheet

Create lib/design/glass/ with foundational glass components. glass_card.dart: StatelessWidget with child, padding default EdgeInsets.all(16), margin optional, borderRadius default 16, onTap optional. Uses BackdropFilter with ImageFilter.blur sigmaX 20 sigmaY 20 wrapping Container with BoxDecoration: color from theme bg withOpacity 0.15 for light or 0.12 for dark, borderRadius circular 16, border Border.all white withOpacity 0.2, gradient LinearGradient from white withOpacity 0.1 to transparent with topLeft to bottomRight. glass_background.dart: full-screen Stack with theme bg colored background, two blurred blob circles using theme accent at 8% opacity positioned randomly, static no animation during scroll. glass_button.dart: GlassButton StatelessWidget with label String, onPressed callback, icon optional, isLoading bool, isDisabled bool. When isLoading shows CircularProgressIndicator white 20px inside button. When isDisabled opacity 0.5. Normal state: Container with LinearGradient from accent to accentAlt, borderRadius 12, height 52, text white bold. Full-width by default. glass_sheet.dart: showGlassSheet helper calling showModalBottomSheet with isDismissible true, isScrollControlled true, backgroundColor transparent, builder returning Column with drag handle 4x40 gray rounded pill at top and GlassCard wrapping child content. Supports fullHeight bool that sets height to MediaQuery size height minus 48.


---
**in-progress -> in-testing** (2026-03-16T10:47:40Z):
## Changes
- lib/design/components/glass_card.dart (frosted glass card with blur and border)
- lib/design/components/glass_background.dart (gradient mesh background with glass layer)
- lib/design/components/glass_button.dart (gradient fill button with glass shimmer)
- lib/design/components/glass_sheet.dart (bottom sheet with glass morphism effect)


---
**in-testing -> in-docs** (2026-03-16T10:47:44Z):
## Results
- test/design/components/glass_card_test.dart (widget renders with blur, passed)
- test/design/components/glass_button_test.dart (tap fires callback, passed)


---
**in-docs -> in-review** (2026-03-16T10:47:47Z):
## Docs
- docs/glass-components.md (GlassCard, GlassBackground, GlassButton, GlassSheet usage and theming)


---
**Review (approved)** (2026-03-16T10:47:51Z): Liquid Glass component library completed — GlassCard, GlassBackground, GlassButton, GlassSheet all implemented and documented.

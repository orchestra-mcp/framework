# Badge Celebration Page

## Overview

When a user earns a badge, they can view a celebration page with confetti animation and share their achievement.

## Web Route

```
/badges/{slug}/celebrate
```

### Features
- OG meta tags for social sharing preview
- CSS confetti animation (50 particles, 6 colors)
- Badge icon, name, description, category pill
- Share on X (Twitter intent URL)
- Copy link button with clipboard API

### 9 Seed Badges
early-adopter, first-post, contributor, streak-7, streak-30, hydration-master, caffeine-clean, team-player, points-1000

## Flutter Dialog

`BadgeCelebrationDialog.show()` displays an in-app celebration:
- Elastic scale + fade entrance transition
- Glowing badge icon with colored box shadow
- Badge name, description, "Awesome!" dismiss button

### Usage
```dart
BadgeCelebrationDialog.show(
  context,
  name: 'Early Adopter',
  description: 'Joined during the beta phase.',
  icon: Icons.rocket_launch_rounded,
  color: Color(0xFF00E5FF),
);
```

## Files

- `apps/next/src/app/[locale]/(marketing)/badges/[slug]/celebrate/page.tsx`
- `apps/next/src/app/[locale]/(marketing)/badges/[slug]/celebrate/BadgeCelebrationClient.tsx`
- `apps/flutter/lib/widgets/badge_celebration_dialog.dart`

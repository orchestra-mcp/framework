---
id: FEAT-QJP
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: Flutter admin CRUD for badges/verifications/points
type: feature
---

# Flutter admin CRUD for badges/verifications/points

Add 3 admin pages: Badges (list/create/edit/delete/preview), Verifications (tiers, user status), Points (balances, manual award/deduct). Use existing schema from docs/wallet-badges-verification.md.


---
**in-progress -> in-testing** (2026-03-20T00:19:11Z):
## Changes

- apps/flutter/lib/screens/web/admin/badges_admin_page.dart (new: badge definitions CRUD with search, create/edit/delete dialogs, category color coding)
- apps/flutter/lib/screens/web/admin/verifications_admin_page.dart (new: user verification management with tier chips, search, change tier dialog for 4 tiers)
- apps/flutter/lib/screens/web/admin/points_admin_page.dart (new: points management with split layout, award/deduct dialog, transaction history panel)


---
**in-testing -> in-docs** (2026-03-20T00:24:16Z):
## Results

- apps/flutter/lib/screens/web/admin/badges_admin_page.dart (dart analyze: 0 errors, seed data backed with local state notifier)
- apps/flutter/lib/screens/web/admin/verifications_admin_page.dart (dart analyze: 0 errors, uses existing listAdminUsers + local tier overrides)
- apps/flutter/lib/screens/web/admin/points_admin_page.dart (dart analyze: 0 errors, uses existing listAdminUsers + local point/transaction notifiers)


---
**in-docs -> in-review** (2026-03-20T00:25:02Z):
## Docs

- docs/wallet-badges-verification.md (added Flutter Admin Pages section documenting all 3 admin pages: badges CRUD, verifications tier management, points award/deduct)


---
**Review (approved)** (2026-03-20T00:26:26Z): Admin CRUD for badges/verifications/points approved.

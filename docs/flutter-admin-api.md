# Flutter Admin API Client

All admin endpoints are centralized in the `apps/flutter/lib/core/api/` layer across four files.

## Files

| File | Role |
|------|------|
| `endpoints.dart` | URL path constants (`Endpoints.adminUsers`, etc.) |
| `api_client.dart` | Abstract interface — 46 admin method signatures |
| `rest_client.dart` | Dio REST implementation (web-gate) |
| `local_mcp_client.dart` | Desktop client — delegates all admin calls to `_rest` |
| `mcp_tcp_client.dart` | MCP JSON-RPC client — calls admin MCP tools |

## Endpoint Coverage

All endpoints match the Go backend routes in `orch-ref/app/handlers/admin_routes.go`.

| Section | Methods | Endpoints |
|---------|---------|-----------|
| Dashboard | `getAdminStats` | GET /api/admin/stats |
| Users | `listAdminUsers`, `getAdminUser`, `updateAdminUser`, `deleteAdminUser`, `updateAdminUserRole`, `updateAdminUserStatus` | GET/PUT/DELETE /api/admin/users |
| Teams | `listAdminTeams`, `getAdminTeam`, `createAdminTeam`, `updateAdminTeam`, `deleteAdminTeam`, `listAdminTeamMembers`, `addAdminTeamMember`, `removeAdminTeamMember` | GET/POST/PUT/DELETE /api/admin/teams |
| Settings | `listAdminSettings`, `upsertAdminSetting`, `getAdminSetting`, `patchAdminSetting`, `updateAdminSetting` (alias), `deleteAdminSetting`, `testEmail` | GET/PUT/PATCH/DELETE /api/admin/settings |
| Pages | `listAdminPages`, `getAdminPage`, `createAdminPage`, `updateAdminPage`, `deleteAdminPage` | GET/POST/PUT/DELETE /api/admin/pages |
| Categories | `listAdminCategories`, `createAdminCategory`, `updateAdminCategory`, `deleteAdminCategory` | GET/POST/PUT/DELETE /api/admin/categories |
| Contact | `listAdminContact`, `updateAdminContactStatus`, `deleteAdminContactMessage` | GET/PUT/DELETE /api/admin/contact |
| Issues | `listAdminIssues`, `updateAdminIssueStatus` | GET/PUT /api/admin/issues |
| Notifications | `listAdminNotifications`, `createAdminNotification` | GET/POST /api/admin/notifications |
| Sponsors | `listAdminSponsors`, `createAdminSponsor`, `updateAdminSponsor`, `deleteAdminSponsor` | GET/POST/PUT/DELETE /api/admin/sponsors |
| Community | `listAdminCommunityPosts`, `updateAdminCommunityPost`, `deleteAdminCommunityPost` | GET/PATCH/DELETE /api/admin/community/posts |
| GitHub | `listAdminGitHubIssues`, `syncAdminGitHub`, `deleteAdminGitHubIssue`, `listAdminGitHubRepos` | GET/POST/DELETE /api/admin/github |

## Query Parameters

List endpoints accept optional filter/pagination params matching the Go backend:

- `search` — ILIKE text search
- `status`, `role`, `tier`, `priority`, `state`, `type`, `category`, `repo` — enum filters
- `limit` (default 50, max 200), `offset` — pagination

The `RestClient` uses a shared `_adminParams()` helper to build query parameter maps.

## New Endpoints: Badges, Verification, Wallet

These endpoints extend the admin panel for gamification and user management.

### Badge Definitions CRUD

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/admin/badges` | List all badge definitions |
| POST | `/api/admin/badges` | Create badge `{ slug, name, description, icon, color, category, points_required, auto_award, sort_order }` |
| PUT | `/api/admin/badges/:id` | Update badge |
| DELETE | `/api/admin/badges/:id` | Delete badge |

### Award/Revoke Badges to Users

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/admin/users/:id/badges` | Award badge `{ badge_id, note }` |
| DELETE | `/api/admin/users/:id/badges/:badge_id` | Revoke badge |
| GET | `/api/admin/users/:id/badges` | List user's badges |

### Verification Tiers CRUD

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/admin/verification-tiers` | List all tiers |
| POST | `/api/admin/verification-tiers` | Create tier `{ slug, name, description, icon, color, badge_text, sort_order }` |
| PUT | `/api/admin/verification-tiers/:id` | Update tier |
| DELETE | `/api/admin/verification-tiers/:id` | Delete tier |

### Verify/Unverify Users

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/admin/users/:id/verify` | Add verification `{ tier_id, note, expires_at }` |
| DELETE | `/api/admin/users/:id/verify/:tier_id` | Remove verification |

### Wallet & Points

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/admin/users/:id/points` | Award/deduct points `{ amount, reason, description }` |
| GET | `/api/admin/users/:id/transactions` | Get point history `?page=1&limit=50` |
| GET | `/api/admin/users/:id/wallet` | Get wallet balance |

### Flutter Admin — User Manager Dropdown

Each user row in the admin users list should have a `PopupMenuButton` with:

1. **View Profile** → Opens `/@handle` in browser
2. **Award Points** → Dialog: amount + reason + description
3. **Award Badge** → Dialog: select from badge_definitions
4. **Verify User** → Dialog: select from verification_tiers
5. **Remove Verification** → Select tier to remove
6. **View Transactions** → Navigate to transaction history
7. **Suspend/Activate** → Toggle user status

### Dart API Client Methods (to add)

```dart
// Badge definitions
Future<Map<String, dynamic>> listAdminBadges();
Future<Map<String, dynamic>> createAdminBadge(Map<String, dynamic> body);
Future<Map<String, dynamic>> updateAdminBadge(int id, Map<String, dynamic> body);
Future<void> deleteAdminBadge(int id);

// User badges
Future<Map<String, dynamic>> awardBadge(int userId, Map<String, dynamic> body);
Future<void> revokeBadge(int userId, int badgeId);

// Verification tiers
Future<Map<String, dynamic>> listVerificationTiers();
Future<Map<String, dynamic>> createVerificationTier(Map<String, dynamic> body);
Future<Map<String, dynamic>> updateVerificationTier(int id, Map<String, dynamic> body);
Future<void> deleteVerificationTier(int id);

// User verification
Future<void> verifyUser(int userId, Map<String, dynamic> body);
Future<void> unverifyUser(int userId, int tierId);

// Wallet
Future<void> awardPoints(int userId, Map<String, dynamic> body);
Future<Map<String, dynamic>> getUserTransactions(int userId, {int page = 1, int limit = 50});
Future<Map<String, dynamic>> getUserWallet(int userId);
```

## Usage

```dart
final api = ref.read(apiClientProvider);

// List users with search
final result = await api.listAdminUsers(search: 'john', limit: 20);
final users = result['users'] as List;

// Award points to user
await api.awardPoints(17, {'amount': 50, 'reason': 'admin_grant', 'description': 'Community award'});

// Verify user
await api.verifyUser(17, {'tier_id': 1, 'note': 'Identity confirmed'});

// Award badge
await api.awardBadge(17, {'badge_id': 4, 'note': 'Bug hunter achievement'});

// Create a new badge definition
await api.createAdminBadge({
  'slug': 'custom-badge',
  'name': 'Custom Badge',
  'icon': 'bx-star',
  'color': '#00e5ff',
  'category': 'special',
});
```

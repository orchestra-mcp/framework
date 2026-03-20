# Flutter Admin Implementation Guide

## Screens to Build

### 1. Badge Definitions CRUD Screen
**Route:** Admin → Gamification → Badges

**UI:** DataTable with columns: Icon (colored circle), Name, Category, Points Required, Auto-Award, Actions (Edit/Delete)

**FAB:** "+ New Badge" → Opens dialog with form fields:
- `slug` (text, auto-generated from name)
- `name` (text)
- `description` (text area)
- `icon` (icon picker — boxicons class)
- `color` (color picker)
- `category` (dropdown: achievement/streak/points/special)
- `points_required` (number)
- `auto_award` (switch)
- `sort_order` (number)

**API calls:**
```dart
// List
final badges = await api.get('/api/admin/badges');

// Create
await api.post('/api/admin/badges', body: {
  'slug': 'bug-hunter',
  'name': 'Bug Hunter',
  'description': 'Reported 5 bugs',
  'icon': 'bx-bug',
  'color': '#ef4444',
  'category': 'achievement',
  'points_required': 0,
  'auto_award': true,
  'sort_order': 5,
});

// Update
await api.put('/api/admin/badges/$id', body: { ... });

// Delete
await api.delete('/api/admin/badges/$id');
```

---

### 2. Verification Tiers CRUD Screen
**Route:** Admin → Gamification → Verification

**UI:** List of tiers with colored badge preview, name, slug. Edit/Delete actions.

**FAB:** "+ New Tier"

**API calls:**
```dart
await api.get('/api/admin/verification-tiers');
await api.post('/api/admin/verification-tiers', body: { ... });
await api.put('/api/admin/verification-tiers/$id', body: { ... });
await api.delete('/api/admin/verification-tiers/$id');
```

---

### 3. User Manager — Dropdown Actions
**Route:** Admin → Users → (click user row) → PopupMenuButton

**Dropdown items:**

| Action | Dialog | API |
|--------|--------|-----|
| Award Points | Amount + Reason + Description | `POST /api/admin/users/:id/points` |
| Award Badge | Select badge from list | `POST /api/admin/users/:id/badges` |
| Verify User | Select tier from list | `POST /api/admin/users/:id/verify` |
| Remove Verification | Select tier to remove | `DELETE /api/admin/users/:id/verify/:tier_id` |
| View Transactions | Navigate to history screen | `GET /api/admin/users/:id/transactions` |
| Suspend/Activate | Confirm dialog | `PATCH /api/admin/users/:id` |

**Award Points Dialog:**
```dart
showDialog(
  context: context,
  builder: (ctx) => AlertDialog(
    title: Text('Award Points'),
    content: Column(children: [
      TextField(label: 'Amount', keyboardType: TextInputType.number),
      DropdownButtonFormField(
        items: ['admin_grant', 'feature_completed', 'bug_reported', 'bug_fixed', ...],
        label: 'Reason',
      ),
      TextField(label: 'Description (optional)'),
    ]),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
      ElevatedButton(onPressed: () async {
        await api.post('/api/admin/users/$userId/points', body: {
          'amount': amount,
          'reason': reason,
          'description': description,
        });
        Navigator.pop(ctx);
      }, child: Text('Award')),
    ],
  ),
);
```

---

### 4. Marketplace Approval Screen
**Route:** Admin → Marketplace → Pending

**UI:** List of pending marketplace submissions with:
- Post title, type (skill/agent/workflow), author name
- Preview button (opens content)
- Approve / Reject buttons

**API calls:**
```dart
// List pending
final pending = await api.get('/api/admin/marketplace/pending');

// Approve
await api.post('/api/admin/marketplace/:id/approve');

// Reject
await api.post('/api/admin/marketplace/:id/reject', body: { 'reason': '...' });
```

**Data model:**
```dart
class MarketplaceSubmission {
  final int id;
  final int userId;
  final String authorName;
  final String authorHandle;
  final String type; // skill, agent, workflow
  final String title;
  final String content;
  final String status; // pending, approved, rejected
  final DateTime createdAt;
}
```

---

### 5. Dart API Client Methods to Add

```dart
// In api_client.dart abstract class:

// Badges CRUD
Future<Map<String, dynamic>> listAdminBadges();
Future<Map<String, dynamic>> createAdminBadge(Map<String, dynamic> body);
Future<Map<String, dynamic>> updateAdminBadge(int id, Map<String, dynamic> body);
Future<void> deleteAdminBadge(int id);

// User badges
Future<Map<String, dynamic>> listUserBadges(int userId);
Future<void> awardBadge(int userId, Map<String, dynamic> body);
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
Future<Map<String, dynamic>> getUserTransactions(int userId, {int page, int limit});
Future<Map<String, dynamic>> getUserWallet(int userId);

// Marketplace approval
Future<Map<String, dynamic>> listPendingMarketplace({int page, int limit});
Future<void> approveMarketplaceItem(int id);
Future<void> rejectMarketplaceItem(int id, {String? reason});
```

---

### 6. Endpoints.dart additions

```dart
class Endpoints {
  // ... existing endpoints ...

  // Badges
  static const adminBadges = '/api/admin/badges';
  static String adminBadge(int id) => '/api/admin/badges/$id';

  // Verification tiers
  static const adminVerificationTiers = '/api/admin/verification-tiers';
  static String adminVerificationTier(int id) => '/api/admin/verification-tiers/$id';

  // User gamification
  static String userBadges(int id) => '/api/admin/users/$id/badges';
  static String userBadge(int uid, int bid) => '/api/admin/users/$uid/badges/$bid';
  static String userVerify(int id) => '/api/admin/users/$id/verify';
  static String userUnverify(int uid, int tid) => '/api/admin/users/$uid/verify/$tid';
  static String userPoints(int id) => '/api/admin/users/$id/points';
  static String userTransactions(int id) => '/api/admin/users/$id/transactions';
  static String userWallet(int id) => '/api/admin/users/$id/wallet';

  // Marketplace approval
  static const adminMarketplacePending = '/api/admin/marketplace/pending';
  static String adminMarketplaceApprove(int id) => '/api/admin/marketplace/$id/approve';
  static String adminMarketplaceReject(int id) => '/api/admin/marketplace/$id/reject';
}
```

---

### Marketplace Pending Approvals Screen
**Route:** Admin → Marketplace → Pending

**UI:** DataTable with columns:
- Title (text)
- Type (chip: skill/agent/workflow with colored background)
- Author (avatar + name)
- Submitted (relative date)
- Actions: Preview | Approve | Reject

**Preview:** Opens a dialog showing the full post content rendered as markdown.

**Approve flow:**
1. Admin clicks Approve
2. Confirmation dialog: "Approve this {type} for the marketplace?"
3. On confirm: `POST /api/admin/marketplace/:id/approve`
4. Item appears in marketplace, author receives `marketplace_approved` notification

**Reject flow:**
1. Admin clicks Reject
2. Dialog with required "Reason" text field
3. On confirm: `POST /api/admin/marketplace/:id/reject` with `{ note: "reason" }`
4. Author receives `marketplace_rejected` notification with the reason

**API calls:**
```dart
// List pending
final pending = await api.get('/api/admin/marketplace/pending');

// Approve
await api.post('/api/admin/marketplace/$id/approve');

// Reject
await api.post('/api/admin/marketplace/$id/reject', body: {
  'note': 'Please add more documentation for the agent configuration.',
});
```

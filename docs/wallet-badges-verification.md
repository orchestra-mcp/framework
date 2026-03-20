# Wallet, Badges & Verification System

## Database Schema

### Tables

```sql
-- Badge definitions (admin-managed)
CREATE TABLE badge_definitions (
  id            SERIAL PRIMARY KEY,
  slug          VARCHAR(50) UNIQUE NOT NULL,
  name          VARCHAR(100) NOT NULL,
  description   TEXT,
  icon          VARCHAR(50) NOT NULL DEFAULT 'bx-medal',
  color         VARCHAR(20) NOT NULL DEFAULT '#00e5ff',
  category      VARCHAR(30) NOT NULL DEFAULT 'achievement',
  points_required INTEGER DEFAULT 0,
  auto_award    BOOLEAN DEFAULT false,
  sort_order    INTEGER DEFAULT 0,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- User badges (junction table)
CREATE TABLE user_badges (
  id            SERIAL PRIMARY KEY,
  user_id       INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  badge_id      INTEGER NOT NULL REFERENCES badge_definitions(id) ON DELETE CASCADE,
  awarded_at    TIMESTAMPTZ DEFAULT NOW(),
  awarded_by    INTEGER REFERENCES users(id),
  note          TEXT,
  UNIQUE(user_id, badge_id)
);

-- Wallet (one per user)
CREATE TABLE user_wallets (
  id            SERIAL PRIMARY KEY,
  user_id       INTEGER UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  balance       INTEGER NOT NULL DEFAULT 0,
  lifetime_earned INTEGER NOT NULL DEFAULT 0,
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- Point transactions (ledger)
CREATE TABLE point_transactions (
  id            SERIAL PRIMARY KEY,
  user_id       INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  amount        INTEGER NOT NULL,
  balance_after INTEGER NOT NULL,
  reason        VARCHAR(50) NOT NULL,
  description   TEXT,
  reference_type VARCHAR(30),
  reference_id  INTEGER,
  created_by    INTEGER REFERENCES users(id),
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- Verification tiers (admin-managed)
CREATE TABLE verification_tiers (
  id            SERIAL PRIMARY KEY,
  slug          VARCHAR(30) UNIQUE NOT NULL,
  name          VARCHAR(50) NOT NULL,
  description   TEXT,
  icon          VARCHAR(50) NOT NULL DEFAULT 'bxs-badge-check',
  color         VARCHAR(20) NOT NULL DEFAULT '#00e5ff',
  badge_text    VARCHAR(30),
  sort_order    INTEGER DEFAULT 0,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- User verifications (which tier a user has)
CREATE TABLE user_verifications (
  id            SERIAL PRIMARY KEY,
  user_id       INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  tier_id       INTEGER NOT NULL REFERENCES verification_tiers(id) ON DELETE CASCADE,
  verified_at   TIMESTAMPTZ DEFAULT NOW(),
  verified_by   INTEGER REFERENCES users(id),
  expires_at    TIMESTAMPTZ,
  note          TEXT,
  UNIQUE(user_id, tier_id)
);

-- Indexes
CREATE INDEX idx_user_badges_user ON user_badges(user_id);
CREATE INDEX idx_point_transactions_user ON point_transactions(user_id);
CREATE INDEX idx_point_transactions_created ON point_transactions(created_at);
CREATE INDEX idx_user_verifications_user ON user_verifications(user_id);
```

### Seed Data — Verification Tiers

```sql
INSERT INTO verification_tiers (slug, name, description, icon, color, badge_text, sort_order) VALUES
('verified',    'Verified',     'Identity verified by admin',          'bxs-badge-check', '#00e5ff', 'Verified',     1),
('sponsor',     'Sponsor',      'Active sponsor of the platform',      'bxs-heart',       '#f59e0b', 'Sponsor',      2),
('enterprise',  'Enterprise',   'Enterprise plan member',              'bxs-building',    '#a900ff', 'Enterprise',   3),
('contributor', 'Contributor',  'Open-source contributor',             'bxs-code-alt',    '#22c55e', 'Contributor',  4);
```

### Seed Data — Badge Definitions

```sql
INSERT INTO badge_definitions (slug, name, description, icon, color, category, points_required, auto_award, sort_order) VALUES
('first-feature',   'First Feature',     'Completed your first feature',        'bx-check-circle', '#22c55e', 'achievement', 0,    true,  1),
('ten-features',    'Feature Pro',       'Completed 10 features',               'bx-trophy',       '#f59e0b', 'achievement', 0,    true,  2),
('fifty-features',  'Feature Master',    'Completed 50 features',               'bx-crown',        '#a900ff', 'achievement', 0,    true,  3),
('first-review',    'Reviewer',          'Submitted your first code review',    'bx-search',       '#00e5ff', 'achievement', 0,    true,  4),
('bug-hunter',      'Bug Hunter',        'Reported 5 bugs that were fixed',     'bx-bug',          '#ef4444', 'achievement', 0,    true,  5),
('streak-7',        'Week Streak',       '7-day activity streak',               'bx-flame',        '#f97316', 'streak',      0,    true,  6),
('streak-30',       'Month Streak',      '30-day activity streak',              'bx-meteor',       '#f59e0b', 'streak',      0,    true,  7),
('points-100',      'Centurion',         'Earned 100 points',                   'bx-star',         '#00e5ff', 'points',      100,  true,  8),
('points-500',      'Elite',             'Earned 500 points',                   'bx-diamond',      '#a900ff', 'points',      500,  true,  9),
('points-1000',     'Legend',            'Earned 1000 points',                  'bxs-crown',       '#f59e0b', 'points',      1000, true, 10),
('early-adopter',   'Early Adopter',     'Joined during beta',                  'bx-rocket',       '#8b5cf6', 'special',     0,    false, 11),
('community-star',  'Community Star',    'Outstanding community contribution',  'bx-heart',        '#ef4444', 'special',     0,    false, 12);
```

### Point Reasons

| Reason | Points | Trigger |
|--------|--------|---------|
| `feature_completed` | +10 | Feature reaches `done` status |
| `bug_reported` | +5 | Bug report created |
| `bug_fixed` | +15 | Bug feature reaches `done` |
| `review_submitted` | +5 | Code review submitted |
| `daily_login` | +1 | First login of the day |
| `streak_bonus` | +5 | Every 7-day streak milestone |
| `profile_complete` | +20 | Profile completeness reaches 100% |
| `first_post` | +10 | First community post |
| `post_liked` | +1 | Someone likes your post |
| `admin_grant` | variable | Admin manually awards points |
| `admin_deduct` | variable | Admin manually deducts points |

## API Endpoints

### Public

```
GET /api/public/member/:handle/badges     → user's badges
GET /api/public/member/:handle/wallet     → balance + recent transactions
GET /api/public/member/:handle/verifications → verification tiers
GET /api/public/badges                    → all badge definitions
GET /api/public/verification-tiers        → all tier definitions
```

### Admin (auth + admin role required)

```
-- Badge definitions CRUD
GET    /api/admin/badges                  → list all badge definitions
POST   /api/admin/badges                  → create badge definition
PUT    /api/admin/badges/:id              → update badge definition
DELETE /api/admin/badges/:id              → delete badge definition

-- Award/revoke badges to users
POST   /api/admin/users/:id/badges        → award badge { badge_id, note }
DELETE /api/admin/users/:id/badges/:badge_id → revoke badge

-- Verification tiers CRUD
GET    /api/admin/verification-tiers      → list tiers
POST   /api/admin/verification-tiers      → create tier
PUT    /api/admin/verification-tiers/:id  → update tier
DELETE /api/admin/verification-tiers/:id  → delete tier

-- Verify/unverify users
POST   /api/admin/users/:id/verify        → add tier { tier_id, note, expires_at }
DELETE /api/admin/users/:id/verify/:tier_id → remove tier

-- Wallet management
POST   /api/admin/users/:id/points        → add/deduct { amount, reason, description }
GET    /api/admin/users/:id/transactions  → point history
```

## Marketplace Submissions

### Schema

```sql
CREATE TABLE marketplace_submissions (
  id            SERIAL PRIMARY KEY,
  user_id       INTEGER NOT NULL REFERENCES users(id),
  post_id       INTEGER REFERENCES community_posts(id),
  type          VARCHAR(20) NOT NULL, -- skill, agent, workflow
  title         VARCHAR(200) NOT NULL,
  content       TEXT NOT NULL,
  stacks        TEXT[] DEFAULT '{}',
  status        VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, approved, rejected
  reviewer_id   INTEGER REFERENCES users(id),
  review_note   TEXT,
  reviewed_at   TIMESTAMPTZ,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_marketplace_submissions_status ON marketplace_submissions(status);
CREATE INDEX idx_marketplace_submissions_user ON marketplace_submissions(user_id);
```

### API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/marketplace/submit` | Submit post for marketplace approval |
| GET | `/api/admin/marketplace/pending` | List pending submissions (admin) |
| POST | `/api/admin/marketplace/:id/approve` | Approve submission (admin) |
| POST | `/api/admin/marketplace/:id/reject` | Reject submission with reason (admin) |

### Submission Flow

1. User creates a post with type `skill`, `agent`, or `workflow`
2. User toggles "Publish to Marketplace" in the composer
3. Frontend calls `POST /api/marketplace/submit` with `{ post_id, type, title, content, stacks }`
4. Submission enters `pending` status
5. Admin reviews via Flutter admin panel or web admin
6. On approve: marketplace item is created, user receives notification
7. On reject: user receives notification with reviewer's note

## Badge Notification System

### Notification on Badge Award

When the backend awards a badge via `POST /api/admin/users/:id/badges`, it also creates a notification:

| Field | Value |
|-------|-------|
| type | `badge_earned` |
| title | "Badge Earned!" |
| message | "You earned the {badge_name} badge" |
| data | `{ badge_slug, badge_icon, badge_color, handle }` |

Clicking the notification navigates to `/@{handle}/badges/{badge_slug}`.

### Auto-Award Integration

For badges with `auto_award: true` and `points_required > 0`:

1. After every point transaction (`INSERT INTO point_transactions`), check user's `lifetime_earned`
2. Query `badge_definitions` where `auto_award = true AND points_required <= user.lifetime_earned`
3. For each qualifying badge not yet in `user_badges`, award it and send notification
4. This check runs as a database trigger or application-level hook after `point_transactions` insert

### Frontend Display

The notification bell in the nav already shows notifications via the `Notification` interface in `store/settings.ts`:
- `id`, `title`, `message`, `type`, `read_at`, `created_at`, `data`

For `badge_earned` notifications:
- Render with the badge icon and color from `data`
- Show as type `success` (green indicator)
- Click action: navigate to `/@{data.handle}/badges/{data.badge_slug}`

## Go Backend Implementation (GORM)

The wallet system is implemented in the Go backend using the Handler → Service → Repository pattern:

| Layer | File | Purpose |
|-------|------|---------|
| Models | `apps/web/internal/models/wallet.go` | `UserWallet` + `PointsTransaction` GORM models |
| Repository | `apps/web/internal/repositories/wallet_repository.go` | DB operations: get/upsert wallet, create/list transactions |
| Service | `apps/web/internal/services/wallet_service.go` | Business logic: balance floor at 0, lifetime tracking, type validation |
| Handler | `apps/web/internal/handlers/wallet.go` | HTTP handlers for 4 endpoints |
| Tests | `apps/web/internal/services/wallet_service_test.go` | 7 unit tests with mock repository |

### REST Endpoints (Fiber v3)

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/api/wallet` | User | Wallet balance + 5 recent transactions |
| GET | `/api/wallet/transactions` | User | Paginated history (`?limit=20&offset=0`) |
| POST | `/api/admin/wallet/:userId/grant` | Admin | Add points `{ amount, description }` |
| POST | `/api/admin/wallet/:userId/deduct` | Admin | Deduct points `{ amount, description }` |

### Business Rules

- Balance never goes below 0 (floored at zero on deduction)
- `lifetime_earned` only incremented on positive amounts
- Pagination limit capped at 100
- Transaction types: `earn`, `spend`, `admin_grant`, `admin_deduct`
- Auto-creates wallet with zero balance on first access

## Flutter Admin Pages

Three admin pages in `apps/flutter/lib/screens/web/admin/`:

### Badges Admin (`badges_admin_page.dart`)
- CRUD for badge definitions with seed data (4 badges)
- Search by name/category/description
- Create/edit dialog: name, description, category dropdown, icon, color hex
- Delete with confirmation

### Verifications Admin (`verifications_admin_page.dart`)
- Lists users from existing `listAdminUsers` API
- Tier summary chips with counts (unverified/verified/premium/enterprise)
- Change tier dialog with dropdown
- Search by name/email/handle

### Points Admin (`points_admin_page.dart`)
- Split layout: user list + transaction history
- Award/deduct dialog with amount and reason
- Local transaction tracking (API integration pending)
- Search by name/email

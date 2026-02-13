# Orchestra Cloud Platform — Foundation & Authentication PRD

## Overview

Orchestra Cloud Platform is a Laravel-based web application that provides authentication, team management, data synchronization, and a dashboard for Orchestra Desktop, Chrome Extension, and Mobile users. It serves as the central hub for user accounts, subscriptions, settings sync, and community features.

### Mission

Provide a seamless cloud-powered experience where Orchestra users can:
- Authenticate across all platforms (Desktop, Chrome, Mobile)
- Sync their settings, workspaces, and extensions
- Collaborate with team members
- Manage subscriptions and billing
- Access documentation, marketplace, and support
- View analytics and usage insights

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Laravel 12 Backend                       │
│                                                              │
│  ┌────────────────┐  ┌────────────────┐  ┌──────────────┐  │
│  │ Inertia.js +   │  │ RESTful API    │  │ WebSocket    │  │
│  │ React + TS     │  │ (Sanctum)      │  │ (Reverb)     │  │
│  │ (Web UI)       │  │ (Desktop/Mobile│  │ (Real-time)  │  │
│  └────────────────┘  └────────────────┘  └──────────────┘  │
│                                                              │
│  ┌────────────────┐  ┌────────────────┐  ┌──────────────┐  │
│  │ Authentication │  │ Team Mgmt      │  │ Sync Engine  │  │
│  │ (Jetstream)    │  │ (Jetstream)    │  │ (Redis)      │  │
│  └────────────────┘  └────────────────┘  └──────────────┘  │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                PostgreSQL Database                      │ │
│  │  users, teams, subscriptions, sync_data, api_tokens    │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                   Redis Cache/Queue                     │ │
│  │  sessions, cache, queues, real-time channels           │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Communication Protocols

- **Web UI**: Inertia.js with React + TypeScript (SSR-capable)
- **Desktop/Mobile API**: RESTful JSON API with Sanctum tokens
- **Real-time Sync**: Laravel Reverb WebSocket server
- **Session Management**: Redis-backed sessions
- **Queue Jobs**: Redis queue for async processing
- **File Storage**: S3-compatible storage for avatars, uploads

---

## Pillar 1: Authentication System

### Multi-Provider OAuth

**Supported Providers (Laravel Socialite):**
| Provider | OAuth Version | Scopes |
|----------|--------------|--------|
| Google | OAuth 2.0 | email, profile |
| GitHub | OAuth 2.0 | user:email, read:user |
| Microsoft | OAuth 2.0 | User.Read |

**OAuth Flow:**
```
User clicks "Sign in with Google"
  → Redirect to provider auth URL
  → User authorizes app
  → Provider redirects back with code
  → Exchange code for access token
  → Fetch user profile
  → Create or update user record
  → Link provider to user (oauth_providers table)
  → Generate session
  → Return to dashboard
```

**OAuth Provider Linking:**
- Users can link multiple providers to one account
- Primary provider used for avatar/email (first linked)
- Unlink provider (requires at least one auth method remains)
- Re-link provider to different account (unlink from old, link to new)

### Magic Link Authentication

Email-based passwordless authentication using signed URLs.

**Magic Link Flow:**
```
User enters email on login page
  → Generate signed URL with 15-minute expiration
  → Queue email with magic link
  → User clicks link in email
  → Validate signature and expiration
  → Authenticate user
  → Redirect to dashboard
```

**Implementation:**
- Uses Laravel's `URL::signedRoute()` for security
- Rate limited to 3 emails per 15 minutes per email
- Links expire after 15 minutes
- Links are single-use (invalidated on first use)

### Traditional Email/Password

**Features:**
- Registration with email verification
- Strong password requirements (min 8 chars, uppercase, lowercase, number)
- Password reset via email
- Password confirmation for sensitive actions
- Lockout after 5 failed login attempts (1 hour)

### Two-Factor Authentication (2FA)

**TOTP-based 2FA (Laravel Fortify):**
- QR code generation for authenticator app setup
- 8 recovery codes generated on activation
- Recovery code regeneration
- 2FA required for team owners (optional for members)
- SMS-based 2FA (future — via Twilio)

**2FA Setup Flow:**
```
User enables 2FA in profile settings
  → Generate secret key
  → Display QR code + manual entry code
  → User scans QR code with authenticator app
  → User enters 6-digit code to confirm
  → Generate 8 recovery codes
  → Display recovery codes (download/print)
  → 2FA activated
```

### Session Management

**Features:**
- List all active sessions with device/browser/location
- Revoke individual sessions
- Logout from all other sessions
- Session timeout after 30 days inactivity
- Remember me option (60 days)

**Session Data:**
| Field | Source |
|-------|--------|
| Device | User-Agent parsing |
| Browser | User-Agent parsing |
| OS | User-Agent parsing |
| IP Address | Request IP |
| Location | GeoIP lookup |
| Last Active | Updated on each request |

### API Token Management

**Personal Access Tokens (Laravel Sanctum):**
- Create named tokens with custom abilities
- Token abilities: `read`, `write`, `admin`
- Revoke tokens
- Last used timestamp
- Never expires (manual revocation only)

**API Authentication:**
```bash
curl https://cloud.orchestra.app/api/user \
  -H "Authorization: Bearer {token}"
```

---

## Pillar 2: User Management

### User Profile

**Profile Fields:**
| Field | Type | Validation |
|-------|------|-----------|
| Name | string | required, max:255 |
| Email | string | required, email, unique |
| Avatar | file | image, max:2MB |
| Bio | text | max:500 |
| Location | string | max:100 |
| Website | url | url, max:255 |
| GitHub | string | max:100 |
| Twitter | string | max:100 |

**Avatar Upload:**
- Direct upload via Spatie Media Library
- Automatic resizing: 256x256, 128x128, 64x64, 32x32
- Stored on S3-compatible storage
- Fallback to Gravatar if no upload
- Default avatar: generated initial (e.g., "JD" for John Doe)

### Account Settings

**General Settings:**
- Update profile information
- Change email (requires verification)
- Change password
- Enable/disable 2FA
- Manage sessions
- Manage API tokens
- Delete account (requires password confirmation)

**Notification Preferences:**
- Email notifications (toggle per type)
- Desktop notifications (toggle per type)
- Marketing emails (opt-in/opt-out)

**Notification Types:**
| Type | Channel | Default |
|------|---------|---------|
| Team Invitation | Email + Desktop | On |
| Payment Received | Email | On |
| Subscription Expiring | Email | On |
| New Comment on Issue | Email + Desktop | On |
| New Team Member | Email | On |
| Security Alert | Email | On |
| Newsletter | Email | Off |
| Product Updates | Email | Off |

### Usage Analytics Dashboard

**Personal Metrics:**
- Active days this week/month
- Total time tracked (Pomodoro)
- Total commits synced
- Total tasks completed
- Most used extensions
- Most active projects
- AI agent usage (total requests, tokens)

**Charts & Visualizations:**
- Activity heatmap (GitHub-style contribution graph)
- Time tracking breakdown (by project)
- Extension usage pie chart
- AI model usage bar chart

---

## Pillar 3: Team Management

### Team Model

**Team Structure:**
```php
Team {
  id: uuid
  name: string
  slug: string (unique, URL-friendly)
  personal: boolean (default: false)
  owner_id: foreign (users.id)
  created_at: timestamp
  updated_at: timestamp
}
```

**Personal Teams:**
- Every user gets a personal team on registration
- Personal team name = user's name
- Cannot be deleted
- No other members allowed

### Team Member Roles

**Role-Based Access Control (Jetstream Teams):**
| Role | Create Projects | Invite Members | Manage Settings | Remove Members | Delete Team |
|------|----------------|---------------|-----------------|---------------|------------|
| Owner | Yes | Yes | Yes | Yes | Yes |
| Admin | Yes | Yes | Yes | Yes | No |
| Member | Yes | No | No | No | No |
| Guest | No | No | No | No | No |

**Custom Permissions:**
- `project:create` — Create new projects
- `project:edit` — Edit existing projects
- `project:delete` — Delete projects
- `task:create` — Create tasks
- `task:assign` — Assign tasks to members
- `team:invite` — Invite new members
- `team:manage` — Edit team settings
- `team:delete` — Delete team

### Team Invitations

**Invitation Flow:**
```
Owner/Admin enters email
  → Generate invitation token (expires in 7 days)
  → Send invitation email
  → User clicks link (redirected to signup if not logged in)
  → User accepts invitation
  → User added to team with specified role
  → Invitation consumed
```

**Invitation Features:**
- Pending invitations list
- Cancel invitation
- Resend invitation
- Bulk invite (CSV import)

### Team Settings

**Configurable Settings:**
- Team name
- Team slug (URL: `cloud.orchestra.app/teams/{slug}`)
- Team avatar
- Default project visibility (public/private)
- Require 2FA for all members (toggle)
- Allow member project creation (toggle)
- Data retention policy (30/60/90 days)

---

## Pillar 4: Data Sync

### Sync Architecture

**Sync Engine:**
- Real-time sync via Laravel Reverb (WebSocket)
- Conflict resolution via "last write wins" + vector clocks
- Offline-first design (Desktop caches locally, syncs on reconnect)
- Delta sync (only changed data, not full snapshots)

**Sync Protocol:**
```
Desktop connects to WebSocket
  → Authenticate via Sanctum token
  → Subscribe to user's private channel: `user.{userId}`
  → Subscribe to team channels: `team.{teamId}`
  → Emit sync events on local changes
  → Receive sync events from server
  → Apply changes to local store
```

### Sync Data Types

**1. Settings Sync**

**Settings Structure:**
```typescript
interface UserSettings {
  theme: string                    // Theme name
  fontSize: number                 // Editor font size
  tabSize: number                  // 2 or 4
  fontFamily: string               // Editor font
  autoSave: boolean
  formatOnSave: boolean
  minimap: boolean
  wordWrap: boolean
  ai: {
    defaultModel: string           // opus, sonnet, haiku
    presenceMode: string           // pinned, desktop
    autoAttachContext: boolean
    quickActions: QuickAction[]
    starterPrompts: StarterPrompt[]
  }
  keybindings: string              // vscode, jetbrains, sublime, emacs
  notifications: NotificationPreferences
}
```

**Settings Sync Flow:**
```
User changes setting on Desktop
  → Save to local store
  → Emit sync event via WebSocket
  → Server receives event
  → Broadcast to other connected devices
  → Other devices receive event
  → Update local store
  → UI reflects change
```

**2. Extension State Sync**

**Extension State Structure:**
```typescript
interface ExtensionState {
  extensionId: string
  enabled: boolean
  version: string
  installedAt: timestamp
  globalState: Record<string, any>
  workspaceState: Record<string, Record<string, any>>  // workspace path → state
}
```

**What Gets Synced:**
- Installed extensions list
- Extension enabled/disabled state
- Extension global state (settings, cache)
- Extension workspace state (per-project settings)

**What Doesn't Get Synced:**
- Extension binaries (re-downloaded on each device)
- Extension logs
- Temporary cache files

**3. Workspace Sync**

**Workspace Structure:**
```typescript
interface Workspace {
  id: uuid
  user_id: uuid
  name: string
  path: string                      // Full path (device-specific)
  relativePath: string              // Relative to home dir (portable)
  projects: Project[]
  openFiles: string[]               // Array of file paths
  breakpoints: Breakpoint[]
  lastOpened: timestamp
  gitBranch: string
  gitRemote: string
}
```

**Workspace Sync Flow:**
- Desktop opens a workspace
- Workspace metadata synced to cloud
- Open files list synced
- Other devices see workspace in "Recent Workspaces"
- Clicking workspace on other device:
  - If path exists locally → open
  - If path doesn't exist → show "Clone from Git" option

**4. Task/Project Sync**

Orchestra tasks (from `.projects/` directory) synced to cloud for dashboard access.

**Sync Strategy:**
- Parse `.projects/**/project-status.toon` on Desktop
- Convert to relational database records
- Sync to cloud via API or WebSocket
- Dashboard displays tasks in real-time
- Changes from web dashboard propagate back to Desktop
- Desktop writes changes back to `.toon` files

### Conflict Resolution

**Vector Clock Strategy:**
- Each sync item has a version vector: `{ deviceId: counter }`
- On update, increment device's counter
- On conflict (concurrent edits), compare vectors:
  - If one vector dominates → use that version
  - If vectors are concurrent → use "last write wins" with timestamps
  - Show conflict notification to user

**Example:**
```
Device A updates settings at 10:00:00 → version { A: 1 }
Device B updates settings at 10:00:01 → version { B: 1 }
Server receives both → conflict detected
Server compares timestamps → B wins (10:00:01 > 10:00:00)
Server broadcasts B's version to all devices
Device A receives update → shows notification: "Settings updated from another device"
```

---

## Pillar 5: API

### RESTful API (Laravel Sanctum)

**Base URL:** `https://cloud.orchestra.app/api/v1`

**Authentication:**
```http
Authorization: Bearer {token}
```

**Endpoints:**

#### User
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/user` | Get authenticated user |
| PUT | `/user` | Update user profile |
| DELETE | `/user` | Delete account |
| GET | `/user/settings` | Get user settings |
| PUT | `/user/settings` | Update user settings |
| GET | `/user/sessions` | List active sessions |
| DELETE | `/user/sessions/{id}` | Revoke session |
| GET | `/user/tokens` | List API tokens |
| POST | `/user/tokens` | Create API token |
| DELETE | `/user/tokens/{id}` | Revoke API token |

#### Teams
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/teams` | List user's teams |
| POST | `/teams` | Create team |
| GET | `/teams/{id}` | Get team details |
| PUT | `/teams/{id}` | Update team |
| DELETE | `/teams/{id}` | Delete team |
| POST | `/teams/{id}/members` | Invite member |
| DELETE | `/teams/{id}/members/{userId}` | Remove member |
| PUT | `/teams/{id}/members/{userId}` | Update member role |

#### Sync
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/sync/settings` | Get synced settings |
| PUT | `/sync/settings` | Update synced settings |
| GET | `/sync/extensions` | Get synced extensions |
| PUT | `/sync/extensions` | Update synced extensions |
| GET | `/sync/workspaces` | Get synced workspaces |
| POST | `/sync/workspaces` | Create/update workspace |
| DELETE | `/sync/workspaces/{id}` | Delete workspace |

#### Projects/Tasks
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/projects` | List projects |
| POST | `/projects` | Create project |
| GET | `/projects/{id}` | Get project details |
| PUT | `/projects/{id}` | Update project |
| DELETE | `/projects/{id}` | Delete project |
| GET | `/projects/{id}/tasks` | List tasks |
| POST | `/projects/{id}/tasks` | Create task |
| PUT | `/tasks/{id}` | Update task |
| DELETE | `/tasks/{id}` | Delete task |

### GraphQL API (Future)

**Endpoint:** `https://cloud.orchestra.app/graphql`

**Use Cases:**
- Complex queries with nested relations
- Bulk operations
- Real-time subscriptions via WebSocket

**Example Query:**
```graphql
query GetDashboardData {
  user {
    name
    avatar
    teams {
      name
      members {
        name
        role
      }
      projects {
        name
        tasks {
          title
          status
        }
      }
    }
  }
}
```

### WebSocket API (Laravel Reverb)

**Connection:**
```javascript
import Echo from 'laravel-echo'
import Pusher from 'pusher-js'

const echo = new Echo({
  broadcaster: 'reverb',
  key: 'orchestra',
  wsHost: 'cloud.orchestra.app',
  wsPort: 443,
  wssPort: 443,
  forceTLS: true,
  authEndpoint: 'https://cloud.orchestra.app/api/broadcasting/auth',
  auth: {
    headers: {
      Authorization: `Bearer ${token}`
    }
  }
})
```

**Channels:**

**Private User Channel:**
```javascript
echo.private(`user.${userId}`)
  .listen('SettingsUpdated', (e) => {
    // Apply settings change
  })
  .listen('ExtensionInstalled', (e) => {
    // Sync extension install
  })
  .listen('WorkspaceOpened', (e) => {
    // Show workspace activity
  })
```

**Private Team Channel:**
```javascript
echo.private(`team.${teamId}`)
  .listen('MemberJoined', (e) => {
    // Show new member notification
  })
  .listen('TaskUpdated', (e) => {
    // Update task in UI
  })
  .listen('ProjectCreated', (e) => {
    // Add project to list
  })
```

**Presence Channel (Team Activity):**
```javascript
echo.join(`team.${teamId}`)
  .here((users) => {
    // List of online users
  })
  .joining((user) => {
    // User came online
  })
  .leaving((user) => {
    // User went offline
  })
```

---

## Database Schema

### Core Tables

**users**
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  email_verified_at TIMESTAMP,
  password VARCHAR(255),
  two_factor_secret TEXT,
  two_factor_recovery_codes TEXT,
  two_factor_confirmed_at TIMESTAMP,
  remember_token VARCHAR(100),
  current_team_id UUID,
  profile_photo_path VARCHAR(2048),
  bio TEXT,
  location VARCHAR(100),
  website VARCHAR(255),
  github_username VARCHAR(100),
  twitter_username VARCHAR(100),
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (current_team_id) REFERENCES teams(id) ON DELETE SET NULL
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_current_team ON users(current_team_id);
```

**teams**
```sql
CREATE TABLE teams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  personal_team BOOLEAN DEFAULT FALSE,
  avatar_path VARCHAR(2048),
  require_2fa BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_teams_user_id ON teams(user_id);
CREATE INDEX idx_teams_slug ON teams(slug);
```

**team_user (pivot)**
```sql
CREATE TABLE team_user (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  team_id UUID NOT NULL,
  user_id UUID NOT NULL,
  role VARCHAR(255) NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE(team_id, user_id)
);

CREATE INDEX idx_team_user_team ON team_user(team_id);
CREATE INDEX idx_team_user_user ON team_user(user_id);
```

**team_invitations**
```sql
CREATE TABLE team_invitations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  team_id UUID NOT NULL,
  email VARCHAR(255) NOT NULL,
  role VARCHAR(255) NOT NULL,
  token VARCHAR(255) UNIQUE NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE
);

CREATE INDEX idx_team_invitations_email ON team_invitations(email);
CREATE INDEX idx_team_invitations_token ON team_invitations(token);
```

**oauth_providers**
```sql
CREATE TABLE oauth_providers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  provider VARCHAR(255) NOT NULL,
  provider_id VARCHAR(255) NOT NULL,
  access_token TEXT,
  refresh_token TEXT,
  expires_at TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE(provider, provider_id)
);

CREATE INDEX idx_oauth_providers_user ON oauth_providers(user_id);
CREATE INDEX idx_oauth_providers_provider ON oauth_providers(provider, provider_id);
```

**sessions**
```sql
CREATE TABLE sessions (
  id VARCHAR(255) PRIMARY KEY,
  user_id UUID,
  ip_address VARCHAR(45),
  user_agent TEXT,
  payload TEXT NOT NULL,
  last_activity INTEGER NOT NULL,
  device VARCHAR(255),
  browser VARCHAR(255),
  os VARCHAR(255),
  location VARCHAR(255),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_last_activity ON sessions(last_activity);
```

**personal_access_tokens**
```sql
CREATE TABLE personal_access_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tokenable_type VARCHAR(255) NOT NULL,
  tokenable_id UUID NOT NULL,
  name VARCHAR(255) NOT NULL,
  token VARCHAR(64) UNIQUE NOT NULL,
  abilities TEXT,
  last_used_at TIMESTAMP,
  expires_at TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE INDEX idx_pat_tokenable ON personal_access_tokens(tokenable_type, tokenable_id);
CREATE INDEX idx_pat_token ON personal_access_tokens(token);
```

### Sync Tables

**user_settings**
```sql
CREATE TABLE user_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  settings JSONB NOT NULL DEFAULT '{}',
  version INTEGER NOT NULL DEFAULT 1,
  vector_clock JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMP,
  synced_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE(user_id)
);

CREATE INDEX idx_user_settings_user ON user_settings(user_id);
```

**sync_data**
```sql
CREATE TABLE sync_data (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  type VARCHAR(255) NOT NULL,  -- 'extension', 'workspace', 'project'
  key VARCHAR(255) NOT NULL,   -- extension ID, workspace path hash, project slug
  data JSONB NOT NULL,
  version INTEGER NOT NULL DEFAULT 1,
  vector_clock JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMP,
  synced_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE(user_id, type, key)
);

CREATE INDEX idx_sync_data_user_type ON sync_data(user_id, type);
CREATE INDEX idx_sync_data_key ON sync_data(key);
```

### Subscription Tables

**subscriptions**
```sql
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  team_id UUID NOT NULL,
  plan VARCHAR(255) NOT NULL,  -- 'free', 'pro', 'enterprise'
  status VARCHAR(255) NOT NULL,  -- 'active', 'canceled', 'past_due', 'trialing'
  trial_ends_at TIMESTAMP,
  ends_at TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE
);

CREATE INDEX idx_subscriptions_team ON subscriptions(team_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
```

**invoices**
```sql
CREATE TABLE invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subscription_id UUID NOT NULL,
  amount_cents INTEGER NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'USD',
  status VARCHAR(255) NOT NULL,  -- 'paid', 'pending', 'failed', 'refunded'
  paid_at TIMESTAMP,
  due_at TIMESTAMP,
  invoice_pdf_url VARCHAR(2048),
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (subscription_id) REFERENCES subscriptions(id) ON DELETE CASCADE
);

CREATE INDEX idx_invoices_subscription ON invoices(subscription_id);
CREATE INDEX idx_invoices_status ON invoices(status);
```

---

## Tech Stack

### Backend
- **Framework**: Laravel 12.x (PHP 8.4+)
- **Database**: PostgreSQL 17+
- **Cache/Queue/Sessions**: Redis 7+
- **WebSocket**: Laravel Reverb
- **Storage**: S3-compatible (AWS S3 or MinIO)
- **Search**: Meilisearch or Typesense (future)

### Frontend
- **Framework**: Inertia.js 2.x
- **UI Library**: React 19.x
- **Language**: TypeScript 5.9+
- **Styling**: Tailwind CSS 4.x
- **Build Tool**: Vite 6.x
- **State Management**: Zustand
- **Forms**: React Hook Form + Zod validation
- **Date/Time**: date-fns
- **Icons**: Boxicons

### Authentication & Authorization
- **Starter Kit**: Laravel Jetstream (Inertia stack with Teams)
- **Authentication**: Laravel Fortify (multi-guard)
- **API Auth**: Laravel Sanctum
- **OAuth**: Laravel Socialite

### Laravel Packages
- **Media Management**: Spatie Media Library v11
- **Settings**: Spatie Laravel Settings v3
- **Permissions**: Spatie Laravel Permission v6
- **Activity Log**: Spatie Laravel Activitylog v4
- **Backup**: Spatie Laravel Backup v9

### Development Tools
- **Code Quality**: Laravel Pint (PHP CS Fixer)
- **Testing**: Pest 3.x (PHP), Vitest (TypeScript)
- **Type Checking**: PHPStan level 8
- **CI/CD**: GitHub Actions

---

## Implementation Plan

### Phase 1: Laravel Scaffold + Authentication (OCD-1, OCD-2)
**Goal:** Full authentication system with OAuth, magic links, 2FA, sessions.

**Epics:**
- OCD-1: Laravel Project Setup
- OCD-2: Authentication System

**Stories:**
- Scaffold Laravel 12 + Inertia.js + React + TypeScript
- Install & configure Jetstream, Fortify, Sanctum
- Install Spatie packages + Tailwind CSS 4
- Base layouts, routing, testing setup
- Login, Register, Password Reset (Fortify)
- OTP/2FA & Magic Login
- Profile Management (Avatar, Devices, API Keys, Password)
- User Settings & Notification Preferences
- Teams & Roles (Jetstream Teams)

**DOD:**
- User can register via email/password or OAuth
- User can login via password, magic link, or OAuth
- User can enable 2FA with QR code
- User can manage active sessions
- User can create and manage API tokens
- User can create teams and invite members
- User can switch between teams

### Phase 2: User Dashboard & Sync (OCD-5, OCD-8)
**Goal:** Employee dashboard with synced tasks, timers, version control, AI agent status.

**Epics:**
- OCD-5: Employee Dashboard
- OCD-8: Real-time & API Layer

**Stories:**
- Progress Widgets & Dashboard Overview
- Synced Tasks (Project/Epic/Story/Task Hierarchy)
- Timer, Break & Pomodoro Reports
- Version Control & AI Agent Control
- Notifications & Sprint Tracking
- Laravel Reverb WebSocket & Event-Driven Architecture
- Laravel Echo Frontend & Real-time UI Integration
- Sanctum API Layer (RESTful, Versioned, Rate Limited)

**DOD:**
- Dashboard displays user's projects, tasks, time tracking
- Tasks sync from Desktop to cloud in real-time
- WebSocket connection established on dashboard load
- API endpoints for Desktop/Mobile clients working
- Real-time updates appear in dashboard without refresh

### Phase 3: Public Pages & Documentation (OCD-3, OCD-4)
**Goal:** Landing page, download page, support, blog, marketplace, docs.

**Epics:**
- OCD-3: Public Pages
- OCD-4: Documentation System

**Stories:**
- Landing Page & Download Page
- Support Page & Email Subscription
- Blog System
- Web Marketplace
- Documentation Reader & Sidebar Navigation
- Documentation Search

**DOD:**
- Public landing page live with CTA to download
- Download page detects OS and shows correct installer
- Blog posts manageable from admin panel
- Marketplace displays extensions with install links
- Documentation renders markdown files with search

### Phase 4: Team Dashboard & Admin (OCD-6, OCD-7)
**Goal:** Team owner dashboard, admin dashboard, analytics.

**Epics:**
- OCD-6: Team Owner Dashboard
- OCD-7: Admin Dashboard

**Stories:**
- Team Activity Widgets & Community Page
- Team Management (Invite, Roles, Assignments)
- Entity CRUD & User Management
- Marketplace Control & Feature Flags
- Push Updates, Marketing Notifications & Analytics

**DOD:**
- Team owners can view team activity and member stats
- Team owners can invite/remove members and assign roles
- Admins can manage all users, teams, content
- Admins can approve/reject marketplace submissions
- Admins can view analytics (DAU/WAU/MAU)

### Phase 5: Subscriptions & Billing (OCD-96, OCD-99)
**Goal:** Subscription plans, billing integration, payment processing.

**Epics:**
- OCD-96: Subscription & Billing System
- OCD-99: Payment Integration

**Stories:**
- Database Schema & Models for Subscriptions
- Laravel Pennant Feature Flags
- Admin Subscription Management
- Team Subscription Logic
- GitHub Sponsors webhook integration
- Bank transfer payment flow
- Manual payment processing for admins

**DOD:**
- Users can subscribe to Pro or Enterprise plans
- Billing cycles managed automatically
- GitHub Sponsors donations synced to subscriptions
- Manual payments tracked by admins

### Phase 6: Community & Social (OCD-97)
**Goal:** User profiles, social features, activity feed.

**Epic:**
- OCD-97: User Profile & Community System

**Stories:**
- Database schema for profiles and community
- Profile models and relationships
- Social features: posts, comments, likes, shares
- Follow system implementation
- Activity feed system
- Profile controller and routes
- Admin profile management dashboard

**DOD:**
- Users can view public profiles
- Users can follow other users
- Activity feed shows followed users' activity
- Posts, comments, likes/shares functional

### Phase 7: SEO & Analytics (OCD-98)
**Goal:** SEO optimization, structured data, analytics.

**Epic:**
- OCD-98: SEO & Analytics System

**Stories:**
- SSR setup with Inertia.js
- SeoService with meta tags and structured data
- Sitemap generation and scheduling
- Firebase Analytics integration for web

**DOD:**
- All public pages have proper meta tags
- Sitemap generated and updated daily
- Analytics tracking page views and events
- Social media previews working (OpenGraph, Twitter Cards)

---

## Definition of Done (DOD)

### Authentication System
- [ ] Users can register with email/password
- [ ] Users can login with email/password
- [ ] Users can login with Google OAuth
- [ ] Users can login with GitHub OAuth
- [ ] Users can login with Microsoft OAuth
- [ ] Users can request magic link and login via email
- [ ] Users can enable 2FA with QR code
- [ ] Users can use recovery codes for 2FA
- [ ] Users can view all active sessions
- [ ] Users can revoke individual sessions
- [ ] Users can create personal access tokens
- [ ] Users can revoke personal access tokens

### User Management
- [ ] Users can update profile information
- [ ] Users can upload avatar
- [ ] Users can change password
- [ ] Users can delete account
- [ ] Users can configure notification preferences
- [ ] Users can view usage analytics dashboard
- [ ] Activity heatmap displays user's active days
- [ ] Time tracking breakdown shows hours per project

### Team Management
- [ ] Users can create teams
- [ ] Team owners can invite members via email
- [ ] Invited users receive email and can accept
- [ ] Team owners can remove members
- [ ] Team owners can change member roles
- [ ] Team settings configurable (name, slug, avatar, 2FA requirement)
- [ ] Users can switch current team
- [ ] Personal team created automatically on registration

### Data Sync
- [ ] Settings sync in real-time across devices
- [ ] Extensions list syncs across devices
- [ ] Workspaces sync with open files list
- [ ] Conflict resolution works (last write wins with notification)
- [ ] WebSocket connection established on page load
- [ ] Sync events broadcast to all connected devices
- [ ] Desktop can sync settings via API
- [ ] Desktop can sync via WebSocket

### API
- [ ] RESTful API functional with Sanctum authentication
- [ ] API rate limiting enforced (60 requests/minute)
- [ ] API documentation generated (Scramble or similar)
- [ ] WebSocket authentication working
- [ ] Private channels authenticated correctly
- [ ] Presence channels show online users

### Dashboard
- [ ] Dashboard displays projects and tasks
- [ ] Dashboard displays time tracking stats
- [ ] Dashboard displays AI agent usage
- [ ] Real-time updates appear without refresh
- [ ] Charts and visualizations render correctly

### Public Pages
- [ ] Landing page live with responsive design
- [ ] Download page detects OS and shows correct installer
- [ ] Support page with FAQ and contact form
- [ ] Blog system with admin CRUD
- [ ] Marketplace displays extensions

### Documentation
- [ ] Documentation renders markdown files
- [ ] Sidebar navigation generated from file structure
- [ ] Search functionality working
- [ ] Code blocks syntax highlighted

### Subscriptions
- [ ] Subscription plans displayed (Free, Pro, Enterprise)
- [ ] Users can subscribe to plan
- [ ] Billing cycles managed automatically
- [ ] Invoices generated and emailed
- [ ] GitHub Sponsors integration syncing

### SEO & Analytics
- [ ] All public pages have meta tags
- [ ] Sitemap generated and updated
- [ ] Analytics tracking page views
- [ ] Social media previews working

---

## Performance Targets

| Metric | Target |
|--------|--------|
| Homepage load time | < 1s (LCP) |
| Dashboard load time | < 2s (LCP) |
| API response time (p95) | < 200ms |
| WebSocket latency (p95) | < 100ms |
| Database queries per request | < 20 |
| Cache hit rate | > 80% |
| Sync conflict rate | < 1% |

---

## Security Considerations

- All passwords hashed with bcrypt (cost factor 12)
- All API requests authenticated via Sanctum tokens
- CSRF protection enabled for web routes
- Rate limiting on auth endpoints (5 attempts per minute)
- 2FA required for team owners
- API tokens stored hashed in database
- WebSocket connections authenticated
- Private channels require authorization
- OAuth tokens encrypted at rest
- Session cookies: HttpOnly, Secure, SameSite=Strict

---

## Deployment Architecture

```
                     ┌──────────────────┐
                     │   Load Balancer   │
                     │   (nginx/HAProxy) │
                     └────────┬──────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
         ┌────▼─────┐   ┌────▼─────┐   ┌────▼─────┐
         │  Web 1   │   │  Web 2   │   │  Web 3   │
         │ (Laravel)│   │ (Laravel)│   │ (Laravel)│
         └────┬─────┘   └────┬─────┘   └────┬─────┘
              │               │               │
              └───────────────┼───────────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
         ┌────▼─────┐   ┌────▼─────┐   ┌────▼─────┐
         │PostgreSQL│   │  Redis   │   │ Reverb   │
         │  Primary │   │  Cluster │   │WebSocket │
         └────┬─────┘   └──────────┘   └──────────┘
              │
         ┌────▼─────┐
         │PostgreSQL│
         │ Replica  │
         └──────────┘
```

**Infrastructure:**
- **Web Servers**: 3+ Laravel instances (PHP-FPM + nginx)
- **Database**: PostgreSQL 17 (primary + read replicas)
- **Cache**: Redis cluster (3+ nodes)
- **WebSocket**: Laravel Reverb (dedicated instances)
- **Queue Workers**: Laravel Horizon (supervised)
- **Storage**: S3-compatible (AWS S3 or MinIO)
- **CDN**: Cloudflare

---

This PRD provides a comprehensive foundation for building the Orchestra Cloud Platform with authentication, team management, real-time sync, and API support for Desktop, Chrome, and Mobile clients.

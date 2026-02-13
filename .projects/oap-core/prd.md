# PRD 1: Core Architecture & Build System

**Parent:** orchestra-app (Master PRD)
**Depends on:** ODS-1 (Design System Tokens) for any UI components

---

## Goal

Set up the foundation that everything else builds on: migrate the build system to `src/`, build the extension runtime with DI container, establish the ServiceProvider pattern, create the manifest/contributes system, implement feature control system, and integrate full authentication.

## Critical Dependencies
1. **Design System (ODS-1)**: All UI components must use design tokens
2. **Auth System**: Required for cloud sync, admin panel, and mobile app integration
3. **Feature Control**: Required for enterprise deployment and admin-managed features

---

## Scope

### 1. Build System Migration

**Source:** Root `pnpm-workspace.yaml`, `electron-vite.config.ts`, `package.json` scripts

**What to do:**
- Update `pnpm-workspace.yaml` to include `src/packages/*` (not `packages/*`)
- Update `electron-vite.config.ts` to resolve from `src/` paths
- Update all scripts (`pnpm dev:desktop`, `pnpm build:desktop`, `pnpm typecheck`, etc.) to work from `src/`
- `packages/` removed from workspace but stays on disk as reference
- Verify `pnpm dev:desktop` starts successfully from new structure
- Verify `pnpm build:desktop` produces a working build

### 2. Extension Runtime (`src/app/Providers/`)

**Source:** `packages/desktop/src/main/platform/serviceRegistry.ts`, `extensionHost.ts`, `lifecycleService.ts`, `activationService.ts`

**What to do:**
- Migrate and refactor into `src/app/Providers/`
- **ServiceRegistry:** DI container with `register()`, `resolve()`, `dispose()`, `createServiceId<T>()`
- **ExtensionHost:** Discovers packages from `src/packages/*/package.json`, loads and activates them
- **LifecycleService:** App startup → extension activation → extension deactivation → shutdown
- **ActivationService:** Respects `activationEvents` from manifest (onStartup, onCommand, onView, etc.)
- Dependency resolution: reads `extensionDependencies` and activates in correct order
- Error isolation: one extension failure does not crash others
- Enable/disable support per extension

### 3. ServiceProvider Pattern (`src/packages/example/`)

**Source:** `src/packages/example/src/ExampleServiceProvider.ts` (currently empty)

**What to do:**
- Define `ServiceProvider` base class/interface:
  ```typescript
  abstract class ServiceProvider {
    register(): void;    // Register services into DI container
    boot(): void;        // Boot after all providers registered
    shutdown(): void;    // Cleanup on deactivation
  }
  ```
- Each package exports a `{Name}ServiceProvider` extending this base
- ExtensionHost calls `register()` → `boot()` → (on shutdown) `shutdown()` for each
- ServiceProvider has access to all core service APIs via DI

### 4. Extension Manifest & Contributes System

**Source:** `packages/extensions/*/package.json` (existing manifests)

**What to do:**
- Define TypeScript types for full manifest schema
- Parse `contributes` section from each `package.json`:
  ```json
  {
    "contributes": {
      "sidebar": [],
      "tabs": [],
      "trayMenu": [],
      "settings": [],
      "commands": [],
      "mcpTools": [],
      "searchProviders": [],
      "widgets": [],
      "themes": [],
      "integrations": [],
      "browserScripts": []
    },
    "activationEvents": [],
    "extensionDependencies": [],
    "marketplace": { "category": "", "paid": false }
  }
  ```
- **ContributionRegistry:** Collects all contributions by type across all extensions
- Core services consume contributions from this registry
- JSON Schema file for IDE autocompletion when editing `package.json`
- Validation errors logged with extension name and field path

### 5. Event Bus & Disposable Pattern

**Source:** Event patterns scattered across `packages/desktop/`

**What to do:**
- `Event<T>` type with typed subscribe
- `EventEmitter` implementation
- `Disposable` interface and `DisposableStore` for cleanup
- `toDisposable()`, `combineDisposables()` utilities
- Every `register()` call in every service returns a `Disposable`

### 6. Scaffold Remaining Directories

Ensure all `src/app/` PascalCase folders exist with `index.ts` stubs:
- AI/, Actions/, Chrome/ (Header/, Sidebar/, Status/, Tabs/), Components/, Http/, IPC/, Jobs/, LSP/, MCP/, Marketplace/, Models/, Notifications/, Panels/, Providers/, Search/, Services/, Settings/, Socket/, Tray/, VS/, Widgets/
- Add: Themes/, AccountCenter/, BrowserInjection/

Ensure `src/packages/example/` has the complete reference structure:
```
src/packages/example/
├── src/
│   ├── ExampleServiceProvider.ts
│   ├── Http/
│   ├── Models/
│   ├── Services/
│   ├── Jobs/
│   ├── Notifications/
│   ├── Panels/
│   └── Widgets/
├── database/
├── routes/
│   ├── web.ts
│   └── socket.ts
├── resources/
│   ├── chrome/
│   ├── desktop/
│   └── web/
├── docs/
│   ├── README.md
│   ├── api/
│   │   └── README.md
│   ├── guides/
│   │   └── README.md
│   └── changelog/
│       └── README.md
├── tests/
├── package.json
├── tsconfig.json
└── vitest.config.ts
```

### 7. Root Documentation Scaffold

Create `docs/` at project root:
```
docs/
├── README.md
├── getting-started/
│   └── README.md
├── core-services/
│   └── README.md
├── extension-development/
│   └── README.md
├── cloud-platform/
│   └── README.md
├── mobile-app/
│   └── README.md
└── contributing/
    └── README.md
```

### 8. Feature Control System

**Purpose:** Enable/disable IDE features dynamically via admin panel, control package visibility, and manage updates.

**Source:** New system, reference patterns from VS Code feature flags

**What to do:**

#### A. Feature Flag Service (`src/app/Services/FeatureFlagService.ts`)
```typescript
interface FeatureFlag {
  id: string;
  name: string;
  description: string;
  enabled: boolean;
  scope: 'global' | 'user' | 'workspace';
  requiresRestart: boolean;
  adminOnly: boolean;
}

class FeatureFlagService {
  // Check if feature is enabled
  isEnabled(flagId: string): boolean;

  // Get all flags
  getFlags(): FeatureFlag[];

  // Enable/disable feature (admin only)
  setEnabled(flagId: string, enabled: boolean): Promise<void>;

  // Sync with server
  syncWithServer(): Promise<void>;

  // Subscribe to changes
  onDidChangeFlag(callback: (flag: FeatureFlag) => void): Disposable;
}
```

**Features controlled**:
- UI panels (Sidebar, Terminal, Database, etc.)
- Extensions (enable/disable packages)
- IDE capabilities (AI, LSP, MCP, etc.)
- Experimental features

#### B. Package Control Service (`src/app/Services/PackageControlService.ts`)
```typescript
interface PackageControl {
  id: string;           // Package ID
  visible: boolean;     // Show in marketplace
  published: boolean;   // Available for installation
  version: string;      // Current version
  minVersion: string;   // Minimum IDE version required
  deprecated: boolean;  // Mark as deprecated
}

class PackageControlService {
  // Get package control settings
  getControl(packageId: string): PackageControl;

  // Publish/unpublish package (admin only)
  setPublished(packageId: string, published: boolean): Promise<void>;

  // Show/hide in marketplace (admin only)
  setVisible(packageId: string, visible: boolean): Promise<void>;

  // Deprecate package (admin only)
  deprecate(packageId: string, reason: string): Promise<void>;

  // Sync with admin panel
  syncWithAdminPanel(): Promise<void>;
}
```

#### C. Update Manager Service (`src/app/Services/UpdateManagerService.ts`)
```typescript
interface UpdateInfo {
  version: string;
  releaseDate: Date;
  releaseNotes: string;
  mandatory: boolean;
  rolloutPercentage: number;  // Staged rollout
  channel: 'stable' | 'beta' | 'alpha';
}

class UpdateManagerService {
  // Check for updates
  checkForUpdates(): Promise<UpdateInfo | null>;

  // Download update in background
  downloadUpdate(version: string): Promise<void>;

  // Apply update (restart required)
  applyUpdate(): Promise<void>;

  // Get current version
  getCurrentVersion(): string;

  // Get update channel
  getChannel(): 'stable' | 'beta' | 'alpha';

  // Set update channel (user preference)
  setChannel(channel: 'stable' | 'beta' | 'alpha'): void;

  // Admin: Push update to users
  pushUpdate(version: string, rollout: number): Promise<void>;
}
```

**Update sources**:
- GitHub Releases (desktop app)
- Chrome Web Store (extension)
- App Store / Play Store (mobile)
- Admin-controlled update server

### 9. Authentication System

**Purpose:** Full auth system connecting IDE → Cloud Server → Mobile App. Enables cloud sync, admin features, and cross-device continuity.

**Source:** Patterns from GitHub Desktop, VS Code LiveShare, JetBrains Account

**What to do:**

#### A. Auth Service (`src/app/Services/AuthService.ts`)
```typescript
interface User {
  id: string;
  email: string;
  name: string;
  avatar?: string;
  role: 'user' | 'admin' | 'enterprise_admin';
  subscription: 'free' | 'pro' | 'enterprise';
  team?: {
    id: string;
    name: string;
    role: 'member' | 'admin' | 'owner';
  };
}

interface AuthToken {
  accessToken: string;
  refreshToken: string;
  expiresAt: Date;
}

class AuthService {
  // Sign in (opens browser for OAuth)
  signIn(): Promise<User>;

  // Sign out
  signOut(): Promise<void>;

  // Get current user
  getCurrentUser(): User | null;

  // Check if signed in
  isSignedIn(): boolean;

  // Refresh tokens
  refreshTokens(): Promise<AuthToken>;

  // Subscribe to auth changes
  onDidChangeAuthStatus(callback: (user: User | null) => void): Disposable;
}
```

**Auth Flow**:
1. User clicks "Sign In" in IDE
2. Opens browser to `https://orchestra.ai/auth/cli`
3. User signs in with OAuth (GitHub, Google, Email)
4. Browser redirects to `orchestra://auth/callback?code=...`
5. IDE exchanges code for tokens
6. Tokens stored in secure storage (Keychain/Credential Manager)
7. IDE connects to server via WebSocket with token
8. Server validates token and establishes session

#### B. Cloud Sync Service (`src/app/Services/CloudSyncService.ts`)
```typescript
interface SyncData {
  settings: Record<string, any>;       // IDE settings
  extensions: string[];                // Installed extensions
  themes: { active: string };          // Active theme
  workspaces: Workspace[];             // Recent workspaces
  keybindings: Keybinding[];           // Custom keybindings
}

class CloudSyncService {
  // Push local state to cloud
  push(): Promise<void>;

  // Pull state from cloud
  pull(): Promise<SyncData>;

  // Enable/disable sync
  setEnabled(enabled: boolean): void;

  // Get sync status
  getSyncStatus(): 'syncing' | 'synced' | 'conflict' | 'error';

  // Resolve conflicts (user chooses local or remote)
  resolveConflict(choice: 'local' | 'remote'): Promise<void>;

  // Real-time sync via WebSocket
  enableRealtimeSync(): void;
}
```

**Synced across**:
- Desktop app (Mac/Windows/Linux)
- Chrome extension
- Mobile app (iOS/Android)

#### C. Session Service (`src/app/Services/SessionService.ts`)
```typescript
interface Session {
  id: string;
  userId: string;
  deviceId: string;
  deviceName: string;
  platform: 'desktop' | 'chrome' | 'mobile';
  ipAddress: string;
  lastActive: Date;
  current: boolean;
}

class SessionService {
  // Get all active sessions
  getSessions(): Promise<Session[]>;

  // Revoke session (sign out device)
  revokeSession(sessionId: string): Promise<void>;

  // Revoke all other sessions
  revokeAllOtherSessions(): Promise<void>;

  // Get current session
  getCurrentSession(): Session;
}
```

**Admin features** (via admin panel):
- View all user sessions
- Force sign-out users
- Monitor active devices
- Audit auth logs

#### D. WebSocket Connection Service (`src/app/Services/WebSocketService.ts`)
```typescript
class WebSocketService {
  // Connect to server
  connect(token: string): Promise<void>;

  // Disconnect
  disconnect(): void;

  // Send message
  send(channel: string, data: any): void;

  // Subscribe to channel
  subscribe(channel: string, callback: (data: any) => void): Disposable;

  // Connection status
  getStatus(): 'connecting' | 'connected' | 'disconnected' | 'error';

  // Auto-reconnect on network change
  enableAutoReconnect(): void;
}
```

**WebSocket channels**:
- `auth` — Auth status changes
- `sync` — Real-time settings sync
- `notifications` — Push notifications from admin
- `updates` — Update availability notifications
- `features` — Feature flag changes
- `packages` — Package publish/unpublish events



### 8. Account Integration System

**Purpose:** Centralized management of third-party service accounts (Cloudflare, GitHub, GitLab, Google, etc.) with .env-based client control.

**Services:**

#### AccountIntegrationService

Manages all third-party service accounts and credentials.

```typescript
// src/app/Services/AccountIntegrationService.ts

export interface ServiceAccount {
  id: string;
  service: string;              // 'cloudflare', 'github', 'google', etc.
  name: string;                 // User-friendly name
  credentials: Record<string, any>;
  metadata: Record<string, any>;
  createdAt: Date;
  updatedAt: Date;
  status: 'active' | 'inactive' | 'error';
  lastValidated?: Date;
}

export interface ServiceIntegration {
  id: string;
  name: string;
  icon: string;
  authType: 'oauth' | 'apikey' | 'token' | 'custom';
  requiredFields: IntegrationField[];
  oauthConfig?: OAuthConfig;
  validateConnection: (credentials: any) => Promise<boolean>;
}

export interface IntegrationField {
  key: string;
  label: string;
  type: 'text' | 'password' | 'url' | 'email';
  required: boolean;
  placeholder?: string;
  helpText?: string;
  envVar?: string;              // If specified, read from .env by default
}

export interface OAuthConfig {
  authUrl: string;
  tokenUrl: string;
  scopes: string[];
  clientIdEnvVar?: string;      // Read from .env: GITHUB_CLIENT_ID
  clientSecretEnvVar?: string;  // Read from .env: GITHUB_CLIENT_SECRET
}

/**
 * AccountIntegrationService — Manages third-party service accounts
 *
 * IMPORTANT: For client-controlled integrations (OAuth apps), credentials
 * MUST be stored in .env and NOT in database:
 *
 * - GITHUB_CLIENT_ID=xxx
 * - GITHUB_CLIENT_SECRET=xxx
 * - CLOUDFLARE_API_KEY=xxx
 * - etc.
 *
 * User accounts (tokens) are stored encrypted in database.
 */
export class AccountIntegrationService {
  private accounts = new Map<string, ServiceAccount>();
  private integrations = new Map<string, ServiceIntegration>();

  constructor(
    private storageService: StorageService,
    private encryptionService: EncryptionService,
    private envService: EnvironmentService
  ) {
    this.registerDefaultIntegrations();
    this.loadAccounts();
  }

  /**
   * Register available integrations
   */
  private registerDefaultIntegrations(): void {
    // Cloudflare Integration
    this.registerIntegration({
      id: 'cloudflare',
      name: 'Cloudflare',
      icon: 'cloudflare',
      authType: 'apikey',
      requiredFields: [
        {
          key: 'apiToken',
          label: 'API Token',
          type: 'password',
          required: true,
          placeholder: 'Enter your Cloudflare API token',
          helpText: 'Create at: https://dash.cloudflare.com/profile/api-tokens',
        },
        {
          key: 'accountId',
          label: 'Account ID',
          type: 'text',
          required: true,
          placeholder: 'Your Cloudflare Account ID',
        },
      ],
      validateConnection: async (credentials) => {
        const response = await fetch('https://api.cloudflare.com/client/v4/user/tokens/verify', {
          headers: { 'Authorization': `Bearer ${credentials.apiToken}` },
        });
        return response.ok;
      },
    });

    // GitHub Integration (OAuth)
    this.registerIntegration({
      id: 'github',
      name: 'GitHub',
      icon: 'github',
      authType: 'oauth',
      requiredFields: [],
      oauthConfig: {
        authUrl: 'https://github.com/login/oauth/authorize',
        tokenUrl: 'https://github.com/login/oauth/access_token',
        scopes: ['repo', 'user'],
        clientIdEnvVar: 'GITHUB_CLIENT_ID',       // Must be in .env
        clientSecretEnvVar: 'GITHUB_CLIENT_SECRET', // Must be in .env
      },
      validateConnection: async (credentials) => {
        const response = await fetch('https://api.github.com/user', {
          headers: { 'Authorization': `token ${credentials.accessToken}` },
        });
        return response.ok;
      },
    });

    // Google Integration (OAuth)
    this.registerIntegration({
      id: 'google',
      name: 'Google',
      icon: 'google',
      authType: 'oauth',
      requiredFields: [],
      oauthConfig: {
        authUrl: 'https://accounts.google.com/o/oauth2/v2/auth',
        tokenUrl: 'https://oauth2.googleapis.com/token',
        scopes: ['email', 'profile'],
        clientIdEnvVar: 'GOOGLE_CLIENT_ID',
        clientSecretEnvVar: 'GOOGLE_CLIENT_SECRET',
      },
      validateConnection: async (credentials) => {
        const response = await fetch('https://www.googleapis.com/oauth2/v2/userinfo', {
          headers: { 'Authorization': `Bearer ${credentials.accessToken}` },
        });
        return response.ok;
      },
    });

    // Add more: GitLab, Bitbucket, AWS, Azure, etc.
  }

  /**
   * Register a new integration
   */
  registerIntegration(integration: ServiceIntegration): void {
    this.integrations.set(integration.id, integration);
  }

  /**
   * Get all available integrations
   */
  getIntegrations(): ServiceIntegration[] {
    return Array.from(this.integrations.values());
  }

  /**
   * Get integration by ID
   */
  getIntegration(serviceId: string): ServiceIntegration | undefined {
    return this.integrations.get(serviceId);
  }

  /**
   * Add a new account
   */
  async addAccount(serviceId: string, name: string, credentials: any): Promise<ServiceAccount> {
    const integration = this.getIntegration(serviceId);
    if (!integration) {
      throw new Error(`Integration not found: ${serviceId}`);
    }

    // Validate connection
    const isValid = await integration.validateConnection(credentials);
    if (!isValid) {
      throw new Error(`Failed to validate ${integration.name} connection`);
    }

    // Encrypt credentials
    const encrypted = await this.encryptionService.encrypt(JSON.stringify(credentials));

    const account: ServiceAccount = {
      id: this.generateId(),
      service: serviceId,
      name,
      credentials: encrypted,
      metadata: {},
      createdAt: new Date(),
      updatedAt: new Date(),
      status: 'active',
      lastValidated: new Date(),
    };

    this.accounts.set(account.id, account);
    await this.saveAccounts();

    return account;
  }

  /**
   * Get account by ID
   */
  getAccount(accountId: string): ServiceAccount | undefined {
    return this.accounts.get(accountId);
  }

  /**
   * List accounts for a service
   */
  listAccounts(serviceId?: string): ServiceAccount[] {
    const accounts = Array.from(this.accounts.values());
    return serviceId ? accounts.filter(a => a.service === serviceId) : accounts;
  }

  /**
   * Get decrypted credentials
   */
  async getCredentials(accountId: string): Promise<any> {
    const account = this.getAccount(accountId);
    if (!account) {
      throw new Error(`Account not found: ${accountId}`);
    }

    const decrypted = await this.encryptionService.decrypt(account.credentials);
    return JSON.parse(decrypted);
  }

  /**
   * Update account credentials
   */
  async updateCredentials(accountId: string, credentials: any): Promise<void> {
    const account = this.getAccount(accountId);
    if (!account) {
      throw new Error(`Account not found: ${accountId}`);
    }

    const integration = this.getIntegration(account.service);
    if (!integration) {
      throw new Error(`Integration not found: ${account.service}`);
    }

    // Validate new credentials
    const isValid = await integration.validateConnection(credentials);
    if (!isValid) {
      throw new Error(`Failed to validate new credentials`);
    }

    // Encrypt and save
    const encrypted = await this.encryptionService.encrypt(JSON.stringify(credentials));
    account.credentials = encrypted;
    account.updatedAt = new Date();
    account.lastValidated = new Date();
    account.status = 'active';

    await this.saveAccounts();
  }

  /**
   * Remove account
   */
  async removeAccount(accountId: string): Promise<void> {
    this.accounts.delete(accountId);
    await this.saveAccounts();
  }

  /**
   * Test account connection
   */
  async testConnection(accountId: string): Promise<boolean> {
    const account = this.getAccount(accountId);
    if (!account) return false;

    const integration = this.getIntegration(account.service);
    if (!integration) return false;

    const credentials = await this.getCredentials(accountId);
    const isValid = await integration.validateConnection(credentials);

    account.lastValidated = new Date();
    account.status = isValid ? 'active' : 'error';
    await this.saveAccounts();

    return isValid;
  }

  /**
   * Get OAuth client credentials from .env
   */
  getOAuthClientCredentials(serviceId: string): { clientId: string; clientSecret: string } | null {
    const integration = this.getIntegration(serviceId);
    if (!integration?.oauthConfig) return null;

    const clientId = this.envService.get(integration.oauthConfig.clientIdEnvVar);
    const clientSecret = this.envService.get(integration.oauthConfig.clientSecretEnvVar);

    if (!clientId || !clientSecret) {
      throw new Error(
        `Missing OAuth credentials in .env: ${integration.oauthConfig.clientIdEnvVar}, ${integration.oauthConfig.clientSecretEnvVar}`
      );
    }

    return { clientId, clientSecret };
  }

  private generateId(): string {
    return `acc_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  private async loadAccounts(): Promise<void> {
    const stored = await this.storageService.get<ServiceAccount[]>('accounts');
    if (stored) {
      stored.forEach(acc => this.accounts.set(acc.id, acc));
    }
  }

  private async saveAccounts(): Promise<void> {
    const accounts = Array.from(this.accounts.values());
    await this.storageService.set('accounts', accounts);
  }
}
```

#### EnvironmentService

Manages .env file reading and validation.

```typescript
// src/app/Services/EnvironmentService.ts

import { readFileSync, existsSync } from 'fs';
import { join } from 'path';

/**
 * EnvironmentService — Reads and validates .env configuration
 *
 * Supports:
 * - .env file parsing
 * - Required variable validation
 * - Type conversion (string, number, boolean)
 * - Default values
 * - Environment-specific files (.env.local, .env.production)
 */
export class EnvironmentService {
  private env: Record<string, string> = {};

  constructor(private appPath: string) {
    this.loadEnv();
  }

  /**
   * Load .env files
   */
  private loadEnv(): void {
    const envFiles = [
      '.env',
      '.env.local',
      process.env.NODE_ENV === 'production' ? '.env.production' : '.env.development',
    ];

    for (const file of envFiles) {
      const path = join(this.appPath, file);
      if (existsSync(path)) {
        this.parseEnvFile(path);
      }
    }

    // Merge with process.env (process.env takes precedence)
    this.env = { ...this.env, ...process.env };
  }

  /**
   * Parse .env file
   */
  private parseEnvFile(path: string): void {
    const content = readFileSync(path, 'utf-8');
    const lines = content.split('\n');

    for (const line of lines) {
      const trimmed = line.trim();

      // Skip comments and empty lines
      if (!trimmed || trimmed.startsWith('#')) continue;

      // Parse KEY=VALUE
      const match = trimmed.match(/^([A-Z_][A-Z0-9_]*)=(.*)$/);
      if (match) {
        const [, key, value] = match;

        // Remove quotes if present
        let cleanValue = value.trim();
        if ((cleanValue.startsWith('"') && cleanValue.endsWith('"')) ||
            (cleanValue.startsWith("'") && cleanValue.endsWith("'"))) {
          cleanValue = cleanValue.slice(1, -1);
        }

        this.env[key] = cleanValue;
      }
    }
  }

  /**
   * Get environment variable
   */
  get(key: string, defaultValue?: string): string | undefined {
    return this.env[key] ?? defaultValue;
  }

  /**
   * Get as number
   */
  getNumber(key: string, defaultValue?: number): number | undefined {
    const value = this.get(key);
    if (!value) return defaultValue;
    const num = parseInt(value, 10);
    return isNaN(num) ? defaultValue : num;
  }

  /**
   * Get as boolean
   */
  getBoolean(key: string, defaultValue?: boolean): boolean | undefined {
    const value = this.get(key)?.toLowerCase();
    if (!value) return defaultValue;
    return value === 'true' || value === '1' || value === 'yes';
  }

  /**
   * Require environment variable (throws if missing)
   */
  require(key: string): string {
    const value = this.get(key);
    if (!value) {
      throw new Error(`Required environment variable missing: ${key}`);
    }
    return value;
  }

  /**
   * Check if variable exists
   */
  has(key: string): boolean {
    return key in this.env;
  }

  /**
   * Get all environment variables
   */
  getAll(): Record<string, string> {
    return { ...this.env };
  }

  /**
   * Validate required variables
   */
  validateRequired(keys: string[]): void {
    const missing = keys.filter(key => !this.has(key));
    if (missing.length > 0) {
      throw new Error(`Missing required environment variables: ${missing.join(', ')}`);
    }
  }
}
```

### 9. Firebase Integration System

**Purpose:** Integrate Firebase services (Analytics, Crashlytics, Performance) across all platforms (Electron, Web, Chrome, Mobile).

#### FirebaseService

```typescript
// src/app/Services/FirebaseService.ts

import { initializeApp, FirebaseApp, FirebaseOptions } from 'firebase/app';
import { getAnalytics, Analytics, logEvent, setUserProperties } from 'firebase/analytics';
import { getPerformance, Performance, trace } from 'firebase/performance';

/**
 * FirebaseService — Unified Firebase integration for all platforms
 *
 * Configuration from .env:
 * - FIREBASE_API_KEY
 * - FIREBASE_AUTH_DOMAIN
 * - FIREBASE_PROJECT_ID
 * - FIREBASE_STORAGE_BUCKET
 * - FIREBASE_MESSAGING_SENDER_ID
 * - FIREBASE_APP_ID
 * - FIREBASE_MEASUREMENT_ID
 *
 * Supports:
 * - Analytics (web, mobile, electron)
 * - Performance monitoring
 * - Crash reporting
 * - Remote config (future)
 */
export class FirebaseService {
  private app: FirebaseApp;
  private analytics?: Analytics;
  private performance?: Performance;
  private enabled: boolean;

  constructor(private envService: EnvironmentService) {
    this.enabled = envService.getBoolean('FIREBASE_ENABLED', true);

    if (this.enabled) {
      this.initializeFirebase();
    }
  }

  /**
   * Initialize Firebase
   */
  private initializeFirebase(): void {
    const config: FirebaseOptions = {
      apiKey: this.envService.require('FIREBASE_API_KEY'),
      authDomain: this.envService.get('FIREBASE_AUTH_DOMAIN'),
      projectId: this.envService.require('FIREBASE_PROJECT_ID'),
      storageBucket: this.envService.get('FIREBASE_STORAGE_BUCKET'),
      messagingSenderId: this.envService.get('FIREBASE_MESSAGING_SENDER_ID'),
      appId: this.envService.require('FIREBASE_APP_ID'),
      measurementId: this.envService.get('FIREBASE_MEASUREMENT_ID'),
    };

    try {
      this.app = initializeApp(config);

      // Initialize Analytics (web and electron only)
      if (this.isBrowser()) {
        this.analytics = getAnalytics(this.app);
        this.performance = getPerformance(this.app);
      }

      console.log('[Firebase] Initialized successfully');
    } catch (error) {
      console.error('[Firebase] Initialization failed:', error);
      this.enabled = false;
    }
  }

  /**
   * Log analytics event
   */
  logEvent(eventName: string, params?: Record<string, any>): void {
    if (!this.enabled || !this.analytics) return;

    try {
      logEvent(this.analytics, eventName, params);
    } catch (error) {
      console.error('[Firebase] Log event failed:', error);
    }
  }

  /**
   * Set user properties
   */
  setUserProperties(properties: Record<string, any>): void {
    if (!this.enabled || !this.analytics) return;

    try {
      setUserProperties(this.analytics, properties);
    } catch (error) {
      console.error('[Firebase] Set user properties failed:', error);
    }
  }

  /**
   * Start performance trace
   */
  startTrace(traceName: string): PerformanceTrace {
    if (!this.enabled || !this.performance) {
      return new NoopPerformanceTrace();
    }

    try {
      const t = trace(this.performance, traceName);
      t.start();
      return new FirebasePerformanceTrace(t);
    } catch (error) {
      console.error('[Firebase] Start trace failed:', error);
      return new NoopPerformanceTrace();
    }
  }

  /**
   * Track screen view
   */
  trackScreen(screenName: string, screenClass?: string): void {
    this.logEvent('screen_view', {
      screen_name: screenName,
      screen_class: screenClass || screenName,
    });
  }

  /**
   * Track error
   */
  trackError(error: Error, context?: Record<string, any>): void {
    this.logEvent('error', {
      error_message: error.message,
      error_stack: error.stack,
      ...context,
    });
  }

  /**
   * Track feature usage
   */
  trackFeature(featureName: string, action: string, params?: Record<string, any>): void {
    this.logEvent(`feature_${action}`, {
      feature_name: featureName,
      ...params,
    });
  }

  /**
   * Track command execution
   */
  trackCommand(commandId: string, duration?: number): void {
    this.logEvent('command_executed', {
      command_id: commandId,
      duration_ms: duration,
    });
  }

  /**
   * Track extension activation
   */
  trackExtensionActivation(extensionId: string): void {
    this.logEvent('extension_activated', {
      extension_id: extensionId,
    });
  }

  private isBrowser(): boolean {
    return typeof window !== 'undefined';
  }
}

/**
 * Performance trace interface
 */
export interface PerformanceTrace {
  stop(): void;
  putMetric(name: string, value: number): void;
}

class FirebasePerformanceTrace implements PerformanceTrace {
  constructor(private trace: any) {}

  stop(): void {
    this.trace.stop();
  }

  putMetric(name: string, value: number): void {
    this.trace.putMetric(name, value);
  }
}

class NoopPerformanceTrace implements PerformanceTrace {
  stop(): void {}
  putMetric(_name: string, _value: number): void {}
}
```

**Platform-Specific Setup:**

**Electron:**
```typescript
// src/app/main.ts
import { FirebaseService } from './Services/FirebaseService';

const firebase = serviceRegistry.resolve<FirebaseService>('FirebaseService');

// Track app launch
firebase.logEvent('app_launch', {
  platform: 'electron',
  os: process.platform,
  version: app.getVersion(),
});
```

**Chrome Extension:**
```typescript
// packages/chrome-extension/src/background/index.ts
chrome.runtime.onInstalled.addListener(() => {
  firebase.logEvent('extension_installed', {
    version: chrome.runtime.getManifest().version,
  });
});
```

**Mobile (React Native):**
```typescript
// Use @react-native-firebase/analytics
import analytics from '@react-native-firebase/analytics';

analytics().logEvent('app_open', {
  platform: Platform.OS,
});
```

---

**Tasks Added:**
- Create AccountIntegrationService with OAuth and API key support
- Create EnvironmentService for .env management
- Create FirebaseService for cross-platform analytics
- Register default integrations (Cloudflare, GitHub, Google)
- Update all integration packages to use AccountIntegrationService
- Add Firebase to Electron main process
- Add Firebase to Chrome extension background
- Add Firebase to Web platform
- Add Firebase to Mobile app
- Create .env.example with all required variables
\n\n---



### 10. Script Runner & Installation Wizard System

**Purpose:** Allow packages to register and run OS-level installation scripts, making it easy to install language servers, database providers, and other dependencies through a unified wizard interface.

#### 10.1 ScriptRunnerService

Central service for executing OS scripts with progress tracking, error handling, and logging.

```typescript
// src/app/Services/ScriptRunnerService.ts

import { spawn, exec } from 'child_process';
import { EventEmitter } from './EventBus';
import { NotificationService } from './NotificationService';
import { LoggerService } from './LoggerService';

export interface ScriptDefinition {
  id: string;
  name: string;
  description: string;
  platform: 'darwin' | 'linux' | 'win32' | 'all';
  requiresAdmin: boolean;
  steps: ScriptStep[];
  rollback?: ScriptStep[];
}

export interface ScriptStep {
  name: string;
  command: string;
  args?: string[];
  cwd?: string;
  env?: Record<string, string>;
  timeout?: number; // milliseconds
  retries?: number;
  optional?: boolean;
  verify?: () => Promise<boolean>; // Verify step succeeded
}

export interface ScriptProgress {
  scriptId: string;
  currentStep: number;
  totalSteps: number;
  stepName: string;
  status: 'running' | 'success' | 'error' | 'cancelled';
  output?: string;
  error?: string;
}

/**
 * ScriptRunnerService - Execute OS-level installation scripts
 *
 * Features:
 * - Cross-platform script execution
 * - Progress tracking with events
 * - Error handling and rollback
 * - Admin privilege elevation (sudo/UAC)
 * - Output capturing and logging
 * - Script verification
 */
export class ScriptRunnerService {
  private runningScripts = new Map<string, AbortController>();
  private readonly onProgress = new EventEmitter<ScriptProgress>();
  readonly onProgressEvent = this.onProgress.event;

  constructor(
    private notificationService: NotificationService,
    private loggerService: LoggerService
  ) {}

  /**
   * Execute a script with progress tracking
   */
  async runScript(script: ScriptDefinition): Promise<boolean> {
    // Check platform compatibility
    if (script.platform !== 'all' && script.platform !== process.platform) {
      throw new Error(`Script ${script.id} is not compatible with ${process.platform}`);
    }

    const abortController = new AbortController();
    this.runningScripts.set(script.id, abortController);

    try {
      this.loggerService.info(`Starting script: ${script.name}`);
      this.notificationService.showInfo(`Installing ${script.name}...`);

      for (let i = 0; i < script.steps.length; i++) {
        const step = script.steps[i];

        // Check if cancelled
        if (abortController.signal.aborted) {
          throw new Error('Script cancelled by user');
        }

        // Emit progress
        this.onProgress.fire({
          scriptId: script.id,
          currentStep: i + 1,
          totalSteps: script.steps.length,
          stepName: step.name,
          status: 'running',
        });

        try {
          await this.executeStep(step, script.requiresAdmin);

          // Verify step if verification provided
          if (step.verify) {
            const verified = await step.verify();
            if (!verified && !step.optional) {
              throw new Error(`Step verification failed: ${step.name}`);
            }
          }

          this.onProgress.fire({
            scriptId: script.id,
            currentStep: i + 1,
            totalSteps: script.steps.length,
            stepName: step.name,
            status: 'success',
          });
        } catch (error) {
          if (step.optional) {
            this.loggerService.warn(`Optional step failed: ${step.name}`, error);
            continue;
          }

          // Run rollback if available
          if (script.rollback) {
            await this.runRollback(script);
          }

          this.onProgress.fire({
            scriptId: script.id,
            currentStep: i + 1,
            totalSteps: script.steps.length,
            stepName: step.name,
            status: 'error',
            error: error.message,
          });

          throw error;
        }
      }

      this.notificationService.showSuccess(`${script.name} installed successfully!`);
      return true;
    } catch (error) {
      this.loggerService.error(`Script failed: ${script.name}`, error);
      this.notificationService.showError(`Failed to install ${script.name}: ${error.message}`);
      return false;
    } finally {
      this.runningScripts.delete(script.id);
    }
  }

  /**
   * Execute a single script step
   */
  private async executeStep(step: ScriptStep, requiresAdmin: boolean): Promise<void> {
    const maxRetries = step.retries ?? 0;
    let attempt = 0;

    while (attempt <= maxRetries) {
      try {
        if (requiresAdmin && this.needsElevation(step.command)) {
          await this.executeWithElevation(step);
        } else {
          await this.executeNormal(step);
        }
        return; // Success
      } catch (error) {
        attempt++;
        if (attempt > maxRetries) {
          throw error;
        }
        this.loggerService.warn(`Step failed, retrying (${attempt}/${maxRetries})...`);
        await this.delay(1000 * attempt); // Exponential backoff
      }
    }
  }

  /**
   * Execute command normally
   */
  private executeNormal(step: ScriptStep): Promise<void> {
    return new Promise((resolve, reject) => {
      const proc = spawn(step.command, step.args ?? [], {
        cwd: step.cwd,
        env: { ...process.env, ...step.env },
        shell: true,
      });

      let output = '';
      let errorOutput = '';

      proc.stdout.on('data', (data) => {
        output += data.toString();
        this.loggerService.debug(data.toString());
      });

      proc.stderr.on('data', (data) => {
        errorOutput += data.toString();
        this.loggerService.debug(data.toString());
      });

      proc.on('close', (code) => {
        if (code === 0) {
          resolve();
        } else {
          reject(new Error(`Command failed with code ${code}: ${errorOutput}`));
        }
      });

      proc.on('error', (error) => {
        reject(error);
      });

      // Timeout
      if (step.timeout) {
        setTimeout(() => {
          proc.kill();
          reject(new Error(`Step timeout after ${step.timeout}ms`));
        }, step.timeout);
      }
    });
  }

  /**
   * Execute command with admin privileges
   */
  private async executeWithElevation(step: ScriptStep): Promise<void> {
    const platform = process.platform;

    if (platform === 'darwin' || platform === 'linux') {
      // Use sudo
      const sudoCommand = `sudo ${step.command} ${step.args?.join(' ') ?? ''}`;
      return this.executeNormal({ ...step, command: sudoCommand, args: [] });
    } else if (platform === 'win32') {
      // Use runas or UAC prompt
      // For Windows, we need to use a native module or elevate.exe
      throw new Error('Admin elevation on Windows requires native module');
    }

    throw new Error(`Unsupported platform for elevation: ${platform}`);
  }

  /**
   * Check if command needs elevation
   */
  private needsElevation(command: string): boolean {
    const elevatedCommands = ['apt', 'apt-get', 'yum', 'brew', 'pacman', 'systemctl'];
    return elevatedCommands.some(cmd => command.startsWith(cmd));
  }

  /**
   * Run rollback steps
   */
  private async runRollback(script: ScriptDefinition): Promise<void> {
    if (!script.rollback) return;

    this.loggerService.info(`Running rollback for ${script.name}...`);

    for (const step of script.rollback) {
      try {
        await this.executeStep(step, script.requiresAdmin);
      } catch (error) {
        this.loggerService.error(`Rollback step failed: ${step.name}`, error);
      }
    }
  }

  /**
   * Cancel running script
   */
  cancelScript(scriptId: string): void {
    const controller = this.runningScripts.get(scriptId);
    if (controller) {
      controller.abort();
      this.runningScripts.delete(scriptId);
    }
  }

  /**
   * Check if script is running
   */
  isScriptRunning(scriptId: string): boolean {
    return this.runningScripts.has(scriptId);
  }

  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
```

#### 10.2 InstallationWizardService

UI service for guiding users through installations with a step-by-step wizard.

```typescript
// src/app/Services/InstallationWizardService.ts

import { ScriptDefinition, ScriptRunnerService } from './ScriptRunnerService';
import { EventEmitter } from './EventBus';

export interface InstallationWizard {
  id: string;
  name: string;
  description: string;
  icon?: string;
  category: 'language-server' | 'database' | 'development-tool' | 'other';
  preChecks?: PreCheck[];
  steps: WizardStep[];
  scripts: ScriptDefinition[];
}

export interface PreCheck {
  name: string;
  check: () => Promise<boolean>;
  failureMessage: string;
  required: boolean;
}

export interface WizardStep {
  name: string;
  description: string;
  component?: string; // UI component to render
  validate?: () => Promise<boolean>;
  onNext?: () => Promise<void>;
  onBack?: () => Promise<void>;
}

/**
 * InstallationWizardService - Manage installation wizards
 *
 * Packages can register wizards that guide users through:
 * - Pre-installation checks
 * - Configuration options
 * - Script execution with progress
 * - Post-installation verification
 */
export class InstallationWizardService {
  private wizards = new Map<string, InstallationWizard>();
  private readonly onWizardRegistered = new EventEmitter<InstallationWizard>();
  readonly onWizardRegisteredEvent = this.onWizardRegistered.event;

  constructor(private scriptRunner: ScriptRunnerService) {}

  /**
   * Register an installation wizard
   */
  registerWizard(wizard: InstallationWizard): void {
    this.wizards.set(wizard.id, wizard);
    this.onWizardRegistered.fire(wizard);
  }

  /**
   * Get all wizards
   */
  getWizards(): InstallationWizard[] {
    return Array.from(this.wizards.values());
  }

  /**
   * Get wizards by category
   */
  getWizardsByCategory(category: string): InstallationWizard[] {
    return this.getWizards().filter(w => w.category === category);
  }

  /**
   * Get wizard by ID
   */
  getWizard(wizardId: string): InstallationWizard | undefined {
    return this.wizards.get(wizardId);
  }

  /**
   * Run pre-checks for a wizard
   */
  async runPreChecks(wizardId: string): Promise<{ passed: boolean; failures: string[] }> {
    const wizard = this.getWizard(wizardId);
    if (!wizard || !wizard.preChecks) {
      return { passed: true, failures: [] };
    }

    const failures: string[] = [];

    for (const check of wizard.preChecks) {
      const result = await check.check();
      if (!result) {
        failures.push(check.failureMessage);
        if (check.required) {
          return { passed: false, failures };
        }
      }
    }

    return { passed: true, failures };
  }

  /**
   * Execute wizard installation
   */
  async executeWizard(wizardId: string): Promise<boolean> {
    const wizard = this.getWizard(wizardId);
    if (!wizard) {
      throw new Error(`Wizard not found: ${wizardId}`);
    }

    // Run all scripts in the wizard
    for (const script of wizard.scripts) {
      const success = await this.scriptRunner.runScript(script);
      if (!success) {
        return false;
      }
    }

    return true;
  }

  /**
   * Unregister wizard
   */
  unregisterWizard(wizardId: string): void {
    this.wizards.delete(wizardId);
  }
}
```

#### 10.3 Package Contribution System

Packages register their installation wizards via `package.json` contributes:

```json
{
  "name": "lsp",
  "contributes": {
    "installationWizards": [
      {
        "id": "install-typescript-ls",
        "name": "TypeScript Language Server",
        "description": "Install TypeScript language server for code intelligence",
        "category": "language-server",
        "handler": "./src/wizards/TypeScriptLSWizard"
      },
      {
        "id": "install-php-intelephense",
        "name": "PHP Intelephense",
        "description": "Install Intelephense for PHP code intelligence",
        "category": "language-server",
        "handler": "./src/wizards/PhpIntelephenseWizard"
      }
    ]
  }
}
```

#### 10.4 Example: TypeScript Language Server Wizard

```typescript
// packages/lsp/src/wizards/TypeScriptLSWizard.ts

import { InstallationWizard, ScriptDefinition } from '@/app/Services';

export const TypeScriptLSWizard: InstallationWizard = {
  id: 'install-typescript-ls',
  name: 'TypeScript Language Server',
  description: 'Install TypeScript language server for code intelligence',
  icon: 'typescript',
  category: 'language-server',

  // Pre-checks
  preChecks: [
    {
      name: 'Node.js installed',
      check: async () => {
        try {
          const { execSync } = require('child_process');
          execSync('node --version', { stdio: 'ignore' });
          return true;
        } catch {
          return false;
        }
      },
      failureMessage: 'Node.js is not installed. Please install Node.js first.',
      required: true,
    },
    {
      name: 'npm installed',
      check: async () => {
        try {
          const { execSync } = require('child_process');
          execSync('npm --version', { stdio: 'ignore' });
          return true;
        } catch {
          return false;
        }
      },
      failureMessage: 'npm is not installed.',
      required: true,
    },
  ],

  // Wizard steps
  steps: [
    {
      name: 'Welcome',
      description: 'This wizard will install the TypeScript language server.',
    },
    {
      name: 'Installation',
      description: 'Installing TypeScript language server...',
    },
    {
      name: 'Complete',
      description: 'TypeScript language server installed successfully!',
    },
  ],

  // Installation scripts
  scripts: [
    {
      id: 'install-typescript-ls',
      name: 'Install TypeScript Language Server',
      description: 'Install typescript-language-server via npm',
      platform: 'all',
      requiresAdmin: false,
      steps: [
        {
          name: 'Install typescript globally',
          command: 'npm',
          args: ['install', '-g', 'typescript'],
          timeout: 60000,
          retries: 2,
          verify: async () => {
            try {
              const { execSync } = require('child_process');
              execSync('tsc --version', { stdio: 'ignore' });
              return true;
            } catch {
              return false;
            }
          },
        },
        {
          name: 'Install typescript-language-server',
          command: 'npm',
          args: ['install', '-g', 'typescript-language-server'],
          timeout: 60000,
          retries: 2,
          verify: async () => {
            try {
              const { execSync } = require('child_process');
              execSync('typescript-language-server --version', { stdio: 'ignore' });
              return true;
            } catch {
              return false;
            }
          },
        },
      ],
      rollback: [
        {
          name: 'Uninstall typescript-language-server',
          command: 'npm',
          args: ['uninstall', '-g', 'typescript-language-server'],
        },
      ],
    },
  ],
};
```

#### 10.5 Example: PostgreSQL Database Provider Wizard

```typescript
// packages/dev-database/src/wizards/PostgreSQLWizard.ts

import { InstallationWizard, ScriptDefinition } from '@/app/Services';

export const PostgreSQLWizard: InstallationWizard = {
  id: 'install-postgresql',
  name: 'PostgreSQL',
  description: 'Install PostgreSQL database server',
  icon: 'postgresql',
  category: 'database',

  preChecks: [
    {
      name: 'Check if already installed',
      check: async () => {
        try {
          const { execSync } = require('child_process');
          execSync('which psql', { stdio: 'ignore' });
          return false; // Already installed, no need to install
        } catch {
          return true; // Not installed, proceed
        }
      },
      failureMessage: 'PostgreSQL is already installed.',
      required: false,
    },
  ],

  steps: [
    {
      name: 'Welcome',
      description: 'This wizard will install PostgreSQL on your system.',
    },
    {
      name: 'Installation',
      description: 'Installing PostgreSQL...',
    },
    {
      name: 'Configuration',
      description: 'Configuring PostgreSQL...',
    },
    {
      name: 'Complete',
      description: 'PostgreSQL installed successfully!',
    },
  ],

  scripts: [
    {
      id: 'install-postgresql-macos',
      name: 'Install PostgreSQL (macOS)',
      description: 'Install PostgreSQL via Homebrew',
      platform: 'darwin',
      requiresAdmin: false,
      steps: [
        {
          name: 'Install PostgreSQL',
          command: 'brew',
          args: ['install', 'postgresql@16'],
          timeout: 300000, // 5 minutes
          verify: async () => {
            try {
              const { execSync } = require('child_process');
              execSync('psql --version', { stdio: 'ignore' });
              return true;
            } catch {
              return false;
            }
          },
        },
        {
          name: 'Start PostgreSQL service',
          command: 'brew',
          args: ['services', 'start', 'postgresql@16'],
        },
      ],
    },
    {
      id: 'install-postgresql-linux',
      name: 'Install PostgreSQL (Linux)',
      description: 'Install PostgreSQL via apt',
      platform: 'linux',
      requiresAdmin: true,
      steps: [
        {
          name: 'Update package list',
          command: 'apt-get',
          args: ['update'],
          timeout: 120000,
        },
        {
          name: 'Install PostgreSQL',
          command: 'apt-get',
          args: ['install', '-y', 'postgresql', 'postgresql-contrib'],
          timeout: 300000,
          verify: async () => {
            try {
              const { execSync } = require('child_process');
              execSync('psql --version', { stdio: 'ignore' });
              return true;
            } catch {
              return false;
            }
          },
        },
        {
          name: 'Start PostgreSQL service',
          command: 'systemctl',
          args: ['start', 'postgresql'],
        },
        {
          name: 'Enable PostgreSQL on boot',
          command: 'systemctl',
          args: ['enable', 'postgresql'],
          optional: true,
        },
      ],
    },
  ],
};
```

#### 10.6 UI Components

**Installation Wizard Modal (React):**

```typescript
// src/app/UI/components/InstallationWizard.tsx

import React, { useState } from 'react';
import { InstallationWizardService } from '@/app/Services';

export function InstallationWizard({ wizardId }: { wizardId: string }) {
  const [currentStep, setCurrentStep] = useState(0);
  const [installing, setInstalling] = useState(false);
  const [progress, setProgress] = useState<ScriptProgress | null>(null);

  const wizard = InstallationWizardService.getWizard(wizardId);

  const handleNext = async () => {
    if (currentStep === 1) {
      // Installation step
      setInstalling(true);

      // Subscribe to progress
      InstallationWizardService.scriptRunner.onProgressEvent((prog) => {
        setProgress(prog);
      });

      const success = await InstallationWizardService.executeWizard(wizardId);
      setInstalling(false);

      if (success) {
        setCurrentStep(currentStep + 1);
      }
    } else {
      setCurrentStep(currentStep + 1);
    }
  };

  const handleBack = () => {
    setCurrentStep(Math.max(0, currentStep - 1));
  };

  return (
    <div className="wizard">
      <h2>{wizard.name}</h2>
      <p>{wizard.steps[currentStep].description}</p>

      {installing && progress && (
        <div className="progress">
          <div className="progress-bar">
            <div
              style={{ width: `${(progress.currentStep / progress.totalSteps) * 100}%` }}
            />
          </div>
          <p>{progress.stepName}</p>
        </div>
      )}

      <div className="buttons">
        {currentStep > 0 && (
          <button onClick={handleBack} disabled={installing}>
            Back
          </button>
        )}
        {currentStep < wizard.steps.length - 1 && (
          <button onClick={handleNext} disabled={installing}>
            {installing ? 'Installing...' : 'Next'}
          </button>
        )}
        {currentStep === wizard.steps.length - 1 && (
          <button onClick={() => window.close()}>
            Finish
          </button>
        )}
      </div>
    </div>
  );
}
```

#### 10.7 Usage in Packages

**LSP Package ServiceProvider:**

```typescript
// packages/lsp/src/LspServiceProvider.ts

import { ServiceProvider } from '@/app/Providers/ServiceProvider';
import { InstallationWizardService } from '@/app/Services';
import { TypeScriptLSWizard } from './wizards/TypeScriptLSWizard';
import { PhpIntelephenseWizard } from './wizards/PhpIntelephenseWizard';

export class LspServiceProvider extends ServiceProvider {
  register(): void {
    // Register language server installation wizards
    const wizardService = this.serviceRegistry.resolve<InstallationWizardService>(
      'InstallationWizardService'
    );

    wizardService.registerWizard(TypeScriptLSWizard);
    wizardService.registerWizard(PhpIntelephenseWizard);
    // Register more language servers...
  }
}
```

**Database Package ServiceProvider:**

```typescript
// packages/dev-database/src/DatabaseServiceProvider.ts

import { ServiceProvider } from '@/app/Providers/ServiceProvider';
import { InstallationWizardService } from '@/app/Services';
import { PostgreSQLWizard } from './wizards/PostgreSQLWizard';
import { MySQLWizard } from './wizards/MySQLWizard';

export class DatabaseServiceProvider extends ServiceProvider {
  register(): void {
    const wizardService = this.serviceRegistry.resolve<InstallationWizardService>(
      'InstallationWizardService'
    );

    wizardService.registerWizard(PostgreSQLWizard);
    wizardService.registerWizard(MySQLWizard);
    // Register more database providers...
  }
}
```

---

**Benefits:**
1. **Unified Installation Experience** - All OS-level installs use the same wizard UI
2. **Cross-Platform** - Scripts adapt to macOS, Linux, Windows
3. **Extensible** - Packages easily register their own wizards
4. **Safe** - Pre-checks, rollback, verification
5. **User-Friendly** - Progress tracking, error messages, step-by-step guidance

**Tasks Added:**
- Create ScriptRunnerService (OS script execution)
- Create InstallationWizardService (wizard management)
- Create wizard contribution system
- Create UI components (wizard modal, progress bar)
- Create example wizards (TypeScript LS, PostgreSQL)
- Add package.json schema for wizard contributions
- Write tests for script execution and rollback


## Success Criteria

- `pnpm dev:desktop` runs from `src/` structure
- `pnpm build:desktop` produces working build
- `pnpm typecheck` passes
- ExtensionHost loads `src/packages/example/` and calls its ServiceProvider
- ContributionRegistry correctly parses manifests
- DI container resolves services across extensions
- Example extension template is complete and documented
- `docs/` root structure scaffolded with README.md indexes
- **Feature control system working**: Admin can enable/disable features via panel
- **Package control working**: Admin can publish/unpublish packages
- **Update manager working**: IDE checks for updates and applies them
- **Auth system working**: Users can sign in via OAuth, tokens stored securely
- **Cloud sync working**: Settings sync across devices in real-time
- **WebSocket connection stable**: Reconnects automatically, handles offline mode


---

### 10.6 Integration with Existing Installation Scripts

Orchestra already has working installation scripts in `scripts/`:
- `install-lsp.sh`: Installs language servers (TypeScript, Python, PHP, Vue, Tailwind, etc.)
- `install-db.sh`: Checks and installs database tools (SQLite, MySQL, PostgreSQL, Redis, MongoDB)
- `install-hooks.sh`: Sets up git hooks

The ScriptRunnerService wraps these existing scripts to provide:
- Progress tracking in the UI
- Cancellation support
- Rollback mechanisms
- Cross-platform admin elevation

#### Example 1: Language Server Wizard (Wraps install-lsp.sh)

```typescript
// packages/lsp/src/wizards/LanguageServerWizard.ts

import { InstallationWizard } from '@/app/Services';
import { app } from 'electron';
import { join } from 'path';

export const LanguageServerWizard: InstallationWizard = {
  id: 'install-language-servers',
  name: 'Language Servers',
  description: 'Install all language servers required for Orchestra IDE',
  icon: 'code',
  category: 'development',

  preChecks: [
    {
      name: 'Check Node.js version',
      check: async () => {
        try {
          const { execSync } = require('child_process');
          const version = execSync('node --version', { encoding: 'utf-8' }).trim();
          const majorVersion = parseInt(version.slice(1).split('.')[0]);
          return majorVersion >= 18;
        } catch {
          return false;
        }
      },
      failureMessage: 'Node.js 18+ is required. Please install Node.js from nodejs.org',
      required: true,
    },
    {
      name: 'Check npm availability',
      check: async () => {
        try {
          const { execSync } = require('child_process');
          execSync('npm --version', { stdio: 'ignore' });
          return true;
        } catch {
          return false;
        }
      },
      failureMessage: 'npm is not available. Please ensure Node.js is properly installed.',
      required: true,
    },
  ],

  steps: [
    {
      name: 'Welcome',
      description: 'This wizard will install language servers for TypeScript, Python, PHP, Vue, Tailwind CSS, Bash, YAML, and JSON.',
    },
    {
      name: 'Installation',
      description: 'Installing language servers...',
    },
  ],

  // Wrap the existing install-lsp.sh script
  scripts: [
    {
      id: 'run-install-lsp-script',
      name: 'Run Language Server Installation Script',
      description: 'Execute install-lsp.sh',
      platform: 'darwin', // macOS
      requiresAdmin: false,
      steps: [
        {
          name: 'Execute install-lsp.sh',
          command: 'bash',
          args: [
            join(app.getAppPath(), '../../../scripts/install-lsp.sh')
          ],
          timeout: 300000, // 5 minutes
          retries: 1,
          onProgress: (line) => {
            // Parse output from the script
            if (line.includes('Installing')) {
              return { status: 'Installing language servers...', progress: 50 };
            }
            if (line.includes('✓')) {
              return { status: 'Installation complete', progress: 100 };
            }
            return null;
          },
          verify: async () => {
            // Verify key language servers are installed
            try {
              const { execSync } = require('child_process');
              execSync('typescript-language-server --version', { stdio: 'ignore' });
              execSync('pyright --version', { stdio: 'ignore' });
              return true;
            } catch {
              return false;
            }
          },
        },
      ],
      rollback: [
        // No rollback needed - language servers are installed globally
        // Users can manually uninstall if needed
      ],
    },
  ],

  postInstall: {
    message: 'Language servers installed successfully! Orchestra can now provide code intelligence for TypeScript, Python, PHP, and more.',
    actions: [
      {
        label: 'Open Settings',
        action: 'openSettings',
        params: { section: 'language-servers' },
      },
    ],
  },
};
```

#### Example 2: Database Tools Wizard (Wraps install-db.sh)

```typescript
// packages/dev-database/src/wizards/DatabaseToolsWizard.ts

import { InstallationWizard } from '@/app/Services';
import { app } from 'electron';
import { join } from 'path';

export const DatabaseToolsWizard: InstallationWizard = {
  id: 'install-database-tools',
  name: 'Database Tools',
  description: 'Check and install database tools (SQLite, MySQL, PostgreSQL, Redis, MongoDB)',
  icon: 'database',
  category: 'development',

  preChecks: [
    {
      name: 'Check system compatibility',
      check: async () => {
        // Always pass - the script will check individual tools
        return true;
      },
      required: true,
    },
  ],

  steps: [
    {
      name: 'Welcome',
      description: 'This wizard will check for database tools and provide installation instructions for any missing tools.',
    },
    {
      name: 'Checking',
      description: 'Checking installed database tools...',
    },
    {
      name: 'Installation',
      description: 'Setting up database tools...',
    },
  ],

  // Wrap the existing install-db.sh script
  scripts: [
    {
      id: 'run-install-db-script',
      name: 'Run Database Tools Check Script',
      description: 'Execute install-db.sh',
      platform: 'darwin', // macOS
      requiresAdmin: false,
      steps: [
        {
          name: 'Execute install-db.sh',
          command: 'bash',
          args: [
            join(app.getAppPath(), '../../../scripts/install-db.sh')
          ],
          timeout: 180000, // 3 minutes
          retries: 1,
          onProgress: (line) => {
            // Parse output from the script
            if (line.includes('Checking')) {
              return { status: 'Checking database tools...', progress: 30 };
            }
            if (line.includes('SQLite')) {
              return { status: 'SQLite check complete', progress: 50 };
            }
            if (line.includes('Rebuilding')) {
              return { status: 'Rebuilding better-sqlite3...', progress: 70 };
            }
            if (line.includes('Done')) {
              return { status: 'Database tools ready', progress: 100 };
            }
            return null;
          },
          verify: async () => {
            // Verify better-sqlite3 rebuild succeeded
            try {
              const { execSync } = require('child_process');
              execSync('node -e "require('better-sqlite3')"', {
                cwd: join(app.getAppPath(), '../../../'),
                stdio: 'ignore'
              });
              return true;
            } catch {
              return false;
            }
          },
        },
      ],
      rollback: [
        // No rollback needed - we're just checking and rebuilding
      ],
    },
  ],

  postInstall: {
    message: 'Database tools check complete! Orchestra is ready to work with databases.',
    actions: [
      {
        label: 'Open Database Manager',
        action: 'openPanel',
        params: { panel: 'database' },
      },
    ],
  },
};
```

#### Example 3: Git Hooks Wizard (Wraps install-hooks.sh)

```typescript
// packages/git/src/wizards/GitHooksWizard.ts

import { InstallationWizard } from '@/app/Services';
import { app } from 'electron';
import { join } from 'path';

export const GitHooksWizard: InstallationWizard = {
  id: 'install-git-hooks',
  name: 'Git Hooks',
  description: 'Install Husky git hooks for code quality checks',
  icon: 'git-branch',
  category: 'development',

  preChecks: [
    {
      name: 'Check if in git repository',
      check: async () => {
        try {
          const { execSync } = require('child_process');
          execSync('git rev-parse --git-dir', {
            cwd: join(app.getAppPath(), '../../../'),
            stdio: 'ignore'
          });
          return true;
        } catch {
          return false;
        }
      },
      failureMessage: 'Not in a git repository. Hooks can only be installed in git repositories.',
      required: true,
    },
    {
      name: 'Check Husky installation',
      check: async () => {
        try {
          const { existsSync } = require('fs');
          return existsSync(join(app.getAppPath(), '../../../node_modules/husky'));
        } catch {
          return false;
        }
      },
      failureMessage: 'Husky is not installed. Run "pnpm install" first.',
      required: true,
    },
  ],

  steps: [
    {
      name: 'Welcome',
      description: 'This wizard will set up git hooks to automatically run tests and linters before commits.',
    },
    {
      name: 'Installation',
      description: 'Setting up git hooks...',
    },
  ],

  scripts: [
    {
      id: 'run-install-hooks-script',
      name: 'Run Git Hooks Installation Script',
      description: 'Execute install-hooks.sh',
      platform: 'all',
      requiresAdmin: false,
      steps: [
        {
          name: 'Execute install-hooks.sh',
          command: 'bash',
          args: [
            join(app.getAppPath(), '../../../scripts/install-hooks.sh')
          ],
          timeout: 60000, // 1 minute
          retries: 1,
          onProgress: (line) => {
            if (line.includes('Installing')) {
              return { status: 'Setting up hooks...', progress: 50 };
            }
            if (line.includes('Done')) {
              return { status: 'Hooks installed', progress: 100 };
            }
            return null;
          },
          verify: async () => {
            // Verify hook files exist
            try {
              const { existsSync } = require('fs');
              const hookPath = join(app.getAppPath(), '../../../.husky/pre-commit');
              return existsSync(hookPath);
            } catch {
              return false;
            }
          },
        },
      ],
      rollback: [
        {
          name: 'Remove hooks',
          command: 'rm',
          args: ['-rf', join(app.getAppPath(), '../../../.husky/_')],
        },
      ],
    },
  ],

  postInstall: {
    message: 'Git hooks installed successfully! Your commits will now be checked for code quality.',
    actions: [
      {
        label: 'View Hook Configuration',
        action: 'openFile',
        params: { file: '.husky/pre-commit' },
      },
    ],
  },
};
```

#### Example 4: Generic Shell Script Wrapper

For any other bash script in the `scripts/` folder:

```typescript
// Helper function to create wizard from any bash script
function createWizardFromScript(
  scriptPath: string,
  id: string,
  name: string,
  description: string,
  category: string = 'development'
): InstallationWizard {
  return {
    id,
    name,
    description,
    icon: 'terminal',
    category,

    preChecks: [
      {
        name: 'Check script exists',
        check: async () => {
          const { existsSync } = require('fs');
          return existsSync(scriptPath);
        },
        failureMessage: `Script not found: ${scriptPath}`,
        required: true,
      },
    ],

    steps: [
      {
        name: 'Welcome',
        description: `This wizard will run: ${scriptPath}`,
      },
      {
        name: 'Execution',
        description: 'Running script...',
      },
    ],

    scripts: [
      {
        id: `run-${id}`,
        name: `Execute ${name}`,
        description: `Run ${scriptPath}`,
        platform: 'all',
        requiresAdmin: false,
        steps: [
          {
            name: `Execute ${scriptPath}`,
            command: 'bash',
            args: [scriptPath],
            timeout: 300000,
            retries: 1,
            onProgress: (line) => {
              return { status: line, progress: null };
            },
          },
        ],
      },
    ],

    postInstall: {
      message: `${name} completed successfully!`,
    },
  };
}

// Usage examples:
const installOrchestraCliWizard = createWizardFromScript(
  join(app.getAppPath(), '../../../scripts/orch.sh'),
  'install-orchestra-cli',
  'Orchestra CLI',
  'Install Orchestra CLI globally'
);

const initProjectWizard = createWizardFromScript(
  join(app.getAppPath(), '../../../scripts/init-project.sh'),
  'init-orchestra-project',
  'Initialize Orchestra Project',
  'Set up new Orchestra project structure'
);
```

#### How Packages Register Their Wizards

Each package registers its wizards with the InstallationWizardService:

```typescript
// packages/lsp/src/index.ts

import { InstallationWizardService } from '@/app/Services';
import { LanguageServerWizard } from './wizards/LanguageServerWizard';

export class LSPExtension {
  async activate() {
    // Register the wizard
    const wizardService = new InstallationWizardService();
    wizardService.registerWizard(LanguageServerWizard);

    console.log('LSP Extension: Language Server wizard registered');
  }
}
```

```typescript
// packages/dev-database/src/index.ts

import { InstallationWizardService } from '@/app/Services';
import { DatabaseToolsWizard } from './wizards/DatabaseToolsWizard';

export class DevDatabaseExtension {
  async activate() {
    // Register the wizard
    const wizardService = new InstallationWizardService();
    wizardService.registerWizard(DatabaseToolsWizard);

    console.log('Dev Database Extension: Database tools wizard registered');
  }
}
```

#### UI Integration

The Chrome extension can show all available wizards:

```typescript
// packages/chrome-extension/src/sidepanel/wizards/WizardList.tsx

import React, { useEffect, useState } from 'react';

interface Wizard {
  id: string;
  name: string;
  description: string;
  category: string;
  icon: string;
}

export function WizardList() {
  const [wizards, setWizards] = useState<Wizard[]>([]);

  useEffect(() => {
    // Get all registered wizards from the service
    window.orchestra.wizards.getAll().then(setWizards);
  }, []);

  const runWizard = async (wizardId: string) => {
    try {
      const success = await window.orchestra.wizards.execute(wizardId);
      if (success) {
        alert('Installation completed successfully!');
      } else {
        alert('Installation failed. Check logs for details.');
      }
    } catch (error) {
      alert(`Error: ${error.message}`);
    }
  };

  return (
    <div className="wizard-list">
      <h2>Installation Wizards</h2>
      <div className="wizard-grid">
        {wizards.map(wizard => (
          <div key={wizard.id} className="wizard-card">
            <div className="wizard-icon">{wizard.icon}</div>
            <h3>{wizard.name}</h3>
            <p>{wizard.description}</p>
            <button onClick={() => runWizard(wizard.id)}>
              Install
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}
```

### 10.7 Benefits of This Approach

1. **Reuses Existing Scripts**: No need to rewrite bash scripts in TypeScript
2. **Adds Missing Features**: Progress tracking, cancellation, rollback
3. **Consistent UX**: All installations use the same wizard UI
4. **Extensible**: Any package can add wizards for its dependencies
5. **Cross-Platform**: Handles platform differences (macOS, Linux, Windows)
6. **Admin Elevation**: Automatically prompts for sudo/UAC when needed
7. **Error Handling**: Comprehensive error messages and rollback support

### 10.8 Implementation Tasks

The following tasks will be created to implement this integration:

**Epic: OC-XX - Script Runner & Installation System**

**Story: OC-XX1 - Core Script Runner**
- Task 1: Create ScriptRunnerService (from Section 10.1)
- Task 2: Create InstallationWizardService (from Section 10.2)
- Task 3: Add platform detection and admin elevation

**Story: OC-XX2 - Language Server Wizard**
- Task 1: Create LanguageServerWizard wrapping install-lsp.sh
- Task 2: Add progress parsing for npm installations
- Task 3: Add verification checks for installed language servers

**Story: OC-XX3 - Database Tools Wizard**
- Task 1: Create DatabaseToolsWizard wrapping install-db.sh
- Task 2: Add better-sqlite3 rebuild verification
- Task 3: Add UI for missing database installation instructions

**Story: OC-XX4 - Git Hooks Wizard**
- Task 1: Create GitHooksWizard wrapping install-hooks.sh
- Task 2: Add git repository verification
- Task 3: Add rollback support for hooks

**Story: OC-XX5 - Wizard UI (Chrome Extension)**
- Task 1: Create WizardList component
- Task 2: Create WizardProgress component showing real-time progress
- Task 3: Add wizard discovery in settings/tools panel

---



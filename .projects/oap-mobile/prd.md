# Orchestra Mobile App - React Native PRD

**Parent:** orchestra-app (Master PRD)
**Depends on:** PRD 5 (oap-cloud), PRD 3 (oap-packages - Design System)

---

## Overview

Orchestra Mobile App is a cross-platform iOS/Android companion app built with React Native. It provides full access to Orchestra's cloud platform features including task management, time tracking, version control, AI agent control, and team collaboration - all from your mobile device.

**Key Differentiators:**
- Real-time sync with desktop IDE via WebSocket
- Push notifications for AI agent requests and team updates
- Offline-first architecture with queue-based sync
- Shared codebase with web platform (API, types, stores)
- Native biometric authentication
- Full markdown rendering with syntax highlighting
- Live code viewing and file browsing

---

## Tech Stack

| Component | Technology | Version | Notes |
|-----------|-----------|---------|-------|
| Framework | React Native | 0.76+ | Latest stable with New Architecture |
| Language | TypeScript | 5.9 | Shared types with all platforms |
| Styling | NativeWind | 4.x | Tailwind CSS for React Native |
| Navigation | React Navigation | 7.x | Type-safe navigation |
| State Management | Zustand | 5.x | Shared store patterns with web/chrome |
| API Client | Axios | Latest | Same endpoints as web platform |
| Authentication | Laravel Sanctum | - | Token-based auth from cloud platform |
| Real-time | Socket.io Client | Latest | WebSocket connection to cloud server |
| Push Notifications | Firebase Cloud Messaging | Latest | Cross-platform push |
| Analytics | Firebase Analytics | Latest | Usage tracking |
| Markdown | react-native-markdown-display | Latest | Same parser logic as desktop |
| Syntax Highlighting | react-syntax-highlighter | Latest | Code blocks in markdown |
| Charts | Victory Native | Latest | Task burndown, time tracking charts |
| Storage | AsyncStorage | Latest | Local data persistence |
| Secure Storage | react-native-keychain | Latest | Token storage |
| Biometrics | react-native-biometrics | Latest | Face ID / Touch ID / Fingerprint |
| Deep Linking | React Navigation Deep Linking | - | Handle orchestra:// URLs |
| File Viewing | react-native-webview | Latest | Code viewer |
| Testing | Jest + React Native Testing Library | Latest | Unit and integration tests |

---

## Architecture

### 1. Project Structure

```
src/mobile/
├── src/
│   ├── app/                          # Screen components (React Navigation)
│   │   ├── (auth)/                   # Authentication flow
│   │   │   ├── login.tsx
│   │   │   ├── register.tsx
│   │   │   ├── reset-password.tsx
│   │   │   ├── verify-otp.tsx
│   │   │   └── setup-biometric.tsx
│   │   ├── (tabs)/                   # Main tab navigation
│   │   │   ├── dashboard/
│   │   │   │   ├── index.tsx         # Employee dashboard
│   │   │   │   ├── team.tsx          # Team owner dashboard
│   │   │   │   └── widgets/
│   │   │   ├── tasks/
│   │   │   │   ├── index.tsx         # Task list
│   │   │   │   ├── [id].tsx          # Task detail
│   │   │   │   └── filters.tsx
│   │   │   ├── timers/
│   │   │   │   ├── index.tsx         # Active timer
│   │   │   │   ├── history.tsx       # Timer history
│   │   │   │   └── reports.tsx       # Charts & analytics
│   │   │   ├── code/
│   │   │   │   ├── index.tsx         # Code browser
│   │   │   │   ├── viewer.tsx        # File viewer
│   │   │   │   └── search.tsx
│   │   │   ├── terminal/
│   │   │   │   ├── index.tsx         # Terminal sessions
│   │   │   │   └── [sessionId].tsx
│   │   │   └── settings/
│   │   │       ├── index.tsx
│   │   │       ├── profile.tsx
│   │   │       ├── notifications.tsx
│   │   │       ├── integrations.tsx
│   │   │       └── theme.tsx
│   │   ├── version-control/
│   │   │   ├── commits.tsx
│   │   │   ├── pull-requests.tsx
│   │   │   └── issues.tsx
│   │   ├── agent/
│   │   │   ├── index.tsx             # AI Agent control panel
│   │   │   ├── permissions.tsx       # Permission requests
│   │   │   └── chat.tsx              # Agent conversation
│   │   ├── team/
│   │   │   ├── members.tsx
│   │   │   ├── activity.tsx
│   │   │   └── manage.tsx
│   │   ├── notifications/
│   │   │   └── index.tsx
│   │   └── workspace/
│   │       ├── switcher.tsx
│   │       └── [id].tsx
│   ├── components/                   # Shared UI components
│   │   ├── markdown/
│   │   │   ├── MarkdownRenderer.tsx
│   │   │   ├── CodeBlock.tsx
│   │   │   └── InlineCode.tsx
│   │   ├── charts/
│   │   │   ├── BurndownChart.tsx
│   │   │   ├── TimeChart.tsx
│   │   │   └── ProgressRing.tsx
│   │   ├── tasks/
│   │   │   ├── TaskCard.tsx
│   │   │   ├── TaskList.tsx
│   │   │   └── TaskHierarchy.tsx
│   │   ├── timers/
│   │   │   ├── TimerCard.tsx
│   │   │   └── PomodoroTimer.tsx
│   │   ├── terminal/
│   │   │   └── TerminalEmulator.tsx
│   │   ├── code/
│   │   │   ├── FileTree.tsx
│   │   │   ├── FileViewer.tsx
│   │   │   └── SyntaxHighlight.tsx
│   │   └── ui/
│   │       ├── Button.tsx
│   │       ├── Input.tsx
│   │       ├── Card.tsx
│   │       ├── Avatar.tsx
│   │       ├── Badge.tsx
│   │       ├── Spinner.tsx
│   │       └── Toast.tsx
│   ├── stores/                       # Zustand stores (shared patterns)
│   │   ├── authStore.ts
│   │   ├── taskStore.ts
│   │   ├── timerStore.ts
│   │   ├── agentStore.ts
│   │   ├── teamStore.ts
│   │   ├── workspaceStore.ts
│   │   ├── notificationStore.ts
│   │   └── syncStore.ts
│   ├── services/                     # Core services
│   │   ├── api/
│   │   │   ├── ApiClient.ts
│   │   │   ├── AuthService.ts
│   │   │   ├── TaskService.ts
│   │   │   ├── TimerService.ts
│   │   │   ├── AgentService.ts
│   │   │   ├── TeamService.ts
│   │   │   └── WorkspaceService.ts
│   │   ├── websocket/
│   │   │   ├── WebSocketService.ts
│   │   │   └── SocketEvents.ts
│   │   ├── push/
│   │   │   ├── FCMService.ts
│   │   │   └── NotificationHandler.ts
│   │   ├── storage/
│   │   │   ├── StorageService.ts
│   │   │   ├── SecureStorage.ts
│   │   │   └── CacheService.ts
│   │   ├── sync/
│   │   │   ├── SyncService.ts
│   │   │   ├── QueueManager.ts
│   │   │   └── ConflictResolver.ts
│   │   └── biometric/
│   │       └── BiometricService.ts
│   ├── navigation/
│   │   ├── RootNavigator.tsx
│   │   ├── AuthNavigator.tsx
│   │   ├── TabNavigator.tsx
│   │   └── types.ts
│   ├── theme/
│   │   ├── colors.ts               # Maps to IDE theme tokens
│   │   ├── typography.ts
│   │   ├── spacing.ts
│   │   └── index.ts
│   ├── utils/
│   │   ├── formatters.ts
│   │   ├── validators.ts
│   │   └── constants.ts
│   └── types/
│       ├── models.ts               # Shared with cloud platform
│       └── api.ts
├── android/                         # Android native code
├── ios/                             # iOS native code
├── docs/
│   ├── README.md
│   ├── setup.md
│   ├── architecture.md
│   ├── api/
│   │   └── README.md
│   ├── guides/
│   │   ├── development.md
│   │   ├── testing.md
│   │   └── deployment.md
│   └── changelog/
│       └── README.md
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── app.json
├── package.json
├── tsconfig.json
├── metro.config.js
├── tailwind.config.js
├── jest.config.js
└── .env.example
```

---

## Features

### 1. Code Viewer

**Purpose:** Browse and view project files from connected desktop workspace.

**Features:**
- File tree navigation with search
- Syntax highlighting for all supported languages
- Line numbers and code folding
- Quick file search (fuzzy match)
- Recent files history
- File metadata (size, modified date, git status)
- Offline caching of recently viewed files
- Deep linking to specific files/lines
- Share code snippets (copy/share)

**UI Components:**
```typescript
// components/code/FileTree.tsx
interface FileTreeProps {
  workspace: Workspace;
  onFileSelect: (file: File) => void;
  searchQuery?: string;
}

// components/code/FileViewer.tsx
interface FileViewerProps {
  file: File;
  content: string;
  language: string;
  theme: CodeTheme;
  lineNumbers?: boolean;
}

// components/code/SyntaxHighlight.tsx
interface SyntaxHighlightProps {
  code: string;
  language: string;
  theme: 'light' | 'dark';
  showLineNumbers?: boolean;
  highlightLines?: number[];
}
```

**API Endpoints:**
- `GET /api/workspaces/{id}/files` - List files in workspace
- `GET /api/workspaces/{id}/files/content` - Get file content
- `GET /api/workspaces/{id}/files/search` - Search files
- `GET /api/workspaces/{id}/files/recent` - Recently viewed files

---

### 2. Terminal Access

**Purpose:** Connect to desktop terminal sessions and execute commands remotely.

**Features:**
- View active terminal sessions from desktop
- Connect to existing sessions (read-only or interactive)
- Execute commands remotely
- Session history and output logs
- Multiple terminals support
- Terminal tabs
- Command auto-completion (basic)
- Keyboard shortcuts (custom mobile keyboard)
- Copy/paste support
- Search in output
- Export session logs

**WebSocket Events:**
```typescript
// Terminal session creation
socket.emit('terminal:create', { workspaceId, cwd });
socket.on('terminal:created', { sessionId, cwd });

// Terminal input/output
socket.emit('terminal:input', { sessionId, data: 'ls -la\n' });
socket.on('terminal:output', { sessionId, data: '...' });

// Terminal resize (on orientation change)
socket.emit('terminal:resize', { sessionId, cols, rows });

// Terminal close
socket.emit('terminal:close', { sessionId });
socket.on('terminal:closed', { sessionId });
```

**UI Components:**
```typescript
// components/terminal/TerminalEmulator.tsx
interface TerminalEmulatorProps {
  sessionId: string;
  onInput: (data: string) => void;
  output: string[];
  cwd: string;
  readOnly?: boolean;
}
```

**Security:**
- All terminal commands executed on desktop machine
- Mobile app only sends commands via WebSocket
- Desktop user can approve/deny terminal access
- Session permissions controlled by team role

---

### 3. Push Notifications

**Purpose:** Real-time alerts for important events even when app is backgrounded.

**Notification Types:**

#### AI Agent Notifications
- Agent needs permission (tap to approve/deny)
- Agent has a question (tap to answer)
- Agent completed task
- Agent encountered error

#### Task Notifications
- Task assigned to you
- Task status changed
- Task deadline approaching
- Task comment/mention

#### Team Notifications
- Team member mentioned you
- Team activity update
- Team member joined/left

#### CI/CD Notifications
- Build started/completed
- Deployment succeeded/failed
- Tests passed/failed

#### Marketing Notifications (Admin-sent)
- Product updates
- New features
- Maintenance windows

**FCM Integration:**
```typescript
// services/push/FCMService.ts
export class FCMService {
  async initialize(): Promise<void>;
  async getToken(): Promise<string>;
  async requestPermission(): Promise<boolean>;
  onMessage(handler: (message: RemoteMessage) => void): void;
  onNotificationOpened(handler: (notification: Notification) => void): void;
  subscribeToTopic(topic: string): Promise<void>;
  unsubscribeFromTopic(topic: string): Promise<void>;
}

// services/push/NotificationHandler.ts
export class NotificationHandler {
  handleAgentPermissionRequest(notification: AgentNotification): void;
  handleAgentQuestion(notification: AgentNotification): void;
  handleTaskAssignment(notification: TaskNotification): void;
  handleTeamMention(notification: TeamNotification): void;
  handleCIStatus(notification: CINotification): void;
  // Navigate to relevant screen
  navigateFromNotification(notification: Notification): void;
}
```

**Notification Payload Schema:**
```typescript
interface NotificationPayload {
  type: 'agent' | 'task' | 'team' | 'ci' | 'marketing';
  title: string;
  body: string;
  data: {
    screen: string;         // Navigation target
    params?: any;           // Navigation params
    actionRequired?: boolean;
    priority: 'high' | 'normal' | 'low';
  };
}
```

---

### 4. Task Management

**Purpose:** Full access to Orchestra's task hierarchy (Project → Epic → Story → Task).

**Features:**
- View all tasks across projects
- Task detail view with full markdown
- Update task status
- Add comments
- Assign tasks (team owners)
- Set priorities (team owners)
- Task timeline view
- Quick actions (start timer, mark done)
- Offline support (queue updates)
- Filter by project/epic/story/status/assignee
- Sort by priority/date/status
- Search tasks
- Task notifications

**Store:**
```typescript
// stores/taskStore.ts
interface TaskStore {
  tasks: Task[];
  loading: boolean;
  error: string | null;

  // Actions
  fetchTasks: (filters?: TaskFilters) => Promise<void>;
  fetchTaskById: (id: string) => Promise<Task>;
  updateTaskStatus: (id: string, status: TaskStatus) => Promise<void>;
  addComment: (taskId: string, comment: string) => Promise<void>;
  assignTask: (taskId: string, userId: string) => Promise<void>;
  startTimer: (taskId: string) => Promise<void>;

  // Offline queue
  queueUpdate: (action: TaskAction) => void;
  syncQueue: () => Promise<void>;
}
```

**API Endpoints:**
- `GET /api/tasks` - List tasks (with filters)
- `GET /api/tasks/{id}` - Task detail
- `PUT /api/tasks/{id}` - Update task
- `POST /api/tasks/{id}/comments` - Add comment
- `PUT /api/tasks/{id}/assign` - Assign task
- `POST /api/tasks/{id}/timer` - Start timer

---

### 5. Workspace Sync

**Purpose:** View and switch between workspaces, sync settings across devices.

**Features:**
- View workspace status (active/idle)
- Switch workspaces (triggers desktop switch)
- Workspace file tree
- Recent files per workspace
- Workspace settings sync
- Git status per workspace
- Workspace search
- Offline workspace list cache

**WebSocket Events:**
```typescript
// Workspace status
socket.on('workspace:status', { workspaceId, status: 'active' | 'idle' });

// Workspace switch
socket.emit('workspace:switch', { workspaceId });
socket.on('workspace:switched', { workspaceId });

// Workspace file updates
socket.on('workspace:file:changed', { workspaceId, file, changeType });
socket.on('workspace:file:created', { workspaceId, file });
socket.on('workspace:file:deleted', { workspaceId, file });
```

**Store:**
```typescript
// stores/workspaceStore.ts
interface WorkspaceStore {
  workspaces: Workspace[];
  activeWorkspace: Workspace | null;

  fetchWorkspaces: () => Promise<void>;
  switchWorkspace: (id: string) => Promise<void>;
  syncSettings: (workspaceId: string) => Promise<void>;
  getFileTree: (workspaceId: string) => Promise<FileNode[]>;
}
```

---

### 6. Authentication

**Purpose:** Secure OAuth integration with cloud platform and native biometric auth.

**Methods:**

#### OAuth Integration
- Email + Password
- GitHub OAuth
- Google OAuth
- Magic Link (email)
- TOTP 2FA

#### Native Biometric
- Face ID (iOS)
- Touch ID (iOS)
- Fingerprint (Android)
- PIN fallback

**Flow:**
1. User taps "Sign In"
2. App opens WebView to `https://orchestra.ai/auth/mobile`
3. User signs in via OAuth provider
4. Server redirects to `orchestra://auth/callback?code=...`
5. App exchanges code for tokens
6. Tokens stored in Keychain/Keystore (encrypted)
7. User prompted to enable biometric auth
8. Future logins use biometric → refresh token

**Security:**
- Access tokens expire in 15 minutes
- Refresh tokens expire in 30 days
- Token rotation on refresh
- Biometric unlocks refresh token
- Failed biometric attempts fall back to re-auth

**Service:**
```typescript
// services/api/AuthService.ts
export class AuthService {
  async signIn(email: string, password: string): Promise<AuthResponse>;
  async signInWithOAuth(provider: 'github' | 'google'): Promise<void>;
  async signInWithMagicLink(email: string): Promise<void>;
  async verifyOTP(code: string): Promise<void>;
  async refreshTokens(): Promise<void>;
  async signOut(): Promise<void>;

  // Biometric
  async isBiometricAvailable(): Promise<boolean>;
  async enableBiometric(): Promise<void>;
  async disableBiometric(): Promise<void>;
  async authenticateWithBiometric(): Promise<boolean>;
}

// services/biometric/BiometricService.ts
export class BiometricService {
  async isAvailable(): Promise<boolean>;
  async getAvailableTypes(): Promise<BiometricType[]>;
  async authenticate(reason: string): Promise<boolean>;
  async saveCredentials(key: string, value: string): Promise<void>;
  async getCredentials(key: string): Promise<string | null>;
  async deleteCredentials(key: string): Promise<void>;
}
```

---

### 7. Real-time Sync Architecture

**WebSocket Connection:**
```typescript
// services/websocket/WebSocketService.ts
export class WebSocketService {
  private socket: SocketIOClient.Socket;

  connect(token: string): Promise<void>;
  disconnect(): void;

  // Channels
  subscribe(channel: string, handler: (data: any) => void): void;
  unsubscribe(channel: string): void;

  // Events
  emit(event: string, data: any): void;
  on(event: string, handler: (data: any) => void): void;
  off(event: string): void;

  // Auto-reconnect
  enableAutoReconnect(): void;
  getConnectionStatus(): 'connecting' | 'connected' | 'disconnected';
}
```

**Event Channels:**
```typescript
// User-specific
socket.subscribe(`user.${userId}`, handleUserEvent);

// Team-specific
socket.subscribe(`team.${teamId}`, handleTeamEvent);

// Workspace-specific
socket.subscribe(`workspace.${workspaceId}`, handleWorkspaceEvent);

// Agent-specific
socket.subscribe(`agent.${agentId}`, handleAgentEvent);
```

**Events:**
```typescript
interface SocketEvents {
  // Tasks
  'task:created': Task;
  'task:updated': { id: string; changes: Partial<Task> };
  'task:deleted': { id: string };
  'task:assigned': { taskId: string; userId: string };
  'task:commented': { taskId: string; comment: Comment };

  // Timers
  'timer:started': { taskId: string; startedAt: Date };
  'timer:stopped': { taskId: string; duration: number };
  'timer:paused': { taskId: string };

  // Agent
  'agent:status': { status: 'idle' | 'working' | 'waiting' };
  'agent:permission_required': { requestId: string; action: string };
  'agent:question': { questionId: string; question: string };
  'agent:output': { output: string };
  'agent:completed': { taskId: string };

  // Team
  'team:member_online': { userId: string };
  'team:member_offline': { userId: string };
  'team:activity': { userId: string; activity: Activity };

  // Notifications
  'notification:new': Notification;
  'notification:read': { notificationId: string };

  // Workspace
  'workspace:file:changed': { workspaceId: string; file: File };
  'workspace:status': { workspaceId: string; status: string };
}
```

---

### 8. Offline Support

**Strategy:** Offline-first with queue-based sync.

**Features:**
- Cache all fetched data locally
- Queue writes when offline
- Auto-sync on reconnect
- Conflict resolution
- Offline indicator in UI
- View cached tasks/timers/code
- Optimistic UI updates

**Queue Manager:**
```typescript
// services/sync/QueueManager.ts
export class QueueManager {
  private queue: QueuedAction[] = [];

  enqueue(action: QueuedAction): void;
  dequeue(): QueuedAction | null;
  clear(): void;
  getAll(): QueuedAction[];

  async syncQueue(): Promise<SyncResult>;
}

interface QueuedAction {
  id: string;
  type: 'task_update' | 'timer_start' | 'comment_add';
  timestamp: Date;
  data: any;
  retries: number;
}

interface SyncResult {
  synced: number;
  failed: number;
  conflicts: Conflict[];
}
```

**Conflict Resolution:**
```typescript
// services/sync/ConflictResolver.ts
export class ConflictResolver {
  resolve(local: any, remote: any, strategy: 'local' | 'remote' | 'merge'): any;

  // Task conflict: prefer remote status but merge comments
  resolveTaskConflict(local: Task, remote: Task): Task;

  // Timer conflict: prefer longer duration
  resolveTimerConflict(local: Timer, remote: Timer): Timer;
}
```

**Storage:**
```typescript
// services/storage/CacheService.ts
export class CacheService {
  async cacheTask(task: Task): Promise<void>;
  async getCachedTask(id: string): Promise<Task | null>;
  async cacheWorkspace(workspace: Workspace): Promise<void>;
  async getCachedWorkspaces(): Promise<Workspace[]>;
  async clearCache(): Promise<void>;
}
```

---

## Platform Support

### iOS Requirements
- iOS 14.0+
- iPhone, iPad, iPod Touch
- Face ID / Touch ID support
- Push Notification entitlements
- Background modes: fetch, remote-notification

### Android Requirements
- Android 8.0+ (API 26+)
- ARMv7, ARM64, x86, x86_64
- Fingerprint sensor (optional)
- Google Play Services for FCM
- Background service for sync

### Device Capabilities
- Minimum 2GB RAM
- Portrait and landscape support
- Dark mode support
- Split-screen / multi-window (Android)
- iPad multi-tasking (iOS)

---

## Navigation Structure

```typescript
// navigation/types.ts
export type RootStackParamList = {
  Auth: undefined;
  Main: undefined;
  TaskDetail: { id: string };
  FileViewer: { workspaceId: string; path: string };
  AgentPermission: { requestId: string };
  Terminal: { sessionId: string };
};

export type AuthStackParamList = {
  Login: undefined;
  Register: undefined;
  ResetPassword: undefined;
  VerifyOTP: { email: string };
  SetupBiometric: undefined;
};

export type MainTabParamList = {
  Dashboard: undefined;
  Tasks: undefined;
  Code: undefined;
  Terminal: undefined;
  Settings: undefined;
};
```

**Deep Linking:**
```typescript
// orchestra://task/123 → Navigate to task detail
// orchestra://file?workspace=abc&path=/src/index.ts → Open file
// orchestra://agent/permission/456 → Agent permission request
// orchestra://terminal/session/789 → Terminal session
```

---

## Design System Integration

**Theme Mapping:**
```typescript
// theme/colors.ts
import { designTokens } from '@orchestra/design-system';

export const lightTheme = {
  primary: designTokens.colors.primary[600],
  background: designTokens.colors.neutral[50],
  surface: designTokens.colors.neutral[0],
  text: designTokens.colors.neutral[900],
  // ... maps all design tokens to NativeWind
};

export const darkTheme = {
  primary: designTokens.colors.primary[400],
  background: designTokens.colors.neutral[900],
  surface: designTokens.colors.neutral[800],
  text: designTokens.colors.neutral[50],
  // ...
};
```

**Component Styling:**
```tsx
// Using NativeWind (Tailwind for RN)
import { View, Text } from 'react-native';

export function TaskCard({ task }) {
  return (
    <View className="bg-surface p-4 rounded-lg shadow-sm border border-neutral-200">
      <Text className="text-lg font-semibold text-neutral-900">
        {task.title}
      </Text>
      <Text className="text-sm text-neutral-600 mt-1">
        {task.description}
      </Text>
    </View>
  );
}
```

---

## API Integration

**Shared API Client:**
```typescript
// services/api/ApiClient.ts
import axios from 'axios';
import { SecureStorage } from '../storage/SecureStorage';

export class ApiClient {
  private client = axios.create({
    baseURL: process.env.API_URL,
    timeout: 30000,
  });

  constructor() {
    // Interceptor: Add auth token
    this.client.interceptors.request.use(async (config) => {
      const token = await SecureStorage.getToken();
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
      return config;
    });

    // Interceptor: Refresh token on 401
    this.client.interceptors.response.use(
      response => response,
      async error => {
        if (error.response?.status === 401) {
          await this.refreshToken();
          return this.client.request(error.config);
        }
        throw error;
      }
    );
  }

  private async refreshToken(): Promise<void> {
    const refreshToken = await SecureStorage.getRefreshToken();
    const { data } = await this.client.post('/api/auth/refresh', { refreshToken });
    await SecureStorage.setToken(data.accessToken);
  }

  // API methods match cloud platform endpoints
  async get<T>(url: string, params?: any): Promise<T>;
  async post<T>(url: string, data?: any): Promise<T>;
  async put<T>(url: string, data?: any): Promise<T>;
  async delete<T>(url: string): Promise<T>;
}
```

**Service Layer:**
```typescript
// services/api/TaskService.ts
export class TaskService {
  constructor(private api: ApiClient) {}

  async getTasks(filters?: TaskFilters): Promise<Task[]> {
    return this.api.get('/api/tasks', filters);
  }

  async getTask(id: string): Promise<Task> {
    return this.api.get(`/api/tasks/${id}`);
  }

  async updateTaskStatus(id: string, status: TaskStatus): Promise<Task> {
    return this.api.put(`/api/tasks/${id}`, { status });
  }

  async addComment(taskId: string, content: string): Promise<Comment> {
    return this.api.post(`/api/tasks/${taskId}/comments`, { content });
  }
}
```

---

## Testing Strategy

### Unit Tests
```bash
# Run all tests
npm test

# Watch mode
npm test -- --watch

# Coverage
npm test -- --coverage
```

**Example:**
```typescript
// __tests__/stores/taskStore.test.ts
import { renderHook, act } from '@testing-library/react-hooks';
import { useTaskStore } from '@/stores/taskStore';

describe('taskStore', () => {
  it('should fetch tasks', async () => {
    const { result } = renderHook(() => useTaskStore());

    await act(async () => {
      await result.current.fetchTasks();
    });

    expect(result.current.tasks.length).toBeGreaterThan(0);
    expect(result.current.loading).toBe(false);
  });
});
```

### Integration Tests
```typescript
// __tests__/integration/auth.test.ts
import { AuthService } from '@/services/api/AuthService';

describe('Authentication Flow', () => {
  it('should sign in and store tokens', async () => {
    const authService = new AuthService();

    const response = await authService.signIn('test@example.com', 'password');

    expect(response.user).toBeDefined();
    expect(response.accessToken).toBeDefined();
  });
});
```

### E2E Tests (Detox)
```typescript
// e2e/tasks.e2e.ts
describe('Tasks Screen', () => {
  beforeAll(async () => {
    await device.launchApp();
  });

  it('should display task list', async () => {
    await element(by.id('tasks-tab')).tap();
    await expect(element(by.id('task-list'))).toBeVisible();
  });

  it('should open task detail', async () => {
    await element(by.id('task-item-0')).tap();
    await expect(element(by.id('task-detail'))).toBeVisible();
  });
});
```

---

## Deployment

### iOS Build
```bash
# Development build
npm run ios

# Production build
cd ios && pod install
npx react-native run-ios --configuration Release

# Archive and upload to App Store Connect
xcodebuild -workspace ios/OrchestraMobile.xcworkspace \
  -scheme OrchestraMobile \
  -configuration Release \
  -archivePath build/OrchestraMobile.xcarchive \
  archive

# Export IPA
xcodebuild -exportArchive \
  -archivePath build/OrchestraMobile.xcarchive \
  -exportPath build \
  -exportOptionsPlist ExportOptions.plist
```

### Android Build
```bash
# Development build
npm run android

# Production build (AAB for Play Store)
cd android && ./gradlew bundleRelease

# Output: android/app/build/outputs/bundle/release/app-release.aab

# APK for sideloading
cd android && ./gradlew assembleRelease
# Output: android/app/build/outputs/apk/release/app-release.apk
```

### Environment Variables
```.env
# API Configuration
API_URL=https://orchestra.ai
WS_URL=wss://orchestra.ai

# Firebase
FIREBASE_API_KEY=xxx
FIREBASE_AUTH_DOMAIN=xxx
FIREBASE_PROJECT_ID=xxx
FIREBASE_STORAGE_BUCKET=xxx
FIREBASE_MESSAGING_SENDER_ID=xxx
FIREBASE_APP_ID=xxx
FIREBASE_MEASUREMENT_ID=xxx

# OAuth (if using direct OAuth instead of WebView)
GITHUB_CLIENT_ID=xxx
GOOGLE_CLIENT_ID=xxx

# Features
ENABLE_BIOMETRIC=true
ENABLE_OFFLINE_MODE=true
ENABLE_TERMINAL=true
ENABLE_CODE_VIEWER=true
```

---

## Documentation

### Setup Guide
```markdown
# docs/setup.md

## Development Environment

1. Install dependencies:
   npm install

2. Install iOS dependencies:
   cd ios && pod install

3. Set up environment:
   cp .env.example .env
   # Edit .env with your configuration

4. Run on iOS:
   npm run ios

5. Run on Android:
   npm run android
```

### Architecture Guide
```markdown
# docs/architecture.md

## Key Patterns

- **Offline-First**: All data cached locally, synced on reconnect
- **Event-Driven**: WebSocket events drive real-time updates
- **Store Pattern**: Zustand stores shared with web platform
- **Service Layer**: API services abstract network calls
- **Component Pattern**: Atomic design with shared UI components
```

---

## Success Criteria

### Functionality
- [ ] App runs on iOS 14+ and Android 8+
- [ ] OAuth authentication working
- [ ] Biometric authentication working
- [ ] All employee dashboard features working
- [ ] Team owner features working
- [ ] Real-time sync via WebSocket
- [ ] FCM push notifications working
- [ ] Code viewer with syntax highlighting
- [ ] Terminal access working
- [ ] Offline mode with queue sync
- [ ] Conflict resolution working
- [ ] Deep linking working

### Performance
- [ ] App startup < 3 seconds
- [ ] Screen transitions < 200ms
- [ ] API response handling < 500ms
- [ ] WebSocket reconnect < 2 seconds
- [ ] File tree loads < 1 second
- [ ] Markdown renders < 500ms

### Quality
- [ ] Test coverage > 80%
- [ ] Zero crashes in production
- [ ] < 1% ANR rate (Android)
- [ ] < 1% crash rate (iOS)
- [ ] App size < 50MB
- [ ] Memory usage < 150MB

### UX
- [ ] Dark mode support
- [ ] Tablet layouts (iPad/Android tablets)
- [ ] Accessibility labels
- [ ] VoiceOver/TalkBack support
- [ ] Landscape orientation support
- [ ] Pull-to-refresh on all lists
- [ ] Loading states on all screens
- [ ] Error states with retry
- [ ] Empty states with helpful messages

### Security
- [ ] Tokens stored in Keychain/Keystore
- [ ] SSL pinning enabled
- [ ] Biometric auth with fallback
- [ ] Session timeout after 15 minutes
- [ ] Auto-logout on security events

---

## Epics & Stories

### Epic 1: Foundation & Setup (OMB-1)
- Story: Project initialization & dependencies
- Story: Navigation structure
- Story: Theme system integration

### Epic 2: Authentication & Security (OMB-2)
- Story: OAuth integration
- Story: Biometric authentication
- Story: Session management

### Epic 3: Dashboard & Tasks (OMB-3)
- Story: Employee dashboard
- Story: Task list & detail
- Story: Task filters & search
- Story: Offline task management

### Epic 4: Real-time & WebSocket (OMB-4)
- Story: WebSocket service
- Story: Push notifications (FCM)

### Epic 5: Code Viewer & Terminal (OMB-5)
- Story: File tree browser
- Story: Code viewer with syntax highlighting
- Story: Terminal emulator

### Epic 6: Team & Collaboration (OMB-6)
- Story: Team dashboard
- Story: Team activity feed
- Story: Team management

---

## Dependencies

**From Cloud Platform (PRD 5):**
- Laravel API endpoints
- Sanctum token authentication
- WebSocket server (Laravel Reverb)
- User/Team models
- Task hierarchy models
- Real-time event system

**From Design System (ODS-1):**
- Design tokens (colors, spacing, typography)
- Component patterns
- Theme system

---

## Timeline Estimate

| Phase | Duration | Tasks |
|-------|----------|-------|
| Setup & Foundation | 1 week | Project init, navigation, theme |
| Authentication | 1 week | OAuth, biometric, session |
| Core Features (Tasks, Dashboard) | 2 weeks | UI, API, offline sync |
| Real-time (WebSocket, Push) | 1 week | Socket service, FCM |
| Code Viewer & Terminal | 2 weeks | File tree, syntax highlight, terminal |
| Team Features | 1 week | Team dashboard, activity |
| Testing & Polish | 2 weeks | Tests, performance, UX polish |
| **Total** | **10 weeks** | |

---

## Notes

- Share as much code as possible with web platform (types, API clients, stores)
- Use design tokens from design system for consistent theming
- Follow React Native best practices (FlatList for long lists, Image caching, etc.)
- Implement proper error boundaries
- Use TypeScript strict mode
- Follow accessibility guidelines (WCAG 2.1)
- Implement proper analytics tracking

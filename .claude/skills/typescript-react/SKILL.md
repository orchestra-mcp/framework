---
name: typescript-react
description: React and TypeScript patterns with Zustand state management. Activates when writing React components, hooks, stores, API clients, shared types, or any TypeScript frontend code.
---

# TypeScript & React — Components + Zustand + Shared Types

All five frontends (Desktop, Chrome Extension, Mobile, Web Dashboard, Admin Panel) share a common React + TypeScript foundation with Zustand for state management.

## Project Structure

```
resources/
├── package.json              # Root workspace config
├── pnpm-workspace.yaml
├── turbo.json                # Build orchestration
├── tsconfig.base.json        # Shared TS config
│
├── shared/                   # @orchestra/shared — types, API, hooks, stores
│   ├── package.json
│   ├── tsconfig.json
│   ├── types/
│   │   ├── user.ts
│   │   ├── project.ts
│   │   ├── file.ts
│   │   ├── sync.ts
│   │   └── api.ts
│   ├── api/
│   │   ├── client.ts         # Base API client (fetch wrapper)
│   │   ├── auth.ts           # Auth endpoints
│   │   ├── projects.ts       # Project endpoints
│   │   └── sync.ts           # Sync endpoints
│   ├── hooks/
│   │   ├── useAuth.ts
│   │   ├── useProjects.ts
│   │   ├── useSync.ts
│   │   └── useWebSocket.ts
│   ├── stores/
│   │   ├── auth.store.ts
│   │   ├── project.store.ts
│   │   ├── editor.store.ts
│   │   └── sync.store.ts
│   └── utils/
│       ├── format.ts
│       ├── validation.ts
│       └── constants.ts
│
├── ui/                       # @orchestra/ui — shared component library
│   ├── package.json
│   ├── components/
│   ├── layouts/
│   └── theme/
│
├── extension/                # Chrome Extension app
├── dashboard/                # Web Dashboard app
├── admin/                    # Admin Panel app
├── desktop/                  # Wails Desktop app
└── mobile/                   # React Native app
```

## Shared Types

```typescript
// resources/shared/types/user.ts
export interface User {
  id: string;
  email: string;
  name: string;
  avatar_url?: string;
  plan: 'free' | 'pro' | 'team' | 'enterprise';
  settings: Record<string, unknown>;
  created_at: string;
  updated_at: string;
}

// resources/shared/types/project.ts
export interface Project {
  id: string;
  name: string;
  path?: string;
  settings: ProjectSettings;
  last_synced_at?: string;
  created_at: string;
  updated_at: string;
}

export interface ProjectSettings {
  theme?: string;
  font_size?: number;
  tab_size?: number;
  auto_save?: boolean;
}

// resources/shared/types/sync.ts
export interface SyncEvent {
  entity_id: string;
  entity_type: string;
  action: 'create' | 'update' | 'delete';
  data: unknown;
  version: number;
  timestamp: string;
  device_id: string;
  checksum: string;
}

export interface SyncState {
  last_sync_version: number;
  device_id: string;
  is_syncing: boolean;
  pending_count: number;
}

// resources/shared/types/api.ts
export interface ApiResponse<T> {
  data: T;
}

export interface ApiError {
  error: string;
  message: string;
  details?: Record<string, string>;
}

export interface PaginatedResponse<T> {
  data: T[];
  meta: {
    page: number;
    per_page: number;
    total: number;
    last_page: number;
  };
}
```

## API Client

```typescript
// resources/shared/api/client.ts
const API_BASE = import.meta.env.VITE_API_URL || 'http://localhost:3000/api/v1';

class ApiClient {
  private token: string | null = null;

  setToken(token: string) {
    this.token = token;
  }

  clearToken() {
    this.token = null;
  }

  private async request<T>(path: string, options: RequestInit = {}): Promise<T> {
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
      ...options.headers as Record<string, string>,
    };

    if (this.token) {
      headers['Authorization'] = `Bearer ${this.token}`;
    }

    const response = await fetch(`${API_BASE}${path}`, {
      ...options,
      headers,
    });

    if (!response.ok) {
      const error = await response.json() as ApiError;
      throw new ApiRequestError(response.status, error);
    }

    return response.json();
  }

  get<T>(path: string) {
    return this.request<T>(path);
  }

  post<T>(path: string, body: unknown) {
    return this.request<T>(path, { method: 'POST', body: JSON.stringify(body) });
  }

  put<T>(path: string, body: unknown) {
    return this.request<T>(path, { method: 'PUT', body: JSON.stringify(body) });
  }

  delete(path: string) {
    return this.request(path, { method: 'DELETE' });
  }
}

export class ApiRequestError extends Error {
  constructor(public status: number, public error: ApiError) {
    super(error.message);
  }
}

export const api = new ApiClient();
```

## Zustand Store Pattern

```typescript
// resources/shared/stores/auth.store.ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { User } from '../types/user';
import { api } from '../api/client';

interface AuthState {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
  isLoading: boolean;
}

interface AuthActions {
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
  refresh: () => Promise<void>;
  setUser: (user: User) => void;
}

export const useAuthStore = create<AuthState & AuthActions>()(
  persist(
    (set, get) => ({
      user: null,
      token: null,
      isAuthenticated: false,
      isLoading: false,

      login: async (email, password) => {
        set({ isLoading: true });
        try {
          const { data } = await api.post<{ data: { user: User; token: string } }>(
            '/auth/login',
            { email, password }
          );
          api.setToken(data.token);
          set({ user: data.user, token: data.token, isAuthenticated: true });
        } finally {
          set({ isLoading: false });
        }
      },

      logout: () => {
        api.clearToken();
        set({ user: null, token: null, isAuthenticated: false });
      },

      refresh: async () => {
        const { token } = get();
        if (!token) return;
        api.setToken(token);
        const { data } = await api.get<{ data: User }>('/users/me');
        set({ user: data, isAuthenticated: true });
      },

      setUser: (user) => set({ user }),
    }),
    {
      name: 'orchestra-auth',
      partialize: (state) => ({ token: state.token }),
    }
  )
);
```

```typescript
// resources/shared/stores/project.store.ts
import { create } from 'zustand';
import type { Project } from '../types/project';
import { api } from '../api/client';

interface ProjectState {
  projects: Project[];
  activeProject: Project | null;
  isLoading: boolean;
}

interface ProjectActions {
  fetchProjects: () => Promise<void>;
  setActiveProject: (project: Project | null) => void;
  createProject: (name: string, path?: string) => Promise<Project>;
  updateProject: (id: string, updates: Partial<Project>) => Promise<void>;
  deleteProject: (id: string) => Promise<void>;
}

export const useProjectStore = create<ProjectState & ProjectActions>()((set, get) => ({
  projects: [],
  activeProject: null,
  isLoading: false,

  fetchProjects: async () => {
    set({ isLoading: true });
    try {
      const { data } = await api.get<{ data: Project[] }>('/projects');
      set({ projects: data });
    } finally {
      set({ isLoading: false });
    }
  },

  setActiveProject: (project) => set({ activeProject: project }),

  createProject: async (name, path) => {
    const { data } = await api.post<{ data: Project }>('/projects', { name, path });
    set((state) => ({ projects: [...state.projects, data] }));
    return data;
  },

  updateProject: async (id, updates) => {
    const { data } = await api.put<{ data: Project }>(`/projects/${id}`, updates);
    set((state) => ({
      projects: state.projects.map((p) => (p.id === id ? data : p)),
      activeProject: state.activeProject?.id === id ? data : state.activeProject,
    }));
  },

  deleteProject: async (id) => {
    await api.delete(`/projects/${id}`);
    set((state) => ({
      projects: state.projects.filter((p) => p.id !== id),
      activeProject: state.activeProject?.id === id ? null : state.activeProject,
    }));
  },
}));
```

## WebSocket Hook

```typescript
// resources/shared/hooks/useWebSocket.ts
import { useEffect, useRef, useCallback } from 'react';
import type { SyncEvent } from '../types/sync';

interface UseWebSocketOptions {
  url: string;
  token: string;
  onMessage: (event: SyncEvent) => void;
  onConnect?: () => void;
  onDisconnect?: () => void;
  reconnectInterval?: number;
}

export function useWebSocket({
  url,
  token,
  onMessage,
  onConnect,
  onDisconnect,
  reconnectInterval = 3000,
}: UseWebSocketOptions) {
  const wsRef = useRef<WebSocket | null>(null);
  const reconnectRef = useRef<NodeJS.Timeout>();

  const connect = useCallback(() => {
    const ws = new WebSocket(`${url}?token=${token}`);

    ws.onopen = () => {
      onConnect?.();
    };

    ws.onmessage = (event) => {
      const data = JSON.parse(event.data) as SyncEvent;
      onMessage(data);
    };

    ws.onclose = () => {
      onDisconnect?.();
      reconnectRef.current = setTimeout(connect, reconnectInterval);
    };

    wsRef.current = ws;
  }, [url, token, onMessage, onConnect, onDisconnect, reconnectInterval]);

  const send = useCallback((data: unknown) => {
    wsRef.current?.send(JSON.stringify(data));
  }, []);

  useEffect(() => {
    connect();
    return () => {
      clearTimeout(reconnectRef.current);
      wsRef.current?.close();
    };
  }, [connect]);

  return { send };
}
```

## Component Pattern

```typescript
// Functional component with proper typing
import { type FC } from 'react';
import type { Project } from '@orchestra/shared/types/project';

interface ProjectCardProps {
  project: Project;
  onSelect: (project: Project) => void;
  onDelete?: (id: string) => void;
  isActive?: boolean;
}

export const ProjectCard: FC<ProjectCardProps> = ({
  project,
  onSelect,
  onDelete,
  isActive = false,
}) => {
  return (
    <div
      className={cn(
        "rounded-lg border p-4 cursor-pointer transition-colors",
        isActive ? "border-primary bg-primary/5" : "border-border hover:border-primary/50"
      )}
      onClick={() => onSelect(project)}
    >
      <h3 className="font-medium text-sm">{project.name}</h3>
      {project.path && (
        <p className="text-xs text-muted-foreground mt-1 truncate">{project.path}</p>
      )}
      {onDelete && (
        <button
          className="text-xs text-destructive mt-2"
          onClick={(e) => { e.stopPropagation(); onDelete(project.id); }}
        >
          Delete
        </button>
      )}
    </div>
  );
};
```

## Testing with Vitest

```typescript
// resources/shared/__tests__/stores/project.store.test.ts
import { describe, it, expect, beforeEach, vi } from 'vitest';
import { useProjectStore } from '../../stores/project.store';

// Mock API
vi.mock('../../api/client', () => ({
  api: {
    get: vi.fn(),
    post: vi.fn(),
    put: vi.fn(),
    delete: vi.fn(),
  },
}));

describe('ProjectStore', () => {
  beforeEach(() => {
    useProjectStore.setState({
      projects: [],
      activeProject: null,
      isLoading: false,
    });
  });

  it('fetches projects', async () => {
    const mockProjects = [{ id: '1', name: 'Test' }];
    const { api } = await import('../../api/client');
    vi.mocked(api.get).mockResolvedValue({ data: mockProjects });

    await useProjectStore.getState().fetchProjects();

    expect(useProjectStore.getState().projects).toEqual(mockProjects);
    expect(useProjectStore.getState().isLoading).toBe(false);
  });
});
```

## Data Fetching (React Query + Axios)

```typescript
// resources/shared/api/axios.ts
import axios from 'axios';
import { useAuthStore } from '../stores/auth.store';

export const http = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:3000/api/v1',
  headers: { 'Content-Type': 'application/json' },
});

// Auth interceptor
http.interceptors.request.use((config) => {
  const token = useAuthStore.getState().token;
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

// Error interceptor
http.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      useAuthStore.getState().logout();
    }
    return Promise.reject(error);
  }
);
```

```typescript
// resources/shared/hooks/useProjects.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { http } from '../api/axios';
import type { Project, ApiResponse, PaginatedResponse } from '../types';

export function useProjects() {
  return useQuery({
    queryKey: ['projects'],
    queryFn: () => http.get<ApiResponse<Project[]>>('/projects').then(r => r.data.data),
  });
}

export function useProject(id: string) {
  return useQuery({
    queryKey: ['projects', id],
    queryFn: () => http.get<ApiResponse<Project>>(`/projects/${id}`).then(r => r.data.data),
    enabled: !!id,
  });
}

export function useCreateProject() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: { name: string; path?: string }) =>
      http.post<ApiResponse<Project>>('/projects', data).then(r => r.data.data),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['projects'] }),
  });
}

export function useDeleteProject() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (id: string) => http.delete(`/projects/${id}`),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['projects'] }),
  });
}
```

```typescript
// resources/dashboard/src/App.tsx — React Query provider setup
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000,    // 5 minutes
      retry: 1,
      refetchOnWindowFocus: false,
    },
  },
});

export function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <RouterProvider router={router} />
    </QueryClientProvider>
  );
}
```

## Routing (React Router)

```typescript
// resources/dashboard/src/router.tsx
import { createBrowserRouter, Navigate } from 'react-router-dom';
import { AppLayout } from '@orchestra/ui/layouts/AppLayout';

export const router = createBrowserRouter([
  {
    path: '/',
    element: <AppLayout />,
    children: [
      { index: true, element: <Navigate to="/projects" replace /> },
      { path: 'projects', element: <ProjectsPage /> },
      { path: 'projects/:id', element: <ProjectDetailPage /> },
      { path: 'settings', element: <SettingsPage /> },
      { path: 'billing', element: <BillingPage /> },
    ],
  },
  { path: '/login', element: <LoginPage /> },
  { path: '/register', element: <RegisterPage /> },
  { path: '*', element: <NotFoundPage /> },
]);
```

## Code Editor (Monaco)

```typescript
// resources/shared/components/CodeEditor.tsx
import { type FC, useRef, useEffect } from 'react';
import * as monaco from 'monaco-editor';

interface CodeEditorProps {
  value: string;
  language: string;
  onChange?: (value: string) => void;
  readOnly?: boolean;
  theme?: 'vs-dark' | 'vs-light';
  height?: string;
}

export const CodeEditor: FC<CodeEditorProps> = ({
  value,
  language,
  onChange,
  readOnly = false,
  theme = 'vs-dark',
  height = '400px',
}) => {
  const containerRef = useRef<HTMLDivElement>(null);
  const editorRef = useRef<monaco.editor.IStandaloneCodeEditor | null>(null);

  useEffect(() => {
    if (!containerRef.current) return;

    const editor = monaco.editor.create(containerRef.current, {
      value,
      language,
      theme,
      readOnly,
      minimap: { enabled: false },
      fontSize: 14,
      lineNumbers: 'on',
      scrollBeyondLastLine: false,
      automaticLayout: true,
    });

    editor.onDidChangeModelContent(() => {
      onChange?.(editor.getValue());
    });

    editorRef.current = editor;
    return () => editor.dispose();
  }, [language, theme, readOnly]);

  useEffect(() => {
    if (editorRef.current && value !== editorRef.current.getValue()) {
      editorRef.current.setValue(value);
    }
  }, [value]);

  return <div ref={containerRef} style={{ height, width: '100%' }} />;
};
```

## Terminal (xterm.js)

```typescript
// resources/shared/components/Terminal.tsx
import { type FC, useRef, useEffect } from 'react';
import { Terminal as XTerm } from '@xterm/xterm';
import { FitAddon } from '@xterm/addon-fit';
import { WebLinksAddon } from '@xterm/addon-web-links';
import '@xterm/xterm/css/xterm.css';

interface TerminalProps {
  wsUrl: string;
  onData?: (data: string) => void;
}

export const Terminal: FC<TerminalProps> = ({ wsUrl, onData }) => {
  const containerRef = useRef<HTMLDivElement>(null);
  const termRef = useRef<XTerm | null>(null);

  useEffect(() => {
    if (!containerRef.current) return;

    const term = new XTerm({
      cursorBlink: true,
      fontSize: 14,
      fontFamily: 'JetBrains Mono, Menlo, monospace',
      theme: {
        background: '#1e1e2e',
        foreground: '#cdd6f4',
      },
    });

    const fitAddon = new FitAddon();
    term.loadAddon(fitAddon);
    term.loadAddon(new WebLinksAddon());
    term.open(containerRef.current);
    fitAddon.fit();

    // Connect to backend terminal WebSocket
    const ws = new WebSocket(wsUrl);
    ws.onmessage = (event) => term.write(event.data);
    term.onData((data) => {
      ws.send(data);
      onData?.(data);
    });

    const resizeObserver = new ResizeObserver(() => fitAddon.fit());
    resizeObserver.observe(containerRef.current);

    termRef.current = term;
    return () => {
      resizeObserver.disconnect();
      ws.close();
      term.dispose();
    };
  }, [wsUrl]);

  return <div ref={containerRef} style={{ height: '100%', width: '100%' }} />;
};
```

## Build Tool (Vite)

```typescript
// resources/dashboard/vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@orchestra/shared': path.resolve(__dirname, '../shared'),
      '@orchestra/ui': path.resolve(__dirname, '../ui'),
    },
  },
  server: {
    port: 5173,
    proxy: {
      '/api': { target: 'http://localhost:3000', changeOrigin: true },
      '/ws': { target: 'ws://localhost:3000', ws: true },
    },
  },
  build: {
    outDir: 'dist',
    sourcemap: true,
  },
});
```

## Conventions

- Import types with `type` keyword: `import type { User } from '...'`
- Use `FC` for component typing (no children by default)
- Zustand stores: separate `State` and `Actions` interfaces, combine in `create<State & Actions>()`
- Use `persist` middleware for stores that need to survive page reloads
- All API responses typed with `ApiResponse<T>` or `PaginatedResponse<T>`
- Shared code in `@orchestra/shared`, UI components in `@orchestra/ui`
- Platform-specific code stays in the app directory, never in shared packages
- Use `cn()` utility (from `@orchestra/ui`) for conditional class names
- Use React Query for server state, Zustand for client state
- Use Axios with interceptors for HTTP, not raw fetch (except in `@orchestra/shared/api/client.ts` base)
- Monaco Editor for code editing, xterm.js for terminal — both in `@orchestra/shared/components/`
- Vite for all frontend builds, resolve `@orchestra/*` aliases in each app's config

## Don'ts

- Don't create stores inside components — stores are module-level singletons
- Don't use `any` type — use `unknown` and narrow with type guards
- Don't put platform-specific code in `@orchestra/shared`
- Don't use relative imports across packages — use `@orchestra/*` aliases
- Don't use class components — functional components only
- Don't duplicate types that exist in shared — import them
- Don't mix React Query and Zustand for the same data — server state in RQ, client state in Zustand
- Don't import Monaco or xterm.js in mobile — they're web/desktop only
- Don't skip the QueryClient provider — every app needs it at the root

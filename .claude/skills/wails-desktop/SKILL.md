---
name: wails-desktop
description: Wails v3 desktop application patterns. Activates when working on the desktop app, Go-React bindings, system tray, window management, or native desktop features.
---

# Wails Desktop — Go + React Desktop App

The desktop app is built with Wails v3, combining a Go backend with a React frontend rendered in a native webview.

## Project Structure

```
cmd/desktop/main.go            # Wails entry point

resources/desktop/              # Desktop frontend
├── package.json
├── vite.config.ts
├── tsconfig.json
├── index.html
├── wailsjs/                    # Auto-generated Go bindings
│   ├── go/
│   │   └── main/
│   │       ├── App.d.ts
│   │       └── App.js
│   └── runtime/
│       └── runtime.d.ts
├── src/
│   ├── App.tsx
│   ├── main.tsx
│   ├── pages/
│   │   ├── Editor.tsx
│   │   ├── Terminal.tsx
│   │   ├── Explorer.tsx
│   │   └── Settings.tsx
│   ├── components/
│   │   ├── TitleBar.tsx       # Custom title bar (frameless window)
│   │   ├── StatusBar.tsx
│   │   └── TrayMenu.tsx
│   └── hooks/
│       ├── useWailsEvent.ts
│       └── useNativeDialog.ts
└── public/
    └── appicon.png
```

## Go Entry Point

```go
// cmd/desktop/main.go
package main

import (
    "context"
    "embed"

    "github.com/wailsapp/wails/v3/pkg/application"
)

//go:embed all:frontend/dist
var assets embed.FS

type App struct {
    ctx     context.Context
    engine  *services.EngineClient
    sync    *services.SyncService
}

func NewApp() *App {
    return &App{}
}

func (a *App) OnStartup(ctx context.Context) {
    a.ctx = ctx
    a.engine = services.NewEngineClient()
    a.sync = services.NewSyncService()
}

func (a *App) OnShutdown(ctx context.Context) {
    a.engine.Close()
    a.sync.Close()
}

// Exposed to frontend via wailsjs bindings
func (a *App) OpenProject(path string) (*models.Project, error) {
    return a.sync.OpenProject(a.ctx, path)
}

func (a *App) ReadFile(projectID, path string) (string, error) {
    return a.engine.ReadFile(a.ctx, projectID, path)
}

func (a *App) SearchCode(projectID, query string) ([]models.SearchResult, error) {
    return a.engine.Search(a.ctx, projectID, query)
}

func (a *App) GetTerminalOutput(sessionID string) (string, error) {
    return a.engine.GetTerminalOutput(a.ctx, sessionID)
}

func main() {
    app := application.New(application.Options{
        Name:        "Orchestra",
        Description: "AI-agentic IDE",
        Assets: application.AssetOptions{
            FS: assets,
        },
        Mac: application.MacOptions{
            ApplicationShouldTerminateAfterLastWindowClosed: false,
        },
    })

    mainApp := NewApp()

    app.NewWebviewWindowWithOptions(application.WebviewWindowOptions{
        Title:     "Orchestra",
        Width:     1400,
        Height:    900,
        MinWidth:  800,
        MinHeight: 600,
        Frameless: true,
        URL:       "/",
    })

    // System tray
    tray := app.NewSystemTray()
    tray.SetLabel("Orchestra")
    trayMenu := app.NewMenu()
    trayMenu.Add("Show").OnClick(func(ctx *application.Context) {
        // Show main window
    })
    trayMenu.Add("Quit").OnClick(func(ctx *application.Context) {
        app.Quit()
    })
    tray.SetMenu(trayMenu)

    app.OnStartup(mainApp.OnStartup)
    app.OnShutdown(mainApp.OnShutdown)

    if err := app.Run(); err != nil {
        panic(err)
    }
}
```

## Frontend Calling Go Functions

```typescript
// Auto-generated in wailsjs/go/main/App.js
// Import and call directly:
import { OpenProject, ReadFile, SearchCode } from '../../wailsjs/go/main/App';

// In a component:
const handleOpenProject = async (path: string) => {
  try {
    const project = await OpenProject(path);
    useProjectStore.getState().setActiveProject(project);
  } catch (err) {
    console.error('Failed to open project:', err);
  }
};
```

## Wails Event System

```typescript
// resources/desktop/src/hooks/useWailsEvent.ts
import { useEffect } from 'react';
import { EventsOn, EventsOff } from '../../wailsjs/runtime/runtime';

export function useWailsEvent<T>(eventName: string, callback: (data: T) => void) {
  useEffect(() => {
    EventsOn(eventName, callback);
    return () => EventsOff(eventName);
  }, [eventName, callback]);
}

// Usage:
useWailsEvent<SyncEvent>('sync:update', (event) => {
  useSyncStore.getState().applyRemoteChange(event);
});
```

## Go Emitting Events to Frontend

```go
// From Go backend, emit events to all windows
func (a *App) notifySyncUpdate(event SyncEvent) {
    application.Get().EmitEvent("sync:update", event)
}
```

## Custom Title Bar (Frameless Window)

```tsx
// resources/desktop/src/components/TitleBar.tsx
import { type FC } from 'react';

export const TitleBar: FC<{ title: string }> = ({ title }) => {
  return (
    <div
      className="h-9 bg-sidebar flex items-center px-3 select-none"
      style={{ '--wails-draggable': 'drag' } as React.CSSProperties}
    >
      {/* macOS traffic lights occupy left ~70px */}
      <div className="w-[70px]" />
      <span className="text-xs text-muted-foreground flex-1 text-center">{title}</span>
      <div className="w-[70px]" />
    </div>
  );
};
```

## Native Dialog Hook

```typescript
// resources/desktop/src/hooks/useNativeDialog.ts
import { OpenFileDialog, SaveFileDialog, MessageDialog } from '../../wailsjs/runtime/runtime';

export function useNativeDialog() {
  return {
    openFile: (options?: { title?: string; filters?: string[] }) =>
      OpenFileDialog({
        Title: options?.title || 'Open File',
        Filters: options?.filters?.join(';') || '*',
      }),

    saveFile: (options?: { title?: string; defaultFilename?: string }) =>
      SaveFileDialog({
        Title: options?.title || 'Save File',
        DefaultFilename: options?.defaultFilename || '',
      }),

    confirm: (title: string, message: string) =>
      MessageDialog({
        Title: title,
        Message: message,
        Type: 'question',
        Buttons: ['Yes', 'No'],
      }),
  };
}
```

## Development Commands

```bash
# Dev mode with hot reload
make dev-desktop       # or: cd cmd/desktop && wails dev

# Build production binary
make build-desktop     # or: cd cmd/desktop && wails build

# Generate Go bindings after changing exported methods
# Automatic in wails dev mode
```

## Conventions

- All Go functions exposed to frontend must be methods on the `App` struct
- Use Wails events for Go→Frontend push notifications
- Use direct function calls for Frontend→Go requests
- Frameless window with custom title bar (macOS-style)
- System tray for background operation
- Desktop app connects to local Rust engine via gRPC (localhost)
- Desktop app connects to cloud sync via WebSocket
- Local SQLite managed by Rust engine, not Go directly

## Don'ts

- Don't use `http.ListenAndServe` for internal communication — use Wails bindings
- Don't access the filesystem from React — call Go functions instead
- Don't use Electron-style IPC — Wails bindings are direct function calls
- Don't put heavy computation in Go event handlers — use goroutines
- Don't assume network connectivity — desktop must work offline via local SQLite

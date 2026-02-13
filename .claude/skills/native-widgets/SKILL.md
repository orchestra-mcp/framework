---
name: native-widgets
description: Cross-platform native widget system for macOS (WidgetKit/Swift), Windows (Adaptive Cards/C#), and Linux (GNOME/KDE). Activates when working on the widget bridge, platform-specific widget code, widget data contracts, or build tags for darwin/windows/linux.
---

# Native Widgets — Cross-Platform Widget Bridge

Orchestra has native OS widgets on all desktop platforms. The Go app writes JSON data via a platform-agnostic bridge interface, and tiny native widget layers render it.

## Architecture

```
Go App (Wails)
  │
  └── bridge.NewWidgetBridge()   ← Factory, picks platform via build tags
        │
        ├── macOS:   Writes JSON to App Group → Swift WidgetKit reads it
        ├── Windows: Writes JSON to AppData  → C# Adaptive Cards reads it
        └── Linux:   Writes JSON to ~/.local → GNOME Extension / KDE Plasmoid reads it
```

## Project Structure

```
bridge/
├── bridge.go                    # WidgetBridge interface + WidgetData struct
├── factory.go                   # NewWidgetBridge() factory
│
├── macos/
│   ├── bridge_darwin.go         # //go:build darwin — App Group JSON + WidgetKit reload
│   └── widget/                  # Swift WidgetKit extension (~200 lines)
│       ├── Package.swift
│       └── Sources/
│           ├── Widget.swift
│           ├── WidgetBundle.swift
│           ├── Provider.swift   # TimelineProvider reads shared JSON
│           └── Views/
│               ├── SmallView.swift
│               ├── MediumView.swift
│               └── LargeView.swift
│
├── windows/
│   ├── bridge_windows.go        # //go:build windows — AppData JSON + COM notification
│   └── widget/                  # C# Windows 11 Widgets (~200 lines)
│       ├── Widget.csproj
│       └── Widgets/
│           ├── SmallWidget.xaml
│           ├── MediumWidget.xaml
│           └── WidgetProvider.cs  # IWidgetProvider, Adaptive Cards
│
└── linux/
    ├── bridge_linux.go          # //go:build linux — .local JSON + DBus signal
    └── widget/
        ├── gnome-extension/     # GNOME Shell extension (~150 lines)
        │   ├── metadata.json
        │   └── extension.js     # PanelMenu.Button, polls JSON
        └── kde-plasmoid/        # KDE Plasmoid (~100 lines)
            ├── metadata.json
            └── contents/
                └── ui/
                    └── main.qml  # Qt Quick, polls JSON
```

## Shared Go Interface

```go
// bridge/bridge.go
package bridge

import "time"

// WidgetData is the contract between Go and all native widget layers.
// Changes here require updates to Swift, C#, JS, and QML renderers.
type WidgetData struct {
    Projects      []WidgetProject `json:"projects"`
    ActiveProject string          `json:"active_project"`
    TotalFiles    int             `json:"total_files"`
    LastSync      time.Time       `json:"last_sync"`
    Status        string          `json:"status"`       // synced, syncing, offline, error
    GitBranch     string          `json:"git_branch"`
    GitChanges    int             `json:"git_changes"`
}

type WidgetProject struct {
    Name         string    `json:"name"`
    FilesChanged int       `json:"files_changed"`
    LastEdited   time.Time `json:"last_edited"`
    Language     string    `json:"language"`
    SyncStatus   string    `json:"sync_status"`
}

// WidgetBridge — each platform implements this.
type WidgetBridge interface {
    UpdateWidget(data WidgetData) error
    RefreshWidget() error
    IsSupported() bool
}
```

```go
// bridge/factory.go
package bridge

// NewWidgetBridge creates the right bridge per platform.
// Go build tags route to the correct implementation automatically.
func NewWidgetBridge() WidgetBridge {
    return newPlatformBridge()
}
```

## Platform Implementations

### macOS (`bridge_darwin.go`)

```go
//go:build darwin

package bridge

/*
#cgo CFLAGS: -x objective-c
#cgo LDFLAGS: -framework Foundation -framework WidgetKit
#import <Foundation/Foundation.h>
#import <WidgetKit/WidgetKit.h>

const char* getAppGroupPath() {
    NSURL *url = [[NSFileManager defaultManager]
        containerURLForSecurityApplicationGroupIdentifier:
        @"group.com.orchestra.shared"];
    return [url.path UTF8String];
}

void refreshAllWidgets() {
    [WidgetCenter.shared reloadAllTimelines];
}
*/
import "C"

type macOSBridge struct {
    sharedPath string
}

func newPlatformBridge() WidgetBridge {
    return &macOSBridge{
        sharedPath: C.GoString(C.getAppGroupPath()),
    }
}

func (b *macOSBridge) UpdateWidget(data WidgetData) error {
    jsonData, err := json.Marshal(data)
    if err != nil {
        return err
    }
    path := filepath.Join(b.sharedPath, "widget-data.json")
    return os.WriteFile(path, jsonData, 0644)
}

func (b *macOSBridge) RefreshWidget() error {
    C.refreshAllWidgets()
    return nil
}

func (b *macOSBridge) IsSupported() bool { return true }
```

### Windows (`bridge_windows.go`)

```go
//go:build windows

package bridge

type windowsBridge struct {
    dataPath string
}

func newPlatformBridge() WidgetBridge {
    appData := os.Getenv("LOCALAPPDATA")
    return &windowsBridge{
        dataPath: filepath.Join(appData, "Orchestra", "widgets"),
    }
}

func (b *windowsBridge) UpdateWidget(data WidgetData) error {
    os.MkdirAll(b.dataPath, 0755)
    jsonData, err := json.Marshal(data)
    if err != nil {
        return err
    }
    return os.WriteFile(filepath.Join(b.dataPath, "widget-data.json"), jsonData, 0644)
}

func (b *windowsBridge) RefreshWidget() error {
    return notifyWidgetUpdate() // COM interop
}

func (b *windowsBridge) IsSupported() bool {
    return isWindows11OrLater()
}
```

### Linux (`bridge_linux.go`)

```go
//go:build linux

package bridge

type linuxBridge struct {
    dataPath string
    desktop  string // "gnome", "kde", "other"
}

func newPlatformBridge() WidgetBridge {
    home := os.Getenv("HOME")
    return &linuxBridge{
        dataPath: filepath.Join(home, ".local", "share", "orchestra", "widgets"),
        desktop:  detectDesktop(),
    }
}

func detectDesktop() string {
    de := os.Getenv("XDG_CURRENT_DESKTOP")
    switch {
    case strings.Contains(de, "GNOME"):
        return "gnome"
    case strings.Contains(de, "KDE"):
        return "kde"
    default:
        return "other"
    }
}

func (b *linuxBridge) UpdateWidget(data WidgetData) error {
    os.MkdirAll(b.dataPath, 0755)
    jsonData, err := json.Marshal(data)
    if err != nil {
        return err
    }
    if err := os.WriteFile(filepath.Join(b.dataPath, "widget-data.json"), jsonData, 0644); err != nil {
        return err
    }
    return b.sendDBusNotification()
}

func (b *linuxBridge) RefreshWidget() error {
    return b.sendDBusNotification()
}

func (b *linuxBridge) sendDBusNotification() error {
    conn, err := dbus.SessionBus()
    if err != nil {
        return err
    }
    return conn.Emit("/com/orchestra/widget", "com.orchestra.Widget.Updated")
}

func (b *linuxBridge) IsSupported() bool {
    return b.desktop == "gnome" || b.desktop == "kde"
}
```

## Using the Bridge from the App

```go
// cmd/desktop/main.go
func main() {
    widget := bridge.NewWidgetBridge()

    if widget.IsSupported() {
        onProjectChanged(func(project *models.Project) {
            widget.UpdateWidget(bridge.WidgetData{
                ActiveProject: project.Name,
                GitBranch:     project.CurrentBranch(),
                GitChanges:    project.UncommittedCount(),
                Status:        project.SyncStatus(),
                Projects:      getRecentProjects(),
                LastSync:      project.LastSyncTime(),
            })
            widget.RefreshWidget()
        })
    }
}
```

## Swift WidgetKit (macOS — the only Swift requirement)

```swift
// bridge/macos/widget/Sources/Provider.swift
struct Provider: TimelineProvider {
    func getTimeline(in context: Context, completion: @escaping (Timeline<ProjectEntry>) -> Void) {
        let url = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.com.orchestra.shared")!
            .appendingPathComponent("widget-data.json")

        guard let data = try? Data(contentsOf: url),
              let widget = try? JSONDecoder().decode(WidgetData.self, from: data) else {
            let entry = ProjectEntry(date: Date(), data: .placeholder)
            completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60))))
            return
        }

        let entry = ProjectEntry(date: Date(), data: widget)
        completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(300))))
    }
}
```

```swift
// bridge/macos/widget/Sources/Views/SmallView.swift
struct SmallView: View {
    let data: WidgetData

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(data.activeProject).font(.headline).lineLimit(1)
            Text("🔀 \(data.gitBranch)").font(.caption)
            Spacer()
            HStack {
                Circle()
                    .fill(data.status == "synced" ? Color.green : Color.yellow)
                    .frame(width: 8, height: 8)
                Text(data.status).font(.caption2)
            }
        }
        .padding()
    }
}
```

## C# Windows Widget (Adaptive Cards)

Windows 11 widgets use Adaptive Cards JSON. The WidgetProvider reads Go's JSON and renders an Adaptive Card.

Key file: `bridge/windows/widget/Widgets/WidgetProvider.cs` — implements `IWidgetProvider`, reads from `%LOCALAPPDATA%\Orchestra\widgets\widget-data.json`.

## GNOME Extension

JavaScript extension that adds a panel menu button. Polls `~/.local/share/orchestra/widgets/widget-data.json` every 5 seconds. Shows active project, git branch, sync status, and recent projects list.

Key file: `bridge/linux/widget/gnome-extension/extension.js`

## KDE Plasmoid

QML widget that polls the same JSON path. Uses Qt Quick components for a native KDE look.

Key file: `bridge/linux/widget/kde-plasmoid/contents/ui/main.qml`

## Build Commands

```makefile
# macOS — Go app + Swift widget
build-macos:
	wails build -platform darwin/universal
	cd bridge/macos/widget && xcodebuild build
	# Bundle widget into .app

# Windows — Go app + C# widget
build-windows:
	wails build -platform windows/amd64
	cd bridge/windows/widget && dotnet build

# Linux — Go app + package extensions
build-linux:
	wails build -platform linux/amd64
	cd bridge/linux/widget/gnome-extension && zip -r youride-widget@orchestra.zip .
	cd bridge/linux/widget/kde-plasmoid && zip -r com.orchestra.widget.plasmoid .
```

## Data Contract Rules

- `WidgetData` in `bridge/bridge.go` is the single source of truth
- Any field change requires updating ALL native renderers (Swift, C#, JS, QML)
- JSON is the only communication mechanism — no IPC, no sockets, no shared memory
- Go writes, native widgets read — never the reverse direction
- Refresh polling: macOS uses TimelineProvider (5-min intervals), Linux polls every 5s, Windows uses COM notification

## Conventions

- All platform-specific Go code uses build tags (`//go:build darwin`, etc.)
- CGo only for macOS APIs — never for business logic
- Native widget code is minimal (~100-200 lines per platform) — all data from Go
- Widget data is project-level info only — never full file contents
- JSON files written atomically (write to temp, rename) to avoid partial reads

## Don'ts

- Don't put business logic in Swift/C#/JS/QML — they only render what Go provides
- Don't use platform-specific APIs without build tags — it won't compile cross-platform
- Don't poll faster than 5 seconds on Linux — battery impact
- Don't store secrets in widget data JSON — it's world-readable
- Don't assume widgets are always running — they may be disabled or unavailable

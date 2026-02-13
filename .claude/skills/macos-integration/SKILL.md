---
name: macos-integration
description: macOS native integration patterns via CGo — Spotlight, Keychain, iCloud, Touch Bar, Notifications, and system APIs. Activates when working on macOS-specific features, CGo Objective-C bridges, darwin build tags, or Apple framework integrations.
---

# macOS Integration — CGo + Apple Frameworks

Most macOS features work directly from Go via CGo — only WidgetKit requires Swift. This skill covers all macOS-native integrations.

## What Works in Go vs Swift

| Feature | Go (CGo) | Swift Required |
|---------|----------|---------------|
| Spotlight integration | Yes | No |
| Keychain access | Yes (go-keychain) | No |
| iCloud Drive | Yes | No |
| Touch Bar | Yes | No |
| Notifications | Yes | No |
| Menu bar extras / tray | Yes (Wails) | No |
| Dark mode | Yes (Wails) | No |
| File associations | Yes | No |
| Apple Silicon | Yes (native compile) | No |
| **macOS Widgets (WidgetKit)** | **No** | **Yes (~200 lines)** |

## Spotlight Integration

Index project files so they appear in macOS Spotlight search.

```go
// bridge/macos/spotlight_darwin.go
//go:build darwin

package macos

/*
#cgo CFLAGS: -x objective-c
#cgo LDFLAGS: -framework CoreSpotlight -framework CoreServices
#import <CoreSpotlight/CoreSpotlight.h>

void indexFileForSpotlight(const char* identifier, const char* title,
                           const char* path, const char* contentType) {
    CSSearchableItemAttributeSet *attrs = [[CSSearchableItemAttributeSet alloc]
        initWithItemContentType:[NSString stringWithUTF8String:contentType]];
    attrs.title = [NSString stringWithUTF8String:title];
    attrs.contentURL = [NSURL fileURLWithPath:[NSString stringWithUTF8String:path]];

    CSSearchableItem *item = [[CSSearchableItem alloc]
        initWithUniqueIdentifier:[NSString stringWithUTF8String:identifier]
        domainIdentifier:@"com.orchestra"
        attributeSet:attrs];

    [[CSSearchableIndex defaultSearchableIndex]
        indexSearchableItems:@[item]
        completionHandler:nil];
}

void removeSpotlightIndex(const char* identifier) {
    [[CSSearchableIndex defaultSearchableIndex]
        deleteSearchableItemsWithIdentifiers:
            @[[NSString stringWithUTF8String:identifier]]
        completionHandler:nil];
}

void removeAllSpotlightIndexes() {
    [[CSSearchableIndex defaultSearchableIndex]
        deleteAllSearchableItemsWithCompletionHandler:nil];
}
*/
import "C"
import "unsafe"

func IndexForSpotlight(id, title, path, contentType string) {
    cID := C.CString(id)
    cTitle := C.CString(title)
    cPath := C.CString(path)
    cType := C.CString(contentType)
    defer C.free(unsafe.Pointer(cID))
    defer C.free(unsafe.Pointer(cTitle))
    defer C.free(unsafe.Pointer(cPath))
    defer C.free(unsafe.Pointer(cType))

    C.indexFileForSpotlight(cID, cTitle, cPath, cType)
}

func RemoveFromSpotlight(id string) {
    cID := C.CString(id)
    defer C.free(unsafe.Pointer(cID))
    C.removeSpotlightIndex(cID)
}

func ClearAllSpotlightIndexes() {
    C.removeAllSpotlightIndexes()
}
```

### Usage in the App

```go
// When a project file is opened/indexed
func (s *SpotlightService) IndexProjectFiles(project *models.Project, files []models.File) {
    for _, f := range files {
        contentType := spotlightContentType(f.Language)
        macos.IndexForSpotlight(
            fmt.Sprintf("orchestra:%s:%s", project.ID, f.ID),
            filepath.Base(f.Path),
            f.FullPath(),
            contentType,
        )
    }
}

func spotlightContentType(lang string) string {
    switch lang {
    case "go":
        return "public.go-source"
    case "rust":
        return "public.rust-source"
    case "typescript", "javascript":
        return "public.script"
    case "python":
        return "public.python-script"
    default:
        return "public.source-code"
    }
}
```

## Keychain Access

Store auth tokens and secrets securely in the macOS Keychain. Uses `go-keychain` library — no CGo needed.

```go
// bridge/macos/keychain.go (no build tag needed — go-keychain handles it)
package macos

import "github.com/keybase/go-keychain"

const serviceName = "com.orchestra.ide"

func SaveToKeychain(account, secret string) error {
    // Delete existing item first (upsert pattern)
    DeleteFromKeychain(account)

    item := keychain.NewItem()
    item.SetSecClass(keychain.SecClassGenericPassword)
    item.SetService(serviceName)
    item.SetAccount(account)
    item.SetData([]byte(secret))
    item.SetSynchronizable(keychain.SynchronizableNo)
    item.SetAccessible(keychain.AccessibleWhenUnlocked)
    return keychain.AddItem(item)
}

func GetFromKeychain(account string) (string, error) {
    query := keychain.NewItem()
    query.SetSecClass(keychain.SecClassGenericPassword)
    query.SetService(serviceName)
    query.SetAccount(account)
    query.SetReturnData(true)
    query.SetMatchLimit(keychain.MatchLimitOne)

    results, err := keychain.QueryItem(query)
    if err != nil {
        return "", err
    }
    if len(results) == 0 {
        return "", fmt.Errorf("keychain: item not found for %s", account)
    }
    return string(results[0].Data), nil
}

func DeleteFromKeychain(account string) error {
    item := keychain.NewItem()
    item.SetSecClass(keychain.SecClassGenericPassword)
    item.SetService(serviceName)
    item.SetAccount(account)
    return keychain.DeleteItem(item)
}
```

### Usage

```go
// Store JWT token
macos.SaveToKeychain("auth_token", token)

// Retrieve JWT token
token, err := macos.GetFromKeychain("auth_token")

// Store API keys
macos.SaveToKeychain("openai_api_key", apiKey)
```

## iCloud Drive Integration

Sync project settings and workspace data via iCloud.

```go
// bridge/macos/icloud_darwin.go
//go:build darwin

package macos

/*
#cgo CFLAGS: -x objective-c
#cgo LDFLAGS: -framework Foundation
#import <Foundation/Foundation.h>

const char* getICloudContainerPath(const char* identifier) {
    NSString *ident = [NSString stringWithUTF8String:identifier];
    NSURL *url = [[NSFileManager defaultManager]
        URLForUbiquityContainerIdentifier:ident];
    if (url == nil) return "";
    return [url.path UTF8String];
}

bool isICloudAvailable() {
    return [[NSFileManager defaultManager] ubiquityIdentityToken] != nil;
}
*/
import "C"
import "unsafe"

const iCloudIdentifier = "iCloud.com.orchestra"

func GetICloudPath() (string, error) {
    cIdent := C.CString(iCloudIdentifier)
    defer C.free(unsafe.Pointer(cIdent))

    path := C.GoString(C.getICloudContainerPath(cIdent))
    if path == "" {
        return "", fmt.Errorf("iCloud container not available")
    }
    return path, nil
}

func IsICloudAvailable() bool {
    return bool(C.isICloudAvailable())
}
```

### Usage

```go
// Sync project settings to iCloud
func SyncSettingsToICloud(settings *models.UserSettings) error {
    if !macos.IsICloudAvailable() {
        return nil // Silently skip if no iCloud
    }
    icloudPath, err := macos.GetICloudPath()
    if err != nil {
        return err
    }
    settingsPath := filepath.Join(icloudPath, "Documents", "settings.json")
    data, _ := json.Marshal(settings)
    return os.WriteFile(settingsPath, data, 0644)
}
```

## Notifications

Send native macOS notifications via UserNotifications framework.

```go
// bridge/macos/notifications_darwin.go
//go:build darwin

package macos

/*
#cgo CFLAGS: -x objective-c
#cgo LDFLAGS: -framework Foundation -framework UserNotifications
#import <UserNotifications/UserNotifications.h>

void requestNotificationPermission() {
    [[UNUserNotificationCenter currentNotificationCenter]
        requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound)
        completionHandler:^(BOOL granted, NSError *error) {}];
}

void sendNotification(const char* title, const char* body, const char* identifier) {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString stringWithUTF8String:title];
    content.body = [NSString stringWithUTF8String:body];
    content.sound = [UNNotificationSound defaultSound];

    UNNotificationRequest *request = [UNNotificationRequest
        requestWithIdentifier:[NSString stringWithUTF8String:identifier]
        content:content
        trigger:nil];

    [[UNUserNotificationCenter currentNotificationCenter]
        addNotificationRequest:request
        withCompletionHandler:nil];
}
*/
import "C"
import "unsafe"

func RequestNotificationPermission() {
    C.requestNotificationPermission()
}

func SendNotification(title, body string) {
    cTitle := C.CString(title)
    cBody := C.CString(body)
    cID := C.CString(uuid.New().String())
    defer C.free(unsafe.Pointer(cTitle))
    defer C.free(unsafe.Pointer(cBody))
    defer C.free(unsafe.Pointer(cID))

    C.sendNotification(cTitle, cBody, cID)
}
```

### Usage

```go
// On app startup
macos.RequestNotificationPermission()

// On events
macos.SendNotification("Build Complete", "Project compiled successfully")
macos.SendNotification("Sync Done", "3 files synced to cloud")
macos.SendNotification("Pull Request", "New review comment from @alice")
```

## Touch Bar

```go
// bridge/macos/touchbar_darwin.go
//go:build darwin

package macos

/*
#cgo CFLAGS: -x objective-c
#cgo LDFLAGS: -framework AppKit

// Touch Bar is set up via NSWindow.touchBar in the Wails window
// Wails handles the window, we add Touch Bar items via delegate
*/
import "C"

// Touch Bar integration is handled through Wails v3 window configuration.
// Custom Touch Bar items (Run, Debug, Git) are defined in the Wails app setup.
```

Note: Touch Bar is deprecated on newer Macs (no Touch Bar on M-series MacBooks). Low priority — implement only if specifically requested.

## Apple Silicon Build

```makefile
# Native Apple Silicon build
build-macos-arm64:
	GOOS=darwin GOARCH=arm64 wails build

# Intel build
build-macos-amd64:
	GOOS=darwin GOARCH=amd64 wails build

# Universal binary (both architectures)
build-macos-universal:
	GOOS=darwin GOARCH=arm64 wails build -o dist/orchestra-arm64
	GOOS=darwin GOARCH=amd64 wails build -o dist/orchestra-amd64
	lipo -create -output dist/Orchestra dist/orchestra-arm64 dist/orchestra-amd64
```

## File Associations

Register Orchestra as handler for source code files in the macOS `Info.plist`:

```xml
<key>CFBundleDocumentTypes</key>
<array>
    <dict>
        <key>CFBundleTypeName</key>
        <string>Source Code</string>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>LSItemContentTypes</key>
        <array>
            <string>public.source-code</string>
            <string>public.script</string>
            <string>public.json</string>
            <string>public.yaml</string>
        </array>
    </dict>
</array>
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>Orchestra Protocol</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>orchestra</string>
        </array>
    </dict>
</array>
```

Handle URL schemes in Go:

```go
// Handle orchestra:// URLs
func handleURLScheme(url string) {
    parsed, _ := url.Parse(url)
    switch parsed.Host {
    case "open":
        openProject(parsed.Path)
    case "settings":
        openSettings()
    }
}
```

## Conventions

- All macOS-specific Go files use `//go:build darwin` tag
- CGo bridges use Objective-C (`-x objective-c`), not Swift
- Each macOS feature in its own file: `spotlight_darwin.go`, `keychain.go`, `icloud_darwin.go`, `notifications_darwin.go`
- Keychain uses `go-keychain` library (no CGo needed for this one)
- Always `defer C.free(unsafe.Pointer(...))` after `C.CString()`
- iCloud and Spotlight are optional — app works fully without them
- Request notification permission on first launch, not on install

## Don'ts

- Don't use Swift for anything except WidgetKit — CGo handles everything else
- Don't assume iCloud is available — always check `IsICloudAvailable()` first
- Don't store large files in iCloud via this API — use iCloud Drive directly
- Don't call CGo functions from goroutines without considering thread safety
- Don't put macOS-specific imports in non-darwin files — use build tags
- Don't hardcode App Group identifiers — use constants
- Don't implement Touch Bar unless requested — it's deprecated on new Macs

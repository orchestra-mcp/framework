---
id: FEAT-UNT
kind: feature
priority: P2
project_slug: orchestra-win
status: backlog
title: scripts/new-windows-plugin.ps1 — plugin scaffold generator
type: feature
---

# scripts/new-windows-plugin.ps1 — plugin scaffold generator

PowerShell scaffold script equivalent to `scripts/new-swift-plugin.sh` for generating new Windows plugin projects.

Usage:
```powershell
.\scripts\new-windows-plugin.ps1 -Name "MyPlugin" -Section DevTools -Order 5
```

What it generates:
```
apps/windows/src/Plugins/MyPlugin/
├── MyPluginPlugin.cs         ← IOrchestraPlugin implementation
├── MyPluginPage.xaml         ← WinUI 3 page
├── MyPluginPage.xaml.cs      ← Code-behind
├── MyPluginViewModel.cs      ← ObservableObject (CommunityToolkit.Mvvm)
└── MyPluginPlugin.csproj     ← Project file with correct refs
```

Template fills in:
- Plugin Id: `plugin.myplugin`
- IconGlyph: prompt user to pick from Segoe Fluent Icons cheatsheet URL
- Section: enum value (Sidebar / DevTools / Settings)
- SupportedPlatforms: prompt which WindowsPlatform flags to include
- Auto-registers in `PluginRegistry.RegisterAll()` in `PluginRegistry.cs`
- Adds `<ProjectReference>` to `Orchestra.Desktop.csproj`

Validation:
- Checks that `-Name` is PascalCase (no spaces, no special chars)
- Warns if Order conflicts with existing plugin
- Prints `dotnet build` command to verify scaffolding compiles

Equivalent scripts for other platforms:
- Swift: `scripts/new-swift-plugin.sh`
- Linux: `scripts/new-linux-plugin.sh` (Vala)
- Android: `scripts/new-android-plugin.sh` (Kotlin)
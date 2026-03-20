---
id: FEAT-SCX
kind: feature
priority: P0
project_slug: orchestra-win
status: backlog
title: Orchestra.sln — .NET solution setup
type: feature
---

# Orchestra.sln — .NET solution setup

Scaffold the `apps/windows/` solution with four projects: `Orchestra.Core` (.NET 8 class library), `Orchestra.Desktop` (WinUI 3 app), `Orchestra.Widgets` (Adaptive Cards widget provider), and `Orchestra.Core.Tests` (xUnit). Configure `go.work`-equivalent for local dev (no NuGet publish needed yet). Target `net8.0-windows10.0.19041.0`.

**Projects:**
- `Orchestra.Core` — transport, models, plugin system, proto generated types
- `Orchestra.Desktop` — WinUI 3 entry point, pages, windows, theme, tray
- `Orchestra.Widgets` — Windows 11 widget provider (Adaptive Cards)
- `Orchestra.Core.Tests` — xUnit + Moq unit tests

**Key NuGet packages:** `Microsoft.WindowsAppSDK 1.5+`, `Google.Protobuf 3.25+`, `Microsoft.Data.Sqlite 8.0+`, `CommunityToolkit.Mvvm 8.2+`, `Microsoft.Extensions.Hosting 8.0+`

**Makefile targets:** `build-windows`, `test-windows`, `clean-windows`
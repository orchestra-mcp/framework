---
id: FEAT-YXK
kind: feature
priority: P1
project_slug: orchestra-swift
status: done
title: ContentView (plugin-driven, platform-adaptive root view)
type: feature
---

# ContentView (plugin-driven, platform-adaptive root view)

Root ContentView that reads PluginRegistry and renders platform-adaptive navigation. macOS/iPadOS: NavigationSplitView with icon rail sidebar (56px) + detail area. iPhone: TabView with plugins as tabs. watchOS: NavigationStack with List. tvOS: TabView with dashboard. visionOS: NavigationSplitView. Plugin selection state, connection status in status bar.
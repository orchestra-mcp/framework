---
id: FEAT-UJL
kind: feature
priority: P1
project_slug: orchestra-swift
status: done
title: Platform entry points (macOS, iOS, watchOS, tvOS, visionOS, CarPlay)
type: feature
---

# Platform entry points (macOS, iOS, watchOS, tvOS, visionOS, CarPlay)

macOS: @main App struct with WindowGroup, Spirit Window, MenuBarExtra (system tray), Settings scene, MacCommands for keyboard shortcuts. iOS: @main App struct with WindowGroup + TabView navigation. watchOS/tvOS/visionOS/CarPlay: stub @main App structs. Each registers appropriate plugins for its platform.
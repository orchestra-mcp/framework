---
id: FEAT-ORB
kind: feature
priority: P0
project_slug: orchestra-swift
status: done
title: Plugin system (OrchestraPlugin protocol + PluginRegistry)
type: feature
---

# Plugin system (OrchestraPlugin protocol + PluginRegistry)

Create OrchestraPlugin protocol with id, name, icon, section, order, supportedPlatforms, makeView(), onActivate(), onDeactivate(). Create PluginRegistry ObservableObject with register(), plugin(for:), sidebarPlugins, devToolPlugins, settingsPlugins computed properties. Platform enum with all 7 Apple platforms. AppSection enum (sidebar, devtools, settings).
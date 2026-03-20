---
id: FEAT-IVX
kind: feature
priority: P2
project_slug: orchestra-swift
status: done
title: Plugin creator script (new-swift-plugin.sh)
type: feature
---

# Plugin creator script (new-swift-plugin.sh)

Shell script at apps/swift/scripts/new-swift-plugin.sh. Usage: ./new-swift-plugin.sh my-feature sidebar. Generates: Shared/Sources/Shared/Plugins/MyFeaturePlugin/MyFeaturePlugin.swift (plugin registration) + MyFeatureView.swift (main view). Prints registration line to add to app entry point. Same pattern as scripts/new-plugin.sh for Go plugins.
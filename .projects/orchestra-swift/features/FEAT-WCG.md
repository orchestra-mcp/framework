---
id: FEAT-WCG
kind: feature
priority: P0
project_slug: orchestra-swift
status: done
title: AppState + OrchestraClient + ToolService
type: feature
---

# AppState + OrchestraClient + ToolService

AppState: root ObservableObject holding QUICConnection, PluginRegistry, ToolService, SettingsService, cached data. OrchestraClient: wraps QUICConnection + StreamFramer, callTool(name:arguments:) async, listTools() async, connection state publisher for SwiftUI binding. ToolService: high-level MCP tool proxy with convenience methods (listProjects, getProjectStatus, createFeature, advanceFeature, listNotes, saveNote, aiPrompt with provider/model).
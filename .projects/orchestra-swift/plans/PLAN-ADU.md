---
created_at: "2026-03-05T11:31:05Z"
description: 'Complete delete-and-rebuild of the floating UI system. Replaces SmartInputWindowManager.swift (1633 lines), SmartInputState.swift, and SmartFloatingContent.swift with a clean 5-layer architecture: FloatingPanelController (AppKit), FloatingUIStore (single ObservableObject), FloatingContentRouter (SwiftUI), Content Modules (chat/terminal/search/notes), and MCPSessionService (MCP-backed persistence). Fixes reactivity bugs, adds multi-content mini panel, creative animations, and MCP session status persistence.'
id: PLAN-ADU
project_id: orchestra-swift
status: approved
title: Floating UI Ground-Up Rebuild
updated_at: "2026-03-05T11:31:08Z"
version: 1
---

# Floating UI Ground-Up Rebuild

Complete delete-and-rebuild of the floating UI system. Replaces SmartInputWindowManager.swift (1633 lines), SmartInputState.swift, and SmartFloatingContent.swift with a clean 5-layer architecture: FloatingPanelController (AppKit), FloatingUIStore (single ObservableObject), FloatingContentRouter (SwiftUI), Content Modules (chat/terminal/search/notes), and MCPSessionService (MCP-backed persistence). Fixes reactivity bugs, adds multi-content mini panel, creative animations, and MCP session status persistence.

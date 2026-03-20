---
id: FEAT-MEF
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: DevTools plugin container
type: feature
---

# DevTools plugin container

DevToolsPlugin (id: "devtools", icon: "utilities-terminal-symbolic", section: SIDEBAR). DevToolsView with AdwNavigationSplitView. Sidebar: GtkListBox with AdwActionRow per sub-tool (File Explorer, Terminal, SSH, Services, Docker, Debugger, Test Runner, Log Viewer, Database, DevOps) each with distinct icon. Content area swaps to the selected sub-tool's view. Sub-tools registered as DevToolsPlugin (internal interface extending OrchestraPlugin with section: DEVTOOLS). Keyboard shortcut: Ctrl+number (1–10) to switch sub-tools.
---
id: FEAT-NIR
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: Terminal emulator (VTE 4)
type: feature
---

# Terminal emulator (VTE 4)

Terminal sub-tool using VTE 4 (vte-2.91-gtk4). Create Vte.Terminal with: orchestra-dark color palette (bg #0a0d14, fg #e8ecf4, 16 ANSI colors matching syntax tokens), monospace font JetBrains Mono 13pt, 10,000 line scrollback, scrollbar shown. Spawn shell via spawn_async() with SHELL env var. Tab support: GtkNotebook with multiple terminal sessions, New Tab button (+), close button per tab. Calls devtools.terminal tools: create_terminal, send_input, get_output, resize_terminal, list_terminals, close_terminal. Resize terminal on widget size-allocate signal.
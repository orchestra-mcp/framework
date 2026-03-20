---
id: FEAT-SJJ
kind: feature
priority: P0
project_slug: orchestra-linux
status: backlog
title: GSettings schema (dev.orchestra.desktop)
type: feature
---

# GSettings schema (dev.orchestra.desktop)

Define GSettings XML schema at data/dev.orchestra.desktop.gschema.xml. Keys: color-theme (string, default "orchestra"), color-scheme (string, default "dark"), window-width (int32, 1280), window-height (int32, 860), window-maximized (bool, false), default-provider (string, "claude"), default-model (string, "claude-sonnet-4-6"), window-mode (string, "main"), autostart (bool, false), last-plugin (string, "chat"). Compile with glib-compile-schemas. Save/restore window geometry on startup/shutdown.
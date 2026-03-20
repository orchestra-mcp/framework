---
id: FEAT-KZD
kind: feature
priority: P0
project_slug: orchestra-linux
status: backlog
title: Vala plugin interface and PluginRegistry
type: feature
---

# Vala plugin interface and PluginRegistry

Define OrchestraPlugin interface (id, name, icon_name, section, order) with create_view(), on_activate(), on_deactivate() methods. AppSection enum (SIDEBAR, DEVTOOLS, SETTINGS). PluginRegistry GObject class with register(), get_plugin(), sidebar_plugins, devtools_plugins, settings_plugins. plugin_added signal for dynamic registration. Sort by order field.
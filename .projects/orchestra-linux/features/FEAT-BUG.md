---
id: FEAT-BUG
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: new-linux-plugin.sh scaffolding script
type: feature
---

# new-linux-plugin.sh scaffolding script

scripts/new-linux-plugin.sh — plugin creator script mirroring new-swift-plugin.sh. Usage: ./scripts/new-linux-plugin.sh my-feature sidebar. Creates: shared/src/plugins/my-feature-plugin/my-feature-plugin.vala (OrchestraPlugin implementation stub with id, name, icon_name, section, order, create_view(), on_activate(), on_deactivate()) and my-feature-view.vala (GtkWidget placeholder). Updates shared/meson.build to add new .vala files to sources list. Prints registration line to add to desktop/src/main.vala. Validates section arg (sidebar/devtools/settings). Makes script executable (chmod +x).
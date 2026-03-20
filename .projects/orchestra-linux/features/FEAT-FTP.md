---
id: FEAT-FTP
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: Accessibility tree reader (AT-SPI2)
type: feature
---

# Accessibility tree reader (AT-SPI2)

Implement ai.screen-reader tool integration via AT-SPI2 D-Bus interface. Connect to org.a11y.atspi.Registry on session bus. Walk accessibility tree from root via org.a11y.atspi.Accessible GetChildren. Extract: name, role (button/text/list/etc.), state (focused/enabled/visible), bounds (screen coordinates), value. Methods: get_accessibility_tree() → AccessibilityNode tree, get_focused_element() → AccessibilityNode, find_element(label, role) → AccessibilityNode, list_windows() → WindowInfo[]. Enable AT-SPI2 registry via gsettings set org.gnome.desktop.interface toolkit-accessibility true.
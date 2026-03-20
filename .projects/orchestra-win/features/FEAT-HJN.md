---
id: FEAT-HJN
kind: feature
priority: P2
project_slug: orchestra-win
status: backlog
title: UI Automation plugin — accessibility tree (AT-SPI2 equivalent)
type: feature
---

# UI Automation plugin — accessibility tree (AT-SPI2 equivalent)

Implement `Orchestra.Desktop/Services/UIAutomationService.cs` — Windows UI Automation equivalent of macOS AXUIElement, for AI screen-reading and context awareness.

**`UIAutomationService` API (ai.screen-reader — 6 tools):**
- `get_accessibility_tree` — walk `AutomationElement` tree from HWND, return JSON hierarchy (role, name, bounds, value, enabled, focused, children up to depth 5)
- `get_focused_element` — `AutomationElement.FocusedElement` → name, role, value, bounds
- `find_element` — search by name/role/automationId via `FindFirst(TreeScope.Descendants, condition)`
- `get_element_hierarchy` — path from root to target element
- `list_windows` — all top-level windows via `AutomationElement.RootElement.FindAll(TreeScope.Children, WindowCondition)`
- `get_window_elements` — full element tree for a specific window HWND

**`System.Windows.Automation`** — standard .NET UI Automation client. Also supports `IUIAutomation` COM interface for lower-level access.

**`WindowInfo` record:** Title, ProcessId, ProcessName, BoundingRect, Handle, IsMinimized

**`AccessibilityNode` record:** Role, Name, AutomationId, BoundingRect, Value, IsEnabled, IsFocused, Children

**Use cases:** AI reads active IDE/browser context, accessibility testing, workflow automation

**Platform:** Desktop, HoloLens (limited). Requires `rescap:Capability Name="uiAutomation"` in manifest.
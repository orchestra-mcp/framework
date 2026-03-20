# Markdown Editor Component

## Overview

A reusable Monaco-based markdown editor component for rich content editing across the admin CMS and community features.

## Location

`apps/next/src/components/ui/markdown-editor.tsx`

## Usage

```tsx
import MarkdownEditor from '@/components/ui/markdown-editor'

<MarkdownEditor
  value={content}
  onChange={setContent}
  height={240}
  isDark={isDark}
  placeholder="Enter content..."
/>
```

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `value` | `string` | required | Controlled markdown content |
| `onChange` | `(value: string) => void` | required | Change handler |
| `height` | `number` | `300` | Editor height in pixels |
| `placeholder` | `string` | — | Placeholder text for preview mode |
| `isDark` | `boolean` | `false` | Dark mode theme |

## Features

- **Monaco Editor** with markdown language support and syntax highlighting
- **Toolbar** with 10 formatting actions: Bold, Italic, Strikethrough, Heading, Link, Inline code, Code block, Bullet list, Numbered list, Quote
- **Write / Preview tabs** for switching between editing and rendered preview
- **Dark mode** support via `isDark` prop
- **Lightweight preview** renderer (no external markdown library required)

## Integration Points

### Admin Settings (`adminField`)

The `adminField` function in the settings page supports a `'markdown'` type:

```tsx
adminField('homepage', 'hero_subtext', 'Hero Subtext', 'markdown')
```

Currently used for:
- Homepage hero subtext
- AI Agents subtext
- Pricing plan features
- Smart Prompts system prompt editor

### Community Post Composer

The community post composer (`member/[handle]/page.tsx`) uses the editor for creating posts with markdown support.

## Dependencies

- `@monaco-editor/react` — React wrapper for Monaco Editor (already in project deps)
- `monaco-editor` — The editor itself (already in project deps)
- Dynamic import via `next/dynamic` with SSR disabled

---

## Flutter MarkdownEditor

**Location:** `apps/flutter/lib/widgets/markdown_editor.dart`

Glass-themed markdown editor with toolbar, live preview, and debounced auto-save.

### Flutter Usage

```dart
// Internal controller (default)
MarkdownEditor(
  initialText: '# Hello',
  onChanged: (text) => print(text),
)

// External controller (for integration with editor screens)
final controller = TextEditingController(text: existing);
MarkdownEditor(
  controller: controller,
  onChanged: (_) {},
)
```

### Flutter Props

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `initialText` | `String` | `''` | Initial text (ignored when `controller` provided) |
| `controller` | `TextEditingController?` | `null` | External controller; caller must dispose |
| `onChanged` | `ValueChanged<String>?` | `null` | Fires after debounce delay |
| `autoSaveDelay` | `Duration` | `500ms` | Debounce before `onChanged` |
| `hintText` | `String` | `'Start writing markdown...'` | Placeholder text |

### Flutter Toolbar

Bold, Italic, Heading, Bullet List, Code, Link, Image + 3 view mode toggles (Edit / Side-by-side / Preview).

### Flutter Integration — NoteEditorScreen

`apps/flutter/lib/screens/library/note_editor_screen.dart`

The note editor's manual mode replaces the plain `TextField` body editor with `MarkdownEditor`. The title field remains a separate `TextField` above.

```dart
// Manual mode layout (inside Column with Expanded)
Expanded(
  child: MarkdownEditor(
    controller: _contentController,
    hintText: l10n.writeMarkdownHint,
  ),
),
```

The `MarkdownEditor` requires bounded height (it uses `Expanded` internally), so the manual-mode body is wrapped in a `Column` → `Expanded` chain rather than the `SingleChildScrollView` used by smart mode.

Smart (AI) mode still uses the original `SingleChildScrollView` layout with prompt input and generated content preview.

### Flutter Integration — McpEntityEditorScreen

`apps/flutter/lib/screens/library/mcp_entity_editor.dart`

The generic entity editor (agents, skills, workflows, docs, features, plans, requests, persons) uses the same pattern. When an entity type has a body (`_meta.hasBody`), the manual-mode layout provides `MarkdownEditor` with bounded height via `Expanded`.

```dart
// Manual mode with body (inside Column → Expanded)
Expanded(
  child: MarkdownEditor(
    controller: _bodyController,
    hintText: _bodyHint,  // entity-specific: agent→"System prompt...", doc→"Document content...", etc.
  ),
),
```

Entity-specific hints are resolved via `_bodyHint` getter based on `McpEntityType`.

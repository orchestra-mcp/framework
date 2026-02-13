---
name: raycast-compat
description: Raycast extension compatibility layer for running Raycast-style extensions in Orchestra. Activates when implementing Raycast API shimming, migrating Raycast extensions, building quick-action style extensions, or working on the Raycast compatibility runtime.
---

# Raycast Compatibility — Quick Action Extensions

Orchestra provides a compatibility layer that allows Raycast extensions to run with minimal modification. This gives Orchestra access to Raycast's rich extension ecosystem for quick actions, search, and utility tools.

## What Raycast Extensions Look Like

Raycast extensions are React components that render in a list/detail/form UI:

```typescript
// Raycast extension pattern
import { List, ActionPanel, Action, showToast, Toast } from "@raycast/api";

export default function Command() {
  const [items, setItems] = useState<Item[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    fetchItems().then((data) => {
      setItems(data);
      setIsLoading(false);
    });
  }, []);

  return (
    <List isLoading={isLoading} searchBarPlaceholder="Search items...">
      {items.map((item) => (
        <List.Item
          key={item.id}
          title={item.title}
          subtitle={item.description}
          icon={item.icon}
          actions={
            <ActionPanel>
              <Action.OpenInBrowser url={item.url} />
              <Action.CopyToClipboard content={item.url} />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
```

## Compatibility Architecture

```
Raycast Extension Code
  │
  └── import { List, Action, ... } from "@raycast/api"
        │
        └── Shimmed to Orchestra equivalents:
              @raycast/api  →  @orchestra/raycast-compat
                │
                ├── List        → orchestra.ui.QuickList
                ├── Detail      → orchestra.ui.DetailPanel
                ├── Form        → orchestra.ui.FormPanel
                ├── Action      → orchestra.commands
                ├── ActionPanel → orchestra.ui.ActionMenu
                ├── showToast   → orchestra.ui.showNotification
                ├── Clipboard   → orchestra.clipboard
                ├── getPrefs    → orchestra.settings.get
                └── localStorage → orchestra.storage
```

## Shim Package (`@orchestra/raycast-compat`)

```typescript
// packages/raycast-compat/src/index.ts
// Re-exports that map Raycast API to Orchestra equivalents

export { List } from './components/List';
export { Detail } from './components/Detail';
export { Form } from './components/Form';
export { Grid } from './components/Grid';
export { ActionPanel } from './components/ActionPanel';
export { Action } from './components/Action';
export { Icon } from './components/Icon';
export { Color } from './components/Color';
export { Image } from './components/Image';

export { showToast, Toast } from './api/toast';
export { showHUD } from './api/hud';
export { Clipboard } from './api/clipboard';
export { getPreferenceValues } from './api/preferences';
export { LocalStorage } from './api/storage';
export { environment } from './api/environment';
export { launchCommand } from './api/launch';
export { open, openExtensionPreferences } from './api/open';
export { useFetch, useCachedPromise, useCachedState } from './hooks';
```

### List Component Shim

```typescript
// packages/raycast-compat/src/components/List.tsx
import { type FC, type ReactNode } from 'react';

interface ListProps {
  isLoading?: boolean;
  searchBarPlaceholder?: string;
  onSearchTextChange?: (text: string) => void;
  filtering?: boolean;
  children: ReactNode;
}

export const List: FC<ListProps> & {
  Item: FC<ListItemProps>;
  Section: FC<ListSectionProps>;
  EmptyView: FC<EmptyViewProps>;
} = ({ isLoading, searchBarPlaceholder, onSearchTextChange, children }) => {
  // Maps to Orchestra's QuickList component
  return (
    <orchestra.ui.QuickList
      loading={isLoading}
      placeholder={searchBarPlaceholder}
      onSearch={onSearchTextChange}
    >
      {children}
    </orchestra.ui.QuickList>
  );
};

List.Item = ({ title, subtitle, icon, accessories, actions }) => {
  return (
    <orchestra.ui.QuickListItem
      title={title}
      subtitle={subtitle}
      icon={mapRaycastIcon(icon)}
      accessories={accessories?.map(mapAccessory)}
      actionPanel={actions}
    />
  );
};
```

### Action Shim

```typescript
// packages/raycast-compat/src/components/Action.tsx
export const Action = {
  OpenInBrowser: ({ url, title }) => (
    <orchestra.ui.ActionItem
      title={title || 'Open in Browser'}
      onAction={() => orchestra.system.openURL(url)}
    />
  ),
  CopyToClipboard: ({ content, title }) => (
    <orchestra.ui.ActionItem
      title={title || 'Copy to Clipboard'}
      onAction={() => orchestra.clipboard.write(content)}
    />
  ),
  Push: ({ target, title }) => (
    <orchestra.ui.ActionItem
      title={title}
      onAction={() => orchestra.ui.pushView(target)}
    />
  ),
  Paste: ({ content, title }) => (
    <orchestra.ui.ActionItem
      title={title || 'Paste'}
      onAction={() => orchestra.clipboard.paste(content)}
    />
  ),
};
```

### Toast/Notification Shim

```typescript
// packages/raycast-compat/src/api/toast.ts
export enum Toast {
  Style = {
    Animated: 'animated',
    Success: 'success',
    Failure: 'failure',
  }
}

export async function showToast(options: {
  style?: string;
  title: string;
  message?: string;
}) {
  const type = options.style === 'failure' ? 'error' :
               options.style === 'success' ? 'success' : 'info';

  orchestra.ui.showNotification(options.title, {
    type,
    description: options.message,
  });
}
```

## Supported Raycast APIs

| Raycast API | Orchestra Equivalent | Status |
|-------------|---------------------|--------|
| `List` | `QuickList` | Full |
| `List.Item` | `QuickListItem` | Full |
| `Detail` | `DetailPanel` | Full |
| `Detail.Metadata` | `DetailMeta` | Full |
| `Form` | `FormPanel` | Full |
| `Grid` | `GridView` | Full |
| `ActionPanel` | `ActionMenu` | Full |
| `Action.*` | Various | Full |
| `showToast` | `showNotification` | Full |
| `showHUD` | `showNotification` (brief) | Partial |
| `Clipboard` | `orchestra.clipboard` | Full |
| `LocalStorage` | `orchestra.storage` | Full |
| `getPreferenceValues` | `orchestra.settings` | Full |
| `useFetch` | Custom hook | Full |
| `useCachedPromise` | Custom hook | Full |
| `environment` | `orchestra.env` | Partial |
| `launchCommand` | `orchestra.commands.execute` | Full |
| `AI` | `orchestra.ai` | Enhanced |

## Unsupported / Different

| Raycast Feature | Orchestra Status |
|----------------|-----------------|
| `MenuBarExtra` | Maps to system tray (desktop only) |
| `OAuth` | Use Orchestra's auth API instead |
| `Raycast Window Management` | Not applicable |
| Deep links (`raycast://`) | Maps to `orchestra://` |

## Migrating a Raycast Extension

1. Replace `@raycast/api` with `@orchestra/raycast-compat` in `package.json`
2. Update `package.json` to Orchestra manifest format (add `engines.orchestra`, `permissions`)
3. Test — most extensions work without code changes
4. Optional: replace Raycast-specific patterns with native Orchestra API for better integration

## Extension Manifest Mapping

```json
// Raycast package.json
{
  "name": "my-raycast-ext",
  "title": "My Extension",
  "commands": [
    { "name": "search", "title": "Search Items", "mode": "view" }
  ],
  "preferences": [
    { "name": "apiKey", "type": "password", "title": "API Key", "required": true }
  ]
}

// Orchestra equivalent (auto-generated during migration)
{
  "name": "my-raycast-ext",
  "displayName": "My Extension",
  "main": "src/search.tsx",
  "engines": { "orchestra": ">=0.1.0" },
  "permissions": ["network"],
  "compat": "raycast",
  "contributes": {
    "commands": [
      { "command": "my-raycast-ext.search", "title": "Search Items" }
    ],
    "settings": [
      { "id": "my-raycast-ext.apiKey", "type": "string", "title": "API Key", "secret": true }
    ]
  }
}
```

## Conventions

- Raycast compat extensions have `"compat": "raycast"` in their manifest
- The `@orchestra/raycast-compat` package is a build-time alias, not a runtime dependency
- All Raycast hooks (`useFetch`, `useCachedPromise`) are re-implemented using Orchestra's data layer
- Raycast `List` renders in Orchestra's command palette / quick list UI
- Extension preferences map to Orchestra's settings system with the extension namespace prefix

## Don'ts

- Don't modify Raycast extension source code during migration unless necessary
- Don't expose Orchestra internals through the Raycast shim — maintain API boundaries
- Don't support Raycast's `MenuBarExtra` on non-desktop platforms
- Don't promise 100% compatibility — document unsupported features clearly
- Don't bundle `@raycast/api` — always use the shim package

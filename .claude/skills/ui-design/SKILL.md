---
name: ui-design
description: UI/UX design patterns with shadcn/ui and Tailwind CSS v4. Activates when styling components, designing layouts, working with themes, responsive design, accessibility, or any visual/UI work.
---

# UI Design — shadcn/ui + Tailwind CSS v4

Orchestra's design system lives in `resources/ui/` and is shared across all five platforms via `@orchestra/ui` package.

## Design System Structure

```
resources/ui/
├── package.json
├── components.json            # shadcn/ui configuration
├── components/
│   ├── ui/                    # shadcn/ui primitives (generated)
│   │   ├── button.tsx
│   │   ├── card.tsx
│   │   ├── dialog.tsx
│   │   ├── dropdown-menu.tsx
│   │   ├── input.tsx
│   │   ├── tabs.tsx
│   │   ├── toast.tsx
│   │   └── ...
│   └── custom/                # Orchestra-specific components
│       ├── file-tree.tsx
│       ├── editor-tabs.tsx
│       ├── terminal-view.tsx
│       ├── search-bar.tsx
│       └── status-bar.tsx
├── layouts/
│   ├── app-layout.tsx         # Main IDE layout (sidebar + editor + terminal)
│   ├── dashboard-layout.tsx   # Web dashboard layout
│   └── admin-layout.tsx       # Admin panel layout
├── theme/
│   ├── colors.ts              # Color tokens
│   ├── typography.ts          # Font scale
│   └── index.ts               # Theme provider + exports
├── lib/
│   └── utils.ts               # cn() utility
└── styles/
    └── app.css                # Tailwind CSS v4 theme
```

## Tailwind CSS v4 Theme (`app.css`)

```css
@import "tailwindcss";

@theme {
  /* IDE-specific color palette */
  --color-sidebar: oklch(0.15 0.01 260);
  --color-sidebar-foreground: oklch(0.85 0.01 260);
  --color-editor: oklch(0.12 0.005 260);
  --color-editor-foreground: oklch(0.92 0 0);
  --color-terminal: oklch(0.10 0.005 260);
  --color-terminal-foreground: oklch(0.88 0.01 150);
  --color-panel: oklch(0.14 0.01 260);
  --color-panel-foreground: oklch(0.85 0.01 260);

  /* Standard tokens */
  --color-background: oklch(0.13 0.005 260);
  --color-foreground: oklch(0.92 0 0);
  --color-primary: oklch(0.65 0.20 260);
  --color-primary-foreground: oklch(0.98 0 0);
  --color-secondary: oklch(0.20 0.02 260);
  --color-secondary-foreground: oklch(0.85 0.01 260);
  --color-muted: oklch(0.20 0.01 260);
  --color-muted-foreground: oklch(0.55 0.01 260);
  --color-accent: oklch(0.25 0.02 260);
  --color-accent-foreground: oklch(0.90 0 0);
  --color-destructive: oklch(0.55 0.20 25);
  --color-border: oklch(0.25 0.01 260);
  --color-ring: oklch(0.65 0.20 260);

  /* Spacing */
  --spacing-sidebar: 240px;
  --spacing-panel: 300px;
  --spacing-statusbar: 24px;
  --spacing-tab: 36px;

  /* Typography */
  --font-sans: "Inter", system-ui, sans-serif;
  --font-mono: "JetBrains Mono", "Fira Code", monospace;
  --font-size-editor: 13px;
  --line-height-editor: 1.6;

  /* Radius */
  --radius-sm: 4px;
  --radius-md: 6px;
  --radius-lg: 8px;
}

/* Light theme override */
@media (prefers-color-scheme: light) {
  @theme {
    --color-background: oklch(0.98 0.005 260);
    --color-foreground: oklch(0.15 0 0);
    --color-sidebar: oklch(0.95 0.01 260);
    --color-sidebar-foreground: oklch(0.20 0.01 260);
    --color-editor: oklch(0.99 0 0);
    --color-editor-foreground: oklch(0.15 0 0);
    --color-border: oklch(0.85 0.01 260);
    --color-muted: oklch(0.92 0.01 260);
    --color-muted-foreground: oklch(0.45 0.01 260);
  }
}
```

## IDE Layout Pattern

```tsx
// resources/ui/layouts/app-layout.tsx
import { type FC, type ReactNode } from 'react';
import { cn } from '../lib/utils';

interface AppLayoutProps {
  sidebar: ReactNode;
  editor: ReactNode;
  terminal?: ReactNode;
  statusBar?: ReactNode;
  sidebarCollapsed?: boolean;
}

export const AppLayout: FC<AppLayoutProps> = ({
  sidebar,
  editor,
  terminal,
  statusBar,
  sidebarCollapsed = false,
}) => {
  return (
    <div className="h-screen w-screen flex flex-col overflow-hidden bg-background text-foreground">
      <div className="flex-1 flex overflow-hidden">
        {/* Sidebar */}
        <aside
          className={cn(
            "h-full bg-sidebar text-sidebar-foreground border-r border-border transition-[width] duration-200",
            sidebarCollapsed ? "w-12" : "w-sidebar"
          )}
        >
          {sidebar}
        </aside>

        {/* Main content */}
        <div className="flex-1 flex flex-col overflow-hidden">
          {/* Editor area */}
          <div className="flex-1 bg-editor text-editor-foreground overflow-hidden">
            {editor}
          </div>

          {/* Terminal panel */}
          {terminal && (
            <div className="h-[300px] bg-terminal text-terminal-foreground border-t border-border">
              {terminal}
            </div>
          )}
        </div>
      </div>

      {/* Status bar */}
      {statusBar && (
        <footer className="h-statusbar bg-primary text-primary-foreground flex items-center px-3 text-xs">
          {statusBar}
        </footer>
      )}
    </div>
  );
};
```

## Adding shadcn Components

```bash
cd resources/ui
npx shadcn@latest add button card dialog input tabs toast dropdown-menu
```

## `cn()` Utility

```typescript
// resources/ui/lib/utils.ts
import { type ClassValue, clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

## Platform-Specific Responsive Patterns

```
Desktop (Wails):    Full IDE layout, all panels, keyboard shortcuts
Chrome Extension:   Compact sidebar mode, collapsible panels, 400px max width
Web Dashboard:      Standard web layout, responsive grid, no terminal
Admin Panel:        Table-heavy layout, data visualization
Mobile:             Bottom navigation, sheet-based panels, touch targets 44px+
```

### Chrome Extension Sidebar

```tsx
<div className="w-[400px] h-screen flex flex-col overflow-hidden">
  <header className="h-tab px-3 flex items-center border-b border-border shrink-0">
    <h1 className="text-sm font-medium">Orchestra</h1>
  </header>
  <main className="flex-1 overflow-y-auto">
    {children}
  </main>
</div>
```

### Mobile Touch Targets

```tsx
// Minimum 44px touch target for mobile
<button className="min-h-[44px] min-w-[44px] flex items-center justify-center">
  <Icon className="h-5 w-5" />
</button>
```

## Accessibility

- Always use semantic HTML (`button`, `nav`, `main`, `aside`, `header`, `footer`)
- Include `aria-label` on icon-only buttons
- Use `role="tablist"`, `role="tab"`, `role="tabpanel"` for tab interfaces
- Ensure color contrast ratio >= 4.5:1 for text
- Support keyboard navigation: Tab, Escape, Enter, Arrow keys
- Use `focus-visible:ring-2 focus-visible:ring-ring` for focus indicators

## Component Guidelines

- Use shadcn primitives as base — extend, don't replace
- Wrap shadcn components for Orchestra-specific behavior, keep primitives untouched
- All colors via CSS custom properties (theme tokens), never hardcoded
- All spacing via Tailwind utilities, never inline styles
- Icons: use `lucide-react` (already a shadcn dependency)

## Don'ts

- Don't hardcode colors — use theme tokens (`text-foreground`, not `text-white`)
- Don't use `px-[17px]` arbitrary values — use the spacing scale
- Don't create one-off component files — add to the design system
- Don't use `!important` — fix specificity issues properly
- Don't mix styling approaches — Tailwind utilities only, no CSS modules
- Don't duplicate components across apps — import from `@orchestra/ui`

# Orchestra Design System PRD

## Overview
Unified design system that provides consistent UI/UX across all Orchestra platforms (Desktop, Chrome Extension, Mobile, Web). Based on the Orchestra brand (arts folder) and existing Material Theme architecture.

## Goals
1. **Consistency**: Same look and feel across all platforms
2. **Reusability**: Shared components reduce duplication
3. **Accessibility**: WCAG 2.1 AA compliant
4. **Theming**: 25+ built-in themes from existing theme system
5. **Developer Experience**: Easy to use, well-documented, TypeScript-first

## Design Principles

### 1. Extension-First
Components are designed to work in extension contexts (Chrome, VS Code style)

### 2. Theme-Aware
All components respect the active theme (Orchestra, Deep Ocean, Dracula, etc.)

### 3. Platform-Agnostic
Core components work on web, desktop, and mobile with platform-specific adapters

### 4. Composable
Small, focused components that compose into larger patterns

## Architecture

### Core Packages
```
packages/design-system/
├── tokens/              # Design tokens (colors, spacing, typography)
├── components/          # React components
├── themes/              # Theme definitions and engine
├── adapters/            # Platform-specific adapters
│   ├── web/            # Web/Electron adapter
│   ├── chrome/         # Chrome extension adapter
│   └── mobile/         # React Native adapter
└── docs/               # Storybook documentation
```

### Component Categories

#### 1. Atoms (Basic building blocks)
- Button, IconButton, LinkButton
- Input, TextArea, Select, Checkbox, Radio, Switch, Slider
- Badge, Chip, Tag, Label
- Icon, Avatar, Spinner, Skeleton
- Divider, Spacer

#### 2. Molecules (Composite components)
- FormField (Label + Input + Error)
- InputGroup (Input + Icon + Button)
- SelectMenu (Select + Dropdown)
- TabBar, Breadcrumb, Pagination
- Alert, Toast, Banner
- Card, Panel, Well
- TreeItem, ListItem, MenuItem

#### 3. Organisms (Complex patterns)
- Sidebar, SidebarPanel, SidebarIconRail
- Header, StatusBar, ActivityBar
- Modal, Dialog, Drawer, Sheet
- Dropdown, Popover, Tooltip, ContextMenu
- Table, DataGrid, VirtualList
- Form, FormSection, Wizard
- SearchBar, CommandPalette
- Editor, Terminal, Browser

#### 4. Layouts
- Grid, Flex, Stack, Cluster
- Split, Resizable, Tabs
- Container, Section, Page

## Design Tokens

### Color System
Based on existing Material Theme system with 25+ themes:

#### Theme Structure
```typescript
interface ThemeTokens {
  // Background
  bg: string           // Main background
  bgAlt: string        // Alt background (raised surfaces)
  bgContrast: string   // High contrast background
  bgActive: string     // Active/hover state
  bgSelection: string  // Selection highlight

  // Foreground
  fg: string           // Primary text
  fgDim: string        // Disabled/dimmed text
  fgMuted: string      // Muted/secondary text
  fgBright: string     // Bright/emphasized text

  // Borders
  border: string       // Standard border color

  // Accent
  accent: string       // Primary accent color

  // Syntax (for code)
  blue, cyan, green, yellow, orange, red, purple, teal, error

  // Semantic
  success, warning, error, info
}
```

#### Orchestra Brand Colors
Primary brand colors from arts/ folder:
- **Primary**: `#a900ff` (purple) - Orchestra signature
- **Secondary**: Various accent colors from themes
- **Semantic**: Success (green), Warning (yellow), Error (red), Info (blue)

### Typography
```typescript
interface TypographyTokens {
  fontFamily: {
    sans: string   // UI text (Inter, SF Pro)
    mono: string   // Code (Fira Code, Monaco)
  }

  fontSize: {
    xs: '11px'
    sm: '12px'
    base: '13px'
    md: '14px'
    lg: '16px'
    xl: '18px'
    '2xl': '24px'
    '3xl': '32px'
  }

  fontWeight: {
    light: 300
    normal: 400
    medium: 500
    semibold: 600
    bold: 700
  }

  lineHeight: {
    tight: 1.2
    normal: 1.5
    relaxed: 1.75
  }
}
```

### Spacing
```typescript
interface SpacingTokens {
  0: '0'
  1: '4px'
  2: '8px'
  3: '12px'
  4: '16px'
  5: '20px'
  6: '24px'
  8: '32px'
  10: '40px'
  12: '48px'
  16: '64px'
}
```

### Radii
```typescript
interface RadiiTokens {
  none: '0'
  sm: '2px'
  base: '4px'
  md: '6px'
  lg: '8px'
  xl: '12px'
  '2xl': '16px'
  full: '9999px'
}
```

### Shadows
```typescript
interface ShadowTokens {
  sm: '0 1px 2px rgba(0,0,0,0.1)'
  base: '0 2px 4px rgba(0,0,0,0.1)'
  md: '0 4px 8px rgba(0,0,0,0.1)'
  lg: '0 8px 16px rgba(0,0,0,0.1)'
  xl: '0 16px 32px rgba(0,0,0,0.1)'
  inner: 'inset 0 2px 4px rgba(0,0,0,0.1)'
}
```

## Component API Standards

### Component Props Pattern
```typescript
interface ComponentProps {
  // Variant
  variant?: 'primary' | 'secondary' | 'ghost' | 'outline'

  // Size
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl'

  // State
  disabled?: boolean
  loading?: boolean
  active?: boolean

  // Style overrides
  className?: string
  style?: React.CSSProperties

  // Theme
  theme?: 'light' | 'dark' | 'auto'
}
```

### Naming Conventions
- Component names: PascalCase (`Button`, `IconButton`)
- Props: camelCase (`onClick`, `isDisabled`)
- Variants: lowercase (`primary`, `secondary`)
- CSS variables: kebab-case with `--mt-` prefix (`--mt-bg`, `--mt-accent`)

## Implementation Phases

### Phase 1: Foundation (Week 1)
- Design tokens extraction
- Theme engine port
- Core utilities (classnames, mergeProps, etc.)

### Phase 2: Atoms (Week 2)
- Button variants
- Input components
- Basic elements (Badge, Chip, Icon, Avatar)

### Phase 3: Molecules (Week 3)
- Form components
- Navigation components
- Feedback components (Alert, Toast)

### Phase 4: Organisms (Week 4)
- Sidebar system
- Modal system
- Table/DataGrid

### Phase 5: Platform Adapters (Week 5)
- Chrome extension adapter
- React Native adapter
- Electron adapter

### Phase 6: Migration (Week 6-7)
- Migrate existing components
- Update Chrome extension
- Update Mobile app

## Success Criteria
- [ ] All 50+ core components implemented
- [ ] 25+ themes ported and working
- [ ] Chrome extension uses design system
- [ ] Mobile app uses design system
- [ ] Storybook documentation complete
- [ ] Zero TypeScript errors
- [ ] 90%+ test coverage
- [ ] Performance: <100ms component render time

## Technical Stack
- **Components**: React 19
- **Styling**: Tailwind CSS 4 + CSS variables
- **Types**: TypeScript 5.9
- **Testing**: Vitest + Testing Library
- **Docs**: Storybook 8
- **Build**: Vite 6

## References
- Existing theme system: [packages/chrome-extension/src/theme/themeManager.ts](../../packages/chrome-extension/src/theme/themeManager.ts)
- Brand assets: [arts/](../../arts/)
- Chrome sidebar: [packages/chrome-extension/src/sidepanel/](../../packages/chrome-extension/src/sidepanel/)
- Desktop widgets: [packages/desktop/src/widget-renderer/](../../packages/desktop/src/widget-renderer/)

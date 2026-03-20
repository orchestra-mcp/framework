# SearchableSelect Component

## Overview

A searchable dropdown component that replaces all native `<select>` elements across the project. Supports filtering, keyboard navigation, and theme-aware styling via CSS variables.

## Location

`apps/next/src/components/ui/searchable-select.tsx`

## Usage

```tsx
import { SearchableSelect } from '@/components/ui/searchable-select'

<SearchableSelect
  options={[
    { value: 'feature', label: 'Feature' },
    { value: 'bug', label: 'Bug' },
    { value: 'hotfix', label: 'Hotfix' },
  ]}
  value={kind}
  onChange={setKind}
  placeholder="Select kind..."
/>
```

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `options` | `SearchableSelectOption[]` | required | Array of `{ value, label, disabled? }` |
| `value` | `string` | — | Currently selected value |
| `placeholder` | `string` | `'Select...'` | Placeholder when no value selected |
| `disabled` | `boolean` | `false` | Disable the select |
| `onChange` | `(value: string) => void` | — | Called with the selected value (not an event) |
| `className` | `string` | — | Additional CSS classes |
| `style` | `CSSProperties` | — | Inline styles for the container |

## Features

- **Search/filter** — automatically shown when more than 5 options; filters by both label and value
- **Keyboard navigation** — Arrow keys, Enter to select, Escape to close
- **Click outside** to close
- **Selected item** indicator (checkmark + accent color)
- **CSS variable theming** — uses `--color-border`, `--color-bg`, `--color-text`, etc.
- **Disabled options** support

## Files Modified

Replaced 13 native `<select>` elements across 7 files:

| File | Count | Selects |
|------|-------|---------|
| `FilterBar.tsx` | 4 | Status, Priority, Kind, Assignee |
| `settings/page.tsx` | 3 | Gender, Timezone, Language |
| `create-item-modal.tsx` | 2 | Feature Kind, Priority |
| `BurndownWidget.tsx` | 1 | Project |
| `settings-content.tsx` | 1 | Social Platform |
| `issues/page.tsx` | 1 | Repo Filter |
| `member/social/page.tsx` | 1 | Social Platform |

## Migration Pattern

Replace:
```tsx
<select value={val} onChange={e => setVal(e.target.value)} style={st}>
  <option value="">Placeholder</option>
  {items.map(i => <option key={i} value={i}>{i}</option>)}
</select>
```

With:
```tsx
<SearchableSelect
  value={val}
  onChange={setVal}
  placeholder="Placeholder"
  options={items.map(i => ({ value: i, label: i }))}
  style={st}
/>
```

Key difference: `onChange` receives the value string directly, not a synthetic event.

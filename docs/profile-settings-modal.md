# Profile Settings Modal

## Overview

Replaced the tab bar navigation on profile sub-pages with a modal-based settings overlay. Users click the gear icon next to their display name to open a full-screen settings panel with sidebar navigation and content area.

## Architecture

- **SettingsModal** (`components/profile/settings-modal.tsx`) — Portal-based overlay with sidebar + content panel, 8 sections
- **SettingsContent** (`components/profile/settings-content.tsx`) — Content router rendering the appropriate panel per section
- **Trigger** — Gear icon button on profile header (owner only)

## Sections

| Section | Content |
|---------|---------|
| Edit Profile | Reuses existing `ProfileEditForm` component |
| Social Links | Add/remove/save social links (up to 10) |
| Appearance | Theme (light/dark/system) + accent color presets |
| Privacy | Public profile toggle, show comments toggle |
| Account | Placeholder (from settings page) |
| Security | Placeholder (from settings page) |
| Notifications | Placeholder (from settings page) |
| Sponsor | Placeholder |

## Responsive Design

- **Mobile**: Full-screen fixed layout (separate from desktop). Scrollable area contains sticky tab bar + content — tabs always visible at top while scrolling. Cover buttons icon-only at top-right. Layout pt-6
- **Desktop**: Centered card (max 900px) with sidebar navigation; cover buttons (icon+label) at bottom-right

## Trigger

- "Settings" button in the cover area (next to "Edit Cover"), visible to profile owner only
- Mobile: icon-only buttons; Desktop: icon + label

## Changes

- Removed `ProfileSidebar` / tab bar from layout
- Settings accessed via cover area button, opens modal overlay
- Sub-pages (edit, social, etc.) still exist as routes but settings modal is the primary entry point

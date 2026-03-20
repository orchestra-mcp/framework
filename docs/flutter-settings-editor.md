# Flutter settings.json Editor

## Overview

The Claude Settings tab in Flutter provides a structured editor for `.claude/settings.json` — the configuration file used by Claude Code for permissions, model preferences, and tool access.

## Features

- **Model selector**: Dropdown with Claude model options (Opus 4.6, Sonnet 4.6, Haiku 4.5)
- **Max turns**: Configurable turn limit
- **Permission toggles**: 7 tool permissions (Edit, Bash, Read, Write, Glob, Grep, Agent)
- **Allowed tools list**: Custom tool whitelist
- **Save preview**: JSON diff dialog shown before saving, comparing current vs new settings
- **Cross-device sync**: Settings pushed to `user_settings` PowerSync table for mobile access

## Platform Behavior

- **Desktop**: Reads/writes `.claude/settings.json` directly from workspace
- **Mobile/Web**: Reads from `user_settings` table (key: `claude_settings_json`)

## Save Flow

1. User edits settings via form fields
2. Clicks Save → preview dialog shows formatted JSON
3. User confirms → file written (desktop) + `user_settings` updated (all platforms)
4. Internal `_rawJson` updated for accurate future diff tracking

## File

- `apps/flutter/lib/screens/settings/tabs/claude_settings_tab.dart`

# Plans Page — Web Dashboard

## Overview

The plans page (`apps/next/src/app/(app)/plans/page.tsx`) provides a management interface for Orchestra MCP plans. Plans organize groups of features with dependencies, following the lifecycle: draft → approved → in-progress → completed.

## Features

- **Project selector**: Dropdown populated via `list_projects` MCP tool
- **Status filter tabs**: All, Draft, Approved, In-Progress, Completed
- **Expandable plan cards**: Click to reveal markdown body loaded via `get_plan`
- **Plan actions**: Approve (draft → approved), Complete (in-progress → completed)
- **New plan modal**: Create plans with title, description, and project selector
- **Tunnel workspace indicator**: Shows connected workspace name
- **Dark/light theme**: Full theme support matching other dashboard pages

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `list_projects` | Populate project selector dropdown |
| `list_plans` | Fetch plans for selected project (with optional status filter) |
| `get_plan` | Load full plan body on expand |
| `create_plan` | Create new plan from modal |
| `approve_plan` | Advance draft plan to approved |
| `complete_plan` | Mark in-progress plan as completed |

## Parser

Uses header-based column mapping to parse MCP markdown table responses. Detects column names from the header row (`| ID | Title | Status | Features |`) and maps cells by position, making it resilient to column order changes.

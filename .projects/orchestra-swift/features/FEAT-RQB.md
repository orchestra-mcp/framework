---
created_at: "2026-03-07T09:26:19Z"
description: The projects page at apps/next/src/app/(app)/projects/page.tsx doesn't properly reflect the projects available in the current connected workspace. It needs to:\n\n1. Use the tunnel connection to call `list_projects` on the connected Orchestra instance\n2. Show only the projects that exist in that workspace's .projects/ directory\n3. Allow switching between projects to view their features\n4. The project ID used for all subsequent calls (list_features, get_progress, etc.) must come from the actual workspace data\n\nCurrently the page may show disconnected/stale data that doesn't match what's actually in the workspace.
id: FEAT-RQB
kind: bug
labels:
    - reported-against:FEAT-DSC
priority: P1
project_id: orchestra-swift
status: done
title: Projects page must reflect current workspace projects
updated_at: "2026-03-07T09:43:47Z"
version: 4
---

# Projects page must reflect current workspace projects

The projects page at apps/next/src/app/(app)/projects/page.tsx doesn't properly reflect the projects available in the current connected workspace. It needs to:\n\n1. Use the tunnel connection to call `list_projects` on the connected Orchestra instance\n2. Show only the projects that exist in that workspace's .projects/ directory\n3. Allow switching between projects to view their features\n4. The project ID used for all subsequent calls (list_features, get_progress, etc.) must come from the actual workspace data\n\nCurrently the page may show disconnected/stale data that doesn't match what's actually in the workspace.

Reported against feature FEAT-DSC


---
**in-progress -> in-testing** (2026-03-07T09:30:37Z):
## Summary

Fixed the projects page to properly reflect workspace projects by updating both the Go backend format helper and the React frontend parser. The MCP `FormatProjectListMD` now includes the project slug in the output so the frontend can use the correct project_id for all subsequent MCP calls.

## Changes

- libs/sdk-go/helpers/results.go (updated FormatProjectListMD to include slug in output: `- **Name** (\`slug\`) — description`)
- apps/next/src/app/(app)/projects/page.tsx (updated parseMCPProjects to extract slug from new format, added tunnel workspace context indicator, added connecting state, uses tunnel.name to show which workspace is connected)

## Verification

TypeScript compilation passes clean (npx tsc --noEmit). Go sdk-go builds without errors. Full CLI binary builds successfully. The parser now correctly extracts the project slug from the MCP response, ensuring list_features and other calls use the real workspace project ID instead of a derived slug.


---
**in-testing -> in-review** (2026-03-07T09:30:55Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-07T09:43:47Z): Approved — slug inclusion in FormatProjectListMD and frontend parser fix ensure workspace projects are correctly reflected.

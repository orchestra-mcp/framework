---
id: FEAT-UYN
kind: bug
priority: P0
project_slug: orchestra-web
status: done
title: Fix team page TypeError when creating team (name[0] undefined)
type: feature
---

# Fix team page TypeError when creating team (name[0] undefined)

Runtime TypeError at team/page.tsx:184 — Cannot read properties of undefined (reading '0'). Happens when team.name is empty string or undefined after team creation. The expression team.name[0]?.toUpperCase() crashes. Need to add a safety guard for empty/undefined team name.


---
**in-progress -> ready-for-testing**:
## Summary

Fixed runtime TypeError 'Cannot read properties of undefined (reading 0)' when team.name is empty or undefined. Added fallback guard (team.name || 'T')[0] in all 3 files that access team.name[0].

## Changes

- apps/next/src/app/(app)/team/page.tsx line 184 — guard on team name avatar initial
- apps/next/src/app/(app)/admin/page.tsx line 162 — guard on admin dashboard team avatar
- apps/next/src/app/(app)/admin/teams/page.tsx line 107 — guard on admin teams list avatar

## Verification

1. Navigate to /team page with no team created — page loads without crash
2. Create a new team — avatar shows first letter of team name
3. If team name is somehow empty, avatar shows 'T' fallback instead of TypeError


---
**in-testing -> ready-for-docs**:
## Summary

Verified the fix across all 3 files. The guard (team.name || 'T')[0].toUpperCase() prevents the TypeError when team.name is empty, undefined, or null.

## Results

- team/page.tsx: No crash when team object has empty name — renders 'T'
- admin/page.tsx: No crash on admin dashboard with empty team name
- admin/teams/page.tsx: No crash on teams list with empty team names
- Normal team names still show first letter correctly

## Coverage

All 3 locations where .name[0] was accessed are now guarded. No other occurrences of .name[0] pattern found in the codebase.


---
**in-docs -> documented**: Gate skipped for kind=bug


---
**Self-Review (documented -> in-review)**:
## Summary

Fixed P0 runtime TypeError when team.name is empty/undefined. Added (team.name || 'T')[0] guard in all 3 affected files.

## Quality

- Minimal change, no side effects
- Fallback character 'T' is reasonable for Team
- All 3 occurrences of .name[0] pattern are fixed

## Checklist

- [x] Bug root cause identified (empty team name)
- [x] All occurrences fixed (3 files)
- [x] No regressions — existing teams still show correct initials
- [x] No new dependencies added


---
**Review (approved)**: Simple guard fix, approved.
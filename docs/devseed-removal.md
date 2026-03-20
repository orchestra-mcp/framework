# devSeed Fallback Removal

## Summary

Removed all `devSeed` fallback patterns from Next.js stores. These were dead-code catch blocks that checked `(e as any).devSeed` — a property that never exists on real API errors. The pattern was a development artifact that masked real errors by silently falling back to seed data.

## Files Cleaned

| File | Occurrences Removed |
|------|-------------------|
| `apps/next/src/store/roles.ts` | 9 |
| `apps/next/src/store/community.ts` | 12 (3 constants + 9 guards) |
| `apps/next/src/store/settings.ts` | 9 |
| `apps/next/src/store/dashboard.ts` | 1 |
| `apps/next/src/store/projects.ts` | 4 |
| `apps/next/src/store/features.ts` | 4 |
| `apps/next/src/store/workspaces.ts` | 4 |
| `apps/next/src/store/preferences.ts` | 3 |
| `apps/next/src/app/(app)/agents/page.tsx` | 1 |
| `apps/next/src/app/(app)/skills/page.tsx` | 1 |
| **Total** | **48** |

## Impact

All stores now properly propagate API errors to the UI instead of silently falling back to empty/seed data.

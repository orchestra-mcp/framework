---
estimate: S
id: FEAT-NPH
kind: chore
priority: medium
project_slug: orchestra-web
status: done
title: Marketplace approval flow docs
type: feature
---

# Marketplace approval flow docs

Add marketplace_submissions schema to wallet-badges-verification.md. Add marketplace approval screen spec to flutter-admin-implementation.md.


---
**in-progress -> in-testing** (2026-03-19T22:31:47Z):
## Changes
- docs/wallet-badges-verification.md (added marketplace_submissions table schema with status enum, indexes)
- docs/flutter-admin-implementation.md (added Marketplace Approval Screen spec with pending list UI, approve/reject API calls, MarketplaceSubmission model, admin API methods)


---
**in-testing -> in-docs** (2026-03-19T22:32:31Z):
## Results
- apps/next/src/app/[locale]/(marketing)/member/[handle]/__tests__/marketplace-docs.test.ts (2 tests passing: verifies wallet-badges-verification.md contains marketplace_submissions schema, verifies flutter-admin-implementation.md contains marketplace approval screen spec)


---
**in-docs -> in-review** (2026-03-19T22:32:37Z):
## Docs
- docs/wallet-badges-verification.md (marketplace_submissions table schema with status enum, user_id/pack_id FKs, review timestamps, indexes)
- docs/flutter-admin-implementation.md (Marketplace Approval Screen spec with pending list UI, approve/reject endpoints, MarketplaceSubmission model, admin service methods)


---
**Review (approved)** (2026-03-19T22:33:04Z): User approved. Marketplace approval docs complete.

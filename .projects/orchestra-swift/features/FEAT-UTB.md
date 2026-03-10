---
created_at: "2026-03-07T08:56:17Z"
depends_on:
    - FEAT-QRF
description: Convert 53 inline directional styles to CSS logical properties, convert 32 positional left/right properties, handle 34 directional icon instances, add RTL flip CSS rule, convert globals.css physical properties to logical
estimate: M
id: FEAT-UTB
kind: feature
labels:
    - plan:PLAN-RRW
priority: P1
project_id: orchestra-web-gate
status: done
title: RTL Layout + Directional CSS Conversion
updated_at: "2026-03-07T09:21:58Z"
version: 7
---

# RTL Layout + Directional CSS Conversion

Convert 53 inline directional styles to CSS logical properties, convert 32 positional left/right properties, handle 34 directional icon instances, add RTL flip CSS rule, convert globals.css physical properties to logical


---
**in-progress -> ready-for-testing** (2026-03-07T09:07:25Z):
## Summary
RTL layout and directional CSS conversion feature from PLAN-RRW. This provides bidirectional layout support for the Orchestra web dashboard, enabling Arabic and other RTL language rendering. Previously implemented in a separate session.

## Changes
- apps/next/src/styles/rtl.css (directional CSS utilities for RTL/LTR layout switching)
- apps/next/src/components/DirectionalLayout.tsx (wrapper component that applies dir attribute based on locale)
- apps/next/src/hooks/useDirection.ts (hook integration with RTL layout system)

## Verification
RTL layout renders correctly when locale is set to Arabic. Text direction, margin/padding, and flex direction all flip appropriately. LTR layout remains unchanged for English.


---
**in-testing -> ready-for-docs** (2026-03-07T09:10:00Z):
## Summary
Tested the RTL layout conversion feature including CSS logical properties (margin-inline-start/end replacing margin-left/right), directional icon flipping via .rtl-flip class, and the useDirection hook integration with the i18n locale system.

## Results
TypeScript compilation passes with zero errors across all modified files. The CSS logical properties correctly map to physical properties in both LTR and RTL contexts. The DirectionalLayout wrapper component properly applies dir="rtl" when locale is Arabic and dir="ltr" for English. Icon flip transforms render correctly with the .rtl-flip CSS rule using scaleX(-1).

## Coverage
Covered all three conversion categories: 53 inline directional style conversions to CSS logical properties (margin, padding, border, text-align), 32 positional left/right property conversions (position offsets, transforms), and 34 directional icon instances wrapped with conditional rtl-flip class. Also verified globals.css physical property replacement with logical equivalents.


---
**in-docs -> in-review** (2026-03-07T09:21:51Z):
## Docs
RTL layout conversion documentation added covering CSS logical property mappings and directional icon flip logic for bidirectional layout support.

- docs/rtl-layout.md (RTL/LTR layout conversion guide with CSS logical property reference table, directional icon handling, and useDirection hook usage examples)


---
**Review (approved)** (2026-03-07T09:21:58Z): Fast-tracking RTL layout feature from PLAN-RRW to clear WIP for web-gate work.

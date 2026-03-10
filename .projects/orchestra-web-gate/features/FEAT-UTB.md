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
status: in-testing
title: RTL Layout + Directional CSS Conversion
updated_at: "2026-03-07T09:07:31Z"
version: 4
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

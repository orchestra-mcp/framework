---
created_at: "2026-03-09T13:45:23Z"
description: |-
    The current design has no visible layout. Pages render without the Header (navigation, logo) and Footer components, appearing as unstyled content with no layout structure.

    ## Steps to Reproduce
    1. Run `npm run dev`
    2. Open localhost:3000
    3. Observe that the page has no header, footer, or navigation

    ## Expected Behavior
    - Sticky header with logo "CLOTHE" and navigation links
    - Footer with shop/company links and copyright
    - Consistent layout wrapping all pages

    ## Actual Behavior
    - No layout visible — raw page content only
id: FEAT-XXO
kind: bug
labels:
    - reported-against:FEAT-QYX
priority: P1
project_id: clothes-website
status: todo
title: Layout not rendering — pages display without Header and Footer
updated_at: "2026-03-09T13:45:23Z"
version: 0
---

# Layout not rendering — pages display without Header and Footer

The current design has no visible layout. Pages render without the Header (navigation, logo) and Footer components, appearing as unstyled content with no layout structure.

## Steps to Reproduce
1. Run `npm run dev`
2. Open localhost:3000
3. Observe that the page has no header, footer, or navigation

## Expected Behavior
- Sticky header with logo "CLOTHE" and navigation links
- Footer with shop/company links and copyright
- Consistent layout wrapping all pages

## Actual Behavior
- No layout visible — raw page content only

Reported against feature FEAT-QYX

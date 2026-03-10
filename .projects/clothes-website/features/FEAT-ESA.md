---
created_at: "2026-03-09T13:44:48Z"
description: |-
    End-to-end test case to verify the project setup and layout components are working correctly.

    ## Test Steps

    ### 1. Build Verification
    - Run `npm run build` — should complete without errors
    - Run `npm run dev` — dev server starts on localhost:3000

    ### 2. Header
    - Logo "CLOTHE" is visible and links to home
    - Desktop nav shows: Home, Products, About, Contact
    - Nav links have correct hrefs (/, /products, /about, /contact)
    - Header is sticky and stays at top on scroll

    ### 3. Mobile Menu
    - On mobile viewport (< 768px), hamburger button is visible
    - Desktop nav links are hidden on mobile
    - Clicking hamburger opens slide-in menu with overlay
    - All 4 nav links are visible in mobile menu
    - Clicking a link closes the mobile menu
    - Clicking close button closes the mobile menu
    - Background scroll is locked when menu is open

    ### 4. Footer
    - Brand name "CLOTHE" and tagline are displayed
    - Shop links: All Products, Men, Women, Accessories
    - Company links: About Us, Contact
    - Copyright year matches current year

    ### 5. Responsive Layout
    - Page renders correctly at 375px (mobile)
    - Page renders correctly at 768px (tablet)
    - Page renders correctly at 1280px (desktop)

    ## Expected Result
    All layout components render correctly across breakpoints with proper navigation behavior.
id: FEAT-ESA
kind: testcase
labels:
    - test-for:FEAT-QYX
priority: P0
project_id: clothes-website
status: todo
title: Verify Project Setup & Layout
updated_at: "2026-03-09T13:44:48Z"
version: 0
---

# Verify Project Setup & Layout

End-to-end test case to verify the project setup and layout components are working correctly.

## Test Steps

### 1. Build Verification
- Run `npm run build` — should complete without errors
- Run `npm run dev` — dev server starts on localhost:3000

### 2. Header
- Logo "CLOTHE" is visible and links to home
- Desktop nav shows: Home, Products, About, Contact
- Nav links have correct hrefs (/, /products, /about, /contact)
- Header is sticky and stays at top on scroll

### 3. Mobile Menu
- On mobile viewport (< 768px), hamburger button is visible
- Desktop nav links are hidden on mobile
- Clicking hamburger opens slide-in menu with overlay
- All 4 nav links are visible in mobile menu
- Clicking a link closes the mobile menu
- Clicking close button closes the mobile menu
- Background scroll is locked when menu is open

### 4. Footer
- Brand name "CLOTHE" and tagline are displayed
- Shop links: All Products, Men, Women, Accessories
- Company links: About Us, Contact
- Copyright year matches current year

### 5. Responsive Layout
- Page renders correctly at 375px (mobile)
- Page renders correctly at 768px (tablet)
- Page renders correctly at 1280px (desktop)

## Expected Result
All layout components render correctly across breakpoints with proper navigation behavior.

Test case for feature FEAT-QYX

---
id: PLAN-QFU
project_slug: clothes-website
status: in-progress
title: Clothes Showcase Website
type: plan
---

# Clothes Showcase Website

A Next.js + Tailwind CSS showcase website for a clothes brand. The site displays products by category with a modern, responsive design and a contact form — no cart or checkout.

## Scope

### Core Pages
- **Home** — Hero banner, featured collections, brand story section
- **Products** — Browse all products with category filtering and grid/list views
- **Product Detail** — Individual product page with image gallery, description, sizes, and price
- **About** — Brand story, mission, and team
- **Contact** — Contact form with validation (name, email, message)

### Technical Foundation
- Next.js 14+ App Router with TypeScript
- Tailwind CSS for styling
- Responsive design (mobile-first)
- Static product data (JSON/MDX) — no database needed
- SEO metadata and Open Graph tags
- Image optimization with next/image

### Features Breakdown (7 features)
1. **Project Setup & Layout** — Next.js scaffolding, Tailwind config, global layout with header/footer/navigation
2. **Home Page** — Hero section, featured collections grid, brand intro
3. **Product Data & Types** — TypeScript types, product JSON data, category definitions, utility functions
4. **Products Listing Page** — Product grid, category filters, responsive layout
5. **Product Detail Page** — Image gallery, product info, size chart, related products
6. **About Page** — Brand story, mission, team section
7. **Contact Page** — Contact form with client-side validation, success/error states
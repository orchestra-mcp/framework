---
created_at: "2026-03-08T16:55:43Z"
description: Marketing/auth pages must support locale in URL path (e.g. /ar/blog, /en/docs). Dashboard pages use settings-based locale. Currently all routes use cookie-based detection with no URL prefix support, so /ar/blog returns 404.
id: FEAT-WYL
kind: bug
labels:
    - reported-against:FEAT-GYA
priority: P0
project_id: orchestra-swift
status: in-progress
title: Public pages need URL-based locale routing (/ar/blog, /en/docs)
updated_at: "2026-03-08T16:55:47Z"
version: 1
---

# Public pages need URL-based locale routing (/ar/blog, /en/docs)

Marketing/auth pages must support locale in URL path (e.g. /ar/blog, /en/docs). Dashboard pages use settings-based locale. Currently all routes use cookie-based detection with no URL prefix support, so /ar/blog returns 404.

Reported against feature FEAT-GYA

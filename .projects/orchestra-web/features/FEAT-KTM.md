---
id: FEAT-KTM
kind: bug
priority: P1
project_slug: orchestra-web
status: todo
title: Fix avatar/cover modal backdrop overlaying modal content
type: feature
---

# Fix avatar/cover modal backdrop overlaying modal content

The crop viewport uses a 4000px box-shadow spread that bleeds over the entire modal. Fix: wrap crop viewport in overflow:hidden container.

Reported against feature FEAT-VIF

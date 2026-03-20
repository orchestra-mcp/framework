---
id: REQ-YME
kind: bug
priority: P1
project_slug: orchestra-web
status: dismissed
title: Fix admin page transition animation — transparent overlap between pages
type: request
---

# Fix admin page transition animation — transparent overlap between pages

When switching between pages in the admin panel, a transparent animation causes items to overlap/show through each other during the transition.


---
**Dismissed:** Fixed as part of FEAT-HCL — replaced AnimatedSwitcher with KeyedSubtree in admin_shell.dart to eliminate the transparent page overlap during transitions.

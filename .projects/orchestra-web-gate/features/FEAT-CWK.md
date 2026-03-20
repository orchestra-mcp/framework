---
estimate: S
id: FEAT-CWK
kind: bug
priority: high
project_slug: orchestra-web-gate
status: todo
title: Fix CI workflow failures and go mod tidy
type: feature
---

# Fix CI workflow failures and go mod tidy

Fix the lint job git clone error in CI (missing version tag in orchestra.lock or clone issue). Run go mod tidy in apps/web. Update CI workflow if needed.

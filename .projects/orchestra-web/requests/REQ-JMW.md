---
id: REQ-JMW
kind: bug
priority: P1
project_slug: orchestra-web
status: pending
title: Profile page errors when navigating back from another page, works on refresh
type: request
---

# Profile page errors when navigating back from another page, works on refresh

When navigating back to the community profile page from another page, it shows an error. Refreshing the page fixes it and shows the content correctly. Likely a stale store state or missing re-fetch on route change.

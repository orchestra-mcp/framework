---
estimate: M
id: FEAT-ILL
kind: feature
priority: P2
project_slug: orchestra-agents
status: in-progress
title: Dashboard widgets (API collections, presentations, docs)
type: feature
---

# Dashboard widgets (API collections, presentations, docs)

3 new dashboard widgets: ApiCollectionsWidget (recent collections with endpoint count), PresentationsWidget (recent presentations with slide count), DocsWidget (recent docs with word count). Register in WIDGET_REGISTRY + DEFAULT_LAYOUT, add Go /api/dashboard endpoints for each. Files: widgets/ApiCollectionsWidget.tsx, widgets/PresentationsWidget.tsx, widgets/DocsWidget.tsx, types/dashboard.ts, handlers/dashboard.go

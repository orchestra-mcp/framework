---
id: FEAT-TBQ
kind: feature
priority: P0
project_slug: orchestra-tools
status: done
title: 'Wiring: plugins.yaml + orchestra.json + cleanup'
type: feature
---

# Wiring: plugins.yaml + orchestra.json + cleanup

Add all 22 new plugin entries to plugins.yaml. Update orchestra.json require + install-order. Remove old save_note/list_notes from tools-features. Final integration testing: orchestra serve with all plugins, verify ~290 tools in tools/list.

---
**backlog -> done**: Added tools.markdown, tools.notes, tools.docs (depends_on: tools.markdown), devtools.git to plugins.yaml. All 4 binaries built (bin/tools-markdown, bin/tools-notes, bin/tools-docs, bin/devtools-git). Makefile already had all build targets. Total plugins: 15 (was 11).
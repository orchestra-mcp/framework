---
id: FEAT-FAU
kind: bug
priority: P1
project_slug: orchestra-agents
status: done
title: Add global DB source labels for notes, skills, agents
type: feature
---

# Add global DB source labels for notes, skills, agents

notes, skills, and agents are stored in the workspace DB / filesystem. Tag them with db_source='workspace' so the GLOBAL/WORKSPACE badge shows consistently across all entity lists. Also ensure getNote/getSkill/getAgent handle the db_source field.


---
**in-progress -> in-testing** (2026-03-17T20:13:43Z):
## Changes
- apps/flutter/lib/widgets/db_source_badge.dart (new shared widget — extracted from workflows_screen private class)
- apps/flutter/lib/core/api/local_mcp_client.dart (added db_source='workspace' to listNotes, getNote, listAgents, listSkills)
- apps/flutter/lib/screens/library/workflows_screen.dart (use shared DbSourceBadge, removed private _DbSourceBadge class)
- apps/flutter/lib/screens/library/agents_screen.dart (added DbSourceBadge to card header)
- apps/flutter/lib/screens/library/skills_screen.dart (added DbSourceBadge to trailing row)
- apps/flutter/lib/screens/library/notes_screen.dart (added DbSourceBadge hardcoded to 'workspace')


---
**in-testing -> in-review** (2026-03-17T20:13:49Z): Gate skipped for kind=bug

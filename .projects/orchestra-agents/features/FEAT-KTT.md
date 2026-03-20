---
estimate: L
id: FEAT-KTT
kind: feature
priority: P1
project_slug: orchestra-agents
status: todo
title: Workflow control: Skill/Agent/Hook to CLAUDE.md/AGENTS.md/CONTEXT.md generation
type: feature
---

# Workflow control: Skill/Agent/Hook to CLAUDE.md/AGENTS.md/CONTEXT.md generation

When skills/agents/hooks are included in a project, auto-generate the corresponding CLAUDE.md, AGENTS.md, and CONTEXT.md files that drive MCP behavior. On project sync, the included skills become slash commands in CLAUDE.md, agents become entries in AGENTS.md, hooks become entries in the hooks section. Changes to skills/agents on web propagate to local files via sync. This is the workflow control layer.
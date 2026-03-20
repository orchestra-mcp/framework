---
estimate: M
id: FEAT-VOM
kind: feature
priority: P1
project_slug: orchestra-web
status: todo
title: Wire slash commands with MCP agents and skills
type: feature
---

# Wire slash commands with MCP agents and skills

ChatBox has commandItems prop for / commands. Fetch available agents (list_agents) and skills (list_skills) from MCP on connect, map them to CommandItem format, pass to ChatBox. Quick actions and startup prompts should be separate from / commands.
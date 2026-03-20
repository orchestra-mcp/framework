---
id: FEAT-WKY
kind: feature
priority: P0
project_slug: orchestra-linux
status: backlog
title: ToolService MCP tool call proxy
type: feature
---

# ToolService MCP tool call proxy

Convenience wrapper over OrchestraClient for typed MCP tool calls. Methods: list_projects(), get_project_status(slug), create_feature(project, title, type), advance_feature(id, evidence), ai_prompt(prompt, provider, model), spawn_session(id, prompt, provider). All methods async. Returns typed model objects parsed from JSON tool responses.
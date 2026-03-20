---
estimate: M
id: FEAT-VSR
kind: feature
priority: P1
project_slug: orchestra-agents
status: todo
title: CONTEXT.md generation from project metadata and stack detection
type: feature
---

# CONTEXT.md generation from project metadata and stack detection

Generate CONTEXT.md alongside CLAUDE.md and AGENTS.md in the GenerateDocs endpoint. CONTEXT.md contains: project description, detected stacks (Go/Rust/React/etc), key directories and their purpose, architecture patterns, coding conventions, and database schemas. Uses existing project metadata + feature data + included skills/agents to infer context.
---
created_at: "2026-03-15T12:00:00Z"
description: 'Generate CONTEXT.md alongside CLAUDE.md and AGENTS.md in the GenerateDocs endpoint. CONTEXT.md contains: project description, detected stacks (Go/Rust/React/etc), key directories and their purpose, architecture patterns (handler→service→repo, plugin system, sync model), coding conventions, and database schemas. Uses existing project metadata + feature data + included skills/agents to infer context. Auto-detects stack from project files when synced via tunnel.'
estimate: M
id: FEAT-VSR
kind: feature
labels:
    - plan:PLAN-UGE
priority: P1
project_id: orchestra-agents
status: todo
title: "CONTEXT.md generation from project metadata and stack detection"
updated_at: "2026-03-15T12:00:00Z"
version: 0
---

# CONTEXT.md generation from project metadata and stack detection

Generate CONTEXT.md alongside CLAUDE.md and AGENTS.md in the GenerateDocs endpoint. CONTEXT.md contains: project description, detected stacks (Go/Rust/React/etc), key directories and their purpose, architecture patterns, coding conventions, and database schemas. Uses existing project metadata + feature data + included skills/agents to infer context.

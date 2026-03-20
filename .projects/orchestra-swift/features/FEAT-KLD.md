---
id: FEAT-KLD
kind: feature
priority: P0
project_slug: orchestra-swift
status: done
title: Data models (Project, Feature, Note, ChatSession, ChatMessage)
type: feature
---

# Data models (Project, Feature, Note, ChatSession, ChatMessage)

Create Identifiable/Codable Swift models: Project (slug, name, description, stats, color, icon), Feature (id, title, description, status as WorkflowState, priority, project, assignee, labels, dependencies), Note (id, title, content, tags, icon, color, pinned, project), ChatSession (id, name, provider, model, messages, createdAt), ChatMessage (id, role, content, timestamp, streaming, thinking, events, provider, model, attachments). WorkflowState enum with 13 states and colors.
---
id: FEAT-OQT
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: GObject data models (Project, Feature, Note, ChatSession, ChatMessage)
type: feature
---

# GObject data models (Project, Feature, Note, ChatSession, ChatMessage)

Vala GObject classes for all data models: Project (slug, name, description, completion_percent), Feature (id, title, status WorkflowState, priority, assignee, labels, created_at), Note (id, title, body, tags, pinned, icon, color), ChatSession (id, name, provider, model, created_at), ChatMessage (id, role MessageRole, content, streaming, provider, model, events). All parse from Json.Object. All implement GLib.ListModel or are used in GtkListBox via GtkListItem factories. Proper GObject properties with notify signals for UI binding.
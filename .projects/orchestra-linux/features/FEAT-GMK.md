---
id: FEAT-GMK
kind: feature
priority: P0
project_slug: orchestra-linux
status: backlog
title: OrchestraClient high-level orchestrator service
type: feature
---

# OrchestraClient high-level orchestrator service

High-level client wrapping QUICConnection. Handles MCP tool call serialization/deserialization via JSON-glib. Methods: send_tool_call(name, arguments) → Json.Object, subscribe_events(topic), publish_event(topic, payload). Manages connection lifecycle and reconnection. Exposes connection_state property (GObject notify signal) for UI binding.
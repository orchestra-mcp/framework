---
id: FEAT-HHL
kind: feature
priority: P0
project_slug: orchestra-swift
status: done
title: Proto message types (placeholder Swift structs)
type: feature
---

# Proto message types (placeholder Swift structs)

Create Swift structs matching the Protobuf schema: PluginRequest, PluginResponse envelopes, ToolRequest (tool_name, arguments, caller_plugin, trace_parent, provider), ToolResponse (success, result text, error_code, error_message), ToolDefinition (name, description, input_schema), ConnectionState enum. These are placeholder types until buf generates proper Swift code from plugin.proto.
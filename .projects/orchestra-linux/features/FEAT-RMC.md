---
id: FEAT-RMC
kind: feature
priority: P0
project_slug: orchestra-linux
status: backlog
title: Protobuf message types and protobuf-c bindings
type: feature
---

# Protobuf message types and protobuf-c bindings

Generate C code from .proto files using protoc-c. Create Vala VAPI bindings for generated protobuf-c types. Support: ConnectionState, ToolRequest (toolName, arguments, callerPlugin, provider), ToolResponse (success, resultText, errorCode), ToolDefinition (name, description, inputSchema), StreamStart/StreamChunk/StreamEnd, Subscribe/Publish/EventDelivery.
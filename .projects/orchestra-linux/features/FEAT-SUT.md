---
id: FEAT-SUT
kind: feature
priority: P0
project_slug: orchestra-linux
status: backlog
title: Length-delimited Protobuf framing
type: feature
---

# Length-delimited Protobuf framing

Implement StreamFramer for length-delimited Protobuf wire format: [4-byte big-endian uint32 length][N-byte protobuf payload]. Max message size: 16 MB. Wire-compatible with Go SDK and Swift OrchestraKit. Uses GIO async streams for non-blocking read/write.
---
id: FEAT-PYV
kind: feature
priority: P0
project_slug: orchestra-win
status: backlog
title: buf.gen.yaml — C# Protobuf code generation for Windows app
type: feature
---

# buf.gen.yaml — C# Protobuf code generation for Windows app

Add C# Protobuf generation to the existing buf.gen.yaml so the Windows app gets strongly-typed Orchestra.Plugin.V1 types.

Changes to `libs/proto/buf.gen.yaml`:
```yaml
plugins:
  - remote: buf.build/protocolbuffers/csharp
    out: ../../apps/windows/src/Orchestra.Core/Generated
    opt:
      - base_namespace=Orchestra.Plugin.V1
```

Generated output: `apps/windows/src/Orchestra.Core/Generated/Plugin.cs`

Add to `Orchestra.Core.csproj`:
```xml
<ItemGroup>
  <PackageReference Include="Google.Protobuf" Version="3.27.*" />
</ItemGroup>
```

Makefile target to add:
```makefile
proto-csharp:
    cd libs/proto && buf generate --template buf.gen.yaml --path orchestra/plugin/v1
```

The generated `PluginRequest`, `PluginResponse`, `PluginManifest`, and `ToolCall` types are used by:
- `StreamFramer.cs` — read/write messages with `.ToByteArray()` + `.Parser.ParseFrom()`
- `PluginClient.cs` — build `PluginManifest` with Id, Version, Language="csharp"
- All tool implementations returning `ToolResponse`

Run `make proto` to regenerate after any `.proto` changes.
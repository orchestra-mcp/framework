# Plugin Generator — Scaffold New Plugins

Generate new Orchestra MCP plugins using `scripts/new-plugin.sh`. This skill guides plugin creation and customization.

## Quick Start

Run the generator:

```bash
./scripts/new-plugin.sh <name> <type>
```

Three plugin types:

| Type | Purpose | Example |
|------|---------|---------|
| `tools` | Provides MCP tools (actions agents can call) | plugin-tools-features |
| `storage` | Provides data storage backend | plugin-storage-markdown |
| `transport` | Bridges external protocols to QUIC mesh | plugin-transport-stdio |

## What Gets Generated

```
libs/plugin-{name}/
├── cmd/main.go                  # Entry point (type-specific)
├── internal/                    # Starter code
├── go.mod                       # Module: github.com/orchestra-mcp/plugin-{name}
├── README.md, LICENSE, SECURITY.md, CHANGELOG.md, CODE_OF_CONDUCT.md
├── .gitignore
├── docs/CONTRIBUTING.md + type-specific docs
└── .github/workflows/ci.yml + ISSUE_TEMPLATE/
```

The script also auto-updates: `go.work`, `Makefile`, `scripts/sync-repos.sh`, `scripts/release.sh`.

## Plugin Type: tools

Creates a plugin that registers MCP tools agents can call.

### Entry Point Pattern (`cmd/main.go`)

```go
func main() {
    builder := plugin.New("tools.{name}").
        Version("0.1.0").
        Description("{name} tools plugin").
        Author("Orchestra").
        Binary("{name}").
        NeedsStorage("markdown")

    adapter := &clientAdapter{}
    store := storage.NewDataStorage(adapter)
    tp := &internal.ToolsPlugin{Storage: store}
    tp.RegisterTools(builder)

    p := builder.BuildWithTools()
    p.ParseFlags()
    adapter.plugin = p

    ctx, cancel := context.WithCancel(context.Background())
    defer cancel()
    // signal handling...
    p.Run(ctx)
}

type clientAdapter struct { plugin *plugin.Plugin }
func (a *clientAdapter) Send(ctx context.Context, req *pluginv1.PluginRequest) (*pluginv1.PluginResponse, error) {
    return a.plugin.OrchestratorClient().Send(ctx, req)
}
```

### Tool Handler Pattern (`internal/tools/*.go`)

Every tool has a Schema function and a Handler function:

```go
func MyToolSchema() *structpb.Struct {
    s, _ := structpb.NewStruct(map[string]any{
        "type": "object",
        "properties": map[string]any{
            "project_id": map[string]any{"type": "string", "description": "Project ID"},
            "title":      map[string]any{"type": "string", "description": "Feature title"},
        },
        "required": []any{"project_id", "title"},
    })
    return s
}

func MyTool(store *storage.DataStorage) func(ctx context.Context, req *pluginv1.ToolRequest) (*pluginv1.ToolResponse, error) {
    return func(ctx context.Context, req *pluginv1.ToolRequest) (*pluginv1.ToolResponse, error) {
        if err := helpers.ValidateRequired(req.Arguments, "project_id", "title"); err != nil {
            return helpers.ErrorResult("validation_error", err.Error()), nil
        }
        projectID := helpers.GetString(req.Arguments, "project_id")
        title := helpers.GetString(req.Arguments, "title")

        // Business logic here...

        return helpers.TextResult(fmt.Sprintf("Created: %s in %s", title, projectID)), nil
    }
}
```

### Registering Tools (`internal/plugin.go`)

```go
type ToolsPlugin struct { Storage *storage.DataStorage }

func (tp *ToolsPlugin) RegisterTools(builder *plugin.PluginBuilder) {
    s := tp.Storage
    builder.RegisterTool("my_tool", "Description of what it does", tools.MyToolSchema(), tools.MyTool(s))
    builder.RegisterTool("another_tool", "Another tool", tools.AnotherSchema(), tools.Another(s))
}
```

### Storage Client (`internal/storage/client.go`)

Tools access storage through the orchestrator:

```go
type StorageClient interface {
    Send(ctx context.Context, req *pluginv1.PluginRequest) (*pluginv1.PluginResponse, error)
}

type DataStorage struct { client StorageClient }
func NewDataStorage(client StorageClient) *DataStorage { return &DataStorage{client: client} }
```

## Plugin Type: storage

Creates a plugin that provides data persistence.

### Entry Point Pattern (`cmd/main.go`)

```go
func main() {
    workspace := flag.String("workspace", ".", "Root workspace directory")
    storage := internal.NewStoragePlugin(*workspace)

    p := plugin.New("storage.{name}").
        Version("0.1.0").
        Description("{name} storage plugin").
        Author("Orchestra").
        Binary("{name}").
        ProvidesStorage("{name}").
        SetStorageHandler(storage).
        BuildWithTools()

    p.ParseFlags()
    storage = internal.NewStoragePlugin(*workspace)  // Re-read after flags
    p.Server().SetStorageHandler(storage)

    // ctx, signal handling, p.Run(ctx)
}
```

### Storage Handler (`internal/storage.go`)

Implement Read/Write/Delete/List:

```go
type StoragePlugin struct { workspace string }

func NewStoragePlugin(workspace string) *StoragePlugin {
    return &StoragePlugin{workspace: workspace}
}

func (s *StoragePlugin) Read(ctx context.Context, req *pluginv1.StorageReadRequest) (*pluginv1.StorageReadResponse, error) {
    // Read from filesystem using s.workspace + req.GetPath()
}

func (s *StoragePlugin) Write(ctx context.Context, req *pluginv1.StorageWriteRequest) (*pluginv1.StorageWriteResponse, error) {
    // Write to filesystem
}

func (s *StoragePlugin) Delete(ctx context.Context, req *pluginv1.StorageDeleteRequest) (*pluginv1.StorageDeleteResponse, error) {
    // Delete from filesystem
}

func (s *StoragePlugin) List(ctx context.Context, req *pluginv1.StorageListRequest) (*pluginv1.StorageListResponse, error) {
    // List files matching prefix
}
```

### Reader/Writer Pattern

```go
// reader.go — Parse raw file bytes into metadata + body
func ParseFile(data []byte) (metadata *structpb.Struct, body []byte, err error) { ... }

// writer.go — Serialize metadata + body into raw file bytes
func FormatFile(metadata *structpb.Struct, body []byte) ([]byte, error) { ... }
```

## Plugin Type: transport

Creates a plugin that bridges external protocols to the QUIC mesh. Transport plugins connect as clients — they do NOT serve incoming QUIC requests.

### Entry Point Pattern (`cmd/main.go`)

```go
func main() {
    orchestratorAddr := flag.String("orchestrator-addr", "localhost:9100", "Orchestrator address")
    certsDir := flag.String("certs-dir", plugin.DefaultCertsDir, "mTLS certs directory")
    flag.Parse()

    // mTLS client setup
    resolvedCertsDir := plugin.ResolveCertsDir(*certsDir)
    clientTLS, err := plugin.ClientTLSConfig(resolvedCertsDir, "transport.{name}-client")

    // Connect to orchestrator
    client, err := plugin.NewOrchestratorClient(ctx, *orchestratorAddr, clientTLS)
    defer client.Close()

    // Bridge protocol
    transport := internal.NewTransport(client, os.Stdin, os.Stdout)
    transport.Run(ctx)
}
```

### Transport Handler (`internal/transport.go`)

```go
type Sender interface {
    Send(ctx context.Context, req *pluginv1.PluginRequest) (*pluginv1.PluginResponse, error)
}

type Transport struct {
    sender Sender
    reader *bufio.Scanner
    writer io.Writer
}

func NewTransport(sender Sender, in io.Reader, out io.Writer) *Transport { ... }
func (t *Transport) Run(ctx context.Context) error {
    // Read loop: parse external protocol, translate to PluginRequest, send to orchestrator
}
```

## SDK Helpers

Available from `github.com/orchestra-mcp/sdk-go/helpers`:

```go
helpers.ValidateRequired(args, "field1", "field2")   // Returns error if missing
helpers.GetString(args, "key")                       // Extract string
helpers.GetInt(args, "key")                          // Extract int
helpers.GetBool(args, "key")                         // Extract bool
helpers.TextResult(text)                             // Success response
helpers.ErrorResult(code, message)                   // Error response
```

## Plugin Builder API

Fluent API from `github.com/orchestra-mcp/sdk-go/plugin`:

```go
plugin.New(id)                    // Create builder
    .Version(v)                   // Semver
    .Description(d)               // Human-readable
    .Author(a)                    // Author name
    .Binary(name)                 // Binary name for discovery
    .ProvidesStorage(types...)    // What this plugin provides
    .ProvidesTools(names...)
    .NeedsStorage(types...)       // What this plugin depends on
    .NeedsTools(names...)
    .RegisterTool(name, desc, schema, handler)
    .SetStorageHandler(impl)
    .BuildWithTools()             // Build the plugin
```

After build:
```go
p.ParseFlags()                    // Parse --orchestrator-addr, --listen-addr, --certs-dir, --manifest
p.Run(ctx)                        // Start QUIC server, register with orchestrator, serve requests
p.OrchestratorClient()            // Get client after Run connects
p.Server().SetStorageHandler(h)   // Replace storage handler post-init
```

## Plugin Manifest

Every plugin responds to `--manifest` with JSON:

```json
{
  "id": "tools.my-plugin",
  "version": "0.1.0",
  "description": "My plugin description",
  "provides_tools": ["tool1", "tool2"],
  "provides_storage": [],
  "needs_storage": ["markdown"],
  "needs_tools": []
}
```

## plugins.yaml Registration

Add your plugin to `plugins.yaml`:

```yaml
plugins:
  - id: tools.my-plugin
    binary: ./bin/my-plugin
    enabled: true
    config:
      workspace: .
```

## After Generating

1. `cd libs/plugin-{name}` — edit `internal/` to implement your logic
2. `go test ./libs/plugin-{name}/...` — run tests
3. `make build-{name}` — build binary
4. Add to `plugins.yaml` to register with orchestrator
5. `./scripts/sync-repos.sh plugin-{name}` — push to GitHub
6. `./scripts/release.sh v0.x.0 plugin-{name}` — tag and release

## Conventions

- Plugin ID format: `{type}.{name}` (e.g., `tools.features`, `storage.markdown`)
- Module path: `github.com/orchestra-mcp/plugin-{name}`
- Binary name: same as `{name}` (no `plugin-` prefix in binary)
- One tool per file in `internal/tools/`
- Schema and Handler always paired
- Use `helpers.ValidateRequired()` before accessing arguments
- Return `helpers.ErrorResult()` for validation errors, never panic

## Don'ts

- Don't use `replace` directives in `go.mod` — `go.work` handles local dev
- Don't import between plugins directly — communicate through the orchestrator
- Don't use `unwrap()` or `panic()` in handlers — return proper errors
- Don't hardcode orchestrator addresses — use `--orchestrator-addr` flag
- Don't skip `ParseFlags()` — it handles `--manifest` discovery
- Don't access storage directly from transport plugins — forward through orchestrator

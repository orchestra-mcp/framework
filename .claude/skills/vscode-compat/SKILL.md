---
name: vscode-compat
description: VS Code extension compatibility layer for running VS Code extensions in Orchestra. Activates when implementing VS Code API shimming, LSP/DAP protocol support, theme migration, or building VS Code-compatible extensions.
---

# VS Code Compatibility — Editor Extensions

Orchestra provides a compatibility layer for VS Code extensions, focusing on the most impactful categories: language support (LSP), debugging (DAP), themes, and editor enhancements.

## Compatibility Tiers

```
Tier 1 — Full Support (auto-load from VS Code)
├── Language Server Protocol (LSP) extensions
├── Debug Adapter Protocol (DAP) extensions
├── Themes (color themes, icon themes)
├── Snippets
└── Language grammar definitions (TextMate)

Tier 2 — Partial Support (shim required)
├── Commands and keybindings
├── Settings contributions
├── Tree view providers
├── Webview panels
└── Status bar items

Tier 3 — Not Supported
├── Custom editors
├── Notebook renderers
├── Source control providers (use Orchestra's git)
├── Test providers (use Orchestra's test runner)
└── Authentication providers (use Orchestra's auth)
```

## Architecture

```
VS Code Extension
  │
  └── import * as vscode from 'vscode'
        │
        └── Shimmed to Orchestra:
              vscode  →  @orchestra/vscode-compat
                │
                ├── vscode.window    → orchestra.ui + orchestra.editor
                ├── vscode.workspace → orchestra.workspace
                ├── vscode.commands  → orchestra.commands
                ├── vscode.languages → orchestra.languages (LSP bridge)
                ├── vscode.debug     → orchestra.debug (DAP bridge)
                └── vscode.Uri       → standard URL
```

## LSP Integration (Tier 1)

Language Server Protocol extensions work by spawning a language server process and communicating via JSON-RPC.

```go
// app/services/lsp_manager.go
type LSPManager struct {
    servers map[string]*LSPServer   // language → server
}

type LSPServer struct {
    cmd        *exec.Cmd
    stdin      io.WriteCloser
    stdout     io.ReadCloser
    language   string
    rootPath   string
    requestID  int64
}

func (m *LSPManager) StartServer(language, command string, args []string, rootPath string) error {
    cmd := exec.Command(command, args...)
    cmd.Dir = rootPath

    stdin, _ := cmd.StdinPipe()
    stdout, _ := cmd.StdoutPipe()

    server := &LSPServer{
        cmd:      cmd,
        stdin:    stdin,
        stdout:   stdout,
        language: language,
        rootPath: rootPath,
    }

    if err := cmd.Start(); err != nil {
        return err
    }

    // Initialize LSP
    server.Initialize()

    m.servers[language] = server
    return nil
}

func (s *LSPServer) Initialize() (*InitializeResult, error) {
    return s.Request("initialize", InitializeParams{
        RootURI: "file://" + s.rootPath,
        Capabilities: ClientCapabilities{
            TextDocument: TextDocumentClientCapabilities{
                Completion: CompletionClientCapabilities{
                    CompletionItem: CompletionItemCapabilities{
                        SnippetSupport: true,
                    },
                },
                Hover:      HoverCapabilities{},
                Definition: DefinitionCapabilities{},
            },
        },
    })
}
```

### Supported LSP Features

| LSP Feature | Orchestra Integration |
|------------|----------------------|
| `textDocument/completion` | Autocomplete in editor |
| `textDocument/hover` | Hover tooltips |
| `textDocument/definition` | Go to definition |
| `textDocument/references` | Find references |
| `textDocument/rename` | Symbol rename |
| `textDocument/formatting` | Format document |
| `textDocument/signatureHelp` | Function signatures |
| `textDocument/codeAction` | Quick fixes |
| `textDocument/diagnostic` | Error/warning squiggles |
| `textDocument/documentSymbol` | Outline view |

### LSP Extension Registration

```json
// VS Code extension package.json for a language server
{
  "contributes": {
    "languages": [{
      "id": "rust",
      "extensions": [".rs"],
      "configuration": "./language-configuration.json"
    }],
    "grammars": [{
      "language": "rust",
      "scopeName": "source.rust",
      "path": "./syntaxes/rust.tmLanguage.json"
    }]
  },
  "main": "./out/extension.js"
}

// Orchestra loads this by:
// 1. Reading the manifest
// 2. Detecting LSP server in the activation code
// 3. Starting the server with the right language root
// 4. Bridging LSP messages between editor and server
```

## DAP Integration (Tier 1)

Debug Adapter Protocol extensions for debugging support.

```go
// app/services/dap_manager.go
type DAPManager struct {
    adapters map[string]*DAPAdapter  // debugType → adapter
}

type DAPAdapter struct {
    cmd       *exec.Cmd
    transport *DAPTransport  // JSON-RPC over stdin/stdout
    debugType string
}

func (m *DAPManager) StartAdapter(debugType, command string, args []string) error {
    cmd := exec.Command(command, args...)
    // Similar to LSP — stdin/stdout JSON-RPC
    adapter := &DAPAdapter{
        cmd:       cmd,
        debugType: debugType,
    }
    m.adapters[debugType] = adapter
    return cmd.Start()
}
```

### Supported DAP Features

| DAP Feature | Orchestra Integration |
|------------|----------------------|
| Launch/Attach | Start/connect debugger |
| Breakpoints | Set/remove breakpoints in editor |
| Step In/Out/Over | Debug controls |
| Variables | Variable inspection panel |
| Call Stack | Stack trace view |
| Watch | Watch expressions |
| Console | Debug console (REPL) |
| Evaluate | Expression evaluation |

## Theme Compatibility (Tier 1)

VS Code themes (JSON color definitions) load directly.

```go
// app/services/theme_loader.go
type VSCodeTheme struct {
    Name   string                   `json:"name"`
    Type   string                   `json:"type"` // "dark" | "light"
    Colors map[string]string        `json:"colors"`
    Rules  []TokenColorRule         `json:"tokenColors"`
}

type TokenColorRule struct {
    Name     string            `json:"name"`
    Scope    interface{}       `json:"scope"` // string or []string
    Settings map[string]string `json:"settings"`
}

func (l *ThemeLoader) LoadVSCodeTheme(path string) (*OrchestraTheme, error) {
    var vsTheme VSCodeTheme
    data, _ := os.ReadFile(path)
    json.Unmarshal(data, &vsTheme)

    // Map VS Code color keys to Orchestra theme tokens
    return &OrchestraTheme{
        Name: vsTheme.Name,
        Type: vsTheme.Type,
        Colors: mapVSCodeColors(vsTheme.Colors),
        SyntaxRules: convertTokenRules(vsTheme.Rules),
    }, nil
}

func mapVSCodeColors(colors map[string]string) map[string]string {
    mapping := map[string]string{
        "editor.background":          "editor",
        "editor.foreground":          "editor-foreground",
        "sideBar.background":         "sidebar",
        "sideBar.foreground":         "sidebar-foreground",
        "activityBar.background":     "sidebar",
        "statusBar.background":       "primary",
        "terminal.background":        "terminal",
        "terminal.foreground":        "terminal-foreground",
        "tab.activeBackground":       "background",
        "tab.inactiveBackground":     "muted",
    }

    result := make(map[string]string)
    for vsKey, orchestraKey := range mapping {
        if color, ok := colors[vsKey]; ok {
            result[orchestraKey] = color
        }
    }
    return result
}
```

## VS Code API Shim (`@orchestra/vscode-compat`)

```typescript
// packages/vscode-compat/src/index.ts
export namespace window {
  export const showInformationMessage = orchestra.ui.showNotification;
  export const showWarningMessage = (msg: string) =>
    orchestra.ui.showNotification(msg, { type: 'warning' });
  export const showErrorMessage = (msg: string) =>
    orchestra.ui.showNotification(msg, { type: 'error' });
  export const showQuickPick = orchestra.ui.showQuickPick;
  export const showInputBox = orchestra.ui.showInputBox;
  export const createStatusBarItem = orchestra.ui.createStatusBarItem;
  export const activeTextEditor = orchestra.editor.active;
  export const onDidChangeActiveTextEditor = orchestra.editor.onDidChangeActive;
}

export namespace commands {
  export const registerCommand = orchestra.commands.register;
  export const executeCommand = orchestra.commands.execute;
}

export namespace workspace {
  export const workspaceFolders = [orchestra.workspace];
  export const onDidChangeTextDocument = orchestra.editor.onDidChangeDocument;
  export const getConfiguration = (section: string) => ({
    get: (key: string) => orchestra.settings.get(`${section}.${key}`),
    update: (key: string, value: any) => orchestra.settings.set(`${section}.${key}`, value),
  });
}

export namespace languages {
  export function registerCompletionItemProvider(
    selector: string,
    provider: any
  ) {
    // Bridge to LSP or custom completion
    return orchestra.languages.registerCompletion(selector, provider);
  }

  export function registerHoverProvider(selector: string, provider: any) {
    return orchestra.languages.registerHover(selector, provider);
  }
}

export class Uri {
  static file(path: string) { return new URL(`file://${path}`); }
  static parse(uri: string) { return new URL(uri); }
}

export class Range {
  constructor(
    public startLine: number,
    public startCharacter: number,
    public endLine: number,
    public endCharacter: number
  ) {}
}

export class Position {
  constructor(public line: number, public character: number) {}
}
```

## Migrating a VS Code Extension

### Tier 1 (Auto-load — no migration needed)
1. LSP extensions: Orchestra detects the language server command and spawns it
2. Themes: Load the JSON directly, map color keys
3. Snippets: Load the snippets JSON directly
4. Grammars: Load TextMate grammars directly

### Tier 2 (Shim required)
1. Replace `import * as vscode from 'vscode'` with `import * as vscode from '@orchestra/vscode-compat'`
2. Update `package.json` to Orchestra manifest format
3. Test — most commands and UI work through the shim
4. Replace unsupported APIs with Orchestra native equivalents

## Conventions

- VS Code compat extensions have `"compat": "vscode"` in their manifest
- LSP servers are spawned as child processes, not in-process
- DAP adapters follow the same spawn pattern as LSP
- Themes are loaded at runtime, not build time
- TextMate grammars power syntax highlighting (same as VS Code)
- The shim translates VS Code API calls to Orchestra equivalents at compile time

## Don'ts

- Don't try to support VS Code's full extension API — focus on Tier 1 and 2
- Don't run VS Code extensions in a VS Code electron shell — use the shim
- Don't modify VS Code extension source during auto-loading (Tier 1)
- Don't assume VS Code extension activate/deactivate lifecycle matches exactly
- Don't support VS Code's testing or source control APIs — use Orchestra's native ones
- Don't load untrusted extensions without sandboxing

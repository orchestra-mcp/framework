---
name: native-extensions
description: Orchestra's native extension API for building first-class extensions with full platform access. Activates when designing the extension runtime, extension API surface, commands, UI components, AI API, permissions, or building native extensions.
---

# Native Extensions — Orchestra Extension API

Orchestra has a three-tier extension system: native extensions (full API), Raycast-compatible extensions (quick actions), and VS Code-compatible extensions (editor features). This skill covers the native tier — the most powerful.

## Architecture

```
Extension Runtime (Go)
├── ExtensionHost         # Loads, sandboxes, and manages extensions
├── ExtensionManifest     # Parses package.json → capabilities
├── PermissionManager     # Grants/revokes API access per extension
├── CommandRegistry       # Registers commands, keybindings, palette items
├── UIBridge              # Renders extension UI in React webview
└── AIBridge              # Exposes AI models to extensions
```

## Extension Structure

```
my-extension/
├── package.json          # Manifest (name, version, permissions, contributions)
├── src/
│   ├── index.ts          # Entry point — activate() / deactivate()
│   ├── commands/         # Command handlers
│   └── views/            # React components (optional UI)
├── assets/               # Icons, images
└── README.md             # Extension docs
```

## Manifest (`package.json`)

```json
{
  "name": "my-extension",
  "displayName": "My Extension",
  "version": "1.0.0",
  "description": "Does something useful",
  "author": "developer@example.com",
  "license": "MIT",
  "main": "src/index.ts",
  "icon": "assets/icon.png",

  "engines": {
    "orchestra": ">=0.1.0"
  },

  "permissions": [
    "filesystem.read",
    "filesystem.write",
    "network",
    "ai.chat",
    "clipboard",
    "notifications"
  ],

  "activationEvents": [
    "onStartup",
    "onCommand:my-extension.hello",
    "onLanguage:typescript",
    "onFileType:*.md"
  ],

  "contributes": {
    "commands": [
      {
        "command": "my-extension.hello",
        "title": "Hello World",
        "category": "My Extension",
        "icon": "assets/hello.svg"
      },
      {
        "command": "my-extension.transform",
        "title": "Transform Selection",
        "keybinding": "Ctrl+Shift+T"
      }
    ],

    "menus": {
      "editor.context": [
        {
          "command": "my-extension.transform",
          "when": "editorHasSelection"
        }
      ],
      "commandPalette": [
        { "command": "my-extension.hello" }
      ]
    },

    "settings": [
      {
        "id": "my-extension.apiKey",
        "type": "string",
        "title": "API Key",
        "description": "Your API key for the service",
        "secret": true
      },
      {
        "id": "my-extension.autoRun",
        "type": "boolean",
        "title": "Auto Run",
        "default": true
      }
    ],

    "views": {
      "sidebar": [
        {
          "id": "my-extension.panel",
          "title": "My Panel",
          "icon": "assets/panel.svg"
        }
      ]
    },

    "themes": [
      {
        "id": "my-extension.dark-pro",
        "label": "Dark Pro",
        "type": "dark",
        "path": "themes/dark-pro.json"
      }
    ],

    "languages": [
      {
        "id": "mycustomlang",
        "extensions": [".mcl"],
        "aliases": ["MyCustomLang"],
        "configuration": "language-config.json"
      }
    ],

    "keybindings": [
      {
        "command": "my-extension.hello",
        "key": "ctrl+shift+h",
        "when": "editorFocus"
      }
    ]
  }
}
```

## Extension API

### Lifecycle

```typescript
import { orchestra } from '@orchestra/api';

export function activate(context: orchestra.ExtensionContext) {
  // Called when extension is activated
  // Register commands, providers, views

  const cmd = orchestra.commands.register('my-extension.hello', () => {
    orchestra.ui.showNotification('Hello from My Extension!');
  });
  context.subscriptions.push(cmd);
}

export function deactivate() {
  // Cleanup when extension is deactivated
}
```

### ExtensionContext

```typescript
interface ExtensionContext {
  extensionPath: string;           // Absolute path to extension directory
  storagePath: string;             // Extension-specific storage directory
  globalStoragePath: string;       // Global storage shared across workspaces
  subscriptions: Disposable[];     // Auto-disposed on deactivate
  secrets: SecretStorage;          // Encrypted secret storage (Keychain)
  extensionMode: 'development' | 'production';
}
```

### Commands API

```typescript
// Register a command
orchestra.commands.register('my-extension.greet', (name: string) => {
  orchestra.ui.showNotification(`Hello, ${name}!`);
});

// Execute another command
await orchestra.commands.execute('editor.formatDocument');

// Get all registered commands
const commands = orchestra.commands.getAll();
```

### Editor API

```typescript
// Get active editor
const editor = orchestra.editor.active;

// Read selection
const selectedText = editor?.selection.text;

// Replace selection
editor?.edit((builder) => {
  builder.replace(editor.selection, transformedText);
});

// Open a file
await orchestra.editor.open('/path/to/file.ts', { line: 42 });

// Listen for document changes
orchestra.editor.onDidChangeDocument((event) => {
  console.log('Changed:', event.document.uri, event.changes);
});

// Get document text
const text = editor?.document.getText();
const lineText = editor?.document.lineAt(10).text;
```

### AI API (Orchestra's Advantage)

```typescript
// Chat with AI
const response = await orchestra.ai.chat({
  model: 'claude-sonnet-4-5-20250929',
  messages: [
    { role: 'user', content: 'Explain this code:\n' + selectedText }
  ],
  maxTokens: 1000,
});

// Stream AI response
const stream = orchestra.ai.chatStream({
  model: 'claude-sonnet-4-5-20250929',
  messages: [{ role: 'user', content: prompt }],
});
for await (const chunk of stream) {
  output.append(chunk.text);
}

// Embeddings
const embedding = await orchestra.ai.embed({
  model: 'text-embedding-3-small',
  input: 'function calculateTotal(items) { ... }',
});

// AI with tools
const result = await orchestra.ai.chat({
  model: 'claude-sonnet-4-5-20250929',
  messages: [{ role: 'user', content: 'Find all TODO comments' }],
  tools: [
    {
      name: 'search_files',
      description: 'Search files for a pattern',
      parameters: { pattern: { type: 'string' } },
      handler: async ({ pattern }) => {
        return orchestra.workspace.search(pattern);
      },
    },
  ],
});
```

### Filesystem API

```typescript
// Read file
const content = await orchestra.fs.readFile('/path/to/file.ts');

// Write file
await orchestra.fs.writeFile('/path/to/output.ts', content);

// List directory
const entries = await orchestra.fs.readDir('/path/to/dir');

// Watch for changes
const watcher = orchestra.fs.watch('/path/to/dir/**/*.ts', (event) => {
  console.log(event.type, event.path); // 'create' | 'change' | 'delete'
});
context.subscriptions.push(watcher);

// File operations
await orchestra.fs.copy(src, dest);
await orchestra.fs.move(src, dest);
await orchestra.fs.delete(path);
await orchestra.fs.exists(path); // boolean
```

### UI API

```typescript
// Notifications
orchestra.ui.showNotification('Build complete!');
orchestra.ui.showNotification('Error occurred', { type: 'error' });

// Quick pick (command palette style)
const choice = await orchestra.ui.showQuickPick([
  { label: 'Option A', description: 'First option' },
  { label: 'Option B', description: 'Second option' },
]);

// Input box
const name = await orchestra.ui.showInputBox({
  prompt: 'Enter project name',
  placeholder: 'my-project',
  validate: (value) => value.length > 0 ? null : 'Name required',
});

// Progress
await orchestra.ui.withProgress('Processing...', async (progress) => {
  for (let i = 0; i < 100; i++) {
    await doWork(i);
    progress.report({ increment: 1 });
  }
});

// Status bar
const statusItem = orchestra.ui.createStatusBarItem({
  text: '$(sync) Syncing...',
  tooltip: 'Click to view sync status',
  command: 'my-extension.showSync',
  alignment: 'right',
  priority: 100,
});
statusItem.show();
```

### Webview (Custom UI Panels)

```typescript
// Create a webview panel with React
const panel = orchestra.ui.createWebviewPanel({
  id: 'my-extension.panel',
  title: 'My Panel',
  viewColumn: 'sidebar',
});

// Send data to webview
panel.postMessage({ type: 'UPDATE', data: results });

// Receive messages from webview
panel.onDidReceiveMessage((msg) => {
  if (msg.type === 'SAVE') {
    saveData(msg.data);
  }
});
```

### Network API

```typescript
// HTTP requests (requires 'network' permission)
const response = await orchestra.network.fetch('https://api.example.com/data', {
  method: 'POST',
  headers: { 'Authorization': `Bearer ${token}` },
  body: JSON.stringify(payload),
});
const data = await response.json();
```

### Workspace API

```typescript
// Get workspace info
const workspace = orchestra.workspace;
const rootPath = workspace.rootPath;
const name = workspace.name;

// Search across workspace
const results = await workspace.search('TODO', {
  include: '**/*.ts',
  exclude: '**/node_modules/**',
  maxResults: 100,
});

// Git integration
const git = workspace.git;
const branch = await git.currentBranch();
const status = await git.status();
const diff = await git.diff();
```

## Permission System

Extensions must declare permissions in `package.json`. Users approve on install.

| Permission | Grants Access To |
|-----------|-----------------|
| `filesystem.read` | Read files in workspace |
| `filesystem.write` | Write/create/delete files |
| `network` | HTTP/WebSocket requests |
| `ai.chat` | AI chat API |
| `ai.embed` | AI embeddings API |
| `clipboard` | Read/write clipboard |
| `notifications` | Show OS notifications |
| `terminal` | Create/write to terminal |
| `git` | Git operations |
| `secrets` | Encrypted secret storage |
| `system.exec` | Execute system commands (dangerous) |

```go
// Go backend: PermissionManager
type PermissionManager struct {
    grants map[string][]Permission  // extensionID → granted permissions
}

func (pm *PermissionManager) Check(extID string, perm Permission) error {
    if !pm.HasPermission(extID, perm) {
        return fmt.Errorf("extension %s lacks permission: %s", extID, perm)
    }
    return nil
}
```

## Extension Runtime (Go Side)

```go
// app/services/extension_host.go
type ExtensionHost struct {
    extensions  map[string]*Extension
    commands    *CommandRegistry
    permissions *PermissionManager
    ai          *AIBridge
}

func (h *ExtensionHost) Load(manifestPath string) (*Extension, error) {
    manifest, err := ParseManifest(manifestPath)
    if err != nil {
        return nil, err
    }

    ext := &Extension{
        ID:       manifest.Name,
        Manifest: manifest,
        State:    ExtensionStateLoaded,
    }

    // Register contributions
    for _, cmd := range manifest.Contributes.Commands {
        h.commands.Register(cmd.Command, ext)
    }

    h.extensions[ext.ID] = ext
    return ext, nil
}

func (h *ExtensionHost) Activate(id string) error {
    ext := h.extensions[id]
    // Check activation events
    // Initialize extension context
    // Call extension's activate()
    ext.State = ExtensionStateActive
    return nil
}
```

## Conventions

- Extensions are TypeScript packages with `@orchestra/api` as a peer dependency
- Manifest follows VS Code contribution format (but with additional Orchestra-specific fields)
- AI API is a first-class citizen — every extension can use AI with permission
- Permissions are declared upfront and approved by the user on install
- Extensions run in a sandboxed context — no direct access to Go internals
- UI extensions render in React webview panels
- Extension storage is isolated per-extension and per-workspace

## Don'ts

- Don't give extensions direct access to GORM/database — all access through APIs
- Don't allow `system.exec` without explicit user confirmation
- Don't run extension code in the Go process — use a JavaScript runtime sandbox
- Don't let extensions modify other extensions' storage
- Don't skip permission checks — always validate before API calls
- Don't expose internal Go types to extensions — use the TypeScript API surface only

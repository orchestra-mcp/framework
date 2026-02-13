# PRD 2: Dynamic Core Services

**Parent:** orchestra-app (Master PRD)
**Depends on:** PRD 1 (oap-core)

---

## Goal

Extract and wrap all core services from `packages/desktop/` into `src/app/` with dynamic registration APIs. Each service keeps its existing functionality but gains a `register/unregister/Disposable` pattern so extensions can plug into it.

---

## Scope — 17 Services

### 1. Dynamic Tray Menu (`src/app/Tray/`)

**Source:** `packages/desktop/src/main/services/trayService.ts` + `menuContributionService.ts`

**API:**
```typescript
interface ITrayMenuService {
  register(item: TrayMenuItem): Disposable;
  update(id: string, patch: Partial<TrayMenuItem>): void;
  unregister(id: string): void;
  onDidChange: Event<TrayMenuItem[]>;
}

interface TrayMenuItem {
  id: string; icon: string; iconColor?: string; label: string;
  group: string; hotkey?: string;
  action: { type: 'ipc' | 'link'; target: string };
  order: number; visible?: boolean; enabled?: boolean;
}
```

**Requirements:**
- Real-time updates when iconColor changes (green/yellow/red for service status)
- Debounced menu rebuild on batch changes
- Group-based ordering with separators
- Sub-menu support
- Dynamic icon from color/path

**Docs:** `docs/core-services/tray-menu.md`

---

### 2. Dynamic Panel Manager (`src/app/Panels/`)

**Source:** `timerPanelService.ts`, `calendarPanelService.ts`, `breakPanelService.ts`, `pomodoroPanelService.ts`, `settingsWindowService.ts`, `marketplaceWindowService.ts` → unified

**API:**
```typescript
interface IPanelManagerService {
  registerPanel(panel: PanelRegistration): Disposable;
  openPanel(id: string): Promise<BrowserWindow>;
  closePanel(id: string): void;
  togglePanel(id: string): void;
  isPanelOpen(id: string): boolean;
  onPanelOpened: Event<string>;
  onPanelClosed: Event<string>;
}

interface PanelRegistration {
  id: string; title: string; icon: string;
  htmlPath: string; preloadPath: string;
  defaultSize: { width: number; height: number };
  resizable: boolean; alwaysOnTop?: boolean;
  trayMenuEntry?: Partial<TrayMenuItem>;
}
```

**Requirements:**
- All existing panel services refactored to use this unified API
- Auto-registers tray menu entry when `trayMenuEntry` specified
- Panel follows IDE theme (CSS variables injected)
- Panel state persistence (position, size) across restarts
- IPC bridge auto-setup between panel and extension service
- Singleton panels (one instance per ID)

**Docs:** `docs/core-services/panel-manager.md`

---

### 3. Dynamic Settings (`src/app/Settings/`)

**Source:** `settingsService.ts` + `settingsWindowService.ts` + `settings-renderer.ts` (75KB)

**API:**
```typescript
interface ISettingsService {
  registerGroup(group: SettingsGroup): Disposable;
  registerSetting(setting: SettingDefinition): Disposable;
  get<T>(key: string): T;
  set(key: string, value: any): Promise<void>;
  onDidChange(key: string, callback: (value: any) => void): Disposable;
  exportSettings(): Record<string, any>;
  importSettings(data: Record<string, any>): Promise<void>;
}

interface SettingsGroup {
  id: string; title: string; description?: string;
  icon: string; order: number; parentGroup?: string;
}

interface SettingDefinition {
  key: string; type: 'string' | 'number' | 'boolean' | 'enum' | 'color' | 'path' | 'custom';
  default: any; label: string; description?: string;
  group: string; order?: number;
  validation?: (value: any) => boolean;
  customComponent?: string;
}
```

**Requirements:**
- Extensions register their settings via ServiceProvider
- Settings UI auto-generated from schema (input/toggle/dropdown/color picker/custom)
- Local JSON storage with atomic writes
- Settings search bar
- Import/export JSON, reset to defaults
- Changes propagated across main + all renderers via IPC
- Future cloud sync interface (stubs only now)

**Docs:** `docs/core-services/settings.md`

---

### 4. Dynamic Themes (`src/app/Themes/`)

**Source:** `chrome-extension/src/theme/` + `widgetThemeService.ts`

**API:**
```typescript
interface IThemeService {
  registerTheme(theme: ThemeDefinition): Disposable;
  setActiveTheme(id: string): void;
  getActiveTheme(): ThemeDefinition;
  getAvailableThemes(): ThemeDefinition[];
  onDidChangeTheme: Event<ThemeDefinition>;
  importVSCodeTheme(vsixPath: string): Promise<ThemeDefinition>;
}
```

**Requirements:**
- Built-in light + dark themes
- Extensions register custom themes
- VSCode theme import (.tmTheme, VS Code JSON)
- CSS custom properties injected into all panels + Chrome ext
- Real-time preview on switch
- Editor syntax highlighting follows active theme

**Docs:** `docs/core-services/themes.md`

---

### 5. Dynamic Notifications (`src/app/Notifications/`)

**Source:** `extensions/notifications/src/index.ts` + `notificationService.ts` + `notificationIpcServer.ts`

**API:**
```typescript
interface INotificationService {
  send(notification: NotificationPayload): Promise<string>;
  dismiss(id: string): void;
  getHistory(): NotificationPayload[];
  clearHistory(): void;
  onNotification: Event<NotificationPayload>;
  registerChannel(channel: NotificationChannel): void;
  setChannelEnabled(channel: string, enabled: boolean): void;
}

interface NotificationPayload {
  id?: string; title: string; body: string; icon?: string;
  sound?: 'default' | 'success' | 'warning' | 'error' | 'none';
  priority: 'low' | 'normal' | 'high' | 'urgent';
  actions?: { label: string; action: string }[];
  channel: 'desktop' | 'browser' | 'mobile' | 'all';
}
```

**Requirements:**
- Unify existing scattered notification code
- Desktop: Electron native notifications
- Browser: push via WebSocket
- Mobile: FCM stub for future
- Sound control via settings
- Notification history
- Settings page under "Notifications" group

**Docs:** `docs/core-services/notifications.md`

---

### 6. Dynamic MCP Server (`src/app/MCP/`)

**Source:** `extensions/mcp/src/main/` (tools/, cli.ts, index.ts)

**API:**
```typescript
interface IMcpServerService {
  registerTool(tool: McpToolDefinition): Disposable;
  registerResource(resource: McpResourceDefinition): Disposable;
  registerPrompt(prompt: McpPromptDefinition): Disposable;
  unregisterTool(name: string): void;
  getRegisteredTools(): McpToolDefinition[];
}
```

**Requirements:**
- Extensions register tools via simple API in their ServiceProvider
- Tool namespacing: `extension.toolName`
- Schema validation on inputs
- stdio transport + CLI entry point (`orchestr-mcp`)
- Dynamic runtime registration/unregistration
- Existing MCP tools (project, epic, story, task, prd, workflow, etc.) migrate as registrations

**Docs:** `docs/core-services/mcp-server.md`

---

### 7. Fast WebSocket Server (`src/app/Socket/`)

**Source:** `services/websocketBridgeService.ts`

**API:**
```typescript
interface IWebSocketService {
  registerHandler(channel: string, handler: MessageHandler): Disposable;
  publish(channel: string, data: any): void;
  subscribe(channel: string, callback: (data: any) => void): Disposable;
  onConnection: Event<WebSocketClient>;
  onDisconnection: Event<WebSocketClient>;
}
```

**Requirements:**
- Extract from existing bridge service
- Channel-based pub/sub
- Token-based auth on connection
- Binary message support
- Reconnection with exponential backoff (client side)
- Offline message queue (flush on reconnect)
- Extensions register custom handlers

**Docs:** `docs/core-services/websocket-server.md`

---

### 8. Fast Web Server (`src/app/Http/`)

**Source:** `extensions/http-server/`

**API:**
```typescript
interface IWebServerService {
  registerRoute(method: string, path: string, handler: RouteHandler): Disposable;
  registerStaticPath(urlPath: string, fsPath: string): Disposable;
  getBaseUrl(): string;
}
```

**Requirements:**
- Dynamic route registration from extensions
- OAuth callback helper
- IDE deep links (`/open?workspace=`, `/open?file=&line=`)
- `orchestra://` protocol handler
- Static file serving
- CORS config

**Docs:** `docs/core-services/web-server.md`

---

### 9. Dynamic Search (`src/app/Search/`)

**Source:** `extensions/search/`

**API:**
```typescript
interface ISearchService {
  registerProvider(provider: SearchProvider): Disposable;
  registerFileType(fileType: FileTypeDefinition): Disposable;
  search(query: string, options?: SearchOptions): Promise<SearchResult[]>;
  getSuggestions(partial: string): Promise<Suggestion[]>;
  getHistory(): string[];
  registerPreviewRenderer(type: string, renderer: PreviewRenderer): Disposable;
}
```

**Requirements:**
- Provider registration from extensions
- Query language: Jira-like (`type:file status:modified`) + SQL-like
- Prefix operators: `@mentions`, `#tags`, `>commands`
- Search history (max 100)
- Dynamic preview renderers per result type

**Docs:** `docs/core-services/search.md`

---

### 10. Dynamic AI Chat Box (`src/app/AI/`)

**Source:** `chatBoxOverlayService.ts` + `claudeCliService.ts` + `chatSessionService.ts` + `chat-box-renderer.ts` (87KB)

**API:**
```typescript
interface IAiChatBoxService {
  registerModelProvider(provider: ModelProvider): Disposable;
  registerSkill(skill: SkillDefinition): Disposable;
  registerAgent(agent: AgentDefinition): Disposable;
  registerMcpServer(server: McpServerConfig): Disposable;
  sendMessage(message: string, options?: ChatOptions): Promise<ChatResponse>;
  getActiveSession(): ChatSession;
  onMessage: Event<ChatMessage>;
}
```

**Requirements:**
- Multi-provider (Claude, OpenAI, Ollama) via settings
- Extensions register skills/agents/MCP servers
- Keep existing Claude CLI integration
- Streaming + markdown rendering
- Code actions (copy, apply, diff)
- Context-aware (current file, workspace)

**Docs:** `docs/core-services/ai-chatbox.md`

---

### 11. Dynamic Marketplace (`src/app/Marketplace/`)

**Source:** `marketplaceClient.ts` + `marketplaceWindowService.ts` + `marketplace-renderer.ts` (90KB) + `vsixInstaller.ts`

**API:**
```typescript
interface IMarketplaceService {
  registerExtensionType(type: ExtensionType): void;
  publishExtension(manifest: ExtensionManifest): void;
  installExtension(id: string): Promise<void>;
  uninstallExtension(id: string): Promise<void>;
  enableExtension(id: string): void;
  disableExtension(id: string): void;
  searchExtensions(query: string): Promise<ExtensionInfo[]>;
  getInstalledExtensions(): ExtensionInfo[];
}
```

**Requirements:**
- Types: Orchestra, VSCode, AI Tools, Services, Integrations
- Install/uninstall/enable/disable at runtime
- Paid extension license key validation
- Dependency resolution on install
- Deep link from web marketplace
- Extensions push tools/services via API
- VSCode VSIX compatibility

**Docs:** `docs/core-services/marketplace.md`

---

### 12. Dynamic Widget Control (`src/app/Widgets/`)

**Source:** `widgetManagerService.ts` + `widgetRegistryService.ts` + `widgetExtensionApi.ts` + `widgetContextMenuService.ts` + `widgetThemeService.ts`

**API:**
```typescript
interface IWidgetControlService {
  registerWidget(widget: WidgetRegistration): Disposable;
  showWidget(id: string): void;
  hideWidget(id: string): void;
  toggleWidget(id: string): void;
  getRegisteredWidgets(): WidgetInfo[];
}
```

**Requirements:**
- Already has good patterns — migrate and expose cleaner API
- Multi-view support
- Views follow IDE theme
- Tray menu show/hide
- State persistence (position, size, visibility)
- Widget events

**Docs:** `docs/core-services/widget-control.md`

---

### 13. Account Center (`src/app/AccountCenter/`)

**Source:** `extensions/credentials/` + `calendar/OAuthService.ts`

**API:**
```typescript
interface IAccountCenterService {
  registerIntegration(integration: IntegrationDefinition): Disposable;
  connect(integrationId: string): Promise<AuthResult>;
  disconnect(integrationId: string): Promise<void>;
  getConnectedIntegrations(): IntegrationStatus[];
  getAccessToken(integrationId: string): Promise<string>;
  onConnectionChange: Event<IntegrationStatus>;
}
```

**Requirements:**
- OAuth2 + PKCE, API key, token auth types
- Secure storage (OS keychain via safeStorage)
- Token auto-refresh
- Integration marketplace view in settings

**Docs:** `docs/core-services/account-center.md`

---

### 14. Universal Markdown Parser (`src/app/Components/`)

**Source:** Chrome extension rehype/remark/Shiki setup

**What to build:**
- Shared React component: `<MarkdownRenderer content={md} />`
- Works in: Chrome ext, Electron panels, web platform, mobile
- GFM, code blocks (Shiki + theme), tables (sorting, CSV export, copy), Mermaid, math/LaTeX
- Export: copy as HTML, plain text
- Follows IDE theme

**Docs:** `docs/core-services/markdown-parser.md`

---

### 15. Dynamic LSP Server (`src/app/LSP/`)

**Source:** `platform/lspClient.ts` + `platform/lspServers/` + `lspManagerService.ts`

**API:**
```typescript
interface ILspServerService {
  registerLanguageServer(config: LanguageServerConfig): Disposable;
  getActiveServers(): LanguageServerInfo[];
  restartServer(languageId: string): Promise<void>;
}
```

**Requirements:**
- Extensions register language servers
- Auto-download binaries
- Lifecycle management
- VSCode language extension compatibility
- Multi-root workspace support

**Docs:** `docs/core-services/lsp-server.md`

---

### 16. Dynamic Browser Script Injection (`src/app/BrowserInjection/`)

**Source:** `chrome-extension/src/content/`

**API:**
```typescript
interface IBrowserInjectionService {
  registerScript(script: InjectionScript): Disposable;
  injectOnUrl(pattern: string | RegExp, scriptPath: string): Disposable;
  sendToPage(tabId: number, message: any): Promise<any>;
  onPageMessage: Event<PageMessage>;
}
```

**Requirements:**
- URL pattern matching
- Bidirectional messaging
- Script isolation per extension
- CSP handling

**Docs:** `docs/core-services/browser-injection.md`

---

### 17. VSCode Compatibility (`src/app/VS/`)

**Source:** `vscodeExtensionService.ts` + `vsixInstaller.ts` + `textmateService.ts` + `grammarLoader.ts` + `semanticTokenRegistry.ts`

**Requirements:**
- VSIX install and extraction
- Theme parsing (.tmTheme, VS Code JSON)
- Grammar parsing (.tmLanguage)
- Snippet extraction
- Unified with Marketplace and Theme/LSP services

**Docs:** `docs/core-services/vscode-compatibility.md` (optional — can be part of marketplace + themes + lsp docs)

---

## Success Criteria

- All 17 services migrated to `src/app/` with dynamic registration APIs
- Every `register()` method returns `Disposable`
- Example extension in `src/packages/example/` successfully uses all service APIs
- All existing functionality preserved (no regressions)
- Each service has documentation in `docs/core-services/{name}.md`
- `pnpm typecheck` passes

---
id: PLAN-FKZ
project_slug: orchestra-flutter
status: in-progress
title: Plan 5: Desktop Mode, Smart Actions & Settings
type: plan
---

# Plan 5: Desktop Mode, Smart Actions & Settings

## Overview
All desktop-specific features: first-run installer, MCP TCP stdio client (subprocess-based), system tray, desktop-only screens (Workspace Manager, Terminal Sessions, Sync Status, Binary Manager), full Settings screens (all 5 tabs), Smart Actions (Foundation Models + tunnel bridge), and the Markdown editor. Depends on Plans 1–3.

## Scope

### 1. Desktop Installer Flow (`lib/features/installer/`)
Entry point for macOS, Windows, Linux on first launch (and update detection on every launch).

**`orchestra_detector.dart`**:
- Binary search order:
  1. `~/.orchestra/bin/orchestra` (primary)
  2. `/usr/local/bin/orchestra` (macOS manual)
  3. `/opt/homebrew/bin/orchestra` (Apple Silicon)
  4. `/usr/bin/orchestra` (Linux system)
  5. `~\\.orchestra\\bin\\orchestra.exe` (Windows)
  6. `C:\\Program Files\\Orchestra\\orchestra.exe` (Windows)
  7. Fallback: `Process.run('which orchestra')` / `where orchestra`
- check(): returns DetectResult — found/not_found/update_available
- getVersions(): fetches GitHub releases API, returns VersionInfo { installed, latest, hasUpdate }

**`orchestra_installer.dart`**:
- Download from: `https://api.github.com/repos/orchestra-mcp/framework/releases/latest`
- Asset name logic:
  - macOS arm64 → `orchestra_darwin_arm64.tar.gz`
  - macOS x64 → `orchestra_darwin_amd64.tar.gz`
  - Windows x64 → `orchestra_windows_amd64.zip`
  - Linux x64 → `orchestra_linux_amd64.tar.gz`
  - Linux arm64 → `orchestra_linux_arm64.tar.gz`
- Uses `archive` package for tar.gz + zip extraction
- Install target: `~/.orchestra/bin/orchestra`
- Post-install macOS: `xattr -dr com.apple.quarantine <path>` (via Process.run)
- Post-install Windows: Add `%USERPROFILE%\.orchestra\bin` to HKCU\Environment\Path registry
- Post-install Linux: Create `~/.local/share/applications/orchestra.desktop` + symlink to `~/.local/bin/orchestra`
- Uses `crypto` package for SHA256 hash verification against release manifest

**`install_progress_model.dart`**:
- InstallStage enum: checking(0%) / fetching_version(5%) / downloading(10–80%) / extracting(80%) / installing(90%) / verifying(95%) / done(100%) / error
- InstallProgress: stage, percent, message, error

**`installer_provider.dart`** — Riverpod AsyncNotifier: InstallState machine

**`installer_screen.dart`** — Full-screen Liquid Glass UI:
- Welcome: Orchestra logo (animated SVG pulse), "Setting up Orchestra", auto-advances after 1s
- Progress: GlassCard with stage label + animated progress bar + message + last 3 log lines
- Done: green checkmark animation + "Orchestra vX.Y.Z installed" badge + "Get Started" CTA
- Error: red X + error message + "Retry" button + "Install Manually" (opens install docs URL)
- Update prompt: shows "Update available: vX.Y.Z" with Skip / Update choice

**Integration with app.dart**:
- On desktop launch: OrchestraDetector.check() before routing
- If found + up-to-date → spawn process → continue to app
- If not found → InstallerScreen
- If update available → subtle banner in Settings → Orchestrator tab (never blocks user)

### 2. MCP TCP Stdio Client (Desktop Only)
`lib/core/api/mcp_tcp_client.dart` (extends ApiClient):
- Spawns `orchestra serve --workspace <path>` subprocess via `Process.start()`
- Pipe stdin/stdout for JSON-RPC 2.0 over stdio
- Initialize handshake: `{"jsonrpc":"2.0","id":0,"method":"initialize","params":{...}}`
- Wait for `initialized` notification
- Tool calls: `{"jsonrpc":"2.0","id":N,"method":"tools/call","params":{"name":"...","arguments":{...}}}`
- Length-delimited framing on stdout: [4-byte big-endian length][JSON bytes]
- Automatic process restart if subprocess dies
- Timeout: 30s per tool call

### 3. System Tray (`lib/features/desktop/tray_manager_service.dart`)
Using `tray_manager` package:
- Icon states: Running (green dot), Starting (yellow), Stopped (gray), Error (red)
- Menu items:
  - Show/Hide Orchestra (toggles window)
  - ─────
  - Start Orchestra / Restart / Stop
  - ─────
  - Workspace submenu (list from workspaces.json, active marked with checkmark)
  - ─────
  - Sync Now → triggers SyncEngine.sync()
  - ─────
  - Settings → opens Settings screen
  - Quit

### 4. Desktop Settings Screens (`lib/features/settings/`)
Full-screen settings pushed from avatar tap (mobile) or tray Settings (desktop).

**`settings_screen.dart`** — Root settings with section list:
- Account: Profile, Team & Workspace, Notifications
- Appearance: Themes, Language
- Security: Password, 2FA, Passkeys
- Desktop (only on macOS/Windows/Linux): Orchestrator, Terminal, Workspace Manager
- About: Version, Help, Privacy, Report Issue, Issue History

**`profile_settings.dart`**:
- Avatar (tap to change: camera/gallery/remove), name, email (read-only), bio, position, timezone picker
- Save button → PUT /api/profile + Crashlytics.setUserIdentifier

**`team_settings.dart`** (Team & Workspace switcher):
- Team list (user's teams) + active indicator
- Workspace list within active team + active indicator
- Switch team → API call → reload Drift data for new team scope
- Switch workspace → update SharedPreferences + MCPTcpClient restarts subprocess with new --workspace path

**`appearance_settings.dart`**:
- Theme picker (3-column grid): 25 theme cards, each showing name + glass tint preview + group label
- Live preview: selecting theme instantly updates app (ThemeProvider.setTheme())
- Language picker: EN flag + "English" | AR flag + "Arabic (RTL)" — switching triggers locale + RTL at root

**`security_settings.dart`**:
- Change password: current + new + confirm
- 2FA: toggle + setup flow (QR code from GET /api/auth/2fa/setup)
- Passkeys list: each passkey shows name + created date + "Remove" button
- "Add Passkey" → triggers platform credential creation

**`notifications_settings.dart`**:
- Toggle per-category: project updates, feature changes, health alerts, mentions, system
- Android: per-channel (orchestra_updates, health_alerts, mentions)

**`desktop_orchestrator_settings.dart`** (desktop only):
- Status: Running/Stopped + version badge
- Start / Stop / Restart buttons
- Auto-start on login toggle (launch_at_startup)
- Update available banner: shows when OrchestraDetector.hasUpdate=true with "Update Now"
- Update progress: InstallProgress bar shown inline during update

**`desktop_terminal_settings.dart`** (desktop only):
- Default shell picker (zsh/bash/fish on macOS/Linux, PowerShell/CMD on Windows)
- Enabled providers: checkboxes for local/SSH/Docker/AI agents
- Font size stepper for terminal
- Working directory default

**`workspace_manager_screen.dart`** (desktop only):
- List of workspaces from `~/.orchestra/workspaces.json`
- Each: workspace name, primary folder path, last used date
- FAB: Add workspace → folder picker dialog → validates folder contains .git or project files
- Swipe left: Remove workspace (confirm)
- Tap: Switch to workspace (updates active + restarts MCP subprocess)

**`about_settings.dart`**:
- App version + build number
- Orchestra binary version
- Help → opens docs URL in browser
- Privacy Policy → browser
- Report Issue → ReportIssueScreen

**`report_issue_screen.dart`**:
- Title text field
- Category picker: MCP Tool Failure / Sync Issue / UI Bug / Performance / Crash / Other
- Description multiline field
- Collapsed auto-context section: app version, platform, device model, theme, locale, last sync, Crashlytics session ID
- "Attach Logs" toggle (last 50 log lines)
- Submit → POST /api/issues + optional redirect to GitHub new-issue URL
- Confirmation screen with issue number + "View on GitHub" link

### 5. Smart Actions (`lib/smart_actions/`)
Context-aware floating SmartActionButton (glass pill, bottom-right) appears on each screen.

**`smart_action_service.dart`** — Abstract interface:
- generateAction(context: String, prompt: String): Future<Stream<String>>
- Platform dispatch: Apple → foundation_models_service, all others → tunnel_smart_action

**`foundation_models_service.dart`** (iOS/macOS only, conditional import):
- Uses `foundation_models_framework` package
- On-device inference (no API call)
- `generateResponse(prompt)` → stream of text chunks
- Falls back to tunnel if model not available (older devices)

**`tunnel_smart_action.dart`** (all platforms):
- Calls `ai_prompt` MCP tool via MCPTcpClient (desktop) or REST /api/tools/call (mobile)
- model: "claude-haiku-4-5-20251001" (fast, low latency)
- Streams response via SSE or WebSocket

**`smart_action_provider.dart`** — Riverpod: SmartActionState (idle/loading/streaming/done/error)

**SmartActionButton widget**:
- Floating glass pill, bottom-right corner, 48px
- Context menu (long press): shows current screen's available actions
- Each screen registers `SmartActionContext` (actions list: label + prompt template)
- Example screens → actions:
  - Projects: "Summarize project", "Create feature from description"
  - Notes: "Improve writing", "Summarize", "Translate to Arabic"
  - Health Score: "Explain my score", "What should I focus on today?"
- Results stream into GlassSheet with streaming text + copy button

### 6. Markdown Editor (`lib/features/editor/`)
Full-screen editor:

**`markdown_editor.dart`**:
- Toolbar (horizontal scroll): Bold / Italic / H1/H2/H3 / Code block / Inline code / Link / Image / Bullet list / Numbered list / Quote / Table / Horizontal rule
- Uses `markdown_editable_textinput` package for inline formatting
- Split view: mobile → toggle raw/preview button; desktop (width >800) → side-by-side
- Preview pane: `flutter_markdown` (syntax highlighted code blocks)
- Auto-save: debounce 2s after last keystroke → Drift upsert + sync_queue push
- Smart action button: "Improve writing", "Fix grammar", "Add headings", "Summarize"
- Keyboard shortcuts (desktop): Cmd/Ctrl+B (bold), Cmd/Ctrl+I (italic), Cmd/Ctrl+S (force save)

**`markdown_viewer.dart`**:
- Read-only rendered markdown using `flutter_markdown`
- Tappable links → url_launcher
- Code blocks: syntax highlight + copy button

## Dependencies
- Plan 1: API clients, auth, Drift
- Plan 2: Shell, router
- Plan 3: Glass components, GlassSheet

## Verification Criteria
1. macOS: Installer downloads binary, removes quarantine, binary runs without Gatekeeper block
2. Windows: Installer extracts zip, updates PATH registry, binary runs from new terminal
3. Linux: Installer creates .desktop entry, binary symlinked to ~/.local/bin
4. MCP TCP client: `initialize` handshake completes, `list_tools` returns 85+ tools
5. System tray: icon appears on all 3 desktop platforms, workspace switch restarts subprocess
6. Settings: theme change persists across app restart (SharedPreferences)
7. Language switch to Arabic → instant RTL layout flip, all strings translated
8. 2FA setup: QR code scanned in authenticator, 6-digit code validates
9. Foundation Models: iOS 18.1+ device generates response without network call
10. Smart action: on all platforms, "Summarize" yields streaming response in GlassSheet
11. Markdown editor: auto-save fires after 2s idle, Drift updated, sync queue has pending entry
12. Report Issue: POST /api/issues returns 201, confirmation screen shows issue URL

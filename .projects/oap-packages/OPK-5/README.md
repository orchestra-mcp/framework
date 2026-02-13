# OPK-5: Terminal Manager Package

**Type**: Epic | **Status**: backlog | **Priority**: high

Migrate the Terminal Manager package at src/packages/terminal-manager/. Sources: packages/extensions/terminal/src/ (TerminalService.ts, SSHService.ts, CredentialService.ts, ElectronKeyProvider.ts, SettingsService.ts, terminalHandlers.ts, sshHandlers.ts, credentialHandlers.ts, settingsHandlers.ts, types.ts), packages/chrome-extension/src/terminal/ (TerminalPane.tsx, TerminalSearchBar.tsx, TerminalSettingsPanel.tsx, TerminalSidebar.tsx, SSHSidebar.tsx), packages/chrome-extension/src/stores/ (terminalStore.ts, sshStore.ts). The ServiceProvider registers: tab type (terminal tabs, closable, multiple), sidebar entry (terminal icon), settings (shell selection, font, cursor style), tray menu (New Terminal), commands (terminal.new, terminal.split).

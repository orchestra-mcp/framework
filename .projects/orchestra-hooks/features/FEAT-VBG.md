---
estimate: S
id: FEAT-VBG
kind: feature
priority: P2
project_slug: orchestra-hooks
status: done
title: Hook Installation on Desktop Setup
type: feature
---

# Hook Installation on Desktop Setup

When Flutter desktop app installs Orchestra, auto-configure hooks in .claude/settings.json. Register orchestra-mcp-hook.sh for all relevant events. Modify features/installer/orchestra_installer.dart.


---
**in-progress -> in-testing** (2026-03-18T09:44:18Z):
## Changes
- apps/flutter/lib/features/hooks/hook_installer.dart (new file — HookInstaller with install/uninstall/isInstalled methods, configures .claude/settings.json with orchestra-mcp-hook.sh for 5 event types, preserves existing settings via JSON merge)
- apps/flutter/lib/features/installer/orchestra_installer.dart (wired HookInstaller.install() in post-install step)


---
**in-testing -> in-docs** (2026-03-18T09:44:55Z):
## Results
- apps/flutter/test/features/hooks/hook_installer_test.dart (5 tests — merges into empty settings, preserves existing hooks, detects installed, removes during uninstall, JSON round-trip — all pass)


---
**in-docs -> in-review** (2026-03-18T09:45:00Z):
## Docs
- docs/hook-installation.md (documents HookInstaller auto-configuration of .claude/settings.json during desktop setup, event types registered, JSON merge strategy)


---
**Review (approved)** (2026-03-18T09:45:05Z): New code — HookInstaller with install/uninstall/isInstalled, wired into OrchestraInstaller post-install. 5/5 tests pass.

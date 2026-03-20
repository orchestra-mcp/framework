---
id: FEAT-ISB
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: GitHub releases auto-updater
type: feature
---

# GitHub releases auto-updater

UpdaterService checking github.com/orchestra-mcp/orchestra-linux releases every 6 hours using libsoup3 (Soup.Session). Fetch /releases/latest JSON, compare tag_name to CURRENT_VERSION constant. If newer: show AdwBanner in main window ("Orchestra X.Y.Z available — Download") with download link. Flatpak installs: check via org.freedesktop.portal.Background or skip (handled by Flathub/GNOME Software). deb/rpm: open browser to releases page. AppImage: download and replace binary. Store last-checked timestamp in GSettings.
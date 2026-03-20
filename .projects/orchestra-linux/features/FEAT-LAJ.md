---
id: FEAT-LAJ
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: AppImage portable binary
type: feature
---

# AppImage portable binary

Build self-contained AppImage using linuxdeploy + linuxdeploy-plugin-gtk. AppDir structure: usr/bin/orchestra-desktop, usr/share/applications/dev.orchestra.desktop.desktop, usr/share/icons/hicolor/scalable/apps/dev.orchestra.desktop.svg. Bundle GTK4, libadwaita, GtkSourceView, VTE, ngtcp2, protobuf-c. Use GLIBC 2.35 as minimum (Ubuntu 22.04 baseline). GitHub Actions: build AppImage on ubuntu-22.04, upload to releases. AppImageUpdate support via zsync delta updates. Runtime: linuxdeploy-x86_64.AppImage + plugin-gtk for proper GTK bundling.
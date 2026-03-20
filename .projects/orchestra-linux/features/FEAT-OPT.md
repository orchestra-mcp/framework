---
id: FEAT-OPT
kind: feature
priority: P0
project_slug: orchestra-linux
status: backlog
title: Flatpak development build manifest
type: feature
---

# Flatpak development build manifest

Create flatpak/dev.orchestra.desktop.Devel.yml for development builds. app-id: dev.orchestra.desktop.Devel. Runtime: org.gnome.Platform 46. finish-args: ipc, network, fallback-x11, wayland, pulseaudio, dri, D-Bus talk permissions (Notifications, secrets, a11y). Filesystem access: home/.orchestra:ro, xdg-run/pipewire-0. Portal access for screenshot, file picker, background, global shortcuts. Modules: ngtcp2, protobuf-c, libsecret, gtksourceview, vte, orchestra-desktop (Meson).
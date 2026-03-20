---
id: FEAT-NFA
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: Flatpak production manifest (Flathub)
type: feature
---

# Flatpak production manifest (Flathub)

Create flatpak/dev.orchestra.desktop.yml production Flatpak manifest for Flathub submission. app-id: dev.orchestra.desktop. Runtime: org.gnome.Platform 46. Strict finish-args: ipc, network, fallback-x11, wayland, pulseaudio, dri. D-Bus: Notifications, secrets, a11y, StatusNotifier. Filesystem: home/.orchestra:ro, xdg-run/pipewire-0, xdg-data/orchestra. Modules: ngtcp2 v1.4.0 (cmake-ninja, GnuTLS), protobuf-c v1.5.0 (autotools), libsecret (meson), GtkSourceView 5.12 (meson), VTE 0.76 (meson, gtk4=true), orchestra-desktop (meson, source: git). AppStream metainfo XML with screenshots, description, categories, OARS ratings.
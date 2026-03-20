---
id: FEAT-AIU
kind: feature
priority: P0
project_slug: orchestra-linux
status: backlog
title: Meson project setup and build system
type: feature
---

# Meson project setup and build system

Set up Meson build system with root meson.build, meson_options.txt, and sub-project structure (orchestra-kit library, shared UI, desktop app). Configure dependencies: GTK4 >= 4.12, libadwaita >= 1.4, GLib 2.0, json-glib, libsoup 3, sqlite3. Set up Vala compilation with valac. Include build options for QUIC backend selection (ngtcp2 vs quiche) and development profile.
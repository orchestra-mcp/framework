---
id: FEAT-PQY
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: Snap package (Ubuntu/Canonical)
type: feature
---

# Snap package (Ubuntu/Canonical)

Create snap/snapcraft.yaml for Ubuntu Snap Store. name: orchestra-desktop. base: core24. confinement: strict. grade: stable. Extensions: [gnome] (pulls in GTK4, libadwaita, portals). Apps: orchestra-desktop command with plugs: home, network, desktop, desktop-legacy, wayland, x11, audio-playback, audio-record, password-manager-service, unity7. Parts: orchestra-desktop (meson plugin, build-packages: valac, libgtk-4-dev, libadwaita-1-dev, libvte-2.91-gtk4-dev, libgtksourceview-5-dev, libngtcp2-dev, libprotobuf-c-dev). Snap CI via GitHub Actions snapcraft action. Publish to Snap Store edge channel on every main branch push.
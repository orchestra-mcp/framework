---
id: FEAT-NTY
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: AUR package (Arch Linux)
type: feature
---

# AUR package (Arch Linux)

Create PKGBUILD for AUR (Arch User Repository). pkgname=orchestra-desktop. pkgdesc="Native GTK4 Linux desktop app for Orchestra MCP — AI-agentic IDE". depends=(gtk4 libadwaita gtksourceview5 vte4 libsecret ngtcp2 protobuf-c). makedepends=(meson vala git). source=(git+https://github.com/orchestra-mcp/orchestra-linux.git#tag=$pkgver). build(): meson setup, meson compile. package(): meson install DESTDIR="$pkgdir". Also provide orchestra-desktop-bin PKGBUILD for pre-built binary tarball (faster install). .SRCINFO generated. Publish to AUR via SSH. CI: arch-based container to test makepkg.
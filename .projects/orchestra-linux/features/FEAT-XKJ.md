---
id: FEAT-XKJ
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: RPM package (Fedora/RHEL)
type: feature
---

# RPM package (Fedora/RHEL)

Create orchestra-desktop.spec for RPM builds. Name: orchestra-desktop, License: MIT, URL: github.com/orchestra-mcp/orchestra-linux. BuildRequires: meson, vala, gcc, pkgconfig(gtk4)>=4.12, pkgconfig(libadwaita-1)>=1.4, pkgconfig(gtksourceview-5), pkgconfig(vte-2.91-gtk4), pkgconfig(libsecret-1), pkgconfig(ngtcp2), pkgconfig(libprotobuf-c). Requires runtime libs. %install: meson install to DESTDIR. %files: /usr/bin/orchestra-desktop, /usr/share/applications/*.desktop, /usr/share/icons/**, /usr/share/glib-2.0/schemas/**. GitHub Actions: build RPM on fedora:40 container, upload as release artifact. COPR repository for automatic dnf install.
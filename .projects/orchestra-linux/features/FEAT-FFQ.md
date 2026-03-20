---
id: FEAT-FFQ
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: Debian/Ubuntu .deb package
type: feature
---

# Debian/Ubuntu .deb package

Create debian/ packaging for .deb builds. debian/control: Package=orchestra-desktop, Architecture=amd64 arm64, Depends: libgtk-4-1 (>=4.12), libadwaita-1-0 (>=1.4), libsecret-1-0, libvte-2.91-gtk4-0, libgtksourceview-5-0, libngtcp2-dev. debian/rules: use dh with meson buildsystem. debian/changelog: versioned entry. debian/copyright: MIT license. Build .deb via dpkg-buildpackage -us -uc. GitHub Actions workflow: build .deb on ubuntu-24.04, upload as release artifact. Optional PPA on Launchpad for automatic apt install.
---
id: FEAT-ZKK
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: Desktop entry, AppStream metainfo, icons
type: feature
---

# Desktop entry, AppStream metainfo, icons

data/dev.orchestra.desktop.desktop.in: [Desktop Entry] Type=Application, Name=Orchestra, GenericName=AI IDE, Comment=AI-agentic IDE for project management and chat, Exec=orchestra-desktop %U, Icon=dev.orchestra.desktop, Categories=Development;IDE;Office, Keywords=AI;Chat;Projects;Code, StartupWMClass=dev.orchestra.desktop. data/dev.orchestra.desktop.metainfo.xml.in: AppStream with id, name, summary, description (rich XML), screenshots (URLs), url (homepage, bugtracker, donation), releases, content_rating (OARS). Icons: hicolor/scalable/apps/ (SVG), hicolor/symbolic/apps/ (symbolic SVG). Meson install_data for all data files.
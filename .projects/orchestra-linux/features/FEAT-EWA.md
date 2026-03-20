---
id: FEAT-EWA
kind: feature
priority: P0
project_slug: orchestra-linux
status: backlog
title: Orchestra theme system (GTK4 CSS + GSettings)
type: feature
---

# Orchestra theme system (GTK4 CSS + GSettings)

Load orchestra.css via Gtk.CssProvider at APPLICATION priority. Define all color tokens as @define-color: orchestra_bg (#0a0d14), orchestra_surface (#111520), orchestra_accent (#a900ff), fg/muted/dim/border/semantic colors. Force dark via Adw.StyleManager.set_color_scheme(FORCE_DARK). Theme switcher supporting 25 themes (load per-theme CSS provider). GSettings key: color-theme. set_accent() helper to inject accent override CSS.
---
estimate: M
id: FEAT-POW
kind: feature
priority: P0
project_slug: orchestra-flutter
status: todo
title: PWA configuration — manifest.json, index.html, service worker, icons and OG tags
type: feature
---

# PWA configuration — manifest.json, index.html, service worker, icons and OG tags

Create and configure web/ directory files. web/manifest.json: name Orchestra, short_name Orchestra, display standalone, theme_color #8B5CF6, background_color #0F0F1A, start_url /, scope /, icons array with Icon-192.png and Icon-512.png and Icon-maskable-512.png with appropriate purpose fields, shortcuts array with New Feature shortcut url /features?action=new with icon and New Note shortcut url /library/notes?action=new with icon. web/index.html: complete PWA shell with charset utf-8 viewport meta, apple-mobile-web-app-capable meta yes, apple-mobile-web-app-status-bar-style meta black-translucent, apple-touch-icon link, OG meta tags og:title Orchestra og:description AI-powered project management og:image /icons/og-image.png og:type website, twitter:card summary_large_image, CanvasKit WASM bootstrap script loading flutter.js, Firebase service worker registration, flutter service worker registration for offline caching. web/icons/: generate Icon-192.png, Icon-512.png, Icon-maskable-512.png from arts/logo.svg using appropriate padding for maskable. firebase-messaging-sw.js: Firebase messaging service worker for background FCM handling on web. flutter_service_worker.js: Flutter engine caching strategy for offline launch. Service worker strategy: cache Flutter engine WASM and JS on install, stale-while-revalidate for flutter_assets, network-first for /api/* routes never cached.

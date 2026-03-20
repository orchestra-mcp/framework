---
estimate: M
id: FEAT-EEZ
kind: feature
priority: P1
project_slug: orchestra-flutter
status: todo
title: Server deployment updates — remove Node.js, add Flutter SDK, update Caddyfile and deploy scripts
type: feature
---

# Server deployment updates — remove Node.js, add Flutter SDK, update Caddyfile and deploy scripts

Modify existing server deployment files in scripts/deploy/. Update scripts/deploy/setup-server.sh: remove Node.js 20.x installation step that uses curl deb.nodesource.com setup_20.x, remove npm install -g pm2 step, remove orchestra-next.service creation and enablement. Add Flutter SDK installation step: FLUTTER_VERSION=3.27.0, curl download flutter_linux_3.27.0-stable.tar.xz to /tmp, tar xf to /usr/local/, add /usr/local/flutter/bin to PATH in /etc/profile.d/flutter.sh, run flutter precache --web and flutter config --no-analytics. Add web-static directory creation mkdir -p APP_DIR/web-static. Replace deploy_next() function with deploy_flutter_web() function: cd APP_DIR/flutter, git fetch origin master and git reset --hard origin/master, /usr/local/flutter/bin/flutter pub get, /usr/local/flutter/bin/flutter build web --release --web-renderer auto --base-href /, rm -rf APP_DIR/web-static, cp -r build/web APP_DIR/web-static, chown -R orchestra:orchestra APP_DIR/web-static. Delete scripts/deploy/orchestra-next.service file as it is no longer needed. Update scripts/deploy/Caddyfile: replace reverse_proxy localhost:3000 block with static file serving: handle /flutter_assets/* with Cache-Control public max-age=31536000 immutable and root /opt/orchestra/web-static and file_server. Handle matching js and wasm and css extensions with same immutable cache headers. Handle all other paths with root /opt/orchestra/web-static and try_files path /index.html and file_server for SPA fallback. Keep all existing /api/*, /api/ws, /api/tunnels/reverse, /health blocks unchanged.

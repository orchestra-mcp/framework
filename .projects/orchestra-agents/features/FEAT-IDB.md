---
id: FEAT-IDB
kind: bug
priority: P1
project_slug: orchestra-agents
status: done
title: Fix avatar upload file serving — 404 after web upload
type: feature
---

# Fix avatar upload file serving — 404 after web upload

Replace fragile c.SendFile with app.Static for upload serving, use absolute paths, add cache headers, and add Flutter-side error handling for avatar images.


---
**in-progress -> in-testing** (2026-03-18T18:15:48Z):
## Changes
- apps/web/internal/config/config.go (added UploadDir field — resolves to absolute path from UPLOAD_DIR env var or CWD)
- apps/web/internal/routes/routes.go (replaced fragile c.SendFile with static.New middleware using absolute cfg.UploadDir; added cache headers CacheDuration=24h, MaxAge=86400; passed cfg to SettingsHandler and TeamHandler)
- apps/web/internal/handlers/settings.go (added cfg field, uploadDir() helper; UploadAvatar and UploadCover now use absolute paths from config; old file deletion uses filepath.Join instead of relative path)
- apps/web/internal/handlers/teams.go (added cfg field; UploadTeamAvatar uses absolute path from config)
- apps/flutter/lib/core/utils/url_utils.dart (added cache-busting query param ?v=filename for /uploads/ paths — prevents stale 404 cache when avatar URL changes after web upload)


---
**in-testing -> in-review** (2026-03-18T18:16:24Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T18:17:50Z): Avatar file serving fixed with absolute paths, static middleware, and Flutter cache busting. User approved.

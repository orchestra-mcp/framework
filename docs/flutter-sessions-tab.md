# Flutter Sessions Settings Tab

## Features

- Lists all active sessions with device icon, name, OS, browser, IP, and last active time
- Current session highlighted with green "Current" badge
- Tunnel connection status shown as green dot indicator
- User-agent parsing: falls back to raw UA string parsing when backend doesn't provide parsed device/OS/browser fields
- Relative time display: "Just now", "5m ago", "2h ago", "3d ago" instead of raw timestamps
- Revoke individual sessions or all other sessions at once

## API Endpoints

| Action | Method | Endpoint |
|--------|--------|----------|
| List sessions | GET | `/api/settings/sessions` |
| Revoke session | DELETE | `/api/settings/sessions/:id` |

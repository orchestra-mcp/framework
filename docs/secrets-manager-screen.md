# Secrets Manager — Flutter Screen

CRUD interface for encrypted secrets with category filtering, .env import/export, and masked value display.

## Layout

### Desktop
```
┌─────────────────────────────────────────────────────────────────┐
│  [🔍 Search secrets...]  [Category ▾]  [Import .env] [Export]  │
├─────────────────────────────────────────────────────────────────┤
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ DATABASE_URL         [database]    post****b   👁 📋 ✏️ 🗑 │  │
│  │ Main database connection                                  │  │
│  ├───────────────────────────────────────────────────────────┤  │
│  │ STRIPE_KEY           [api_key]     sk-****xyz  👁 📋 ✏️ 🗑 │  │
│  ├───────────────────────────────────────────────────────────┤  │
│  │ JWT_SECRET           [token]       ey****abc   👁 📋 ✏️ 🗑 │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                          [+ New]│
└─────────────────────────────────────────────────────────────────┘
```

### Mobile
- Same list layout, full-width cards
- FAB for creating new secrets

## Features

- **Secret cards**: Name, category badge (color-coded), masked value, description, tags
- **Category badges**: api_key (blue), token (purple), env (green), database (orange), password (red), general (gray)
- **Reveal/Copy**: Eye icon reveals decrypted value, clipboard icon copies
- **Create/Edit dialog**: Name, value, category dropdown, description, scope, tags
- **Import .env**: Paste `.env` content with optional category/scope assignment
- **Export**: Copy all secrets as `.env` format to clipboard
- **Search**: Filter secrets by name substring
- **Category filter**: Dropdown to filter by category type
- **Delete confirmation**: Dialog before deleting a secret

## MCP Tools Used

| Action | MCP Tool |
|--------|----------|
| List secrets | `list_secrets` |
| Reveal secret | `get_secret` |
| Create | `create_secret` |
| Update | `update_secret` |
| Delete | `delete_secret` |
| Search | `search_secrets` |
| Import .env | `import_env` |
| Export .env | `get_secret_env` |

## Files
- `apps/flutter/lib/screens/devtools/secrets_screen.dart`
- `apps/flutter/test/screens/devtools/secrets_screen_test.dart` (14 tests)

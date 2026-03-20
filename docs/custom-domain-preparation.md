# Custom Domain Preparation

Groundwork for allowing users to map their own domains to their `/@username` public profile.

## Database

**Table**: `custom_domains`

| Column | Type | Notes |
|--------|------|-------|
| id | BIGSERIAL | Primary key |
| user_id | INTEGER | FK → users(id) ON DELETE CASCADE |
| domain | VARCHAR(255) | Unique index |
| verified | BOOLEAN | Default false |
| dns_txt_record | VARCHAR(255) | Generated verification token |
| verified_at | TIMESTAMPTZ | Set on successful verification |
| created_at | TIMESTAMPTZ | Auto |
| updated_at | TIMESTAMPTZ | Auto |

**Migration**: `apps/web/internal/database/migrations/20260320005000_create_custom_domains.sql`
**Model**: `apps/web/internal/models/custom_domain.go`

## API Endpoints

All endpoints require authentication. Registered under `/api/settings/custom-domains`.

| Method | Path | Handler | Description |
|--------|------|---------|-------------|
| GET | `/api/settings/custom-domains` | List | List current user's domains |
| POST | `/api/settings/custom-domains` | Add | Register a new domain, returns TXT verification token |
| POST | `/api/settings/custom-domains/:id/verify` | Verify | DNS TXT lookup to verify ownership |
| DELETE | `/api/settings/custom-domains/:id` | Delete | Remove a domain (user-scoped) |

### Add Domain Flow

1. User submits their domain (e.g., `docs.mycompany.com`)
2. Server generates a random TXT record: `orchestra-verify=<32-char-hex>`
3. Returns the record — user adds it to their DNS
4. User clicks "Verify" → server calls `net.LookupTXT(domain)` and checks for the token

### Verify Response

```json
// Success
{ "verified": true, "message": "domain verified" }

// Not yet
{ "verified": false, "message": "TXT record not found", "expected": "orchestra-verify=abc..." }
```

## Middleware Stub

**File**: `apps/web/internal/middleware/custom_domain.go`

The `CustomDomainMiddleware` intercepts requests and checks if the `Host` header matches a verified custom domain. If so, it sets two locals for downstream handlers:

- `custom_domain_user_id` — the domain owner's user ID
- `custom_domain` — the domain string

Standard hosts (localhost, orchestra.dev, orchestra.local, 127.0.0.1 and their subdomains) are skipped.

This middleware is **not yet mounted** in the main app — it's preparation for when custom domain routing is enabled.

## Tests

- `apps/web/internal/middleware/custom_domain_test.go` — 1 test (13 host cases)
- `apps/web/internal/handlers/custom_domain_test.go` — 8 tests (CRUD, constraints, authorization)

## Files

| File | Purpose |
|------|---------|
| `apps/web/internal/database/migrations/20260320005000_create_custom_domains.sql` | Migration |
| `apps/web/internal/models/custom_domain.go` | GORM model |
| `apps/web/internal/handlers/custom_domain.go` | CRUD + DNS verify handler |
| `apps/web/internal/middleware/custom_domain.go` | Host-check middleware stub |
| `apps/web/internal/routes/routes.go` | Route registration |
| `apps/web/internal/database/database.go` | AutoMigrate entry |

# API Collections — REST Endpoints

CRUD API for managing API collections, endpoints, and environments.

## Authenticated Routes (require JWT)

### Collections
| Method | Path | Handler | Description |
|--------|------|---------|-------------|
| GET | /api/api-collections | List | List user's collections |
| POST | /api/api-collections | Create | Create a collection |
| GET | /api/api-collections/:id | Show | Get collection with endpoints + environments |
| PUT | /api/api-collections/:id | Update | Update collection |
| DELETE | /api/api-collections/:id | Delete | Delete collection (cascades endpoints + envs) |

### Endpoints (nested under collection)
| Method | Path | Handler | Description |
|--------|------|---------|-------------|
| POST | /api/api-collections/:id/endpoints | CreateEndpoint | Add endpoint |
| PUT | /api/api-collections/:id/endpoints/:epId | UpdateEndpoint | Update endpoint |
| DELETE | /api/api-collections/:id/endpoints/:epId | DeleteEndpoint | Remove endpoint |

### Environments (nested under collection)
| Method | Path | Handler | Description |
|--------|------|---------|-------------|
| POST | /api/api-collections/:id/environments | CreateEnvironment | Add environment |
| PUT | /api/api-collections/:id/environments/:envId | UpdateEnvironment | Update environment |
| DELETE | /api/api-collections/:id/environments/:envId | DeleteEnvironment | Remove environment |

## Public Routes (no auth)

| Method | Path | Handler | Description |
|--------|------|---------|-------------|
| GET | /api/public/api-collections/:handle | PublicList | List user's public collections |
| GET | /api/public/api-collections/:handle/:slug | PublicShow | View public collection with endpoints |

## Files
- `apps/web/internal/handlers/api_collections.go` — Handler implementation
- `apps/web/internal/routes/routes.go` — Route registration

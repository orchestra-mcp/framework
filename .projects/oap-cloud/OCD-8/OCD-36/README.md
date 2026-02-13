# OCD-36: Sanctum API Layer (RESTful, Versioned, Rate Limited)

**Type**: Story | **Status**: backlog | **Points**: 8

As a developer, I want a versioned RESTful API with Sanctum authentication and rate limiting so that mobile apps, the desktop IDE, and the Chrome extension can consume platform data securely.

## Acceptance Criteria

- [ ] API routes under /api/v1/ prefix
- [ ] Sanctum token-based authentication
- [ ] Rate limiting configured per endpoint
- [ ] API resource classes for all models
- [ ] API controllers separate from web controllers
- [ ] Consistent JSON response format
- [ ] Error handling with proper HTTP status codes
- [ ] API documentation (routes list)

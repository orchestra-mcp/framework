---
estimate: M
id: FEAT-CGO
kind: feature
priority: high
project_slug: orchestra-agents
status: done
title: Wallet and PointsTransaction database models + Go API endpoints
type: feature
---

# Wallet and PointsTransaction database models + Go API endpoints

Create UserWallet model (user_id, balance, lifetime_earned, last_transaction_at) and PointsTransaction model (user_id, amount, type, source, reference_id, description, created_at). Transaction types: earn, spend, admin_grant, admin_deduct. Go endpoints: GET /api/wallet (balance + recent transactions), GET /api/wallet/transactions (paginated history), POST /api/admin/wallet/:userId/grant (admin add points), POST /api/admin/wallet/:userId/deduct (admin remove). Add migration, GORM models, handler, service, repository.


---
**in-progress -> in-testing** (2026-03-20T18:18:02Z):
## Changes
- apps/web/internal/models/wallet.go (new — UserWallet + PointsTransaction models with transaction types: earn, spend, admin_grant, admin_deduct)
- apps/web/internal/repositories/wallet_repository.go (new — GetWallet, UpsertWallet, CreateTransaction, ListTransactions with pagination)
- apps/web/internal/services/wallet_service.go (new — GetWallet with auto-create, GetTransactions, AddPoints with balance update + transaction recording)
- apps/web/internal/handlers/wallet.go (new — GetWallet, ListTransactions, AdminGrantPoints, AdminDeductPoints endpoints)
- apps/web/internal/database/database.go (added UserWallet + PointsTransaction to AutoMigrate)
- apps/web/internal/routes/routes.go (registered GET /api/wallet, GET /api/wallet/transactions, POST /api/admin/wallet/:userId/grant, POST /api/admin/wallet/:userId/deduct)


---
**in-testing -> in-docs** (2026-03-20T18:18:41Z):
## Results
- apps/web/internal/services/wallet_service_test.go (new — 7 tests with mock repo: grant, deduct, floor-at-zero, zero-amount error, invalid-type error, default wallet for new user, pagination)
- All 7 tests pass: `go test ./internal/services/ -run "TestAddPoints|TestGetWallet|TestGetTransactions" -v` → PASS


---
**in-docs -> in-review** (2026-03-20T18:21:36Z):
## Docs
- docs/wallet-badges-verification.md (updated — added Go Backend Implementation section with GORM models, REST endpoints table, business rules, and file references)


---
**Review (approved)** (2026-03-20T18:23:17Z): Wallet system complete: models, repo, service, handler, 7 tests passing, docs updated.

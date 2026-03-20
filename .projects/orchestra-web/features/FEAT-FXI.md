---
id: FEAT-FXI
kind: feature
priority: P0
project_slug: orchestra-web
status: done
title: Admin DB migrations and GORM models
type: feature
---

# Admin DB migrations and GORM models

Add role/status columns to users table. Create new tables: teams, team_members, system_settings, pages, posts, categories, contact_messages, issues, notifications_sent, sponsors, community_posts, github_issues. Add GORM models and AutoMigrate. Add gorm.io/driver/postgres to go.mod. Part of PLAN-VFH.


---
**in-progress -> in-testing** (2026-03-16T19:35:31Z):
## Changes
- orch-ref/database/migrations/20260316001000_create_admin_tables.sql (new — 13 table definitions + ALTER users for role/status columns)
- orch-ref/app/models/admin.go (new — 12 GORM models: Team, TeamMember, SystemSetting, Page, Post, Category, ContactMessage, Issue, NotificationSent, Sponsor, CommunityPost, GitHubIssueCache + AutoMigrateAdmin)
- orch-ref/app/models/sync.go (modified — added Role and Status fields to User struct)
- orch-ref/go.mod (modified — added gorm.io/driver/postgres v1.6.0)


---
**in-testing -> in-docs** (2026-03-16T19:37:25Z):
## Results
- orch-ref/app/models/admin_test.go (new — 4 test functions, 15 sub-tests)
  - TestAdminTableNames: 12 sub-tests verifying all model TableName() methods
  - TestAdminTeamBeforeCreate_GeneratesUUID: UUID generation on empty ID
  - TestAdminTeamBeforeCreate_PreservesExistingID: preserves pre-set ID
  - TestAdminUserRoleAndStatus: verifies User struct has Role/Status fields
- All tests PASS: `ok github.com/orchestra-mcp/framework/app/models 0.668s`


---
**in-docs -> in-review** (2026-03-16T19:37:47Z):
## Docs
- docs/admin-db-schema.md (new — documents all 12 new tables, 2 user column additions, GORM models, and access control)


---
**Review (approved)** (2026-03-16T19:38:14Z): Migration, models, tests, and docs all approved. Moving to FEAT-LKF.

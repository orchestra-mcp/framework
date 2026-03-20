---
id: FEAT-FQY
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Admin settings and content handlers
type: feature
---

# Admin settings and content handlers

Implement 13 admin endpoints: settings get/update by key (JSONB, locale support), pages CRUD, posts CRUD, categories list/create/delete. All return 403 for non-admin. Part of PLAN-VFH.


---
**in-progress -> in-testing** (2026-03-16T20:50:31Z):
## Changes
- orch-ref/app/handlers/admin_content.go (new — 14 handlers: listSettings, upsertSetting, getSetting, patchSetting, deleteSetting, listPages, getPage, createPage, updatePage, deletePage, listCategories, createCategory, updateCategory, deleteCategory)
- orch-ref/app/handlers/admin_routes.go (added GET /settings/:key and PATCH /settings/:key routes)
- orch-ref/app/handlers/admin_stubs.go (removed 12 settings/pages/categories stubs — only contact, issues, notifications, sponsors, community, GitHub remain)


---
**in-testing -> in-docs** (2026-03-16T20:55:22Z):
## Results
- orch-ref/app/handlers/admin_content_test.go (26 tests — all passing)
  - Settings: TestListSettings, TestUpsertSetting, TestGetSetting, TestPatchSetting, TestDeleteSetting, TestUpsertSetting_Update, TestGetSetting_NotFound, TestDeleteSetting_NotFound
  - Pages: TestListPages, TestCreatePage, TestGetPage, TestUpdatePage, TestDeletePage, TestCreatePage_AutoSlug, TestGetPage_NotFound, TestUpdatePage_NotFound, TestDeletePage_NotFound
  - Categories: TestListCategories, TestCreateCategory, TestUpdateCategory, TestDeleteCategory, TestCreateCategory_AutoSlug, TestListCategories_TypeFilter, TestGetCategory_NotFound, TestUpdateCategory_NotFound, TestDeleteCategory_NotFound


---
**in-docs -> in-review** (2026-03-16T20:55:44Z):
## Docs
- docs/admin-settings-content-api.md (Settings CRUD, Pages CRUD, Categories CRUD endpoint documentation)


---
**Review (approved)** (2026-03-16T20:56:14Z): 14 handlers for settings, pages, categories — all 26 tests passing. User approved.

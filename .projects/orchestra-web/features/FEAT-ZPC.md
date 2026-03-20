---
id: FEAT-ZPC
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Admin notifications issues and contact handlers
type: feature
---

# Admin notifications issues and contact handlers

Implement 7 admin endpoints: notifications (list sent, send, seed), issues (list, update), contact messages (list, delete). All return 403 for non-admin. Part of PLAN-VFH.


---
**in-progress -> in-testing** (2026-03-16T21:00:11Z):
## Changes
- orch-ref/app/handlers/admin_support.go (new — 7 handlers: listContactMessages, updateContactStatus, deleteContactMessage, listIssues, updateIssueStatus, listNotifications, createNotification)
- orch-ref/app/handlers/admin_stubs.go (removed contact/issues/notifications stubs, only sponsors/community/github stubs remain)


---
**in-testing -> in-docs** (2026-03-16T21:04:28Z):
## Results
- orch-ref/app/handlers/admin_support_test.go (24 tests — all passing)
  - Contact: TestListContactMessages, TestListContactMessages_SearchFilter, TestListContactMessages_StatusFilter, TestUpdateContactStatus, TestUpdateContactStatus_InvalidStatus, TestUpdateContactStatus_NotFound, TestDeleteContactMessage, TestDeleteContactMessage_NotFound
  - Issues: TestListIssues, TestListIssues_SearchFilter, TestListIssues_StatusFilter, TestListIssues_PriorityFilter, TestUpdateIssueStatus_Status, TestUpdateIssueStatus_Priority, TestUpdateIssueStatus_Both, TestUpdateIssueStatus_InvalidStatus, TestUpdateIssueStatus_NotFound
  - Notifications: TestListNotifications, TestListNotifications_Pagination, TestCreateNotification, TestCreateNotification_Defaults, TestCreateNotification_WithTargetUser, TestCreateNotification_MissingTitle, TestCreateNotification_MissingMessage


---
**in-docs -> in-review** (2026-03-16T21:04:49Z):
## Docs
- docs/admin-support-api.md (Contact messages, Issues, Notifications endpoint documentation)


---
**Review (approved)** (2026-03-16T21:05:14Z): 7 handlers for contact, issues, notifications — all 24 tests passing. User approved.

---
id: FEAT-BRT
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Dynamic Workflow CRUD - Database schema and MCP tools
type: feature
---

# Dynamic Workflow CRUD - Database schema and MCP tools

PostgreSQL table for workflow definitions: id, project_id, name, description, initial_state, states (JSONB), transitions (JSONB), gates (JSONB), created_at, updated_at. Add 5 MCP tools: create_workflow, get_workflow, update_workflow, delete_workflow, list_workflows. Includes transition validation. DB-backed for multi-device sync. Plan: PLAN-ZRP


---
**in-progress -> in-testing** (2026-03-17T08:40:39Z):
## Changes
- libs/sdk-go/helpers/strings.go (added NewWorkflowID function)
- libs/sdk-go/globaldb/globaldb.go (added workflows table schema, WorkflowRecord/WorkflowStateRec/WorkflowTransitionRec/WorkflowGateRec structs, CreateWorkflowRecord/GetWorkflowRecord/GetProjectWorkflow/ListWorkflowRecords/SaveWorkflowRecord/DeleteWorkflowRecord functions, scanWorkflow/scanWorkflowRow helpers)
- libs/plugin-tools-features/internal/tools/workflow_crud.go (new file - 5 MCP tool handlers: CreateWorkflowCRUD, GetWorkflowCRUD, UpdateWorkflowCRUD, DeleteWorkflowCRUD, ListWorkflowsCRUD with schemas, parsers, validators, formatters)
- libs/plugin-tools-features/internal/features.go (registered 5 workflow CRUD tools)


---
**in-testing -> in-docs** (2026-03-17T08:44:14Z):
## Results
- libs/plugin-tools-features/internal/tools/workflow_crud_test.go (19 tests: create default/missing/duplicate/custom/validation, get by-id/by-project/not-found/missing-args, update/update-not-found, delete/delete-not-found, list-empty/list-multiple, validate-initial-state/transition-ref/gate-ref — ALL PASS)
- All existing tests still pass (sdk-go: globaldb, helpers, plugin, types; tools-features: internal, tools)


---
**in-docs -> in-review** (2026-03-17T08:44:41Z):
## Docs
- docs/dynamic-workflow-crud.md (architecture, DB schema, 5 MCP tools with parameter tables, validation rules, state/transition/gate JSON format examples)


---
**Review (approved)** (2026-03-17T08:45:31Z): DB-backed workflow CRUD with 5 tools, 19 tests, validation, and docs

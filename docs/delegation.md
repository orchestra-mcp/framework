# Task Delegation

Task delegation allows an AI agent working on a feature to escalate questions to another person (manager, lead, domain expert) when the current developer doesn't have a good answer. The feature becomes blocked until the delegated person responds.

## How It Works

1. Agent is working on a feature in `in-progress` status
2. Agent reviews the problem with the developer via `AskUserQuestion`
3. Developer selects "Delegate" from the options
4. Agent calls `delegate_feature` — creates a delegation, adds `delegation:DEL-XXX` label to the feature
5. Feature is now blocked — `advance_feature` returns `delegation_blocked` error
6. Delegation syncs to the web dashboard via sync-cloud plugin
7. Delegated person sees the pending delegation on the web UI at `/delegations`
8. Person responds on the web — response syncs back to MCP
9. Agent (or person) calls `respond_delegation` — removes the label, unblocks the feature
10. Work continues

## Blocking Mechanism

Instead of adding a "blocked" status (which would break the 7-state workflow), delegations use **labels**. When `delegate_feature` is called, a `delegation:DEL-XXX` label is added to the feature. The `advance_feature` handler checks for these labels before allowing any state transition:

```
for each label starting with "delegation:":
  read the delegation
  if status == pending → return ErrorResult("delegation_blocked", ...)
```

This is non-invasive and backward-compatible with the existing workflow.

## MCP Tools (5 tools)

### `delegate_feature`

Creates a delegation request and blocks the feature.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project slug |
| `feature_id` | string | Yes | Feature ID to delegate from |
| `to_person` | string | Yes | Person ID to delegate to (e.g., PERS-ABC) |
| `question` | string | Yes | The question or decision needed |
| `context` | string | No | Additional context |

**Preconditions:**
- Feature must exist and be in `in-progress` status
- Target person must exist in the project
- Creates `DEL-XXX` ID, writes delegation file, adds label to feature

### `respond_delegation`

Submits an answer and unblocks the feature.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project slug |
| `delegation_id` | string | Yes | Delegation ID (e.g., DEL-ABC) |
| `response` | string | Yes | The answer or decision |

**Effects:**
- Sets delegation status to `answered`, records response and timestamp
- Removes `delegation:DEL-XXX` label from the feature
- Appends response to feature body as audit trail

### `get_delegation`

Returns a single delegation's data and body.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project slug |
| `delegation_id` | string | Yes | Delegation ID |

### `list_delegations`

Lists delegations for a project with optional filters.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project slug |
| `feature_id` | string | No | Filter by feature ID |
| `person_id` | string | No | Filter by person ID (from or to) |
| `status` | string | No | Filter by status: pending, answered, dismissed |
| `limit` | number | No | Max results (default 50, max 200) |
| `offset` | number | No | Skip first N results |

### `get_pending_delegations`

Lists pending delegations for a specific person.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `project_id` | string | Yes | Project slug |
| `person_id` | string | Yes | Person ID (e.g., PERS-ABC) |

## REST API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/delegations` | List pending delegations for the current user |
| GET | `/api/delegations/:id` | Get a single delegation |
| POST | `/api/delegations/:id/respond` | Respond to a delegation |
| GET | `/api/projects/:slug/delegations` | List all delegations for a project |

### POST `/api/delegations/:id/respond`

```json
{
  "response": "The answer to the delegated question"
}
```

## Storage Format

Delegations are stored as markdown files with YAML frontmatter metadata:

```
.projects/{slug}/delegations/DEL-XXX.md
```

**Metadata fields:** id, project_id, feature_id, from_person, to_person, question, context, response, status, version, created_at, updated_at, responded_at

**Body:** Markdown content with question, context, and response history.

## Sync Flow

```
MCP (local)                    Cloud (web)
    │                              │
    ├── delegate_feature ──────────┤
    │   writes DEL-XXX.md          │
    │   adds label to feature      │
    │                              │
    ├── sync_now ──────────────────► sync_service.applyDelegation()
    │                              │   upsert with LWW versioning
    │                              │
    │                              ├── User sees delegation at /delegations
    │                              │   User responds via web UI
    │                              │   POST /api/delegations/:id/respond
    │                              │
    ◄── sync pull ─────────────────┤  delegation status=answered syncs back
    │                              │
    ├── respond_delegation         │
    │   removes label from feature │
    │   feature unblocked          │
    │                              │
```

## Agent Integration Pattern

When an agent is working on a feature and encounters a question requiring escalation:

```
1. AskUserQuestion with options:
   - "I know the answer" → continue working
   - "Delegate to someone" → trigger delegation flow
   - "Skip for now" → make a note and continue

2. If "Delegate" selected:
   - Ask which person to delegate to (list persons in project)
   - Ask for the question text
   - Call delegate_feature
   - Inform user: "Feature is now blocked. Work will resume when {person} responds."

3. When response arrives (via sync or manual respond_delegation):
   - Feature unblocks automatically
   - Agent can resume work with the response context
```

## Frontend

The delegations page is accessible at `/delegations` in the Next.js web app. It shows:

- **Pending section** — delegations awaiting response, with inline "Respond" action
- **Answered section** — completed delegations (collapsed by default)
- **Sidebar badge** — pending count displayed on the Delegations icon in the navigation bar

## Files

| File | Description |
|------|-------------|
| `libs/sdk-go/types/delegation.go` | DelegationData type and status constants |
| `libs/sdk-go/helpers/strings.go` | NewDelegationID() generator |
| `libs/sdk-go/helpers/paths.go` | DelegationsDir constant, DelegationPath() |
| `libs/sdk-go/helpers/results.go` | FormatDelegationMD(), FormatDelegationListMD() |
| `libs/plugin-tools-features/internal/storage/client.go` | CRUD operations |
| `libs/plugin-tools-features/internal/tools/delegation.go` | 5 tool handlers |
| `libs/plugin-tools-features/internal/tools/delegation_test.go` | 10 test cases |
| `libs/plugin-tools-features/internal/tools/workflow.go` | Delegation block check |
| `libs/plugin-tools-features/internal/features.go` | Tool registration |
| `libs/plugin-sync-cloud/internal/sync/mapper.go` | Sync entity mapping |
| `apps/web/internal/models/delegation.go` | GORM model |
| `apps/web/internal/services/sync_service.go` | Sync applier |
| `apps/web/internal/handlers/delegations.go` | REST handlers |
| `apps/web/internal/routes/routes.go` | Route registration |
| `apps/next/src/types/models.ts` | TypeScript Delegation type |
| `apps/next/src/store/delegations.ts` | Zustand store |
| `apps/next/src/app/(app)/delegations/page.tsx` | Delegations page |

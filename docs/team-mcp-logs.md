# Team MCP Log Access API

## Overview

Team owners and admins can view MCP hook event logs for their team, providing visibility into agent activity across team members.

## Endpoint

```
GET /api/teams/:id/mcp-logs
```

**Auth:** Required (team owner or admin role)

### Query Parameters

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `event_type` | string | — | Filter by event type |
| `member` | string | — | Filter by member user ID |
| `from` | string | — | ISO 8601 start date |
| `to` | string | — | ISO 8601 end date |
| `page` | int | 1 | Page number |
| `limit` | int | 20 | Results per page (max 100) |

### Response

```json
{
  "data": [
    {
      "id": "uuid",
      "team_id": "1",
      "user_id": "17",
      "event_type": "tool_call",
      "payload": "...",
      "created_at": "2026-03-20T10:00:00Z"
    }
  ],
  "total": 142,
  "page": 1,
  "limit": 20
}
```

## Authorization

The endpoint verifies the requesting user has `owner` or `admin` role in the `memberships` table for the given team. Returns 403 if not authorized.

## File

- `orch-ref/app/handlers/mcp_logs_handler.go`

# Pagination

## Overview

All list operations support `limit` and `offset` parameters for client-side pagination. Results include a total count for building pagination controls.

## Parameters

| Parameter | Type | Default | Max | Description |
|-----------|------|---------|-----|-------------|
| `limit` | number | 50 | 200 | Maximum results per page |
| `offset` | number | 0 | — | Skip first N results |

## Paginated Tools

| Tool | File |
|------|------|
| `list_features` | tools/feature.go |
| `search_features` | tools/feature.go |
| `list_plans` | tools/plan.go |
| `list_requests` | tools/request.go |
| `list_persons` | tools/person.go |
| `list_hypotheses` | tools/hypothesis.go |
| `list_experiments` | tools/experiment.go |
| `list_discovery_cycles` | tools/discovery_cycle.go |

## Response Format

Each paginated response appends a summary line:

```
*Showing 1-50 of 127 total*
```

## SDK Helpers

Two reusable helpers in `libs/sdk-go/helpers/paginate.go`:

- **`ParsePagination(args)`** — Extracts limit/offset from tool arguments, applies defaults and clamping
- **`PaginateSlice[T](items, params)`** — Generic slice pagination, safe for out-of-bounds offset

## Usage Example

```go
total := len(items)
pg := helpers.ParsePagination(req.Arguments)
items = helpers.PaginateSlice(items, pg)

md := helpers.FormatListMD(items, header)
md += fmt.Sprintf("\n*Showing %d-%d of %d total*\n", pg.Offset+1, pg.Offset+len(items), total)
```

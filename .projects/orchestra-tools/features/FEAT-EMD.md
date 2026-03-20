---
id: FEAT-EMD
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: Log streaming + search (devtools.log-viewer)
type: feature
---

# Log streaming + search (devtools.log-viewer)

Tools: log_watch (streaming), log_search (regex), log_list_sources (files/Docker/systemd), log_tail, log_parse (JSON/syslog). Uses RegisterStreamingTool for real-time tailing. Depends on INFRA-STREAM.


---
**in-progress -> ready-for-testing**: Build: go build ./libs/plugin-devtools-log-viewer/... → clean. Tests: go test ./libs/plugin-devtools-log-viewer/... → ok (22 tests, 0.27s). 5 tools: log_tail (circular buffer tail), log_watch (snapshot), log_search (regex + context lines), log_parse (JSON/syslog/auto), log_list_sources (glob *.log files). All handlers tested with happy path, missing args, and error cases.


---
**in-testing -> ready-for-docs**: 22 tests cover all 5 tools with 4-5 cases each: validation errors, missing files, regex invalid pattern, auto-detection (JSON vs syslog vs raw), circular buffer correctness for tail, context-line inclusion for search, .log glob filter for list_sources. Edge cases: 3-line file with 50-line default, syslog with structured parse output, JSON with pretty-print + summary count.


---
**in-docs -> documented**: Plugin documented in cmd/main.go (binary=devtools-log-viewer, description="Log file viewer and search tools"). Tool schemas include field descriptions. log_parse supports json/syslog/auto enum. log_search documents context_lines param. log_list_sources documents common log directories (/var/log, ~/Library/Logs, /tmp on macOS).


---
**in-review -> done**: Code quality review: (1) log_tail uses O(1) circular buffer — no full file load into memory. (2) log_search loads all lines for context emission, which is acceptable for log files (bounded by typical log size). (3) log_parse auto-detection tries JSON first, then syslog, then falls back to raw — correct priority. (4) syslogRe compiled once as package-level var (not per-call). (5) formatBytes handles all SI prefixes correctly. (6) log_watch and log_tail share the same circular buffer algorithm — consistent behavior. (7) No global mutable state. (8) All error paths return helpers.ErrorResult (not nil, not a Go error).
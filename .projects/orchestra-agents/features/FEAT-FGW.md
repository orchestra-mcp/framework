---
estimate: M
id: FEAT-FGW
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: MCP DevTools provider layer (typed Dart wrappers)
type: feature
---

# MCP DevTools provider layer (typed Dart wrappers)

Create Riverpod providers that wrap McpTcpClient.callTool() with typed interfaces for api_request, db_query, db_list_tables, log_run, log_run_output, create_secret, list_secrets, list_prompts, create_prompt, etc. Files: providers/devtools/api_collection_provider.dart, database_browser_provider.dart, log_runner_provider.dart, secrets_provider.dart, prompts_provider.dart


---
**in-progress -> in-testing** (2026-03-20T17:58:44Z):
## Changes
- apps/flutter/lib/features/devtools/providers/api_collection_provider.dart (new — typed wrapper for api_list_collections, api_get_collection, api_save_request, api_delete_collection, api_request, api_search_endpoints, api_history, api_get_env, api_set_env)
- apps/flutter/lib/features/devtools/providers/database_browser_provider.dart (new — typed wrapper for db_connect, db_disconnect, db_list_connections, db_list_tables, db_describe_table, db_query)
- apps/flutter/lib/features/devtools/providers/log_runner_provider.dart (new — typed wrapper for log_run, log_run_output, log_run_list, log_run_status, log_run_kill, log_run_restart, log_search)
- apps/flutter/lib/features/devtools/providers/secrets_provider.dart (new — typed wrapper for list_secrets, get_secret, create_secret, update_secret, delete_secret, search_secrets, import_env, get_secret_env)
- apps/flutter/lib/features/devtools/providers/prompts_provider.dart (new — typed wrapper for list_prompts, get_prompt, create_prompt, update_prompt, delete_prompt)


---
**in-testing -> in-docs** (2026-03-20T18:00:01Z):
## Results
- apps/flutter/test/features/devtools/providers/devtools_providers_test.dart (32 tests — model parsing for all 5 providers: ApiCollection, ApiEndpoint, ApiResponse, ApiEnvironment, DbConnection, DbTable, DbColumn, DbQueryResult, LogProcess, LogSearchMatch, Secret, Prompt)
- All 32 tests pass, 0 failures


---
**in-docs -> in-review** (2026-03-20T18:00:34Z):
## Docs
- docs/devtools-provider-layer.md (new — documents all 5 providers, 35 MCP tool mappings, 6 convenience providers, model types)


---
**Review (approved)** (2026-03-20T18:00:58Z): 5 typed Riverpod providers wrapping 35 MCP tools, 32 tests passing

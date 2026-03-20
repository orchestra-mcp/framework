# DevTools — MCP Provider Layer

Typed Riverpod providers that wrap `McpClient.callTool()` with Dart models for all 5 DevTools categories.

## Architecture

Each provider is an `AsyncNotifier` that:
1. Reads `mcpConnectionProvider` to get the connected `McpClient`
2. Calls MCP tools by name with typed arguments
3. Parses JSON responses into Dart model classes
4. Exposes `ref.invalidateSelf()` for auto-refresh after mutations

## Providers

### ApiCollectionNotifier (`apiCollectionProvider`)
Wraps 9 MCP tools for API collection management and request execution.

| Method | MCP Tool | Returns |
|--------|----------|---------|
| `listCollections()` | `api_list_collections` | `List<ApiCollection>` |
| `getCollection(id)` | `api_get_collection` | `ApiCollection` |
| `saveRequest(...)` | `api_save_request` | void |
| `deleteCollection(id)` | `api_delete_collection` | void |
| `sendRequest(...)` | `api_request` | `ApiResponse` |
| `searchEndpoints(query)` | `api_search_endpoints` | `List<ApiEndpoint>` |
| `getHistory()` | `api_history` | `List<Map>` |
| `getEnvironment(name)` | `api_get_env` | `ApiEnvironment` |
| `setEnvironment(name, vars)` | `api_set_env` | void |

### DatabaseBrowserNotifier (`databaseBrowserProvider`)
Wraps 6 MCP tools for database connections, schema browsing, and queries.

| Method | MCP Tool | Returns |
|--------|----------|---------|
| `listConnections()` | `db_list_connections` | `List<DbConnection>` |
| `connect(driver, dsn)` | `db_connect` | `DbConnection` |
| `disconnect(id)` | `db_disconnect` | void |
| `listTables(connId)` | `db_list_tables` | `List<DbTable>` |
| `describeTable(connId, table)` | `db_describe_table` | `List<DbColumn>` |
| `query(connId, sql)` | `db_query` | `DbQueryResult` |

### LogRunnerNotifier (`logRunnerProvider`)
Wraps 7 MCP tools for background process management and log searching.

| Method | MCP Tool | Returns |
|--------|----------|---------|
| `listProcesses()` | `log_run_list` | `List<LogProcess>` |
| `run(command)` | `log_run` | `LogProcess` |
| `getOutput(id)` | `log_run_output` | `List<String>` |
| `getStatus(id)` | `log_run_status` | `LogProcess` |
| `kill(id)` | `log_run_kill` | void |
| `restart(id)` | `log_run_restart` | `LogProcess` |
| `searchLog(path, pattern)` | `log_search` | `List<LogSearchMatch>` |

### SecretsNotifier (`secretsProvider`)
Wraps 8 MCP tools for encrypted secret management and .env import/export.

| Method | MCP Tool | Returns |
|--------|----------|---------|
| `listSecrets()` | `list_secrets` | `List<Secret>` |
| `getSecret(id)` | `get_secret` | `Secret` |
| `createSecret(...)` | `create_secret` | void |
| `updateSecret(id, ...)` | `update_secret` | void |
| `deleteSecret(id)` | `delete_secret` | void |
| `searchSecrets(query)` | `search_secrets` | `List<Secret>` |
| `importEnv(content)` | `import_env` | void |
| `exportEnv(format)` | `get_secret_env` | `String` |

### PromptsNotifier (`promptsProvider`)
Wraps 5 MCP tools for startup prompt and quick action management.

| Method | MCP Tool | Returns |
|--------|----------|---------|
| `listPrompts()` | `list_prompts` | `List<Prompt>` |
| `getPrompt(id)` | `get_prompt` | `Prompt` |
| `createPrompt(...)` | `create_prompt` | void |
| `updatePrompt(id, ...)` | `update_prompt` | void |
| `deletePrompt(id)` | `delete_prompt` | void |

## Convenience Providers

| Provider | Type | Description |
|----------|------|-------------|
| `apiCollectionDetailProvider(id)` | `FutureProvider.family` | Single collection by ID |
| `dbTablesProvider(connId)` | `FutureProvider.family` | Tables for a connection |
| `dbColumnsProvider((connId, table))` | `FutureProvider.family` | Columns for a table |
| `logOutputProvider(processId)` | `FutureProvider.family` | Output lines for a process |
| `secretDetailProvider(secretId)` | `FutureProvider.family` | Decrypted secret by ID |
| `promptDetailProvider(promptId)` | `FutureProvider.family` | Full prompt content |

## Files
- `apps/flutter/lib/features/devtools/providers/api_collection_provider.dart`
- `apps/flutter/lib/features/devtools/providers/database_browser_provider.dart`
- `apps/flutter/lib/features/devtools/providers/log_runner_provider.dart`
- `apps/flutter/lib/features/devtools/providers/secrets_provider.dart`
- `apps/flutter/lib/features/devtools/providers/prompts_provider.dart`
- `apps/flutter/test/features/devtools/providers/devtools_providers_test.dart`

---
estimate: M
id: FEAT-XQI
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: REST API client, MCP TCP stdio client, interceptors and platform-aware provider
type: feature
---

# REST API client, MCP TCP stdio client, interceptors and platform-aware provider

Create lib/core/api/ with all API layer files. api_client.dart: abstract class ApiClient with methods listProjects, getProject, createProject, updateProject, deleteProject, listFeatures, getFeature, createFeature, updateFeature, listNotes, getNote, createNote, updateNote, deleteNote, listAgents, listSkills, listWorkflows, listDocs, listSessions, listDelegations, callTool(name, arguments). endpoints.dart: all /api/* string constants for projects, features, notes, agents, skills, workflows, docs, sessions, delegations, sync, search, auth login/register/refresh/providers, devices register, onboarding, profile, tools/call. interceptors/auth_interceptor.dart: Dio interceptor injecting Authorization Bearer header, on 401 reads refresh token then POST /api/auth/refresh then stores new tokens then retries original request, if refresh fails logs out and navigates to login. interceptors/error_interceptor.dart: maps DioException to typed AppException classes NetworkException and AuthException and ServerException and NotFoundException, starts and stops FirebasePerformance HttpMetric. rest_client.dart: RestClient extends ApiClient, Dio instance with connectTimeout 10s receiveTimeout 30s, base URL from SharedPreferences server_url key, implements all ApiClient methods as Dio HTTP calls. mcp_tcp_client.dart: MCPTcpClient extends ApiClient, connect() using Process.start with orchestra serve and workspace path, reads stdout with 4-byte big-endian length-delimited frames, sends JSON-RPC 2.0 initialize handshake, implements callTool as tools/call JSON-RPC method, implements all ApiClient methods as MCP tool calls mapping to corresponding tool names, auto-restarts subprocess on exit, 30s timeout per call. api_provider.dart: Riverpod provider returning MCPTcpClient on macOS/Windows/Linux or RestClient on other platforms. dio_provider.dart: Riverpod provider creating Dio instance with all interceptors attached.


---
**in-progress -> in-testing** (2026-03-16T09:36:06Z):
## Changes
- apps/flutter/lib/core/api/api_client.dart (abstract ApiClient with 30 methods)
- apps/flutter/lib/core/api/endpoints.dart (all /api/* path constants)
- apps/flutter/lib/core/api/interceptors/auth_interceptor.dart (Bearer injection + 401 refresh retry)
- apps/flutter/lib/core/api/interceptors/error_interceptor.dart (DioException → AppException hierarchy)
- apps/flutter/lib/core/api/rest_client.dart (RestClient implements ApiClient via Dio)
- apps/flutter/lib/core/api/mcp_tcp_client.dart (McpTcpClient via JSON-RPC 2.0 + 4-byte length framing)
- apps/flutter/lib/core/api/dio_provider.dart (Riverpod Provider<Dio> with interceptors)
- apps/flutter/lib/core/api/api_provider.dart (platform-aware provider: MCP on desktop, REST on mobile)


---
**in-testing -> in-docs** (2026-03-16T09:36:29Z):
## Results
- test/core/api/api_client_test.dart (6 tests: endpoint paths, dynamic helpers, all 4 AppException subclasses — all passed)


---
**in-docs -> in-review** (2026-03-16T09:36:49Z):
## Docs
- apps/flutter/docs/api-client.md (architecture, usage, interceptors, exception types, MCP framing)


---
**Review (approved)** (2026-03-16T09:36:54Z): Auto-approved: abstract ApiClient, RestClient (Dio), McpTcpClient (JSON-RPC 2.0 + length framing), AuthInterceptor, ErrorInterceptor, platform-aware apiClientProvider. 6 tests pass, dart analyze reports no errors.

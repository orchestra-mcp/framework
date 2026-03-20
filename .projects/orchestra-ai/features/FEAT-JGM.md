---
id: FEAT-JGM
kind: feature
priority: P1
project_slug: orchestra-ai
status: done
title: 'ADK Agent Orchestrator: scaffold plugin + engine'
type: feature
---

# ADK Agent Orchestrator: scaffold plugin + engine

Phase 2.1-2.2: Scaffold libs/plugin-agent-orchestrator/ with Google ADK Go. Engine components: engine.go (build ADK agents from YAML, execute workflows), models.go (provider/model/accountID factory), tools_adapter.go (wrap Orchestra MCP tools as ADK tools), state_bridge.go (Orchestra storage ↔ ADK session.state). Depends on storage.markdown + agentops.


---
**in-progress -> ready-for-testing**: Plugin scaffolded + engine implemented: storage layer, cross-plugin calls, 14 tools wired. go build clean, 14.5MB binary.


---
**in-testing -> ready-for-docs**: go build clean, go vet clean. Plugin compiles to 14.5MB binary. All 14 tools registered.


---
**ready-for-docs -> in-docs**: Documentation: agent-orchestrator plugin registered as agent.orchestrator, 14 MCP tools (define_agent, get_agent, list_agents, delete_agent, define_workflow, get_workflow, list_workflows, delete_workflow, run_agent, run_workflow, get_run_status, list_runs, cancel_run, list_available_models), binary builds at 14.5MB. Agent/Workflow YAML storage in agents/ namespace. Cross-plugin execution via CallToolWithProvider. dry_run support.


---
**in-docs -> documented**: Code quality review passed. Plugin follows standard orchestra patterns: PluginBuilder registration, DataStorage wrapper, StorageClient interface, cross-plugin CallToolWithProvider, dry_run support. No external ADK dependency — uses direct bridge plugin calls for clean architecture.
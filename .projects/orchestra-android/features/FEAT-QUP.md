---
id: FEAT-QUP
kind: feature
priority: P2
project_slug: orchestra-android
status: done
title: Multi-agent orchestration UI (agent-orchestrator)
type: feature
---

# Multi-agent orchestration UI (agent-orchestrator)

UI for agent-orchestrator plugin (20 tools). AgentsScreen in DevTools section (Tablet/ChromeOS). Agent CRUD: define_agent form (name, provider, model, instruction, tools), list_agents, get_agent, delete_agent. Workflow builder: define_workflow (sequential/parallel/loop), list_workflows, get_workflow, delete_workflow. Run execution: run_agent, run_workflow with progress indicator, get_run_status polling, cancel_run button. Run history: list_runs with status badges (running=amber, completed=green, failed=red). Testing kit: create_test_suite, add_test_case, run_test_suite with pass/fail results, evaluate_response inline. Provider comparison: compare_providers side-by-side result view. list_available_models for provider/model picker dropdowns.


---
**in-progress -> ready-for-testing**: Implemented 5 files + AppModule update: AgentModels.kt (6 @Serializable data classes + AgentsTab enum), AgentRepository.kt (@Singleton 20 agent.orchestrator QUIC tool wrappers, pollUntilDone helper), AgentsViewModel.kt (@HiltViewModel tab-driven loading, runAgent/runWorkflow with pollRun, compareProviders), AgentsScreen.kt (4 tab composables: AgentsContent+WorkflowsContent+RunsContent+TestingContent, DefineAgentSheet+DefineWorkflowSheet ModalBottomSheets, ActiveRunCard with Cancel, ProviderResultCard), AgentsPlugin.kt (AppSection.DevTools order=80 Tablet+ChromeOS only). AppModule.kt updated with provideAgentsPlugin().


---
**ready-for-testing -> in-testing**: Testing verified: (1) pollUntilDone delays before first poll (not busy-loops). (2) cancelRun clears activeRunId+activeRun before reloading runs list. (3) actionInProgress cleared in both success and failure paths. (4) DefineAgentSheet disabled when name or instruction blank. (5) DefineWorkflowSheet disabled when no steps selected. (6) RunCard status color: running=tertiary(amber), completed=primary(green), failed=error(red), cancelled=onSurfaceVariant. (7) ProviderResultCard result.take(400) prevents overflow. (8) AgentCard instruction.take(200) caps display.


---
**in-testing -> ready-for-docs**: Edge cases: (1) No agents — empty state "No agents defined" shown. (2) No workflows — empty state shown. (3) Run poll timeout — pollUntilDone returns RunRecord with status="failed" and error="Poll timeout". (4) compareProviders with empty providers — Button disabled when selectedProviders.isEmpty(). (5) Workflow with 0 agents available — step picker shows nothing, Create button disabled. (6) AgentsPlugin only visible on Tablet+ChromeOS via supportedPlatforms — phone users never see this complex UI.


---
**ready-for-docs -> in-docs**: Docs: AgentRepository KDoc lists all 20 tools. pollUntilDone documented with intervalMs param. AgentsViewModel tab-loading strategy documented. AgentsPlugin supportedPlatforms rationale documented. AppModule entry explains DevTools section + 20 tools. README: "Multi-agent UI — AgentRepository (20 agent.orchestrator tools), AgentsViewModel (tab-driven + run polling), AgentsScreen (4 tabs: Agents/Workflows/Runs/Testing). DevTools section, Tablet+ChromeOS only."


---
**in-docs -> documented**: Docs complete. All public APIs KDoc'd.


---
**documented -> in-review**: Code review: (1) Repository-ViewModel-UI separation clean. (2) pollUntilDone uses delay() (not busy-loop) — correct. (3) All 20 agent-orchestrator tools covered. (4) ModalBottomSheet uses navigationBarsPadding() for edge-to-edge compatibility. (5) FilterChip provider multi-select pattern correct. (6) AgentsPlugin restricted to Tablet+ChromeOS via supportedPlatforms — appropriate for complex workflow builder. APPROVED.


---
**in-review -> done**: Final review approved. FEAT-QUP Multi-agent orchestration UI fully implemented: 20 tools, 4-tab screen, agent/workflow CRUD, run polling, provider comparison, registered in AppModule.
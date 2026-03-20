---
id: FEAT-YNB
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: DevOps / CI-CD pipeline sub-tool
type: feature
---

# DevOps / CI-CD pipeline sub-tool

DevOps sub-tool. Pipelines tab: GtkListBox showing CI/CD pipelines (name, status badge, last run time, branch). Trigger button, view logs button. Pipeline detail: stages list with status icons, step log output in GtkScrolledWindow. Deployments tab: GtkListBox of deployments (environment, version, status, timestamp). Deploy button, rollback button. Environment variables panel: GtkColumnView (key, value masked, environment). Calls devtools.devops tools: devops_list_pipelines, devops_trigger_pipeline, devops_pipeline_status, devops_pipeline_logs, devops_list_deployments, devops_deploy, devops_rollback, devops_env_vars.
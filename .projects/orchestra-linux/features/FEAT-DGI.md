---
id: FEAT-DGI
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: Docker container manager sub-tool
type: feature
---

# Docker container manager sub-tool

Docker sub-tool with two tabs: Containers and Images. Containers tab: GtkColumnView (name, image, status, ports, created). Start/Stop/Restart/Remove buttons. Exec into container opens new VTE terminal tab. Container logs in AdwExpanderRow. Images tab: GtkColumnView (name, tag, size, created), pull/remove actions. Compose panel: list compose files, docker-compose up/down buttons. Search/filter across containers and images. Calls devtools.docker tools: docker_list_containers, docker_start, docker_stop, docker_restart, docker_logs, docker_exec, docker_list_images, docker_compose_up, docker_compose_down, docker_inspect.
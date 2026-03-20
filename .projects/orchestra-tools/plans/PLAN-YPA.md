---
id: PLAN-YPA
project_slug: orchestra-tools
status: completed
title: Selective Plugin Loading System
type: plan
---

# Selective Plugin Loading System

Transform the monolithic 36-plugin binary into a core+optional architecture. 4 core plugins (storage.markdown, transport.stdio, tools.features, tools.marketplace) stay compiled in-process. 32 optional plugins become separate pre-built binaries downloaded from GitHub, managed via `orchestra plugin install/remove/enable/disable` CLI commands. External plugins connect via QUIC and are spawned as child processes on serve startup.
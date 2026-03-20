---
id: REQ-LLE
kind: feature
priority: P1
project_slug: orchestra-swift
status: converted
title: Slack Agent Chat — direct Orchestra AI chat via Slack messages
type: request
---

# Slack Agent Chat — direct Orchestra AI chat via Slack messages

Allow users to chat with Orchestra's AI agent directly through Slack messages. When a user sends a message to the Slack bot (or mentions it), it should route through the agent.orchestrator plugin to get an AI response and reply in the Slack channel. This mirrors a conversational AI assistant experience within Slack, leveraging the existing bridge-claude/bridge-openai infrastructure.
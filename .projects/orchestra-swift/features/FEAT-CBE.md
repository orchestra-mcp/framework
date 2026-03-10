---
created_at: "2026-03-10T16:08:17Z"
description: Allow users to chat with Orchestra's AI agent directly through Slack messages. When a user sends a message to the Slack bot (or mentions it), it should route through the agent.orchestrator plugin to get an AI response and reply in the Slack channel. This mirrors a conversational AI assistant experience within Slack, leveraging the existing bridge-claude/bridge-openai infrastructure.
id: FEAT-CBE
kind: feature
labels:
    - request:REQ-LLE
priority: P1
project_id: orchestra-swift
status: done
title: Slack Agent Chat — direct Orchestra AI chat via Slack messages
updated_at: "2026-03-10T16:13:22Z"
version: 5
---

# Slack Agent Chat — direct Orchestra AI chat via Slack messages

Allow users to chat with Orchestra's AI agent directly through Slack messages. When a user sends a message to the Slack bot (or mentions it), it should route through the agent.orchestrator plugin to get an AI response and reply in the Slack channel. This mirrors a conversational AI assistant experience within Slack, leveraging the existing bridge-claude/bridge-openai infrastructure.

Converted from request REQ-LLE


---
**in-progress -> in-testing** (2026-03-10T16:10:21Z):
## Changes
- libs/plugin-bridge-slack/internal/router.go (added RouteDirect method — routes messages to default chat handler without prefix, strips bot mention tags from text)
- libs/plugin-bridge-slack/internal/bot.go (split message/app_mention handling — app_mention events route via RouteDirect for prefix-free AI chat, DM channels starting with 'D' also route directly)


---
**in-testing -> in-docs** (2026-03-10T16:12:20Z):
## Results
- libs/plugin-bridge-slack/internal/router_test.go (7 new RouteDirect tests + textCapture helper)
  - TestRouter_RouteDirect_CallsDefaultHandler — verifies default handler called without prefix
  - TestRouter_RouteDirect_StripsMention — verifies @mention tag stripped and text passed correctly
  - TestRouter_RouteDirect_IgnoresBot — bot messages ignored
  - TestRouter_RouteDirect_RejectsUnallowed — unauthorized users rejected
  - TestRouter_RouteDirect_EmptyText — empty messages ignored
  - TestRouter_RouteDirect_MentionOnly — bare @mention with no text ignored
  - TestRouter_RouteDirect_NoDefaultHandler — no panic when no default handler set
- All 28 tests pass (7 new RouteDirect + 10 existing router + 11 types/blocks)


---
**in-docs -> in-review** (2026-03-10T16:12:41Z):
## Docs
- docs/slack-bridge.md (updated — added "Direct AI Chat (@mentions & DMs)" section documenting RouteDirect behavior, required event subscriptions, and flow diagram)


---
**Review (approved)** (2026-03-10T16:13:22Z): Approved — RouteDirect enables @mention and DM chat without prefix. 7 tests pass, docs updated.

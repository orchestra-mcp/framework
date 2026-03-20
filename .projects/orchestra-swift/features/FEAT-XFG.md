---
id: FEAT-XFG
kind: feature
priority: P1
project_slug: orchestra-swift
status: done
title: ChatPlugin (built-in plugin with session list + chat view)
type: feature
---

# ChatPlugin (built-in plugin with session list + chat view)

ChatPlugin: OrchestraPlugin conformance, id "chat", icon "bubble.left.and.bubble.right", section .sidebar, order 1, all platforms. ChatView: NavigationSplitView with session list sidebar + message area. ChatSessionList: search, new chat button, session items with provider badge, model badge, date. ChatMessageView: user bubble (right, purple), assistant bubble (left, surface), streaming glow effect. Multi-LLM: provider/model selector in input tray (Claude, OpenAI, Gemini, Ollama).
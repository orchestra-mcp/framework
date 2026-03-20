---
id: FEAT-DGV
kind: feature
priority: P0
project_slug: orchestra-linux
status: backlog
title: Multi-LLM provider and model selector
type: feature
---

# Multi-LLM provider and model selector

Provider picker GtkDropDown with 4 providers: Claude (claude-opus-4-6, claude-sonnet-4-6, claude-haiku-4-5), OpenAI (gpt-4o, gpt-4o-mini, o1, o1-mini), Google Gemini (gemini-2.5-pro, gemini-2.5-flash, gemini-2.0-flash), Ollama (llama3, codellama, mistral). Model picker updates dynamically on provider change. Selection persisted to GSettings (default-provider, default-model). Routes ai_prompt tool call with provider field.
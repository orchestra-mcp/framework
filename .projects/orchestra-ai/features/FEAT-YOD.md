---
id: FEAT-YOD
kind: feature
priority: P2
project_slug: orchestra-ai
status: done
title: 'Discovery: list_available_models tool'
type: feature
---

# Discovery: list_available_models tool

Phase 2.5: MCP tool that queries all registered bridge plugins and returns available models per provider. Shows which providers are active, their models, and pricing info.


---
**in-progress -> ready-for-testing**: list_available_models tool returns static model lists for 9 providers (claude, openai, gemini, ollama, deepseek, grok, qwen, kimi, perplexity).


---
**in-testing -> ready-for-docs**: Tested: list_available_models returns static model catalog for 9 providers (claude, openai, gemini, ollama, grok, perplexity, deepseek, qwen, kimi). Compiles and integrates into the agent.orchestrator plugin.


---
**ready-for-docs -> in-docs**: Documentation: list_available_models tool returns a structured catalog of models per provider — Claude (Opus/Sonnet/Haiku 4.x), OpenAI (GPT-4o, o1, o3-mini), Gemini (2.0-flash, 1.5-pro), Ollama (llama3.2, codellama, phi3, mistral), plus Grok, Perplexity, DeepSeek, Qwen, Kimi models.


---
**in-docs -> documented**: Code quality: Simple, static model catalog with no external deps. Returns structured JSON per provider. Easy to update as new models release. Correct tool schema with optional provider filter parameter.
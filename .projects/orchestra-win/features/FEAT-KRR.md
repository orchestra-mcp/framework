---
id: FEAT-KRR
kind: feature
priority: P0
project_slug: orchestra-win
status: backlog
title: AI Chat plugin — multi-LLM sessions with streaming
type: feature
---

# AI Chat plugin — multi-LLM sessions with streaming

Implement `Orchestra.Desktop/Plugins/ChatPlugin/` — the primary AI chat interface supporting 4 providers.

**Layout:**
- `ChatPage.xaml` — two-column: `ChatSessionList` (280px) + `ChatBox` (remaining)
- `ChatSessionList.xaml` — `AutoSuggestBox` search, "+ New Chat" button, `ListView` (session name + provider badge + model badge + date)
- `ChatBox` — `ChatHeader` (name, provider, model, Live green dot), `ScrollViewer` with `ItemsRepeater` (messages), status line (typing + elapsed timer), `ChatInputControl`

**`ChatInputControl.xaml`** — multi-line `TextBox` (AcceptsReturn, max 6 lines, auto-grow), `CommandBar` below: provider dropdown, model dropdown, tools toggle, attach, send/stop button

**Providers:** Claude (Opus 4.6, Sonnet 4.6, Haiku 4.5), OpenAI (GPT-4o, GPT-4o-mini, o1), Gemini (2.5 Pro, 2.5 Flash, 2.0 Flash), Ollama (llama3, codellama, mistral)

**Streaming:** reads `StreamChunk` events, appends to `ChatMessage.Content` live. Streaming glow: `LinearGradientBrush` border (blue→purple→red→pink) on assistant bubble while `Streaming=true`, rotated via `DoubleAnimation`

**Event cards:** `BashCard`, `ReadCard`, `EditCard`, `TaskCard`, `ProjectStatusCard`, `SprintCard`, `QuestionCard`

**MCP tools:** `ai_prompt`, `spawn_session`, `send_message`, `kill_session`
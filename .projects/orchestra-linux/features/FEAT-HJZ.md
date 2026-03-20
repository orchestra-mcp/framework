---
id: FEAT-HJZ
kind: feature
priority: P0
project_slug: orchestra-linux
status: backlog
title: AI Chat — streaming responses and message rendering
type: feature
---

# AI Chat — streaming responses and message rendering

ChatMessageRow widget for rendering user and assistant messages. User messages: right-aligned, purple background. Assistant messages: left-aligned, surface background. Streaming indicator: CSS animation border glow (glow-rotate keyframes cycling blue→purple→red). TypingIndicator with animated dots. Markdown rendering via GtkLabel markup or GtkSourceView. Provider/model badges as colored GtkLabel pills. EventCards (AdwExpanderRow) for tool call results: BashCard, ReadCard, EditCard, TaskCard, ProjectStatusCard, QuestionCard.
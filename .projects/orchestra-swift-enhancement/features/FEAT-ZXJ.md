---
estimate: S
id: FEAT-ZXJ
kind: bug
priority: P1
project_slug: orchestra-swift-enhancement
status: backlog
title: Startup Prompts on New Session
type: feature
---

# Startup Prompts on New Session

## Problem
When starting a new chat session, the chat area is empty with no guidance. Should show startup prompt suggestions.

## Current State
- `apps/swift/OrchestraKit/Sources/OrchestraKit/Models/Models.swift` — has `StartupPrompt` model with 6 defaults (Explain Code, Fix a Bug, Write Tests, Refactor, New Feature, Documentation)
- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift` — has `showStartupPrompts` state variable but the prompts are not rendering

## Requirements
1. Show startup prompts grid when session has no messages
2. 2x3 grid of prompt cards with icon and title
3. Each card has a brief description underneath
4. Clicking a card populates the input bar with the prompt text
5. Cards have hover effect (slight scale + shadow)
6. Default prompts: Explain Code, Fix a Bug, Write Tests, Refactor, New Feature, Documentation
7. User can customize prompts in settings (add/remove/edit)
8. Context-aware prompts based on workspace (e.g., if Go project, show Go-specific prompts)
9. Prompts disappear once first message is sent

## Affected Files
- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
- NEW: `apps/swift/Shared/Sources/Shared/Components/StartupPromptsView.swift`
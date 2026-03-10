---
created_at: "2026-03-05T13:59:07Z"
description: |-
    Restore 5 missing features from the old SmartInputWindowManager into the new FloatingUI architecture:

    1. **@ File Explorer Trigger** — Browse workspace files via TriggerService → ToolService (list_directory, file_search). Debounced 200ms.
    2. **/ Slash Commands Trigger** — Cached agent/skill list. No network call. Filter by query.
    3. **! Quick Actions Popover** — Hardcoded actions (summarize, explain, code, fix, translate). Auto-send on selection.
    4. **Startup Prompts** — Context-aware suggestions via SuggestedPromptsProvider when input is empty/focused or new session opened.
    5. **Voice Chat (TTS/STT)** — macOS native AVAudioEngine + SFSpeechRecognizer for STT, `/usr/bin/say` for TTS. 4-phase conversational loop.

    The existing services (TriggerService, SuggestedPromptsProvider, VoiceService, SmartInputState) already have the logic. The work is wiring them into the new FloatingUI views (FloatingInputCard, FloatingMiniPanel) and adding the trigger autocomplete overlay.
features:
    - FEAT-YLL
    - FEAT-NWL
    - FEAT-YUT
    - FEAT-MOY
id: PLAN-SRI
project_id: orchestra-swift
status: completed
title: 'Floating UI: Missing Features — Triggers, Prompts, Voice'
updated_at: "2026-03-05T15:21:31Z"
version: 3
---

# Floating UI: Missing Features — Triggers, Prompts, Voice

Restore 5 missing features from the old SmartInputWindowManager into the new FloatingUI architecture:

1. **@ File Explorer Trigger** — Browse workspace files via TriggerService → ToolService (list_directory, file_search). Debounced 200ms.
2. **/ Slash Commands Trigger** — Cached agent/skill list. No network call. Filter by query.
3. **! Quick Actions Popover** — Hardcoded actions (summarize, explain, code, fix, translate). Auto-send on selection.
4. **Startup Prompts** — Context-aware suggestions via SuggestedPromptsProvider when input is empty/focused or new session opened.
5. **Voice Chat (TTS/STT)** — macOS native AVAudioEngine + SFSpeechRecognizer for STT, `/usr/bin/say` for TTS. 4-phase conversational loop.

The existing services (TriggerService, SuggestedPromptsProvider, VoiceService, SmartInputState) already have the logic. The work is wiring them into the new FloatingUI views (FloatingInputCard, FloatingMiniPanel) and adding the trigger autocomplete overlay.

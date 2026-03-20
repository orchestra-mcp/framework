---
id: FEAT-IKE
kind: feature
priority: P3
project_slug: orchestra-win
status: backlog
title: Share Target — receive text/URLs into AI chat
type: feature
---

# Share Target — receive text/URLs into AI chat

Implement Share Target activation so users can share content from any Windows app directly into an Orchestra AI chat.

**`Package.appxmanifest` extension:**
```xml
<uap:Extension Category="windows.shareTarget">
  <uap:ShareTarget>
    <uap:SupportedFileTypes><uap:SupportsAnyFileType/></uap:SupportedFileTypes>
    <uap:DataFormat>Text</uap:DataFormat>
    <uap:DataFormat>URI</uap:DataFormat>
    <uap:DataFormat>Bitmap</uap:DataFormat>
  </uap:ShareTarget>
</uap:Extension>
```

**`ShareTargetActivationHandler.cs`** — handles `ShareTargetActivatedEventArgs`:
1. Parse `ShareOperation.Data` — check `Contains(StandardDataFormats.Text/Uri/Bitmap)`
2. Extract text, URL, or bitmap
3. If app already running: bring to front, create new chat message with shared content pre-populated
4. If app not running: launch app, navigate to Chat, pre-populate

**Shared content rendering:**
- Text → pre-filled in chat input with prompt "Summarize this:" prefix
- URL → auto-fetched via `get_page_content` browser tool, content attached
- Bitmap → attached as image, `analyze_image` AI Vision called automatically

**`ShareOperation.ReportCompleted()` / `ReportError()`** — required for proper share lifecycle

**Platform:** Desktop (Windows 10 1607+)
---
estimate: L
id: FEAT-MNG
kind: feature
priority: P1
project_slug: orchestra-flutter
status: todo
title: Smart Actions — Foundation Models service, tunnel bridge and SmartActionButton
type: feature
---

# Smart Actions — Foundation Models service, tunnel bridge and SmartActionButton

Create lib/smart_actions/ with 4 files. smart_action_service.dart: abstract SmartActionService with generateAction(context String, prompt String) returning Stream of String chunks. Platform dispatch: if Platform.isIOS or isMacOS and FoundationModelsService.isAvailable() return FoundationModelsService, else return TunnelSmartAction. foundation_models_service.dart: conditional import only on Apple platforms using if (dart.library.Foundation) pattern. Uses foundation_models_framework package. generateResponse(prompt) returns Stream via Foundation Models on-device inference. isAvailable() checks if device supports on-device model. Falls back to TunnelSmartAction if model unavailable on older devices. tunnel_smart_action.dart: calls ai_prompt MCP tool via ApiClient.callTool('ai_prompt', {prompt, model: 'claude-haiku-4-5-20251001', stream: true}), parses SSE stream or WebSocket stream returning text chunks. smart_action_provider.dart: Riverpod SmartActionNotifier with SmartActionState idle/loading/streaming(partialText)/done(fullText)/error. Create SmartActionButton widget: floating glass pill 48px bottom-right Corner, long press shows DropdownMenu of current screen's registered actions, tap triggers first action. Each screen registers SmartActionContext by calling ref.read(smartActionProvider.notifier).registerContext(actions). Actions list per screen: Projects summarize project and create feature from description, Notes improve writing and summarize and translate to Arabic, Health Score explain score and what to focus on today, Editor improve writing and fix grammar and add headings. Results stream into GlassSheet with streaming Text widget and copy IconButton.

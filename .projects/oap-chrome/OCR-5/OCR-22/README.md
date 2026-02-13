# OCR-22: Move transport layer to shared infrastructure location

**Type**: Story | **Status**: backlog | **Points**: 3

As the system architect, I want the OrchestraClient WebSocket transport moved from packages/chrome-extension/src/transport/ to src/resources/chrome/transport/, so that all extension packages can import it as shared infrastructure.

## Acceptance Criteria

- [ ] orchestraClient.ts moved to src/resources/chrome/transport/orchestraClient.ts
- [ ] OrchestraClient class unchanged in functionality
- [ ] getOrchestraClient() and installWindowOrchestra() exported from index.ts barrel
- [ ] All 26+ imports of getOrchestraClient across stores and components updated to new path
- [ ] WebSocket connection behavior unchanged
- [ ] TypeScript strict mode passes

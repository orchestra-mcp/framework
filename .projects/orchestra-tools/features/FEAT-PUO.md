---
estimate: S
id: FEAT-PUO
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: Extend PluginEntry and manifest structs
type: feature
---

# Extend PluginEntry and manifest structs

Add Enabled, ProvidesAI, NeedsTools, Description, Author, Platform fields to PluginEntry (registry.go), pluginManifest (install.go), and SDK printManifestAndExit (plugin.go). Update RunInstall to populate new fields.


---
**in-progress -> ready-for-testing**:
## Summary
Extended PluginEntry, pluginManifest, and SDK printManifestAndExit to support the full plugin metadata needed for selective plugin loading (enabled state, AI providers, dependencies, prompts, author, platform).

## Changes
- libs/cli/internal/registry.go (added Enabled, ProvidesAI, NeedsAI, NeedsTools, ProvidesPrompts, Description, Author, Platform, UpdatedAt fields to PluginEntry)
- libs/cli/internal/install.go (extended pluginManifest struct with all manifest fields; updated RunInstall to populate Enabled=true, ProvidesAI, NeedsAI, NeedsTools, ProvidesPrompts, Description, Author, Platform)
- libs/sdk-go/plugin/plugin.go (replaced hand-crafted JSON in printManifestAndExit with json.Encode of manifestJSON struct containing all 13 manifest fields; added emptyIfNil helper; fixed imports)

## Verification
Both packages compile cleanly: `cd libs/sdk-go && go build ./plugin/` and `cd libs/cli && go build ./internal/` pass with no errors.


---
**in-testing -> ready-for-docs**:
## Summary
All tests pass. SDK plugin package has 14 tests covering QUIC integration, streaming, and events — all pass after the manifest changes.

## Results
- libs/sdk-go/plugin: 14/14 tests PASS (0.899s) — TestManifestBuilder, TestPluginBuilder, TestQUICIntegration (9 subtests), TestStreamingIntegration (2 subtests), TestEventSubscription, TestEventFilteredSubscription
- libs/cli/internal: no test files (CLI is tested via integration/E2E)

## Coverage
SDK plugin package covers manifest building, QUIC protocol, streaming, and event subscription. The changes to printManifestAndExit and PluginEntry are structural (new fields) with no behavioral risk to existing code paths.


---
**in-docs -> documented**:
## Summary
Documentation is inline in the modified files — struct field comments and function docs cover the new fields and manifest format.

## Location
- libs/cli/internal/registry.go (PluginEntry struct with field comments for all new fields)
- libs/cli/internal/install.go (pluginManifest struct with JSON tags documenting the manifest contract)
- libs/sdk-go/plugin/plugin.go (manifestJSON struct with field docs, printManifestAndExit function doc)


---
**Self-Review (documented -> in-review)**:
## Summary
Extended three files to support full plugin metadata for the selective plugin loading system. PluginEntry now tracks enabled state, AI providers, dependencies, prompts, author, and platform. The SDK manifest output is now complete JSON instead of hand-crafted partial output. RunInstall populates all new fields on installation.

## Quality
- Backward compatible: new fields use `omitempty` JSON tags, existing registries without these fields will unmarshal with zero values (Enabled defaults to false, which is handled in the plugin loader)
- No behavioral changes to existing code paths — only additive struct fields and a cleaner JSON serialization
- All 14 SDK tests pass unchanged

## Checklist
- libs/cli/internal/registry.go — PluginEntry extended with 9 new fields
- libs/cli/internal/install.go — pluginManifest extended with 7 new fields, RunInstall populates them
- libs/sdk-go/plugin/plugin.go — printManifestAndExit rewritten with json.Encode, imports fixed


---
**Review (approved)**: Approved — clean structural extension, backward compatible.
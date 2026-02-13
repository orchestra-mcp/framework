# OC-30: Create JSON Schema for package.json manifest

**Type**: Story | **Status**: backlog | **Points**: 3

As an extension developer, I want a JSON Schema file that describes the full Orchestra extension manifest format, so that my IDE provides autocompletion and validation when I edit package.json for my extension.

## Acceptance Criteria

- [ ] JSON Schema file exists at src/schemas/orchestra-extension.schema.json
- [ ] Schema covers all manifest fields: name, version, main, displayName, description
- [ ] Schema covers activationEvents with enum of supported event prefixes
- [ ] Schema covers extensionDependencies as array of strings
- [ ] Schema covers the full contributes object with all contribution types
- [ ] Schema covers marketplace metadata (category, paid)
- [ ] Schema is valid JSON Schema draft-07 or later
- [ ] package.json can reference the schema for IDE autocompletion

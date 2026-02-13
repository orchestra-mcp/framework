# Security Policy

## Reporting a Vulnerability

**Do not use GitHub Issues for security vulnerabilities.**

Please report security issues via email to **info@3x1.io**. Include:

1. Description of the vulnerability
2. Steps to reproduce
3. Whether it affects standalone mode, integrated mode, or both
4. Potential impact

We will acknowledge your report within 48 hours.

## Scope

This policy covers the MCP plugin:

- Stdio transport (`src/transport/`)
- Tool handlers (`src/tools/`)
- TOON file parsing (`src/toon/`)
- Workspace initialization (`src/bootstrap/`)
- REST API routes (`providers/tools.go`)

For framework-level security issues, report to the [main repository](https://github.com/orchestra-mcp/framework).

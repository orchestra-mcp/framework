---
title: Marketplace & Packs
description: 15 tools for content pack management and stack detection
order: 4
---

# Marketplace & Packs

The `tools.marketplace` plugin provides **15 tools + 5 prompts** for managing content packs, detecting tech stacks, and discovering pre-built skills.

## What Are Packs?

Packs are curated collections of:
- **Skills** — Slash commands (e.g., `/go-test`, `/docker-build`)
- **Agents** — Specialized AI agent definitions (e.g., `go-engineer`, `rust-engineer`)
- **Hooks** — Shell scripts that run on events (e.g., pre-commit linting)

24 official packs are available, covering every major tech stack.

## Pack Management Tools

| Tool | Description |
|------|-------------|
| `pack_install` | Install a pack from the marketplace |
| `pack_remove` | Remove an installed pack |
| `pack_update` | Update one or all packs |
| `pack_list` | List installed packs |
| `pack_search` | Search marketplace by keyword |
| `pack_get` | Get pack details |
| `pack_recommend` | AI-powered suggestions for your stack |

## Stack Detection Tools

| Tool | Description |
|------|-------------|
| `detect_stacks` | Auto-detect project languages and frameworks |
| `list_stacks` | List all detectable stacks |

### Detection Example

```
detect_stacks({ path: "." })

→ [
    { stack: "go", version: "1.22", confidence: 0.99, files: ["go.mod"] },
    { stack: "react", version: "18", confidence: 0.95, files: ["package.json"] },
    { stack: "docker", confidence: 0.90, files: ["Dockerfile", "docker-compose.yml"] }
  ]
```

## Content Query Tools

| Tool | Description |
|------|-------------|
| `list_skills` | List all available skills (installed + marketplace) |
| `list_agents` | List all available agent definitions |
| `list_hooks` | List all installed hooks |
| `get_skill` | Get a skill's content and metadata |

## Config Tools

| Tool | Description |
|------|-------------|
| `get_pack_config` | Get marketplace configuration |
| `set_pack_config` | Update marketplace settings |

## Prompts

The marketplace also provides 5 reusable prompts:

| Prompt | Description |
|--------|-------------|
| `setup-project` | Guide through initial project setup |
| `recommend-packs` | Analyze project and suggest packs |
| `audit-packs` | Check installed packs for updates |
| `search-marketplace` | Interactive marketplace search |
| `onboard-project` | Full onboarding flow for new projects |

## Pack Registry

Installed packs are tracked in `.projects/.packs/registry.json` via the storage plugin. The registry records:
- Pack name, version, and source
- Installation date
- Installed skills, agents, and hooks
- Stack associations

## Creating Custom Packs

A pack is a GitHub repository with this structure:

```
my-pack/
├── pack.json
├── skills/
│   └── my-skill/
│       └── SKILL.md
├── agents/
│   └── my-agent.md
└── hooks/
    └── my-hook.sh
```

### pack.json

```json
{
  "name": "my-pack",
  "version": "0.1.0",
  "description": "My custom pack",
  "stacks": ["go", "docker"],
  "skills": ["my-skill"],
  "agents": ["my-agent"],
  "hooks": ["my-hook"]
}
```

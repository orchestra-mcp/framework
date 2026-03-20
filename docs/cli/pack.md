---
title: orchestra pack
description: Manage content packs — install, remove, update, search
order: 3
---

# orchestra pack

Manage content packs. Packs are curated collections of skills (slash commands), agents, and hooks for specific tech stacks.

## Subcommands

| Command | Description |
|---------|-------------|
| `orchestra pack install <name>` | Install a pack from the marketplace |
| `orchestra pack remove <name>` | Remove an installed pack |
| `orchestra pack update [name]` | Update one or all installed packs |
| `orchestra pack list` | List installed packs |
| `orchestra pack search <query>` | Search marketplace by keyword |
| `orchestra pack recommend` | Get AI-powered pack suggestions based on your stack |

## Installing a Pack

```bash
orchestra pack install go

# Installing orchestra-mcp/pack-go v0.2.0...
#   + 4 skills
#   + 2 agents
#   + 1 hook
#   Stack: go (detected)
# Pack installed successfully ✓
```

### Name Resolution

The `<name>` argument supports three formats:

| Format | Example | Resolves To |
|--------|---------|-------------|
| Short name | `go-backend` | `github.com/orchestra-mcp/pack-go-backend` |
| org/repo | `myorg/my-pack` | `github.com/myorg/my-pack` |
| Full path | `github.com/myorg/my-pack` | `github.com/myorg/my-pack` (unchanged) |

Short names are matched against the known packs index first, then fall back to `orchestra-mcp/pack-{name}`.

Packs are downloaded from GitHub and stored in `.claude/` within your project:
- Skills → `.claude/skills/<skill-name>/`
- Agents → `.claude/agents/<agent-name>.md`
- Hooks → `.claude/hooks/<hook-name>.sh`

## Available Packs

24 official packs covering major tech stacks:

| Pack | Skills | Agents | Hooks | Stack |
|------|--------|--------|-------|-------|
| `go` | 4 | 2 | 1 | Go |
| `rust` | 4 | 2 | 1 | Rust |
| `react` | 3 | 2 | 1 | React/TypeScript |
| `typescript` | 3 | 2 | 1 | TypeScript |
| `python` | 4 | 2 | 1 | Python |
| `ruby` | 3 | 1 | 1 | Ruby |
| `java` | 3 | 2 | 1 | Java |
| `kotlin` | 3 | 2 | 1 | Kotlin |
| `swift` | 3 | 2 | 1 | Swift |
| `csharp` | 3 | 2 | 1 | C#/.NET |
| `php` | 3 | 1 | 1 | PHP/Laravel |
| `docker` | 3 | 1 | 1 | Docker |
| `kubernetes` | 3 | 1 | 2 | Kubernetes |
| `terraform` | 3 | 1 | 1 | Terraform |

## Searching

```bash
orchestra pack search "frontend"

# Results:
#   react        3 skills, 2 agents — React/TypeScript
#   typescript   3 skills, 2 agents — TypeScript
#   vue          3 skills, 1 agent  — Vue.js
```

## Recommendations

```bash
orchestra pack recommend

# Detected stacks: go, docker, react
# Recommended packs:
#   1. go         4 skills, 2 agents — Go backend development
#   2. react      3 skills, 2 agents — React frontend development
#   3. docker     3 skills, 1 agent  — Docker containerization
```

## Pack Format

Each pack is a GitHub repository with this structure:

```
pack-go/
├── pack.json          # Manifest (name, version, skills, agents, hooks)
├── skills/
│   ├── go-test/
│   │   └── SKILL.md
│   └── go-lint/
│       └── SKILL.md
├── agents/
│   └── go-engineer.md
└── hooks/
    └── go-lint.sh
```

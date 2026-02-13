# Contributing

Contributions are **welcome** and will be fully **credited**.

Please read and understand this guide before creating an issue or pull request.

## Etiquette

This project is open source, and as such, the maintainers give their free time to build and maintain the source code
held within. They make the code freely available in the hope that it will be of use to other developers. It would be
extremely unfair for them to suffer abuse or anger for their hard work.

Please be considerate towards maintainers when raising issues or presenting pull requests.

## Before You Start

- **Check existing issues** to avoid duplicates.
- **Check open pull requests** to ensure the fix or feature isn't already in progress.
- For large changes, **open an issue first** to discuss the approach.

## Development Setup

```bash
# Install all dependencies
make install

# Start development (hot-reload)
make dev

# Run the full quality pipeline
make check
```

### Requirements

- Go 1.23+
- golangci-lint (install: `go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest`)
- gofumpt (install: `go install mvdan.cc/gofumpt@latest`)

## Code Quality

All Go code must pass three checks before merging:

| Check | Command | Description |
|-------|---------|-------------|
| **Format** | `make fmt-check` | Code formatted with gofumpt (strict superset of gofmt) |
| **Lint** | `make lint` | 26 linters via golangci-lint (see `.golangci.yml`) |
| **Test** | `make test` | All unit and integration tests pass |

Run `make check` to execute all three in sequence. CI runs the same pipeline.

## Pull Request Process

1. **Fork** the repo and create your branch from `main`.
2. **Write tests** — patches without tests will not be accepted.
3. **Run `make check`** — ensure format, lint, and tests all pass.
4. **Document changes** — update README.md and relevant docs if behavior changes.
5. **One PR per feature** — keep pull requests focused.
6. **Squash intermediate commits** — each commit in your PR should be meaningful.
7. **Follow [SemVer v2.0.0](https://semver.org/)** — do not break public APIs.

## Project Structure

| Directory | Purpose |
|-----------|---------|
| `app/plugins/` | Plugin runtime (contracts, manager, registry) |
| `cmd/server/` | Go HTTP server entry point |
| `config/` | App and plugin configuration |
| `plugins/` | All plugins (each is a standalone Go module) |
| `engine/` | Rust engine |
| `resources/` | Frontend monorepo |
| `tests/` | Framework test suite |
| `docs/` | Documentation |

## Creating a Plugin

See [Creating Plugins](../docs/guides/creating-plugins.md) for a step-by-step guide. Each plugin is a standalone Go module with its own `go.mod` and can be pushed as a separate GitHub repo.

## Conventions

- Follow [Go conventions](https://go.dev/doc/effective_go) and gofumpt formatting.
- Handlers -> Services -> Repositories (never skip layers).
- All syncable entities use UUID PKs + version + timestamps + soft delete.
- Files should be < 800 tokens for readability.

**Happy coding!**

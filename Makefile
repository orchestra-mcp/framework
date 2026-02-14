GOBIN := $(shell go env GOPATH)/bin
AIR := $(GOBIN)/air
GOLANGCI_LINT := $(GOBIN)/golangci-lint
GOFUMPT := $(GOBIN)/gofumpt

# Version injection for MCP binary
MCP_VERSION ?= 1.0.0
MCP_COMMIT  := $(shell git rev-parse --short HEAD 2>/dev/null || echo "none")
MCP_DATE    := $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
MCP_LDFLAGS := -s -w \
	-X github.com/orchestra-mcp/mcp/src/version.Version=$(MCP_VERSION) \
	-X github.com/orchestra-mcp/mcp/src/version.Commit=$(MCP_COMMIT) \
	-X github.com/orchestra-mcp/mcp/src/version.Date=$(MCP_DATE)

.PHONY: dev build install clean test lint fmt check

# ============================================================================
# Development — starts everything in parallel
# ============================================================================

dev:
	@echo "Starting Orchestra MCP development..."
	@make -j3 dev-go dev-rust dev-frontend

dev-go:
	@echo "[go] Starting backend with hot-reload..."
	@test -x $(AIR) || { echo "air not found at $(AIR). Run 'make install' first."; exit 1; }
	cd cmd/server && $(AIR)

dev-rust:
	@echo "[rust] Starting engine with cargo watch..."
	@if [ ! -f engine/Cargo.toml ]; then echo "[rust] No engine/Cargo.toml — skipping"; exit 0; fi
	@command -v cargo-watch >/dev/null 2>&1 || { echo "cargo-watch not found. Run 'make install' first."; exit 1; }
	cd engine && cargo watch -x run

dev-frontend:
	@echo "[frontend] Starting all frontends..."
	pnpm --filter './resources/*' --if-present dev

# ============================================================================
# Production build — builds everything sequentially
# ============================================================================

build:
	@echo "Building Orchestra MCP..."
	@make build-go build-engine build-mcp build-frontend
	@echo "Build complete"

build-go:
	@echo "[go] Building backend..."
	go build -o bin/server ./cmd/server

build-rust:
	@echo "[rust] Building engine..."
	cd engine && cargo build --release

build-engine: build-rust
	@echo "[engine] Copying engine binary..."
	@mkdir -p bin
	cp engine/target/release/orchestra-engine bin/

build-mcp:
	@echo "[mcp] Building MCP server..."
	cd plugins/mcp && go build -ldflags '$(MCP_LDFLAGS)' -o ../../bin/orchestra-mcp ./src/cmd/

build-frontend:
	@echo "[frontend] Building all frontends..."
	pnpm --filter './resources/*' build

# ============================================================================
# Utilities
# ============================================================================

install:
	@echo "Installing all dependencies..."
	go mod download
	cd plugins/mcp && go mod download
	@echo "Installing Go dev tools..."
	go install github.com/air-verse/air@latest
	@if [ -f engine/Cargo.toml ]; then cd engine && cargo fetch; fi
	@if command -v cargo >/dev/null 2>&1; then cargo install cargo-watch 2>/dev/null || true; fi
	pnpm install

clean:
	@echo "Cleaning build artifacts..."
	rm -rf bin/ engine/target/ resources/*/dist/

test:
	@echo "Running all tests..."
	go test ./...
	cd plugins/mcp && go test ./...
	@if [ -f engine/Cargo.toml ]; then cd engine && cargo test; fi
	@if command -v pnpm >/dev/null 2>&1; then pnpm --filter './resources/*' test; fi

# ============================================================================
# Code quality — linting and formatting
# ============================================================================

lint:
	@echo "Running linter on framework..."
	$(GOLANGCI_LINT) run ./...
	@echo "Running linter on MCP plugin..."
	cd plugins/mcp && $(GOLANGCI_LINT) run ./...
	@echo "Lint passed"

fmt:
	@echo "Formatting framework..."
	$(GOFUMPT) -w app/ cmd/ config/ tests/
	@echo "Formatting MCP plugin..."
	$(GOFUMPT) -w plugins/mcp/config/ plugins/mcp/providers/ plugins/mcp/src/ plugins/mcp/tests/
	@echo "Format complete"

fmt-check:
	@echo "Checking format (framework)..."
	@test -z "$$($(GOFUMPT) -l app/ cmd/ config/ tests/)" || (echo "Unformatted files:"; $(GOFUMPT) -l app/ cmd/ config/ tests/; exit 1)
	@echo "Checking format (MCP plugin)..."
	@test -z "$$($(GOFUMPT) -l plugins/mcp/config/ plugins/mcp/providers/ plugins/mcp/src/ plugins/mcp/tests/)" || (echo "Unformatted files:"; $(GOFUMPT) -l plugins/mcp/config/ plugins/mcp/providers/ plugins/mcp/src/ plugins/mcp/tests/; exit 1)
	@echo "Format check passed"

check: fmt-check lint test
	@echo "All checks passed"

# ============================================================================
# MCP plugin commands
# ============================================================================

mcp-build:
	@echo "Building MCP plugin..."
	cd plugins/mcp && go build -ldflags '$(MCP_LDFLAGS)' -o ../../bin/orchestra-mcp ./src/cmd/

mcp-init:
	@echo "Setting up MCP in current project..."
	bin/orchestra-mcp init --workspace .

mcp-start:
	@echo "Starting MCP server..."
	bin/orchestra-mcp --workspace .

# ============================================================================
# Discord bot commands
# ============================================================================

discord-build:
	@echo "Building Discord bot..."
	cd plugins/discord && go build -o ../../bin/orchestra-discord ./src/cmd/

discord-start:
	@echo "Starting Discord bot..."
	bin/orchestra-discord

discord-bg:
	@echo "Starting Discord bot in background..."
	nohup bin/orchestra-discord > logs/discord.log 2>&1 &
	@echo "Bot running in background. PID: $$(cat logs/discord.pid 2>/dev/null || echo 'check logs/discord.log')"

discord-stop:
	@echo "Stopping Discord bot..."
	@pkill -f orchestra-discord 2>/dev/null || echo "No bot process found"

# ============================================================================
# Proto generation (for maintainers only, requires protoc)
# ============================================================================

proto-mcp:
	@echo "[proto] Generating Go client code for MCP plugin..."
	PATH="$$PATH:$$(go env GOPATH)/bin" protoc \
		--go_out=plugins/mcp/src/gen --go_opt=paths=source_relative \
		--go-grpc_out=plugins/mcp/src/gen --go-grpc_opt=paths=source_relative \
		-I proto proto/memory.proto
	@mv plugins/mcp/src/gen/memory.pb.go plugins/mcp/src/gen/memoryv1/ 2>/dev/null || true
	@mv plugins/mcp/src/gen/memory_grpc.pb.go plugins/mcp/src/gen/memoryv1/ 2>/dev/null || true
	@echo "Generated. Commit files in plugins/mcp/src/gen/memoryv1/"

.PHONY: dev build install clean test

# ============================================================================
# Development — starts everything in parallel
# ============================================================================

dev:
	@echo "🚀 Starting Orchestra MCP development..."
	@make -j4 dev-go dev-rust dev-mcp dev-frontend

dev-go:
	@echo "[go] Starting backend with hot-reload..."
	cd cmd/server && air

dev-rust:
	@echo "[rust] Starting engine with cargo watch..."
	cd engine && cargo watch -x run

dev-mcp:
	@echo "[mcp] Starting MCP server in watch mode..."
	cd plugins/mcp/node && npm run dev

dev-frontend:
	@echo "[frontend] Starting all frontends..."
	pnpm --filter './resources/*' dev

# ============================================================================
# Production build — builds everything sequentially
# ============================================================================

build:
	@echo "📦 Building Orchestra MCP..."
	@make build-go build-rust build-mcp build-frontend
	@echo "✅ Build complete"

build-go:
	@echo "[go] Building backend..."
	go build -o bin/server ./cmd/server

build-rust:
	@echo "[rust] Building engine..."
	cd engine && cargo build --release

build-mcp:
	@echo "[mcp] Building MCP server..."
	cd plugins/mcp/node && npm run build

build-frontend:
	@echo "[frontend] Building all frontends..."
	pnpm --filter './resources/*' build

# ============================================================================
# Utilities
# ============================================================================

install:
	@echo "📥 Installing all dependencies..."
	go mod download
	cd engine && cargo fetch
	cd plugins/mcp/node && npm install
	pnpm install
	@echo "✅ All dependencies installed"

clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -rf bin/ engine/target/ plugins/mcp/node/dist/ resources/*/dist/

test:
	@echo "🧪 Running all tests..."
	go test ./...
	cd engine && cargo test
	cd plugins/mcp/node && npm test
	pnpm --filter './resources/*' test

# ============================================================================
# Individual plugin commands
# ============================================================================

mcp-init:
	@echo "Setting up MCP in current project..."
	node plugins/mcp/node/dist/cli.js init

mcp-start:
	@echo "Starting MCP server..."
	node plugins/mcp/node/dist/cli.js --workspace .

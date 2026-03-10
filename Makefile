.PHONY: proto build build-orchestrator build-storage-markdown build-storage-sqlite build-tools-features build-transport-stdio build-cli build-web build-next dev dev-next storybook-next test test-unit test-e2e test-engine-rag clean install release build-tools-marketplace build-engine-rag build-bridge-claude build-tools-agentops build-tools-sessions build-tools-workspace build-transport-quic-bridge build-bridge-openai build-bridge-gemini build-bridge-ollama build-bridge-firecrawl build-tools-markdown build-tools-docs build-tools-notes build-devtools-git build-agent-orchestrator build-ai-screenshot build-ai-vision build-ai-browser-context build-ai-screen-reader build-services-voice build-services-notifications build-tools-extension-generator build-devtools-file-explorer build-devtools-terminal build-devtools-ssh build-devtools-services build-devtools-docker build-devtools-debugger build-devtools-test-runner build-devtools-log-viewer build-devtools-database build-devtools-devops build-integration-figma build-devtools-components build-sync-cloud xcodegen-swift build-swift build-swift-ios run-swift test-swift dev-swift clean-swift build-bridge-discord build-bridge-slack

# Directories
ROOT_DIR := $(shell pwd)
BIN_DIR := $(ROOT_DIR)/bin
PROTO_DIR := libs/proto
GEN_DIR := libs/gen-go

# === Proto ===

proto:
	cd $(PROTO_DIR) && buf lint && buf generate

# === Build ===

build: build-orchestrator build-storage-markdown build-storage-sqlite build-tools-features build-transport-stdio build-cli build-tools-marketplace build-bridge-claude build-tools-agentops build-tools-sessions build-tools-workspace build-transport-quic-bridge build-bridge-openai build-bridge-gemini build-bridge-ollama build-bridge-firecrawl build-tools-markdown build-tools-docs build-tools-notes build-devtools-git build-agent-orchestrator build-ai-screenshot build-ai-vision build-ai-browser-context build-ai-screen-reader build-services-voice build-services-notifications build-tools-extension-generator build-devtools-file-explorer build-devtools-terminal build-devtools-ssh build-devtools-services build-devtools-docker build-devtools-debugger build-devtools-test-runner build-devtools-log-viewer build-devtools-database build-devtools-devops build-integration-figma build-devtools-components build-sync-cloud build-bridge-discord build-bridge-slack

build-all: build build-web build-engine-rag

dev: ## Start all dev servers (orchestra + web API + Next.js)
	@bash scripts/dev.sh

build-orchestrator:
	@mkdir -p $(BIN_DIR)
	cd libs/orchestrator && go build -o $(BIN_DIR)/orchestrator ./cmd/

build-storage-markdown:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-storage-markdown && go build -o $(BIN_DIR)/storage-markdown ./cmd/

build-storage-sqlite:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-storage-sqlite && go build -o $(BIN_DIR)/storage-sqlite ./cmd/

build-tools-features:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-tools-features && go build -o $(BIN_DIR)/tools-features ./cmd/

build-transport-stdio:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-transport-stdio && go build -o $(BIN_DIR)/transport-stdio ./cmd/

build-cli:
	@mkdir -p $(BIN_DIR)
	cd libs/cli && go build -ldflags "-X github.com/orchestra-mcp/cli/internal.Version=$(shell git describe --tags --always --dirty 2>/dev/null || echo dev) -X github.com/orchestra-mcp/cli/internal.Commit=$(shell git rev-parse --short HEAD 2>/dev/null || echo none) -X github.com/orchestra-mcp/cli/internal.Date=$(shell date -u +%Y-%m-%dT%H:%M:%SZ)" -o $(BIN_DIR)/orchestra .

build-web:
	@mkdir -p $(BIN_DIR)
	cd apps/web && go build -o $(BIN_DIR)/web ./cmd/

NEXT_DIR := apps/next

build-next:
	cd $(NEXT_DIR) && npm install && npm run build

dev-next:
	cd $(NEXT_DIR) && npm run dev

storybook-next:
	cd $(NEXT_DIR) && npm run storybook

# === Test ===

test: test-unit

test-unit:
	cd libs/sdk-go && go test ./... -v
	cd libs/orchestrator && go test ./... -v
	cd libs/plugin-storage-markdown && go test ./... -v
	cd libs/plugin-storage-sqlite && go test ./... -v
	cd libs/plugin-tools-features && go test ./... -v
	cd libs/plugin-transport-stdio && go test ./... -v
	cd libs/plugin-devtools-components && go test ./... -v
	cd libs/plugin-integration-figma && go test ./... -v
	cd libs/plugin-devtools-devops && go test ./... -v
	cd libs/plugin-devtools-database && go test ./... -v
	cd libs/plugin-devtools-log-viewer && go test ./... -v
	cd libs/plugin-devtools-test-runner && go test ./... -v
	cd libs/plugin-devtools-debugger && go test ./... -v
	cd libs/plugin-devtools-docker && go test ./... -v
	cd libs/plugin-devtools-services && go test ./... -v
	cd libs/plugin-devtools-ssh && go test ./... -v
	cd libs/plugin-devtools-terminal && go test ./... -v
	cd libs/plugin-devtools-file-explorer && go test ./... -v
	cd libs/plugin-tools-extension-generator && go test ./... -v
	cd libs/plugin-services-notifications && go test ./... -v
	cd libs/plugin-services-voice && go test ./... -v
	cd libs/plugin-ai-screen-reader && go test ./... -v
	cd libs/plugin-ai-browser-context && go test ./... -v
	cd libs/plugin-ai-vision && go test ./... -v
	cd libs/plugin-ai-screenshot && go test ./... -v
	cd libs/plugin-agent-orchestrator && go test ./... -v
	cd libs/plugin-devtools-git && go test ./... -v
	cd libs/plugin-tools-notes && go test ./... -v
	cd libs/plugin-tools-docs && go test ./... -v
	cd libs/plugin-tools-markdown && go test ./... -v
	cd libs/plugin-bridge-firecrawl && go test ./... -v
	cd libs/plugin-bridge-ollama && go test ./... -v
	cd libs/plugin-bridge-gemini && go test ./... -v
	cd libs/plugin-bridge-openai && go test ./... -v
	cd libs/plugin-transport-quic-bridge && go test ./... -v
	cd libs/plugin-tools-sessions && go test ./... -v
	cd libs/plugin-tools-agentops && go test ./... -v
	cd libs/plugin-tools-workspace && go test ./... -v
	cd libs/plugin-bridge-claude && go test ./... -v
	cd libs/plugin-tools-marketplace && go test ./... -v

test-e2e: build
	@bash scripts/test-e2e.sh

# === Install ===

PREFIX ?= /usr/local
BINARIES := orchestra orchestrator storage-markdown tools-features transport-stdio web tools-marketplace engine-rag bridge-claude tools-agentops tools-sessions tools-workspace transport-quic-bridge bridge-openai bridge-gemini bridge-ollama bridge-firecrawl tools-markdown tools-docs tools-notes devtools-git agent-orchestrator ai-screenshot ai-vision ai-browser-context ai-screen-reader services-voice services-notifications tools-extension-generator devtools-file-explorer devtools-terminal devtools-ssh devtools-services devtools-docker devtools-debugger devtools-test-runner devtools-log-viewer devtools-database devtools-devops integration-figma devtools-components bridge-discord bridge-slack

install: build
	@mkdir -p $(PREFIX)/bin
	@for b in $(BINARIES); do \
		cp $(BIN_DIR)/$$b $(PREFIX)/bin/ && echo "  installed $(PREFIX)/bin/$$b"; \
	done
	@echo "\nOrchestra installed. Run: orchestra init"

uninstall:
	@for b in $(BINARIES); do \
		rm -f $(PREFIX)/bin/$$b && echo "  removed $(PREFIX)/bin/$$b"; \
	done

# === Release ===

DIST_DIR := dist
VERSION := $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
LDFLAGS := -X github.com/orchestra-mcp/cli/internal.Version=$(VERSION) \
           -X github.com/orchestra-mcp/cli/internal.Commit=$(shell git rev-parse --short HEAD 2>/dev/null || echo none) \
           -X github.com/orchestra-mcp/cli/internal.Date=$(shell date -u +%Y-%m-%dT%H:%M:%SZ)

release:
	@mkdir -p $(DIST_DIR)
	@for goos in darwin linux; do \
		for goarch in amd64 arm64; do \
			echo "Building $$goos/$$goarch..."; \
			GOOS=$$goos GOARCH=$$goarch sh -c 'cd libs/cli && go build -ldflags "$(LDFLAGS)" -o $(ROOT_DIR)/$(DIST_DIR)/orchestra .'; \
			GOOS=$$goos GOARCH=$$goarch sh -c 'cd libs/orchestrator && go build -o $(ROOT_DIR)/$(DIST_DIR)/orchestrator ./cmd/'; \
			GOOS=$$goos GOARCH=$$goarch sh -c 'cd libs/plugin-storage-markdown && go build -o $(ROOT_DIR)/$(DIST_DIR)/storage-markdown ./cmd/'; \
			GOOS=$$goos GOARCH=$$goarch sh -c 'cd libs/plugin-storage-sqlite && go build -o $(ROOT_DIR)/$(DIST_DIR)/storage-sqlite ./cmd/'; \
			GOOS=$$goos GOARCH=$$goarch sh -c 'cd libs/plugin-tools-features && go build -o $(ROOT_DIR)/$(DIST_DIR)/tools-features ./cmd/'; \
			GOOS=$$goos GOARCH=$$goarch sh -c 'cd libs/plugin-transport-stdio && go build -o $(ROOT_DIR)/$(DIST_DIR)/transport-stdio ./cmd/'; \
			GOOS=$$goos GOARCH=$$goarch sh -c 'cd libs/plugin-tools-marketplace && go build -o $(ROOT_DIR)/$(DIST_DIR)/tools-marketplace ./cmd/'; \
			tar -czf $(DIST_DIR)/orchestra-$$goos-$$goarch.tar.gz -C $(DIST_DIR) orchestra orchestrator storage-markdown storage-sqlite tools-features transport-stdio tools-marketplace; \
			rm -f $(DIST_DIR)/orchestra $(DIST_DIR)/orchestrator $(DIST_DIR)/storage-markdown $(DIST_DIR)/storage-sqlite $(DIST_DIR)/tools-features $(DIST_DIR)/transport-stdio $(DIST_DIR)/tools-marketplace; \
		done; \
	done
	@for goarch in amd64; do \
		echo "Building windows/$$goarch..."; \
		GOOS=windows GOARCH=$$goarch sh -c 'cd libs/cli && go build -ldflags "$(LDFLAGS)" -o $(ROOT_DIR)/$(DIST_DIR)/orchestra.exe .'; \
		GOOS=windows GOARCH=$$goarch sh -c 'cd libs/orchestrator && go build -o $(ROOT_DIR)/$(DIST_DIR)/orchestrator.exe ./cmd/'; \
		GOOS=windows GOARCH=$$goarch sh -c 'cd libs/plugin-storage-markdown && go build -o $(ROOT_DIR)/$(DIST_DIR)/storage-markdown.exe ./cmd/'; \
		GOOS=windows GOARCH=$$goarch sh -c 'cd libs/plugin-storage-sqlite && go build -o $(ROOT_DIR)/$(DIST_DIR)/storage-sqlite.exe ./cmd/'; \
		GOOS=windows GOARCH=$$goarch sh -c 'cd libs/plugin-tools-features && go build -o $(ROOT_DIR)/$(DIST_DIR)/tools-features.exe ./cmd/'; \
		GOOS=windows GOARCH=$$goarch sh -c 'cd libs/plugin-transport-stdio && go build -o $(ROOT_DIR)/$(DIST_DIR)/transport-stdio.exe ./cmd/'; \
		GOOS=windows GOARCH=$$goarch sh -c 'cd libs/plugin-tools-marketplace && go build -o $(ROOT_DIR)/$(DIST_DIR)/tools-marketplace.exe ./cmd/'; \
		tar -czf $(DIST_DIR)/orchestra-windows-$$goarch.tar.gz -C $(DIST_DIR) orchestra.exe orchestrator.exe storage-markdown.exe storage-sqlite.exe tools-features.exe transport-stdio.exe tools-marketplace.exe; \
		rm -f $(DIST_DIR)/orchestra.exe $(DIST_DIR)/orchestrator.exe $(DIST_DIR)/storage-markdown.exe $(DIST_DIR)/storage-sqlite.exe $(DIST_DIR)/tools-features.exe $(DIST_DIR)/transport-stdio.exe $(DIST_DIR)/tools-marketplace.exe; \
	done
	@echo "\nRelease tarballs in $(DIST_DIR)/"
	@ls -lh $(DIST_DIR)/*.tar.gz

# === Clean ===

clean:
	rm -rf $(BIN_DIR) $(DIST_DIR)
	rm -rf ~/.orchestra/certs

build-tools-marketplace:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-tools-marketplace && go build -o $(BIN_DIR)/tools-marketplace ./cmd/

build-engine-rag:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-engine-rag && cargo build --release
	cp libs/plugin-engine-rag/target/release/orchestra-rag $(BIN_DIR)/engine-rag

test-engine-rag:
	cd libs/plugin-engine-rag && cargo test

build-bridge-claude:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-bridge-claude && go build -o $(BIN_DIR)/bridge-claude ./cmd/

build-tools-agentops:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-tools-agentops && go build -o $(BIN_DIR)/tools-agentops ./cmd/

build-tools-sessions:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-tools-sessions && go build -o $(BIN_DIR)/tools-sessions ./cmd/

build-tools-workspace:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-tools-workspace && go build -o $(BIN_DIR)/tools-workspace ./cmd/

build-transport-quic-bridge:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-transport-quic-bridge && go build -o $(BIN_DIR)/transport-quic-bridge ./cmd/

build-bridge-openai:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-bridge-openai && go build -o $(BIN_DIR)/bridge-openai ./cmd/

build-bridge-gemini:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-bridge-gemini && go build -o $(BIN_DIR)/bridge-gemini ./cmd/

build-bridge-ollama:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-bridge-ollama && go build -o $(BIN_DIR)/bridge-ollama ./cmd/

build-bridge-firecrawl:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-bridge-firecrawl && go build -o $(BIN_DIR)/bridge-firecrawl ./cmd/

build-tools-markdown:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-tools-markdown && go build -o $(BIN_DIR)/tools-markdown ./cmd/

build-tools-docs:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-tools-docs && go build -o $(BIN_DIR)/tools-docs ./cmd/

build-tools-notes:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-tools-notes && go build -o $(BIN_DIR)/tools-notes ./cmd/

build-devtools-git:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-devtools-git && go build -o $(BIN_DIR)/devtools-git ./cmd/

build-agent-orchestrator:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-agent-orchestrator && go build -o $(BIN_DIR)/agent-orchestrator ./cmd/

build-ai-screenshot:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-ai-screenshot && go build -o $(BIN_DIR)/ai-screenshot ./cmd/

build-ai-vision:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-ai-vision && go build -o $(BIN_DIR)/ai-vision ./cmd/

build-ai-browser-context:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-ai-browser-context && go build -o $(BIN_DIR)/ai-browser-context ./cmd/

build-ai-screen-reader:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-ai-screen-reader && go build -o $(BIN_DIR)/ai-screen-reader ./cmd/

build-services-voice:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-services-voice && go build -o $(BIN_DIR)/services-voice ./cmd/

build-services-notifications:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-services-notifications && go build -o $(BIN_DIR)/services-notifications ./cmd/

build-tools-extension-generator:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-tools-extension-generator && go build -o $(BIN_DIR)/tools-extension-generator ./cmd/

build-devtools-file-explorer:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-devtools-file-explorer && go build -o $(BIN_DIR)/devtools-file-explorer ./cmd/

build-devtools-terminal:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-devtools-terminal && go build -o $(BIN_DIR)/devtools-terminal ./cmd/

build-devtools-ssh:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-devtools-ssh && go build -o $(BIN_DIR)/devtools-ssh ./cmd/

build-devtools-services:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-devtools-services && go build -o $(BIN_DIR)/devtools-services ./cmd/

build-devtools-docker:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-devtools-docker && go build -o $(BIN_DIR)/devtools-docker ./cmd/

build-devtools-debugger:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-devtools-debugger && go build -o $(BIN_DIR)/devtools-debugger ./cmd/

build-devtools-test-runner:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-devtools-test-runner && go build -o $(BIN_DIR)/devtools-test-runner ./cmd/

build-devtools-log-viewer:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-devtools-log-viewer && go build -o $(BIN_DIR)/devtools-log-viewer ./cmd/

build-devtools-database:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-devtools-database && go build -o $(BIN_DIR)/devtools-database ./cmd/

build-devtools-devops:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-devtools-devops && go build -o $(BIN_DIR)/devtools-devops ./cmd/

build-integration-figma:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-integration-figma && go build -o $(BIN_DIR)/integration-figma ./cmd/

build-devtools-components:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-devtools-components && go build -o $(BIN_DIR)/devtools-components ./cmd/

build-sync-cloud:
	@mkdir -p $(BIN_DIR)
	cd libs/plugin-sync-cloud && go build -o $(BIN_DIR)/sync-cloud ./cmd/

# === Swift Universal App ===

SWIFT_DIR        := apps/swift
SWIFT_SCHEME_MAC := OrchestraMac
SWIFT_SCHEME_IOS := OrchestraIOS
SWIFT_CONFIG     := Debug
SWIFT_XCPROJ     := $(SWIFT_DIR)/Orchestra.xcodeproj

# Derived data app path helper (resolves after build)
SWIFT_APP = $(shell find ~/Library/Developer/Xcode/DerivedData/Orchestra-*/Build/Products/Debug \
	-name "Orchestra.app" -not -path "*/Index.noindex/*" 2>/dev/null | head -1)

.PHONY: xcodegen-swift build-swift run-swift test-swift dev-swift watch-swift clean-swift build-bridge-discord

xcodegen-swift: ## Regenerate Orchestra.xcodeproj from project.yml
	xcodegen generate --spec $(SWIFT_DIR)/project.yml

build-swift: xcodegen-swift ## Build macOS Swift app (Debug)
	xcodebuild \
	  -project $(SWIFT_XCPROJ) \
	  -scheme $(SWIFT_SCHEME_MAC) \
	  -configuration $(SWIFT_CONFIG) \
	  -destination "platform=macOS" \
	  build | xcpretty 2>/dev/null || xcodebuild \
	  -project $(SWIFT_XCPROJ) \
	  -scheme $(SWIFT_SCHEME_MAC) \
	  -configuration $(SWIFT_CONFIG) \
	  -destination "platform=macOS" \
	  build

build-swift-ios: xcodegen-swift ## Build iOS Swift app (simulator)
	xcodebuild \
	  -project $(SWIFT_XCPROJ) \
	  -scheme $(SWIFT_SCHEME_IOS) \
	  -configuration $(SWIFT_CONFIG) \
	  -destination "platform=iOS Simulator,name=iPhone 16" \
	  build | xcpretty 2>/dev/null || true

run-swift: build-swift ## Build and launch Orchestra.app on macOS
	@APP="$(SWIFT_APP)"; \
	if [ -z "$$APP" ]; then echo "Orchestra.app not found — run make build-swift first"; exit 1; fi; \
	pkill -x Orchestra 2>/dev/null; sleep 0.3; \
	open "$$APP"

test-swift: ## Run Swift package unit tests (SPM)
	cd $(SWIFT_DIR) && swift test

dev-swift: ## Build, launch, and watch for .swift changes (no xcodegen)
	@bash scripts/dev-swift.sh

watch-swift: ## Watch Swift sources and auto-rebuild + relaunch on changes
	@bash scripts/dev-swift.sh

clean-swift: ## Remove Swift DerivedData for Orchestra
	rm -rf ~/Library/Developer/Xcode/DerivedData/Orchestra-*

build-bridge-discord:
	@mkdir -p $(BIN_DIR)
	go build -o $(BIN_DIR)/bridge-discord ./libs/plugin-bridge-discord/cmd/

build-bridge-slack:
	@mkdir -p $(BIN_DIR)
	go build -o $(BIN_DIR)/bridge-slack ./libs/plugin-bridge-slack/cmd/

#!/bin/sh
#
# Orchestra MCP — Install Script
#
# Usage:
#   curl -fsSL https://orchestra-mcp.dev/install.sh | sh
#   curl -fsSL https://raw.githubusercontent.com/orchestra-mcp/framework/master/scripts/install.sh | sh
#
# Environment variables:
#   INSTALL_DIR   — Installation directory (default: /usr/local/bin)
#   VERSION       — Version to install (default: latest)
#   GITHUB_REPO   — GitHub repository (default: orchestra-mcp/framework)
#
set -e

GITHUB_REPO="${GITHUB_REPO:-orchestra-mcp/framework}"
VERSION="${VERSION:-latest}"
EXE=""
CURL_EXTRA=""

# Core binaries shipped in every release.
CORE_BINARIES="orchestra orchestrator storage-markdown storage-sqlite tools-features transport-stdio tools-marketplace"

# Colors (disabled if not a terminal)
if [ -t 1 ]; then
    RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'
    CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
else
    RED=''; GREEN=''; YELLOW=''; CYAN=''; BOLD=''; NC=''
fi

info()  { printf "${CYAN}>${NC} %s\n" "$1"; }
ok()    { printf "${GREEN}>${NC} %s\n" "$1"; }
warn()  { printf "${YELLOW}>${NC} %s\n" "$1"; }
error() { printf "${RED}>${NC} %s\n" "$1" >&2; exit 1; }

# Detect OS and architecture.
detect_platform() {
    RAW_OS="$(uname -s)"
    ARCH="$(uname -m)"

    case "$RAW_OS" in
        Darwin*)          OS="darwin" ;;
        Linux*)           OS="linux" ;;
        MINGW*|MSYS*|CYGWIN*)
            OS="windows"
            EXE=".exe"
            CURL_EXTRA="--ssl-revoke-best-effort"
            ;;
        *)
            error "Unsupported OS: $RAW_OS. Orchestra supports macOS, Linux, and Windows (Git Bash)."
            ;;
    esac

    case "$ARCH" in
        x86_64|amd64)  ARCH="amd64" ;;
        arm64|aarch64) ARCH="arm64" ;;
        *)
            error "Unsupported architecture: $ARCH. Orchestra supports amd64 and arm64."
            ;;
    esac

    # Default install dir per platform.
    if [ -z "${INSTALL_DIR:-}" ]; then
        if [ "$OS" = "windows" ]; then
            INSTALL_DIR="${LOCALAPPDATA:-$HOME/AppData/Local}/Orchestra/bin"
        else
            INSTALL_DIR="/usr/local/bin"
        fi
    fi

    PLATFORM="${OS}-${ARCH}"
}

# Resolve the download URL.
resolve_url() {
    if [ "$VERSION" = "latest" ]; then
        info "Finding latest version..."
        if command -v curl >/dev/null 2>&1; then
            VERSION="$(curl -fsSL $CURL_EXTRA "https://api.github.com/repos/${GITHUB_REPO}/releases" \
                | grep -m1 '"tag_name"' | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')"
        elif command -v wget >/dev/null 2>&1; then
            VERSION="$(wget -qO- "https://api.github.com/repos/${GITHUB_REPO}/releases" \
                | grep -m1 '"tag_name"' | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')"
        fi
        if [ -z "$VERSION" ]; then
            error "Could not determine latest version. Set VERSION=v1.0.2 manually."
        fi
    fi
    URL="https://github.com/${GITHUB_REPO}/releases/download/${VERSION}/orchestra-${PLATFORM}.tar.gz"
}

# Download and install.
install() {
    printf "\n"
    printf "${BOLD}  Orchestra MCP Installer${NC}\n"
    printf "  https://orchestra-mcp.dev\n"
    printf "\n"

    info "Platform:    ${PLATFORM}"
    info "Install dir: ${INSTALL_DIR}"
    info "Version:     ${VERSION}"
    printf "\n"

    # Create temp directory.
    TMP_DIR="$(mktemp -d)"
    trap 'rm -rf "$TMP_DIR"' EXIT

    info "Downloading ${URL}..."
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL $CURL_EXTRA "$URL" -o "${TMP_DIR}/orchestra.tar.gz"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$URL" -O "${TMP_DIR}/orchestra.tar.gz"
    else
        error "curl or wget is required."
    fi

    info "Extracting..."
    tar -xzf "${TMP_DIR}/orchestra.tar.gz" -C "$TMP_DIR"

    info "Installing to ${INSTALL_DIR}..."

    # Check write permissions, use sudo if needed (skip sudo on Windows).
    SUDO=""
    if [ "$OS" != "windows" ]; then
        if [ ! -w "$INSTALL_DIR" ] 2>/dev/null || { [ ! -d "$INSTALL_DIR" ] && ! mkdir -p "$INSTALL_DIR" 2>/dev/null; }; then
            if command -v sudo >/dev/null 2>&1; then
                info "(need sudo for ${INSTALL_DIR})"
                SUDO="sudo"
            else
                error "No write permission to ${INSTALL_DIR} and sudo not available. Try: INSTALL_DIR=~/.local/bin sh install.sh"
            fi
        fi
    fi

    $SUDO mkdir -p "$INSTALL_DIR"

    INSTALLED=0
    for bin in $CORE_BINARIES; do
        if [ -f "${TMP_DIR}/${bin}${EXE}" ]; then
            $SUDO cp "${TMP_DIR}/${bin}${EXE}" "${INSTALL_DIR}/${bin}${EXE}"
            if [ "$OS" != "windows" ]; then
                $SUDO chmod +x "${INSTALL_DIR}/${bin}${EXE}"
            fi
            ok "  ${bin}${EXE}"
            INSTALLED=$((INSTALLED + 1))
        fi
    done

    # Create orchestra-mcp symlink for MCP server compatibility.
    SYMLINK="${INSTALL_DIR}/orchestra-mcp${EXE}"
    if [ "$OS" != "windows" ]; then
        $SUDO ln -sf "${INSTALL_DIR}/orchestra${EXE}" "$SYMLINK" 2>/dev/null || true
    fi

    printf "\n"
    ok "Installed ${INSTALLED} binaries to ${INSTALL_DIR}"
    printf "\n"

    # Verify it works.
    if command -v "orchestra${EXE}" >/dev/null 2>&1; then
        ok "Version: $(orchestra${EXE} version 2>&1 || true)"
    else
        warn "orchestra installed but not in PATH."
        if [ "$OS" = "windows" ]; then
            warn "Run in PowerShell (as Administrator):"
            warn "  [Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'User') + ';${INSTALL_DIR}', 'User')"
        else
            warn "Add to your shell profile:"
            warn "  export PATH=\"${INSTALL_DIR}:\$PATH\""
        fi
    fi

    printf "\n"
    printf "${BOLD}${GREEN}Orchestra MCP installed!${NC}\n"
    printf "\n"
    printf "  ${CYAN}Quick start:${NC}\n"
    printf "    cd your-project\n"
    printf "    orchestra init         # Initialize Orchestra in this project\n"
    printf "    orchestra serve        # Start MCP server (for Claude Code, Cursor, etc.)\n"
    printf "\n"
    printf "  ${CYAN}Commands:${NC}\n"
    printf "    orchestra serve        # Start MCP stdio server\n"
    printf "    orchestra init         # Initialize project with skills, agents, hooks\n"
    printf "    orchestra version      # Print version\n"
    printf "    orchestra pack install # Install skill/agent packs\n"
    printf "\n"
    printf "  ${CYAN}Update:${NC}\n"
    printf "    curl -fsSL https://orchestra-mcp.dev/install.sh | sh\n"
    printf "\n"
    printf "  ${CYAN}Docs:${NC}\n"
    printf "    https://orchestra-mcp.dev\n"
    printf "\n"
}

detect_platform
resolve_url
install

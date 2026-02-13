#!/bin/sh
# Orchestra MCP installer
# Usage: curl -fsSL https://raw.githubusercontent.com/orchestra-mcp/mcp/main/scripts/install.sh | sh
set -e

REPO="orchestra-mcp/mcp"
BINARY="orchestra-mcp"
INSTALL_DIR="/usr/local/bin"

# Detect OS
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "$OS" in
  linux)  OS="linux" ;;
  darwin) OS="darwin" ;;
  *)      echo "Error: unsupported OS: $OS"; exit 1 ;;
esac

# Detect architecture
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64|amd64)  ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *)             echo "Error: unsupported architecture: $ARCH"; exit 1 ;;
esac

# Get latest version from GitHub
VERSION="$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')"
if [ -z "$VERSION" ]; then
  echo "Error: could not determine latest version"
  exit 1
fi

URL="https://github.com/$REPO/releases/download/v${VERSION}/${BINARY}_${OS}_${ARCH}.tar.gz"
echo "Downloading $BINARY v$VERSION for $OS/$ARCH..."

# Create temp directory
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# Download and extract
curl -fsSL "$URL" | tar -xz -C "$TMP_DIR"

# Install binary
if [ -w "$INSTALL_DIR" ]; then
  mv "$TMP_DIR/$BINARY" "$INSTALL_DIR/$BINARY"
else
  echo "Installing to $INSTALL_DIR (requires sudo)..."
  sudo mv "$TMP_DIR/$BINARY" "$INSTALL_DIR/$BINARY"
fi

chmod +x "$INSTALL_DIR/$BINARY"
echo "Installed $BINARY v$VERSION to $INSTALL_DIR/$BINARY"
echo ""
echo "Run '$BINARY --help' to get started."

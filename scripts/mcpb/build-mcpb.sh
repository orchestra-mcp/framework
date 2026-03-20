#!/bin/bash
# build-mcpb.sh — Build .mcpb bundle for Claude Desktop one-click install.
#
# Usage: bash scripts/mcpb/build-mcpb.sh [--version 1.0.4]
#
# Produces: dist/orchestra.mcpb (a ZIP archive containing manifest.json + binaries)

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
MCPB_DIR="$ROOT_DIR/scripts/mcpb"
DIST_DIR="$ROOT_DIR/dist"
STAGING_DIR="$DIST_DIR/mcpb-staging"

# Parse version flag.
VERSION="${1:-}"
if [[ "$VERSION" == "--version" ]]; then
    VERSION="${2:-}"
fi
if [[ -z "$VERSION" ]]; then
    VERSION="$(git -C "$ROOT_DIR" describe --tags --always --dirty 2>/dev/null || echo "dev")"
fi

echo "==> Building MCPB bundle v${VERSION}"

# Clean staging.
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR/bin"

# Build LDFLAGS for version injection.
LDFLAGS="-X github.com/orchestra-mcp/cli/internal.Version=${VERSION}"
LDFLAGS="$LDFLAGS -X github.com/orchestra-mcp/cli/internal.Commit=$(git -C "$ROOT_DIR" rev-parse --short HEAD 2>/dev/null || echo none)"
LDFLAGS="$LDFLAGS -X github.com/orchestra-mcp/cli/internal.Date=$(date -u +%Y-%m-%dT%H:%M:%SZ)"

# Cross-compile for 5 platform targets.
TARGETS=(
    "darwin:arm64"
    "darwin:amd64"
    "linux:arm64"
    "linux:amd64"
    "windows:amd64"
)

for target in "${TARGETS[@]}"; do
    IFS=':' read -r goos goarch <<< "$target"
    outname="orchestra-${goos}-${goarch}"
    if [[ "$goos" == "windows" ]]; then
        outname="${outname}.exe"
    fi
    echo "  -> Building ${goos}/${goarch}"
    GOOS="$goos" GOARCH="$goarch" go build \
        -ldflags "$LDFLAGS" \
        -o "$STAGING_DIR/bin/$outname" \
        "$ROOT_DIR/libs/cli"
done

# Copy manifest and update version.
cp "$MCPB_DIR/manifest.json" "$STAGING_DIR/manifest.json"
if command -v jq &>/dev/null; then
    jq --arg v "$VERSION" '.version = $v' "$STAGING_DIR/manifest.json" > "$STAGING_DIR/manifest.tmp"
    mv "$STAGING_DIR/manifest.tmp" "$STAGING_DIR/manifest.json"
fi

# Copy icon if it exists.
if [[ -f "$MCPB_DIR/icon.png" ]]; then
    cp "$MCPB_DIR/icon.png" "$STAGING_DIR/icon.png"
fi

# Package as .mcpb (ZIP).
mkdir -p "$DIST_DIR"
rm -f "$DIST_DIR/orchestra.mcpb"
cd "$STAGING_DIR"
zip -r "$DIST_DIR/orchestra.mcpb" . -x '*.DS_Store'

# Clean up.
rm -rf "$STAGING_DIR"

echo "==> MCPB bundle created: dist/orchestra.mcpb"
ls -lh "$DIST_DIR/orchestra.mcpb"

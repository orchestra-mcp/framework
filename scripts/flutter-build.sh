#!/usr/bin/env bash
#
# Orchestra Flutter — Cross-Platform Build Script
#
# Usage:
#   ./scripts/flutter-build.sh                    # Build all platforms for current OS
#   ./scripts/flutter-build.sh android            # Build Android only
#   ./scripts/flutter-build.sh ios macos          # Build iOS + macOS
#   ./scripts/flutter-build.sh web --docker       # Build web + Docker image
#   BUILD_NUMBER=42 ./scripts/flutter-build.sh    # Override build number
#
# Supported platforms: android, ios, macos, linux, windows, web
# iOS/macOS require macOS. Windows requires Windows.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
FLUTTER_DIR="$ROOT_DIR/apps/flutter"
BUILD_NUMBER="${BUILD_NUMBER:-$(date +%s)}"
DOCKER_BUILD="${DOCKER_BUILD:-0}"

# ── Colors ────────────────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log()  { echo -e "${BLUE}[flutter-build]${NC} $1"; }
ok()   { echo -e "${GREEN}[flutter-build]${NC} $1"; }
warn() { echo -e "${YELLOW}[flutter-build]${NC} $1"; }
err()  { echo -e "${RED}[flutter-build]${NC} $1" >&2; }

# ── Pre-flight ────────────────────────────────────────────────────────────────

if ! command -v flutter &>/dev/null; then
    err "Flutter SDK not found in PATH."
    exit 1
fi

cd "$FLUTTER_DIR"

OS="$(uname -s)"

# ── Parse arguments ───────────────────────────────────────────────────────────

PLATFORMS=()
for arg in "$@"; do
    case "$arg" in
        --docker) DOCKER_BUILD=1 ;;
        android|ios|macos|linux|windows|web) PLATFORMS+=("$arg") ;;
        *) err "Unknown argument: $arg"; exit 1 ;;
    esac
done

# Default: build all platforms supported on current OS
if [ ${#PLATFORMS[@]} -eq 0 ]; then
    PLATFORMS=(web)
    case "$OS" in
        Darwin) PLATFORMS+=(android ios macos) ;;
        Linux)  PLATFORMS+=(android linux) ;;
        MINGW*|MSYS*) PLATFORMS+=(android windows) ;;
    esac
fi

log "Platforms: ${PLATFORMS[*]}"
log "Build number: $BUILD_NUMBER"
echo ""

# ── Install dependencies ──────────────────────────────────────────────────────

log "Installing dependencies..."
flutter pub get
echo ""

# ── Build functions ───────────────────────────────────────────────────────────

build_android() {
    log "Building Android APK + AAB..."
    flutter build apk --release --build-number="$BUILD_NUMBER"
    flutter build appbundle --release --build-number="$BUILD_NUMBER"
    ok "Android: build/app/outputs/flutter-apk/app-release.apk"
    ok "Android: build/app/outputs/bundle/release/app-release.aab"
}

build_ios() {
    if [[ "$OS" != "Darwin" ]]; then
        warn "Skipping iOS — requires macOS"
        return
    fi
    log "Building iOS..."
    cd ios && pod install && cd ..
    flutter build ios --release --no-codesign --build-number="$BUILD_NUMBER"
    ok "iOS: build/ios/iphoneos/Runner.app"
}

build_macos() {
    if [[ "$OS" != "Darwin" ]]; then
        warn "Skipping macOS — requires macOS"
        return
    fi
    log "Building macOS..."
    cd macos && pod install && cd ..
    flutter build macos --release --build-number="$BUILD_NUMBER"

    # Create DMG
    local app_path="build/macos/Build/Products/Release/Orchestra.app"
    local dmg_path="build/macos/Orchestra-${BUILD_NUMBER}.dmg"
    if [ -d "$app_path" ]; then
        hdiutil create -volname "Orchestra" -srcfolder "$app_path" -ov -format UDZO "$dmg_path"
        ok "macOS: $dmg_path"
    else
        ok "macOS: $app_path"
    fi
}

build_linux() {
    if [[ "$OS" != "Linux" ]]; then
        warn "Skipping Linux — requires Linux"
        return
    fi
    log "Building Linux..."
    flutter build linux --release --build-number="$BUILD_NUMBER"

    # Create tarball
    local bundle="build/linux/x64/release/bundle"
    local tarball="build/orchestra-linux-x64.tar.gz"
    tar czf "$tarball" -C "$bundle" .
    ok "Linux: $tarball"
}

build_windows() {
    if [[ "$OS" != MINGW* && "$OS" != MSYS* ]]; then
        warn "Skipping Windows — requires Windows"
        return
    fi
    log "Building Windows..."
    flutter build windows --release --build-number="$BUILD_NUMBER"
    ok "Windows: build/windows/x64/runner/Release/"
}

build_web() {
    log "Building Web..."
    flutter build web --release --web-renderer canvaskit --base-href /
    ok "Web: build/web/"

    if [ "$DOCKER_BUILD" = "1" ]; then
        log "Building Docker image..."
        docker build -f deploy/Dockerfile.web -t orchestra-web:latest -t "orchestra-web:$BUILD_NUMBER" .
        ok "Docker: orchestra-web:$BUILD_NUMBER"
    fi
}

# ── Execute builds ────────────────────────────────────────────────────────────

FAILED=()

for platform in "${PLATFORMS[@]}"; do
    echo ""
    case "$platform" in
        android) build_android || FAILED+=("android") ;;
        ios)     build_ios     || FAILED+=("ios") ;;
        macos)   build_macos   || FAILED+=("macos") ;;
        linux)   build_linux   || FAILED+=("linux") ;;
        windows) build_windows || FAILED+=("windows") ;;
        web)     build_web     || FAILED+=("web") ;;
    esac
done

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ ${#FAILED[@]} -eq 0 ]; then
    ok "All builds complete! (${PLATFORMS[*]})"
else
    err "Failed: ${FAILED[*]}"
    exit 1
fi

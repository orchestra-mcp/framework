#!/usr/bin/env bash
# dev-swift.sh — Watch .swift files, rebuild via xcodebuild, relaunch Orchestra.app.
# Only reacts to .swift file changes. Debounces rapid changes. Single instance guaranteed.
set -euo pipefail

SWIFT_DIR="apps/swift"
XCPROJ="$SWIFT_DIR/Orchestra.xcodeproj"
SCHEME="OrchestraMac"
CONFIG="Debug"
LOCKFILE="/tmp/dev-swift.lock"
TRIGGER="/tmp/dev-swift.trigger"

find_app() {
  find ~/Library/Developer/Xcode/DerivedData/Orchestra-*/Build/Products/Debug \
    -maxdepth 1 -name "Orchestra.app" 2>/dev/null | head -1
}

kill_app() {
  pkill -x Orchestra 2>/dev/null || true
  # Don't kill orchestra serve — it survives app restarts.
  # The app's OrchestratorLauncher checks if port 50101 is in use
  # and skips spawning a new one if an instance already exists.
  sleep 0.3
}

build_and_launch() {
  # Lockfile prevents concurrent builds
  if [ -f "$LOCKFILE" ]; then
    # Signal that another build is needed after current one finishes
    touch "$TRIGGER"
    return
  fi
  touch "$LOCKFILE"

  echo "[dev-swift] Building..."
  local build_ok=false
  if xcodebuild \
    -project "$XCPROJ" \
    -scheme "$SCHEME" \
    -configuration "$CONFIG" \
    -destination "platform=macOS" \
    build -quiet 2>&1 | tail -3; then
    build_ok=true
  fi

  if $build_ok; then
    local APP
    APP=$(find_app)
    if [ -n "$APP" ]; then
      kill_app
      open "$APP"
      echo "[dev-swift] Launched Orchestra.app (1 instance)"
    else
      echo "[dev-swift] Orchestra.app not found in DerivedData"
    fi
  else
    echo "[dev-swift] Build failed — fix errors and save again"
  fi

  rm -f "$LOCKFILE"

  # If changes came in during build, rebuild once more
  if [ -f "$TRIGGER" ]; then
    rm -f "$TRIGGER"
    echo "[dev-swift] Changes detected during build — rebuilding..."
    build_and_launch
  fi
}

cleanup() {
  echo ""
  echo "[dev-swift] Stopping..."
  pkill -x Orchestra 2>/dev/null || true
  # Don't kill orchestra serve — it may be owned by Claude Code or another IDE.
  rm -f "$LOCKFILE" "$TRIGGER"
  # Kill the fswatch background process
  [ -n "${FSWATCH_PID:-}" ] && kill "$FSWATCH_PID" 2>/dev/null || true
  exit 0
}
trap cleanup INT TERM EXIT

# Check fswatch
if ! command -v fswatch &>/dev/null; then
  echo "Installing fswatch..."
  brew install fswatch
fi

# Clean stale lock
rm -f "$LOCKFILE" "$TRIGGER"

# Kill any existing Orchestra instances first
kill_app

# Initial build + launch (skip xcodegen — use existing xcodeproj)
build_and_launch

echo "[dev-swift] Watching $SWIFT_DIR for .swift changes (Ctrl+C to stop)..."

# Debounce: collect changes for 2 seconds before triggering a build.
# fswatch writes ALL changed paths to a temp file (no regex filter — broken
# in fswatch 1.18.x). We filter for .swift in the shell loop instead.
CHANGEFILE="/tmp/dev-swift.changes"
: > "$CHANGEFILE"

fswatch -r "$SWIFT_DIR" >> "$CHANGEFILE" &
FSWATCH_PID=$!

while true; do
  sleep 2
  if [ -s "$CHANGEFILE" ]; then
    # Read and clear atomically
    CHANGES=$(cat "$CHANGEFILE")
    : > "$CHANGEFILE"

    # Filter: only .swift files, skip build artifacts
    REAL_CHANGES=""
    while IFS= read -r f; do
      case "$f" in
        *.swift) ;;
        *) continue ;;
      esac
      case "$f" in
        */.build/*|*/DerivedData/*|*/.swiftpm/*|"") continue ;;
        *) REAL_CHANGES="$REAL_CHANGES$f"$'\n' ;;
      esac
    done <<< "$CHANGES"

    if [ -n "$REAL_CHANGES" ]; then
      echo "[dev-swift] Change detected — rebuilding..."
      build_and_launch
    fi
  fi
done

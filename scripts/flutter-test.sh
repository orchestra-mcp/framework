#!/usr/bin/env bash
#
# Orchestra Flutter — Test & Analyze Script
#
# Usage:
#   ./scripts/flutter-test.sh              # Run all checks (analyze + format + test)
#   ./scripts/flutter-test.sh --analyze    # Analyze only
#   ./scripts/flutter-test.sh --format     # Format check only
#   ./scripts/flutter-test.sh --test       # Unit/widget tests only
#   ./scripts/flutter-test.sh --coverage   # Tests with coverage report
#   ./scripts/flutter-test.sh --fix        # Auto-fix format issues

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
FLUTTER_DIR="$ROOT_DIR/apps/flutter"

# ── Colors ────────────────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log()  { echo -e "${BLUE}[flutter-test]${NC} $1"; }
ok()   { echo -e "${GREEN}[flutter-test]${NC} $1"; }
warn() { echo -e "${YELLOW}[flutter-test]${NC} $1"; }
err()  { echo -e "${RED}[flutter-test]${NC} $1" >&2; }

# ── Pre-flight ────────────────────────────────────────────────────────────────

if ! command -v flutter &>/dev/null; then
    err "Flutter SDK not found in PATH."
    exit 1
fi

cd "$FLUTTER_DIR"

# ── Parse arguments ───────────────────────────────────────────────────────────

RUN_ANALYZE=0
RUN_FORMAT=0
RUN_TEST=0
COVERAGE=0
FIX=0

for arg in "$@"; do
    case "$arg" in
        --analyze)  RUN_ANALYZE=1 ;;
        --format)   RUN_FORMAT=1 ;;
        --test)     RUN_TEST=1 ;;
        --coverage) RUN_TEST=1; COVERAGE=1 ;;
        --fix)      FIX=1 ;;
        *) err "Unknown argument: $arg"; exit 1 ;;
    esac
done

# Default: run all checks
if [ $RUN_ANALYZE -eq 0 ] && [ $RUN_FORMAT -eq 0 ] && [ $RUN_TEST -eq 0 ] && [ $FIX -eq 0 ]; then
    RUN_ANALYZE=1
    RUN_FORMAT=1
    RUN_TEST=1
fi

# ── Install dependencies ──────────────────────────────────────────────────────

log "Installing dependencies..."
flutter pub get
echo ""

# ── Tasks ─────────────────────────────────────────────────────────────────────

FAILED=()

if [ $FIX -eq 1 ]; then
    log "Auto-formatting..."
    dart format .
    ok "Format applied."
    echo ""
fi

if [ $RUN_FORMAT -eq 1 ]; then
    log "Checking format..."
    if dart format --set-exit-if-changed . >/dev/null 2>&1; then
        ok "Format: passed"
    else
        err "Format: FAILED — run 'dart format .' to fix"
        FAILED+=("format")
    fi
    echo ""
fi

if [ $RUN_ANALYZE -eq 1 ]; then
    log "Running analyzer..."
    if flutter analyze; then
        ok "Analyze: passed"
    else
        err "Analyze: FAILED"
        FAILED+=("analyze")
    fi
    echo ""
fi

if [ $RUN_TEST -eq 1 ]; then
    log "Running unit & widget tests..."
    TEST_ARGS=()
    if [ $COVERAGE -eq 1 ]; then
        TEST_ARGS+=(--coverage)
    fi
    if flutter test "${TEST_ARGS[@]}"; then
        ok "Tests: passed"
        if [ $COVERAGE -eq 1 ] && [ -f coverage/lcov.info ]; then
            # Print summary
            LINES=$(grep -c "^DA:" coverage/lcov.info 2>/dev/null || echo "0")
            HIT=$(grep "^DA:" coverage/lcov.info 2>/dev/null | grep -cv ",0$" || echo "0")
            if [ "$LINES" -gt 0 ]; then
                PCT=$(( HIT * 100 / LINES ))
                ok "Coverage: ${HIT}/${LINES} lines (${PCT}%)"
            fi
        fi
    else
        err "Tests: FAILED"
        FAILED+=("test")
    fi
    echo ""
fi

# ── Summary ───────────────────────────────────────────────────────────────────

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ ${#FAILED[@]} -eq 0 ]; then
    ok "All checks passed!"
else
    err "Failed: ${FAILED[*]}"
    exit 1
fi

#!/usr/bin/env bash
# scripts/dev.sh — Unified dev server (composer dev style)
# Press Ctrl+C to stop. Press r to rebuild & restart. Press q to quit.
set -u

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BIN_DIR="$ROOT_DIR/bin"
LOG_DIR="$HOME/Library/Logs/Orchestra"

RST="\033[0m"
B="\033[1m"
D="\033[2m"
GRN="\033[32m"
BLU="\033[34m"
MAG="\033[35m"
CYN="\033[36m"
YEL="\033[33m"
RED="\033[31m"

SAVED_TTY=""
SERVICE_PGIDS=()

# ─── Helpers ──────────────────────────────────────────────────────────

restore_tty() {
    [ -n "$SAVED_TTY" ] && stty "$SAVED_TTY" 2>/dev/null
}

# Launch a command in its own process group so we can kill the whole tree.
# Usage: launch_service "TAG" "$COLOR" command args...
launch_service() {
    local tag_name="$1"; shift
    local tag_color="$1"; shift
    # setsid creates a new process group; we kill the whole group on stop.
    setsid bash -c '"$@" 2>&1' _ "$@" | while IFS= read -r line || [ -n "$line" ]; do
        [[ -z "${line// /}" ]] && continue
        printf "${tag_color}[%s]${RST} %s\n" "$tag_name" "$line"
    done &
    local pipe_pid=$!
    # The setsid child is the grandchild; get its pgid from the pipe.
    SERVICE_PGIDS+=("$pipe_pid")
}

stop_services() {
    echo ""
    echo -e "${YEL}[DEV]${RST} Stopping services..."
    # Kill ports directly — most reliable way to stop everything.
    for port in 9201 8080 3000 3001; do
        local pids
        pids=$(lsof -ti :"$port" 2>/dev/null || true)
        if [ -n "$pids" ]; then
            echo "$pids" | xargs kill 2>/dev/null || true
        fi
    done
    # Also kill our tracked pipe PIDs.
    for pid in "${SERVICE_PGIDS[@]}"; do
        kill "$pid" 2>/dev/null || true
    done
    sleep 0.5
    # Force kill anything left.
    for port in 9201 8080 3000 3001; do
        local pids
        pids=$(lsof -ti :"$port" 2>/dev/null || true)
        if [ -n "$pids" ]; then
            echo "$pids" | xargs kill -9 2>/dev/null || true
        fi
    done
    for pid in "${SERVICE_PGIDS[@]}"; do
        kill -9 "$pid" 2>/dev/null || true
    done
    wait 2>/dev/null || true
    SERVICE_PGIDS=()
    echo -e "${YEL}[DEV]${RST} Services stopped."
}

full_cleanup() {
    restore_tty
    stop_services
    echo -e "${YEL}[DEV]${RST} All services stopped."
    exit 0
}
trap full_cleanup INT TERM

# tag <name> <color> — prefix each line, skip empty lines
tag() {
    local name="$1"
    local cc="$2"
    while IFS= read -r line || [ -n "$line" ]; do
        [[ -z "${line// /}" ]] && continue
        printf "${cc}[%s]${RST} %s\n" "$name" "$line"
    done
}

kill_stale() {
    local port="$1"
    local stale_pids
    stale_pids=$(lsof -ti :"$port" 2>/dev/null || true)
    if [ -n "$stale_pids" ]; then
        echo -e "${YEL}[DEV]${RST} Killing stale processes on :${port}: ${stale_pids//$'\n'/ }"
        echo "$stale_pids" | xargs kill 2>/dev/null || true
        sleep 0.3
    fi
}

# ─── Build ────────────────────────────────────────────────────────────

do_build() {
    mkdir -p "$BIN_DIR"

    echo -e "${CYN}[BUILD]${RST} Compiling ${B}orchestra${RST} → bin/orchestra"
    (cd "$ROOT_DIR/libs/cli" && go build \
        -ldflags "-X github.com/orchestra-mcp/cli/internal.Version=$(git describe --tags --always --dirty 2>/dev/null || echo dev) \
                  -X github.com/orchestra-mcp/cli/internal.Commit=$(git rev-parse --short HEAD 2>/dev/null || echo none) \
                  -X github.com/orchestra-mcp/cli/internal.Date=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        -o "$BIN_DIR/orchestra" . 2>&1) | tag "BUILD" "$CYN"

    echo -e "${CYN}[BUILD]${RST} Compiling ${B}web${RST} → bin/web"
    (cd "$ROOT_DIR/apps/web" && go build -o "$BIN_DIR/web" ./cmd/ 2>&1) | tag "BUILD" "$CYN"
}

# ─── Banner ───────────────────────────────────────────────────────────

show_banner() {
    local VERSION
    VERSION=$("$BIN_DIR/orchestra" version 2>/dev/null | awk '{print $2}' || echo "dev")

    local DB_HASH DB_PATH
    DB_HASH=$(python3 -c "import hashlib; print(hashlib.sha256('$ROOT_DIR'.encode()).hexdigest()[:16])" 2>/dev/null)
    DB_PATH="$HOME/.orchestra/db/${DB_HASH}.db"

    local PROJ_COUNT=0 NOTE_COUNT=0 FEAT_COUNT=0 PLAN_COUNT=0 SESS_COUNT=0
    if [ -f "$DB_PATH" ]; then
        PROJ_COUNT=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM projects;" 2>/dev/null || echo "0")
        NOTE_COUNT=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM notes WHERE deleted=0;" 2>/dev/null || echo "0")
        FEAT_COUNT=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM features;" 2>/dev/null || echo "0")
        PLAN_COUNT=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM plans;" 2>/dev/null || echo "0")
        SESS_COUNT=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM sessions;" 2>/dev/null || echo "0")
    fi

    echo ""
    echo -e "  ${B}ORCHESTRA${RST} ${D}${VERSION}${RST}"
    echo -e "  ${D}workspace${RST}  ${ROOT_DIR}"
    echo -e "  ${D}projects ${RST}  ${PROJ_COUNT}   ${D}features${RST}  ${FEAT_COUNT}   ${D}plans${RST}  ${PLAN_COUNT}"
    echo -e "  ${D}notes    ${RST}  ${NOTE_COUNT}   ${D}sessions${RST}  ${SESS_COUNT}"
    echo ""
}

# ─── Start services ──────────────────────────────────────────────────

start_services() {
    mkdir -p "$LOG_DIR"
    LOG_FILE="$LOG_DIR/orchestra-agents.log"

    echo -e "  ${GRN}orchestra${RST}  MCP + WebSocket gateway   ${D}:9201${RST}"
    echo -e "  ${BLU}web${RST}        Go API server              ${D}:8080${RST}"
    echo -e "  ${MAG}next${RST}       Next.js frontend            ${D}:3000${RST}"
    echo -e "  ${D}log${RST}        $LOG_FILE"
    echo ""

    # Orchestra MCP server
    "$BIN_DIR/orchestra" serve \
        --web-gate :9201 \
        --workspace "$ROOT_DIR" \
        > >(tag "MCP" "$GRN") \
        2> >(tee -a "$LOG_FILE" | tag "MCP" "$GRN") &
    SERVICE_PGIDS+=($!)

    sleep 1

    # Web API server
    "$BIN_DIR/web" -addr :8080 2>&1 | tag "WEB" "$BLU" &
    SERVICE_PGIDS+=($!)

    # Next.js frontend
    (cd "$ROOT_DIR/apps/next" && npm run dev 2>&1) | tag "NEXT" "$MAG" &
    SERVICE_PGIDS+=($!)

    echo -e "  ${B}r${RST} rebuild & restart  ${B}q${RST} quit  ${B}Ctrl+C${RST} force quit"
    echo ""
}

# ─── Initial startup ─────────────────────────────────────────────────

kill_stale 9201
kill_stale 8080
kill_stale 3000
do_build
show_banner
start_services

# ─── Key listener ────────────────────────────────────────────────────

if [ -t 0 ]; then
    SAVED_TTY=$(stty -g 2>/dev/null)
    stty -echo -icanon min 1 time 0 2>/dev/null

    while true; do
        if read -rsn1 -t 1 key 2>/dev/null; then
            case "$key" in
                r|R)
                    restore_tty
                    echo -e "\n${YEL}[DEV]${RST} ${B}Restarting...${RST}"
                    stop_services
                    do_build
                    show_banner
                    start_services
                    SAVED_TTY=$(stty -g 2>/dev/null)
                    stty -echo -icanon min 1 time 0 2>/dev/null
                    ;;
                q|Q)
                    full_cleanup
                    ;;
            esac
        fi
    done
else
    wait 2>/dev/null || true
fi

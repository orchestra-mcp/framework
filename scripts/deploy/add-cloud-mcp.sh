#!/usr/bin/env bash
# add-cloud-mcp.sh — Add Orchestra Cloud MCP to an existing Orchestra server
# Run as root on a server that already has web/next/powersync running.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/orchestra-mcp/framework/master/scripts/deploy/add-cloud-mcp.sh | bash
#   # or
#   bash add-cloud-mcp.sh
set -euo pipefail

DEPLOY_USER="deploy"
APP_DIR="/opt/orchestra"
CLOUD_MCP_REPO="https://github.com/orchestra-mcp/cloud-mcp.git"
SERVICE_NAME="orchestra-cloud-mcp"
PORT=8091

# ── Colors ──
GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
ok()   { printf "${GREEN}[ok]${NC}    %s\n" "$*"; }
info() { printf "${CYAN}[info]${NC}  %s\n" "$*"; }
warn() { printf "${YELLOW}[warn]${NC}  %s\n" "$*"; }
fail() { printf "${RED}[fail]${NC}  %s\n" "$*" >&2; exit 1; }

# ── Must run as root ──
[ "$(id -u)" -eq 0 ] || fail "Run as root: sudo bash add-cloud-mcp.sh"

# ── Go must be installed ──
export PATH=$PATH:/usr/local/go/bin
command -v go &>/dev/null || fail "Go not found. Run setup-server.sh first or install Go."

echo ""
echo "═══════════════════════════════════════════════════"
echo "  Orchestra Cloud MCP — Server Add-on"
echo "═══════════════════════════════════════════════════"
echo ""

# ── 1. Read existing credentials ──
info "Reading existing credentials..."
ENV_FILE="$APP_DIR/shared/.env"
[ -f "$ENV_FILE" ] || fail "No existing install found at $ENV_FILE. Run setup-server.sh first."

DB_URL=$(grep -oP 'DATABASE_URL=\K.*' "$ENV_FILE" || echo "")
JWT_SECRET=$(grep -oP 'JWT_SECRET=\K.*' "$ENV_FILE" || echo "")
CF_API_TOKEN=$(grep -oP 'CF_API_TOKEN=\K.*' "$ENV_FILE" || echo "CHANGEME")

[ -z "$DB_URL" ]     && fail "Could not read DATABASE_URL from $ENV_FILE"
[ -z "$JWT_SECRET" ] && fail "Could not read JWT_SECRET from $ENV_FILE"
ok "Credentials loaded"

# ── 2. Clone or update repo ──
info "Cloning cloud-mcp repo..."
# Remove any partial directory that has no .git (failed previous run)
if [ -d "$APP_DIR/cloud-mcp" ] && [ ! -d "$APP_DIR/cloud-mcp/.git" ]; then
    rm -rf "$APP_DIR/cloud-mcp"
fi

if [ -d "$APP_DIR/cloud-mcp/.git" ]; then
    su - $DEPLOY_USER -c "cd $APP_DIR/cloud-mcp && git fetch origin master && git reset --hard origin/master"
    ok "Repo updated"
else
    su - $DEPLOY_USER -c "git clone $CLOUD_MCP_REPO $APP_DIR/cloud-mcp"
    ok "Repo cloned"
fi
mkdir -p "$APP_DIR/cloud-mcp/bin"
chown -R $DEPLOY_USER:$DEPLOY_USER "$APP_DIR/cloud-mcp"

# ── 3. Write env file ──
info "Writing env file..."
mkdir -p "$APP_DIR/env"
cat > "$APP_DIR/env/cloud-mcp.env" << ENVEOF
DATABASE_URL=$DB_URL
JWT_SECRET=$JWT_SECRET
WEB_API_BASE_URL=https://orchestra-mcp.com/api
PORT=$PORT
ENVEOF
chmod 600 "$APP_DIR/env/cloud-mcp.env"
chown $DEPLOY_USER:$DEPLOY_USER "$APP_DIR/env/cloud-mcp.env"
ok "Env file written to $APP_DIR/env/cloud-mcp.env"

# ── 4. Build binary ──
info "Building binary..."
su - $DEPLOY_USER -c "
    export PATH=\$PATH:/usr/local/go/bin
    cd $APP_DIR/cloud-mcp
    go build -buildvcs=false -ldflags='-s -w' -o bin/orchestra-cloud-mcp ./cmd/
"
ok "Binary built: $APP_DIR/cloud-mcp/bin/orchestra-cloud-mcp"

# ── 5. Install systemd service ──
info "Installing systemd service..."
cat > /etc/systemd/system/$SERVICE_NAME.service << EOF
[Unit]
Description=Orchestra Cloud MCP (Hosted MCP Server)
After=network.target postgresql.service
Requires=postgresql.service

[Service]
Type=simple
User=$DEPLOY_USER
Group=$DEPLOY_USER
WorkingDirectory=$APP_DIR/cloud-mcp
ExecStart=$APP_DIR/cloud-mcp/bin/orchestra-cloud-mcp
Restart=always
RestartSec=5
EnvironmentFile=$APP_DIR/env/cloud-mcp.env
KillSignal=SIGTERM
TimeoutStopSec=15
NoNewPrivileges=true
StandardOutput=journal
StandardError=journal
SyslogIdentifier=$SERVICE_NAME

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable $SERVICE_NAME
systemctl restart $SERVICE_NAME
ok "Service started"

# ── 6. Health check ──
info "Waiting for service to be healthy..."
for i in $(seq 1 15); do
    if curl -sf http://localhost:$PORT/health > /dev/null 2>&1; then
        ok "Health check passed"
        break
    fi
    [ "$i" -eq 15 ] && (journalctl -u $SERVICE_NAME --no-pager -n 20; fail "Health check failed after 30s")
    sleep 2
done

# ── 7. Add sudoers entries ──
info "Updating sudoers..."
SUDOERS_FILE="/etc/sudoers.d/orchestra"
if ! grep -q "$SERVICE_NAME" "$SUDOERS_FILE" 2>/dev/null; then
    cat >> "$SUDOERS_FILE" << EOF
$DEPLOY_USER ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart $SERVICE_NAME
$DEPLOY_USER ALL=(ALL) NOPASSWD: /usr/bin/systemctl status $SERVICE_NAME
$DEPLOY_USER ALL=(ALL) NOPASSWD: /usr/bin/systemctl status $SERVICE_NAME *
$DEPLOY_USER ALL=(ALL) NOPASSWD: /bin/systemctl restart $SERVICE_NAME
$DEPLOY_USER ALL=(ALL) NOPASSWD: /bin/systemctl status $SERVICE_NAME
$DEPLOY_USER ALL=(ALL) NOPASSWD: /usr/bin/journalctl -u $SERVICE_NAME *
EOF
    ok "Sudoers updated"
else
    ok "Sudoers already has cloud-mcp entries"
fi

# ── 8. Caddy config — add /mcp route to existing domain block ──
info "Patching Caddyfile with /mcp route..."
CADDYFILE="/etc/caddy/Caddyfile"
if grep -q "handle /mcp" "$CADDYFILE" 2>/dev/null; then
    ok "Caddy already has /mcp route — skipping"
elif grep -q "handle /api/ws" "$CADDYFILE" 2>/dev/null; then
    # Insert /mcp block before the first /api/ws handle
    sed -i 's|handle /api/ws|handle /mcp {\n\t\treverse_proxy localhost:8091 {\n\t\t\tflush_interval -1\n\t\t}\n\t}\n\n\thandle /api/ws|' "$CADDYFILE"
    systemctl reload caddy
    ok "Added /mcp route to Caddyfile and reloaded Caddy"
else
    warn "Could not auto-patch Caddyfile. Add this manually inside your domain block:"
    echo ""
    echo "────────────────────────────────────────────────"
    echo "	# Cloud MCP"
    echo "	handle /mcp {"
    echo "		reverse_proxy localhost:8091 {"
    echo "			flush_interval -1"
    echo "		}"
    echo "	}"
    echo "────────────────────────────────────────────────"
    echo ""
    echo "Then run: systemctl reload caddy"
    echo ""
fi

echo ""
echo "═══════════════════════════════════════════════════"
echo "  DONE"
echo "═══════════════════════════════════════════════════"
echo ""
echo "  Service:   systemctl status $SERVICE_NAME"
echo "  Logs:      journalctl -u $SERVICE_NAME -f"
echo "  Health:    curl http://localhost:$PORT/health"
echo "  MCP:       https://orchestra-mcp.com/mcp"
echo ""
echo "  NEXT STEPS:"
echo "  1. Add GitHub secrets to orchestra-mcp/cloud-mcp repo:"
echo "     VPS_HOST, VPS_USER, VPS_SSH_KEY, VPS_SSH_PORT"
echo "     (Settings → Environments → production)"
echo ""

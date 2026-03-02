#!/usr/bin/env bash
# Orchestra Web — One-time server setup (Debian/Ubuntu, two-repo layout)
# Run as root: bash setup-server.sh
set -euo pipefail

# ═══════════════════════════════════════════════════════════════
# Configuration — edit these before running
# ═══════════════════════════════════════════════════════════════
DEPLOY_USER="deploy"
WEB_REPO_URL="https://github.com/orchestra-mcp/web.git"
NEXT_REPO_URL="https://github.com/orchestra-mcp/next.git"
REPO_BRANCH="master"
APP_DIR="/opt/orchestra"
DB_NAME="orchestra_web"
DB_USER="orchestra"
DB_PASS="$(openssl rand -hex 16)"
JWT_SECRET="$(openssl rand -hex 32)"
GO_VERSION="1.25.0"
NODE_MAJOR="22"

echo "═══════════════════════════════════════════════════"
echo "  Orchestra Web — Server Setup"
echo "═══════════════════════════════════════════════════"

# ── Check root ──
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: This script must be run as root"
    exit 1
fi

# ── 1. System update ──
echo ""
echo "--- [1/12] Updating system packages ---"
apt update && apt upgrade -y
apt install -y curl wget git build-essential unzip lsb-release gnupg2 ca-certificates

# ── 2. Create deploy user ──
echo ""
echo "--- [2/12] Creating deploy user ---"
if id "$DEPLOY_USER" &>/dev/null; then
    echo "User $DEPLOY_USER already exists, skipping"
else
    adduser --disabled-password --gecos "" "$DEPLOY_USER"
    mkdir -p /home/$DEPLOY_USER/.ssh
    chmod 700 /home/$DEPLOY_USER/.ssh
    touch /home/$DEPLOY_USER/.ssh/authorized_keys
    chmod 600 /home/$DEPLOY_USER/.ssh/authorized_keys
    chown -R $DEPLOY_USER:$DEPLOY_USER /home/$DEPLOY_USER/.ssh
    echo "Created user: $DEPLOY_USER"
    echo ""
    echo "  ┌─────────────────────────────────────────────────────────┐"
    echo "  │ Add your SSH public key to:                             │"
    echo "  │   /home/$DEPLOY_USER/.ssh/authorized_keys               │"
    echo "  └─────────────────────────────────────────────────────────┘"
fi

# ── 3. Install Go ──
echo ""
echo "--- [3/12] Installing Go $GO_VERSION ---"
if command -v go &>/dev/null && go version | grep -q "$GO_VERSION"; then
    echo "Go $GO_VERSION already installed, skipping"
else
    ARCH=$(dpkg --print-architecture)
    GO_TAR="go${GO_VERSION}.linux-${ARCH}.tar.gz"
    wget -q "https://go.dev/dl/${GO_TAR}" -O /tmp/${GO_TAR}
    rm -rf /usr/local/go
    tar -C /usr/local -xzf /tmp/${GO_TAR}
    rm /tmp/${GO_TAR}

    cat > /etc/profile.d/go.sh << 'GOEOF'
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
GOEOF
    source /etc/profile.d/go.sh
    echo "Installed: $(go version)"
fi

# ── 4. Install Node.js ──
echo ""
echo "--- [4/12] Installing Node.js $NODE_MAJOR LTS ---"
if command -v node &>/dev/null && node -v | grep -q "v${NODE_MAJOR}"; then
    echo "Node.js $NODE_MAJOR already installed, skipping"
else
    curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash -
    apt install -y nodejs
    echo "Installed: $(node -v), npm $(npm -v)"
fi

# ── 5. Install PostgreSQL 16 ──
echo ""
echo "--- [5/12] Installing PostgreSQL 16 ---"
if systemctl is-active --quiet postgresql; then
    echo "PostgreSQL already running, skipping install"
else
    # Detect codename (works on both Debian and Ubuntu)
    CODENAME=$(lsb_release -cs 2>/dev/null || grep VERSION_CODENAME /etc/os-release | cut -d= -f2)
    # Trixie (Debian 13) may not have a pgdg repo yet — fall back to bookworm or use default
    install -d /usr/share/postgresql-common/pgdg
    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc
    echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt ${CODENAME}-pgdg main" > /etc/apt/sources.list.d/pgdg.list
    apt update
    apt install -y postgresql-16 || apt install -y postgresql
    systemctl enable postgresql
    systemctl start postgresql
    echo "PostgreSQL 16 installed and running"
fi

# Create database and user
echo "Creating database: $DB_NAME, user: $DB_USER"
su - postgres -c "psql -tc \"SELECT 1 FROM pg_roles WHERE rolname='$DB_USER'\" | grep -q 1 || psql -c \"CREATE USER $DB_USER WITH PASSWORD '$DB_PASS'\""
su - postgres -c "psql -tc \"SELECT 1 FROM pg_database WHERE datname='$DB_NAME'\" | grep -q 1 || psql -c \"CREATE DATABASE $DB_NAME OWNER $DB_USER\""
su - postgres -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER\""

# ── 6. Install Caddy with Cloudflare DNS plugin ──
echo ""
echo "--- [6/12] Installing Caddy with Cloudflare DNS plugin ---"
if command -v caddy &>/dev/null; then
    echo "Caddy already installed, skipping"
else
    # Install xcaddy to build custom Caddy
    GOBIN=/usr/local/bin /usr/local/go/bin/go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

    # Build Caddy with Cloudflare DNS plugin
    cd /tmp
    xcaddy build --with github.com/caddy-dns/cloudflare
    mv caddy /usr/bin/caddy
    chmod +x /usr/bin/caddy

    # Create caddy system user
    groupadd --system caddy 2>/dev/null || true
    useradd --system --gid caddy --create-home --home-dir /var/lib/caddy --shell /usr/sbin/nologin caddy 2>/dev/null || true

    # Create caddy systemd service
    cat > /etc/systemd/system/caddy.service << 'CADDYEOF'
[Unit]
Description=Caddy
Documentation=https://caddyserver.com/docs/
After=network.target network-online.target
Requires=network-online.target

[Service]
Type=notify
User=caddy
Group=caddy
ExecStart=/usr/bin/caddy run --environ --config /etc/caddy/Caddyfile
ExecReload=/usr/bin/caddy reload --config /etc/caddy/Caddyfile --force
TimeoutStopSec=5s
LimitNOFILE=1048576
LimitNPROC=512
PrivateTmp=true
ProtectSystem=full
AmbientCapabilities=CAP_NET_BIND_SERVICE
EnvironmentFile=/opt/orchestra/shared/.env

[Install]
WantedBy=multi-user.target
CADDYEOF

    mkdir -p /etc/caddy /var/log/caddy
    chown caddy:caddy /var/log/caddy
    echo "Caddy installed with Cloudflare DNS plugin: $(caddy version)"
fi

# ── 7. Configure UFW firewall ──
echo ""
echo "--- [7/12] Configuring firewall ---"
apt install -y ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp comment 'SSH'
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'
ufw allow 443/udp comment 'HTTP3 QUIC'
echo "y" | ufw enable
ufw status
echo "Firewall: OK (ports 22, 80, 443 TCP+UDP)"

# ── 8. Create application directories ──
echo ""
echo "--- [8/12] Creating application directories ---"
mkdir -p $APP_DIR/web $APP_DIR/next $APP_DIR/shared $APP_DIR/backups /var/log/orchestra
chown -R $DEPLOY_USER:$DEPLOY_USER $APP_DIR /var/log/orchestra

# ── 9. Clone repositories ──
echo ""
echo "--- [9/12] Cloning repositories ---"

# Clone Go backend
if [ -d "$APP_DIR/web/.git" ]; then
    echo "Web repo already cloned, pulling latest"
    su - $DEPLOY_USER -c "cd $APP_DIR/web && git pull origin $REPO_BRANCH"
else
    su - $DEPLOY_USER -c "git clone --branch $REPO_BRANCH $NEXT_REPO_URL $APP_DIR/next"
    su - $DEPLOY_USER -c "git clone --branch $REPO_BRANCH $WEB_REPO_URL $APP_DIR/web"
fi

# Clone Next.js frontend
if [ -d "$APP_DIR/next/.git" ]; then
    echo "Next repo already cloned, pulling latest"
    su - $DEPLOY_USER -c "cd $APP_DIR/next && git pull origin $REPO_BRANCH"
fi

# ── 10. Create environment file ──
echo ""
echo "--- [10/12] Creating environment file ---"
cat > $APP_DIR/shared/.env << ENVEOF
# Orchestra Web — Production Environment
# Generated by setup-server.sh on $(date -u +%Y-%m-%dT%H:%M:%SZ)

# Database
DATABASE_URL=postgres://$DB_USER:$DB_PASS@localhost:5432/$DB_NAME?sslmode=disable

# Auth
JWT_SECRET=$JWT_SECRET
APP_ENV=production

# Cloudflare API token (for Caddy DNS-01 challenge)
# Create at: https://dash.cloudflare.com/profile/api-tokens
# Permission: Zone > DNS > Edit
CF_API_TOKEN=CHANGEME
ENVEOF

chmod 600 $APP_DIR/shared/.env
chown $DEPLOY_USER:$DEPLOY_USER $APP_DIR/shared/.env

# ── 11. Install systemd services + Caddyfile ──
echo ""
echo "--- [11/12] Installing service files ---"

# Write systemd service for Go backend
cat > /etc/systemd/system/orchestra-web.service << 'SVCEOF'
[Unit]
Description=Orchestra Web API (Go/Fiber)
After=network.target postgresql.service
Requires=postgresql.service

[Service]
Type=simple
User=deploy
Group=deploy
WorkingDirectory=/opt/orchestra/web
ExecStart=/opt/orchestra/web/bin/web --addr :8080
Restart=always
RestartSec=5
StartLimitBurst=5
StartLimitIntervalSec=60
EnvironmentFile=/opt/orchestra/shared/.env
KillSignal=SIGTERM
TimeoutStopSec=15
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/orchestra /var/log/orchestra
PrivateTmp=true
StandardOutput=journal
StandardError=journal
SyslogIdentifier=orchestra-web

[Install]
WantedBy=multi-user.target
SVCEOF

# Write systemd service for Next.js
cat > /etc/systemd/system/orchestra-next.service << 'SVCEOF'
[Unit]
Description=Orchestra Next.js Frontend (SSR)
After=network.target orchestra-web.service

[Service]
Type=simple
User=deploy
Group=deploy
WorkingDirectory=/opt/orchestra/next
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=5
StartLimitBurst=5
StartLimitIntervalSec=60
Environment=NODE_ENV=production
Environment=PORT=3000
Environment=NEXT_PUBLIC_API_URL=
StandardOutput=journal
StandardError=journal
SyslogIdentifier=orchestra-next
NoNewPrivileges=true
ProtectSystem=strict
ReadWritePaths=/opt/orchestra
PrivateTmp=true

[Install]
WantedBy=multi-user.target
SVCEOF

# Install Caddyfile
cat > /etc/caddy/Caddyfile << 'CADDYFILEEOF'
# Replace yourdomain.com with your actual domain
yourdomain.com {
	tls {
		dns cloudflare {env.CF_API_TOKEN}
	}

	encode gzip zstd

	header {
		X-Content-Type-Options "nosniff"
		X-Frame-Options "SAMEORIGIN"
		Referrer-Policy "strict-origin-when-cross-origin"
		-Server
	}

	handle /api/ws {
		reverse_proxy localhost:8080 {
			flush_interval -1
		}
	}

	handle /api/* {
		reverse_proxy localhost:8080
	}

	handle /health {
		reverse_proxy localhost:8080
	}

	handle /_next/static/* {
		header Cache-Control "public, max-age=31536000, immutable"
		reverse_proxy localhost:3000
	}

	handle {
		reverse_proxy localhost:3000
	}

	log {
		output file /var/log/caddy/orchestra-access.log {
			roll_size 100mb
			roll_keep 5
		}
	}
}
CADDYFILEEOF

systemctl daemon-reload
systemctl enable orchestra-web orchestra-next caddy

# ── 12. Setup swap + sudoers + backups ──
echo ""
echo "--- [12/12] Final setup (swap, sudoers, backups) ---"

# 2GB swap for Next.js builds
if [ ! -f /swapfile ]; then
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    echo "Swap: 2GB created"
fi

# Sudoers for deploy user (passwordless for service management only)
cat > /etc/sudoers.d/orchestra << 'SUDOEOF'
deploy ALL=(ALL) NOPASSWD: /bin/systemctl restart orchestra-web
deploy ALL=(ALL) NOPASSWD: /bin/systemctl restart orchestra-next
deploy ALL=(ALL) NOPASSWD: /bin/systemctl reload caddy
deploy ALL=(ALL) NOPASSWD: /bin/systemctl status orchestra-web
deploy ALL=(ALL) NOPASSWD: /bin/systemctl status orchestra-next
deploy ALL=(ALL) NOPASSWD: /usr/bin/journalctl -u orchestra-web *
deploy ALL=(ALL) NOPASSWD: /usr/bin/journalctl -u orchestra-next *
SUDOEOF
chmod 440 /etc/sudoers.d/orchestra

# Daily PostgreSQL backup at 3 AM
cat > /etc/cron.d/orchestra-backup << CRONEOF
0 3 * * * $DEPLOY_USER pg_dump -U $DB_USER $DB_NAME | gzip > $APP_DIR/backups/db-\$(date +\%Y\%m\%d).sql.gz
# Clean backups older than 30 days
0 4 * * * $DEPLOY_USER find $APP_DIR/backups -name "db-*.sql.gz" -mtime +30 -delete
CRONEOF

# Create deploy script on the server
cat > $APP_DIR/deploy.sh << 'DEPLOYEOF'
#!/usr/bin/env bash
# Orchestra Web — Zero-downtime deployment script
# Usage: /opt/orchestra/deploy.sh [web|next|all]
set -euo pipefail

export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

COMPONENT="${1:-all}"
APP_DIR="/opt/orchestra"
LOG_DIR="/var/log/orchestra"
LOG_FILE="${LOG_DIR}/deploy-$(date +%Y%m%d-%H%M%S).log"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Orchestra Deploy ($COMPONENT) started at $(date -u +%Y-%m-%dT%H:%M:%SZ) ==="

deploy_web() {
    echo "--- Deploying Go backend ---"
    cd "$APP_DIR/web"
    git fetch origin master
    git reset --hard origin/master
    echo "Git pull web: OK ($(git rev-parse --short HEAD))"

    go build -o bin/web-new ./cmd/
    echo "Go build: OK"

    mv bin/web-new bin/web
    echo "Binary swap: OK"

    sudo systemctl restart orchestra-web
    for i in $(seq 1 15); do
        if curl -sf http://localhost:8080/health > /dev/null 2>&1; then
            echo "Go backend: healthy (attempt $i)"
            return 0
        fi
        if [ "$i" -eq 15 ]; then
            echo "FATAL: Go backend health check failed"
            sudo journalctl -u orchestra-web --no-pager -n 50
            exit 1
        fi
        sleep 2
    done
}

deploy_next() {
    echo "--- Deploying Next.js frontend ---"
    cd "$APP_DIR/next"
    git fetch origin master
    git reset --hard origin/master
    echo "Git pull next: OK ($(git rev-parse --short HEAD))"

    npm ci --production=false
    NEXT_PUBLIC_API_URL= npm run build
    echo "Next.js build: OK"

    sudo systemctl restart orchestra-next
    for i in $(seq 1 15); do
        if curl -sf http://localhost:3000 > /dev/null 2>&1; then
            echo "Next.js: healthy (attempt $i)"
            return 0
        fi
        if [ "$i" -eq 15 ]; then
            echo "FATAL: Next.js health check failed"
            sudo journalctl -u orchestra-next --no-pager -n 50
            exit 1
        fi
        sleep 2
    done
}

case "$COMPONENT" in
    web)  deploy_web ;;
    next) deploy_next ;;
    all)  deploy_web; deploy_next ;;
    *)    echo "Usage: $0 [web|next|all]"; exit 1 ;;
esac

echo "=== Deploy ($COMPONENT) completed at $(date -u +%Y-%m-%dT%H:%M:%SZ) ==="
DEPLOYEOF
chmod +x $APP_DIR/deploy.sh
chown $DEPLOY_USER:$DEPLOY_USER $APP_DIR/deploy.sh

# Harden SSH
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl reload sshd

echo ""
echo "═══════════════════════════════════════════════════"
echo "  Setup Complete!"
echo "═══════════════════════════════════════════════════"
echo ""
echo "  Database: $DB_NAME (user: $DB_USER)"
echo "  DB Password: $DB_PASS"
echo "  JWT Secret: $JWT_SECRET"
echo "  Env file: $APP_DIR/shared/.env"
echo ""
echo "  Server layout:"
echo "    /opt/orchestra/web/    ← orchestra-mcp/web (Go backend)"
echo "    /opt/orchestra/next/   ← orchestra-mcp/next (Next.js)"
echo "    /opt/orchestra/shared/.env"
echo "    /opt/orchestra/deploy.sh [web|next|all]"
echo ""
echo "  ┌─────────────────────────────────────────────────┐"
echo "  │              NEXT STEPS (manual)                 │"
echo "  ├─────────────────────────────────────────────────┤"
echo "  │                                                  │"
echo "  │ 1. Add your SSH public key:                      │"
echo "  │    cat ~/.ssh/id_ed25519.pub >> \\               │"
echo "  │      /home/$DEPLOY_USER/.ssh/authorized_keys     │"
echo "  │                                                  │"
echo "  │ 2. Edit /etc/caddy/Caddyfile:                    │"
echo "  │    Replace 'yourdomain.com' with your domain     │"
echo "  │                                                  │"
echo "  │ 3. Create Cloudflare API token:                  │"
echo "  │    dash.cloudflare.com/profile/api-tokens         │"
echo "  │    Permission: Zone > DNS > Edit                  │"
echo "  │    Edit CF_API_TOKEN in $APP_DIR/shared/.env      │"
echo "  │                                                  │"
echo "  │ 4. Cloudflare DNS:                                │"
echo "  │    A record: yourdomain.com -> server IP          │"
echo "  │    Proxy: ON (orange cloud)                       │"
echo "  │    SSL/TLS mode: Full (strict)                    │"
echo "  │                                                  │"
echo "  │ 5. First deploy:                                  │"
echo "  │    su - $DEPLOY_USER                              │"
echo "  │    /opt/orchestra/deploy.sh all                   │"
echo "  │                                                  │"
echo "  │ 6. Start Caddy:                                   │"
echo "  │    systemctl start caddy                          │"
echo "  │                                                  │"
echo "  │ 7. GitHub Actions secrets (add to BOTH repos):    │"
echo "  │    VPS_HOST=<server IP>                           │"
echo "  │    VPS_USER=$DEPLOY_USER                          │"
echo "  │    VPS_SSH_KEY=<ed25519 private key>              │"
echo "  │    VPS_SSH_PORT=22                                │"
echo "  │                                                  │"
echo "  └─────────────────────────────────────────────────┘"
echo ""
echo "  SAVE THESE CREDENTIALS — they won't be shown again!"
echo ""

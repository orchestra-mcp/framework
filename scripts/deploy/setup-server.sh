#!/usr/bin/env bash
# Orchestra Web — One-time server setup for Ubuntu 24.04 LTS
# Run as root: bash setup-server.sh
set -euo pipefail

# ═══════════════════════════════════════════════════════════════
# Configuration
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
GO_VERSION="1.24.4"
NODE_MAJOR="22"

echo "═══════════════════════════════════════════════════"
echo "  Orchestra Web — Server Setup (Ubuntu 24.04)"
echo "═══════════════════════════════════════════════════"

if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: This script must be run as root"
    exit 1
fi

# ── 1. System update ──
echo ""
echo "--- [1/12] Updating system packages ---"
apt-get update && apt-get upgrade -y
apt-get install -y curl wget git build-essential unzip software-properties-common ca-certificates gnupg

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
fi

# ── 3. Install Go ──
echo ""
echo "--- [3/12] Installing Go $GO_VERSION ---"
if command -v go &>/dev/null && go version | grep -q "go${GO_VERSION}"; then
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
    export PATH=$PATH:/usr/local/go/bin
    echo "Installed: $(/usr/local/go/bin/go version)"
fi

# ── 4. Install Node.js ──
echo ""
echo "--- [4/12] Installing Node.js $NODE_MAJOR LTS ---"
if command -v node &>/dev/null && node -v | grep -q "v${NODE_MAJOR}"; then
    echo "Node.js $NODE_MAJOR already installed, skipping"
else
    curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash -
    apt-get install -y nodejs
    echo "Installed: $(node -v), npm $(npm -v)"
fi

# ── 5. Install PostgreSQL 16 ──
echo ""
echo "--- [5/12] Installing PostgreSQL 16 ---"
if systemctl is-active --quiet postgresql; then
    echo "PostgreSQL already running, skipping install"
else
    install -d /usr/share/postgresql-common/pgdg
    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc
    echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt noble-pgdg main" > /etc/apt/sources.list.d/pgdg.list
    apt-get update
    apt-get install -y postgresql-16
    systemctl enable postgresql
    systemctl start postgresql
    echo "PostgreSQL 16 installed and running"
fi

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
    export PATH=$PATH:/usr/local/go/bin
    GOBIN=/usr/local/bin go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
    cd /tmp
    /usr/local/bin/xcaddy build --with github.com/caddy-dns/cloudflare
    mv caddy /usr/bin/caddy
    chmod +x /usr/bin/caddy

    groupadd --system caddy 2>/dev/null || true
    useradd --system --gid caddy --create-home --home-dir /var/lib/caddy --shell /usr/sbin/nologin caddy 2>/dev/null || true

    cat > /etc/systemd/system/caddy.service << 'EOF'
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
EOF

    mkdir -p /etc/caddy /var/log/caddy
    chown caddy:caddy /var/log/caddy
    echo "Caddy installed: $(caddy version)"
fi

# ── 7. Configure UFW firewall ──
echo ""
echo "--- [7/12] Configuring firewall ---"
apt-get install -y ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp comment 'SSH'
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'
ufw allow 443/udp comment 'HTTP3 QUIC'
echo "y" | ufw enable
echo "Firewall: OK"

# ── 8. Create application directories ──
echo ""
echo "--- [8/12] Creating application directories ---"
mkdir -p $APP_DIR/web $APP_DIR/next $APP_DIR/shared $APP_DIR/backups /var/log/orchestra
chown -R $DEPLOY_USER:$DEPLOY_USER $APP_DIR /var/log/orchestra

# ── 9. Clone repositories ──
echo ""
echo "--- [9/12] Cloning repositories ---"
if [ -d "$APP_DIR/web/.git" ]; then
    echo "Web repo already cloned, pulling latest"
    su - $DEPLOY_USER -c "cd $APP_DIR/web && git pull origin $REPO_BRANCH"
else
    su - $DEPLOY_USER -c "git clone --branch $REPO_BRANCH $WEB_REPO_URL $APP_DIR/web"
fi

if [ -d "$APP_DIR/next/.git" ]; then
    echo "Next repo already cloned, pulling latest"
    su - $DEPLOY_USER -c "cd $APP_DIR/next && git pull origin $REPO_BRANCH"
else
    su - $DEPLOY_USER -c "git clone --branch $REPO_BRANCH $NEXT_REPO_URL $APP_DIR/next"
fi

# ── 10. Create environment file ──
echo ""
echo "--- [10/12] Creating environment file ---"
cat > $APP_DIR/shared/.env << ENVEOF
DATABASE_URL=postgres://$DB_USER:$DB_PASS@localhost:5432/$DB_NAME?sslmode=disable
JWT_SECRET=$JWT_SECRET
APP_ENV=production
CF_API_TOKEN=CHANGEME
ENVEOF

chmod 600 $APP_DIR/shared/.env
chown $DEPLOY_USER:$DEPLOY_USER $APP_DIR/shared/.env

# ── 11. Install systemd services + Caddyfile ──
echo ""
echo "--- [11/12] Installing service files ---"

cat > /etc/systemd/system/orchestra-web.service << 'EOF'
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
EnvironmentFile=/opt/orchestra/shared/.env
KillSignal=SIGTERM
TimeoutStopSec=15
NoNewPrivileges=true
StandardOutput=journal
StandardError=journal
SyslogIdentifier=orchestra-web

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/orchestra-next.service << 'EOF'
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
Environment=NODE_ENV=production
Environment=PORT=3000
Environment=NEXT_PUBLIC_API_URL=
StandardOutput=journal
StandardError=journal
SyslogIdentifier=orchestra-next
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/caddy/Caddyfile << 'EOF'
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
EOF

systemctl daemon-reload
systemctl enable orchestra-web orchestra-next caddy

# ── 12. Final setup ──
echo ""
echo "--- [12/12] Final setup (swap, sudoers, backups, deploy script) ---"

# 2GB swap
if [ ! -f /swapfile ]; then
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    echo "Swap: 2GB created"
fi

# Sudoers
cat > /etc/sudoers.d/orchestra << 'EOF'
deploy ALL=(ALL) NOPASSWD: /bin/systemctl restart orchestra-web
deploy ALL=(ALL) NOPASSWD: /bin/systemctl restart orchestra-next
deploy ALL=(ALL) NOPASSWD: /bin/systemctl reload caddy
deploy ALL=(ALL) NOPASSWD: /bin/systemctl status orchestra-web
deploy ALL=(ALL) NOPASSWD: /bin/systemctl status orchestra-next
deploy ALL=(ALL) NOPASSWD: /usr/bin/journalctl -u orchestra-web *
deploy ALL=(ALL) NOPASSWD: /usr/bin/journalctl -u orchestra-next *
EOF
chmod 440 /etc/sudoers.d/orchestra

# Daily backup
cat > /etc/cron.d/orchestra-backup << CRONEOF
0 3 * * * $DEPLOY_USER pg_dump -U $DB_USER $DB_NAME | gzip > $APP_DIR/backups/db-\$(date +\%Y\%m\%d).sql.gz
0 4 * * * $DEPLOY_USER find $APP_DIR/backups -name "db-*.sql.gz" -mtime +30 -delete
CRONEOF

# Deploy script
cat > $APP_DIR/deploy.sh << 'DEPLOYEOF'
#!/usr/bin/env bash
set -euo pipefail
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

COMPONENT="${1:-all}"
APP_DIR="/opt/orchestra"
LOG_DIR="/var/log/orchestra"
LOG_FILE="${LOG_DIR}/deploy-$(date +%Y%m%d-%H%M%S).log"
mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Deploy ($COMPONENT) at $(date -u +%Y-%m-%dT%H:%M:%SZ) ==="

deploy_web() {
    echo "--- Go backend ---"
    cd "$APP_DIR/web"
    git fetch origin master && git reset --hard origin/master
    mkdir -p bin
    go build -buildvcs=false -o bin/web-new ./cmd/
    mv bin/web-new bin/web
    sudo systemctl restart orchestra-web
    for i in $(seq 1 15); do
        curl -sf http://localhost:8080/health > /dev/null 2>&1 && echo "API: healthy" && return 0
        [ "$i" -eq 15 ] && echo "FATAL: API health check failed" && sudo journalctl -u orchestra-web --no-pager -n 30 && exit 1
        sleep 2
    done
}

deploy_next() {
    echo "--- Next.js ---"
    cd "$APP_DIR/next"
    git fetch origin master && git reset --hard origin/master
    npm ci --production=false
    NEXT_PUBLIC_API_URL= npm run build
    sudo systemctl restart orchestra-next
    for i in $(seq 1 15); do
        curl -sf http://localhost:3000 > /dev/null 2>&1 && echo "Next.js: healthy" && return 0
        [ "$i" -eq 15 ] && echo "FATAL: Next.js health check failed" && sudo journalctl -u orchestra-next --no-pager -n 30 && exit 1
        sleep 2
    done
}

case "$COMPONENT" in
    web)  deploy_web ;;
    next) deploy_next ;;
    all)  deploy_web; deploy_next ;;
    *)    echo "Usage: $0 [web|next|all]"; exit 1 ;;
esac

echo "=== Done ==="
DEPLOYEOF
chmod +x $APP_DIR/deploy.sh
chown $DEPLOY_USER:$DEPLOY_USER $APP_DIR/deploy.sh

# Harden SSH
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl reload sshd

SERVER_IP=$(curl -4s ifconfig.me 2>/dev/null || echo "YOUR_IP")

echo ""
echo "═══════════════════════════════════════════════════"
echo "  SETUP COMPLETE"
echo "═══════════════════════════════════════════════════"
echo ""
echo "  DB Password: $DB_PASS"
echo "  JWT Secret:  $JWT_SECRET"
echo "  Env file:    $APP_DIR/shared/.env"
echo ""
echo "  SAVE THESE NOW — they won't be shown again!"
echo ""
echo "═══════════════════════════════════════════════════"
echo "  NEXT STEPS"
echo "═══════════════════════════════════════════════════"
echo ""
echo "  1. Edit Caddyfile — set your domain:"
echo "     nano /etc/caddy/Caddyfile"
echo ""
echo "  2. Set Cloudflare API token:"
echo "     nano $APP_DIR/shared/.env"
echo "     # Set CF_API_TOKEN=your_token"
echo ""
echo "  3. Cloudflare DNS:"
echo "     A record: yourdomain.com -> $SERVER_IP (Proxied)"
echo "     SSL/TLS: Full (strict)"
echo ""
echo "  4. First deploy:"
echo "     su - deploy"
echo "     /opt/orchestra/deploy.sh all"
echo ""
echo "  5. Start Caddy:"
echo "     systemctl start caddy"
echo ""
echo "  6. GitHub secrets (add to BOTH web + next repos):"
echo "     VPS_HOST=$SERVER_IP"
echo "     VPS_USER=deploy"
echo "     VPS_SSH_KEY=<generate with: ssh-keygen -t ed25519>"
echo "     VPS_SSH_PORT=22"
echo ""

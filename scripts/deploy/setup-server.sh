#!/usr/bin/env bash
# Orchestra Web — One-time Ubuntu VPS setup
# Run as root on a fresh Ubuntu 22.04/24.04 server:
#   curl -sSL https://raw.githubusercontent.com/orchestra-mcp/orchestra-agents/master/scripts/deploy/setup-server.sh | bash
# Or copy and run manually.
set -euo pipefail

# ═══════════════════════════════════════════════════════════════
# Configuration — edit these before running
# ═══════════════════════════════════════════════════════════════
DEPLOY_USER="deploy"
REPO_URL="https://github.com/orchestra-mcp/orchestra-agents.git"
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
apt install -y curl wget git build-essential unzip software-properties-common

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
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
    apt update
    apt install -y postgresql-16
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
mkdir -p $APP_DIR/repo $APP_DIR/shared $APP_DIR/backups /var/log/orchestra
chown -R $DEPLOY_USER:$DEPLOY_USER $APP_DIR /var/log/orchestra

# ── 9. Clone repository ──
echo ""
echo "--- [9/12] Cloning repository ---"
if [ -d "$APP_DIR/repo/.git" ]; then
    echo "Repository already cloned, pulling latest"
    cd $APP_DIR/repo
    su - $DEPLOY_USER -c "cd $APP_DIR/repo && git pull origin $REPO_BRANCH"
else
    su - $DEPLOY_USER -c "git clone --branch $REPO_BRANCH $REPO_URL $APP_DIR/repo"
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
cp $APP_DIR/repo/scripts/deploy/orchestra-web.service /etc/systemd/system/
cp $APP_DIR/repo/scripts/deploy/orchestra-next.service /etc/systemd/system/
cp $APP_DIR/repo/scripts/deploy/Caddyfile /etc/caddy/Caddyfile

systemctl daemon-reload
systemctl enable orchestra-web orchestra-next caddy

# Make deploy script executable
chmod +x $APP_DIR/repo/scripts/deploy/deploy.sh

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
echo "  │    A record → yourdomain.com → $(curl -4s ifconfig.me)    │"
echo "  │    Proxy: ON (orange cloud)                       │"
echo "  │    SSL/TLS mode: Full (strict)                    │"
echo "  │                                                  │"
echo "  │ 5. Run first deploy:                              │"
echo "  │    su - $DEPLOY_USER -c \\                       │"
echo "  │      '$APP_DIR/repo/scripts/deploy/deploy.sh'    │"
echo "  │                                                  │"
echo "  │ 6. Start Caddy:                                   │"
echo "  │    systemctl start caddy                          │"
echo "  │                                                  │"
echo "  │ 7. GitHub Actions secrets:                        │"
echo "  │    VPS_HOST=$(curl -4s ifconfig.me)               │"
echo "  │    VPS_USER=$DEPLOY_USER                          │"
echo "  │    VPS_SSH_KEY=<ed25519 private key>              │"
echo "  │    VPS_SSH_PORT=22                                │"
echo "  │                                                  │"
echo "  └─────────────────────────────────────────────────┘"
echo ""
echo "  SAVE THESE CREDENTIALS — they won't be shown again!"
echo ""

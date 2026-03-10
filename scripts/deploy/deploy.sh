#!/usr/bin/env bash
# Orchestra Web — Zero-downtime deployment script
# Called by GitHub Actions via SSH, or manually: ssh deploy@vps '/opt/orchestra/repo/scripts/deploy/deploy.sh'
set -euo pipefail

REPO_DIR="/opt/orchestra/repo"
ENV_FILE="/opt/orchestra/shared/.env"
LOG_DIR="/var/log/orchestra"
LOG_FILE="${LOG_DIR}/deploy-$(date +%Y%m%d-%H%M%S).log"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Orchestra Deploy started at $(date -u +%Y-%m-%dT%H:%M:%SZ) ==="

# ── Step 1: Pull latest code ──
echo "--- Pulling latest code ---"
cd "$REPO_DIR"
git fetch origin master
git reset --hard origin/master
echo "Git pull: OK ($(git rev-parse --short HEAD))"

# ── Step 2: Build Go backend (BEFORE restarting anything) ──
echo "--- Building Go backend ---"
cd "$REPO_DIR/apps/web"
go build -o bin/web-new ./cmd/
echo "Go build: OK"

# ── Step 3: Build Next.js frontend (BEFORE restarting anything) ──
echo "--- Building Next.js frontend ---"
cd "$REPO_DIR/apps/next"
npm ci --production=false
# Write .env from shared config (populated by GitHub Actions secrets)
if [ -f "$ENV_FILE" ]; then
    cp "$ENV_FILE" .env.local
    echo "Env file: copied from $ENV_FILE"
fi
npm run build
echo "Next.js build: OK"

# ── Step 4: Atomic swap Go binary ──
cd "$REPO_DIR/apps/web"
mv bin/web-new bin/web
echo "Binary swap: OK"

# ── Step 4b: Sync docs to web dir (for wiki scanner) ──
rsync -a --delete "$REPO_DIR/docs/" /opt/orchestra/web/docs/
echo "Docs sync: OK"

# ── Step 5: Restart Go backend + health check ──
echo "--- Restarting orchestra-web ---"
sudo systemctl restart orchestra-web
for i in $(seq 1 15); do
    if curl -sf http://localhost:8080/health > /dev/null 2>&1; then
        echo "Go backend: healthy (attempt $i)"
        break
    fi
    if [ "$i" -eq 15 ]; then
        echo "FATAL: Go backend health check failed after 15 attempts"
        sudo journalctl -u orchestra-web --no-pager -n 50
        exit 1
    fi
    sleep 2
done

# ── Step 6: Restart Next.js + health check ──
echo "--- Restarting orchestra-next ---"
sudo systemctl restart orchestra-next
for i in $(seq 1 15); do
    if curl -sf http://localhost:3000 > /dev/null 2>&1; then
        echo "Next.js: healthy (attempt $i)"
        break
    fi
    if [ "$i" -eq 15 ]; then
        echo "FATAL: Next.js health check failed after 15 attempts"
        sudo journalctl -u orchestra-next --no-pager -n 50
        exit 1
    fi
    sleep 2
done

echo "=== Deploy completed at $(date -u +%Y-%m-%dT%H:%M:%SZ) ==="
echo "=== Commit: $(cd "$REPO_DIR" && git rev-parse --short HEAD) ==="

#!/usr/bin/env bash
# sync-components.sh — Create GitHub repos, push, and publish @orchestra-mcp/* npm packages.
# Follows the same pattern as sync-repos.sh.
#
# Usage:
#   ./scripts/sync-components.sh                    # Sync + publish all
#   ./scripts/sync-components.sh ui theme icons     # Sync specific packages only
#   ./scripts/sync-components.sh --dry-run          # Preview without pushing
#   ./scripts/sync-components.sh --message "fix X"  # Custom commit message
#   ./scripts/sync-components.sh --no-publish       # Push repos only, skip npm publish
#   ./scripts/sync-components.sh --create-only      # Create repos only, no push/publish

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="${ROOT}/apps/components"
GITHUB_ORG="orchestra-mcp"
BRANCH="main"
VERSION="1.0.0"
DRY_RUN=false
NO_PUBLISH=false
CREATE_ONLY=false
MSG=""

# Load NPM_TOKEN from .env if not already set
if [[ -z "${NPM_TOKEN:-}" ]] && [[ -f "${ROOT}/.env" ]]; then
  NPM_TOKEN=$(grep -E '^NPM_TOKEN=' "${ROOT}/.env" | cut -d'=' -f2- | tr -d '"' | tr -d "'")
  export NPM_TOKEN
fi

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
info()  { printf "${CYAN}[sync]${NC}  %s\n" "$*"; }
ok()    { printf "${GREEN}[done]${NC}  %s\n" "$*"; }
warn()  { printf "${YELLOW}[skip]${NC}  %s\n" "$*"; }
fail()  { printf "${RED}[fail]${NC}  %s\n" "$*" >&2; }
step()  { printf "\n${BOLD}═══ %s ═══${NC}\n\n" "$*"; }

# Package definitions: name|description|tier
# Tiers control publish order (leaf first)
PACKAGES=(
  "ui|Orchestra MCP UI component library — desktop-first React components|1"
  "icons|React SVG icon components for Orchestra MCP|1"
  "theme|Color themes and CSS variables for Orchestra MCP — Tailwind CSS v4|1"
  "search|Search spotlight component for Orchestra MCP|1"
  "voice|Voice UI components for Orchestra MCP|1"
  "widgets|Utility widget components for Orchestra MCP|2"
  "editor|Code and Markdown editor components for Orchestra MCP|3"
  "ai|AI chat and copilot components for Orchestra MCP|4"
  "tasks|Task management UI components for Orchestra MCP|4"
  "devtools|Developer tools components for Orchestra MCP — terminal, debugger|4"
)

# Parse args
FILTER=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)      DRY_RUN=true; shift ;;
    --no-publish)   NO_PUBLISH=true; shift ;;
    --create-only)  CREATE_ONLY=true; shift ;;
    --message)      MSG="$2"; shift 2 ;;
    --help|-h)
      echo "Usage: $0 [--dry-run] [--no-publish] [--create-only] [--message \"msg\"] [pkg ...]"
      echo ""
      echo "Packages:"
      for entry in "${PACKAGES[@]}"; do
        IFS='|' read -r n d t <<< "$entry"
        printf "  %-15s %s (tier %s)\n" "$n" "$d" "$t"
      done
      exit 0
      ;;
    -*) fail "Unknown flag: $1"; exit 1 ;;
    *)  FILTER+=("$1"); shift ;;
  esac
done

# Preflight
command -v gh &>/dev/null || { fail "gh CLI not found"; exit 1; }
command -v git &>/dev/null || { fail "git not found"; exit 1; }

TIMESTAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"
COMMIT_MSG="${MSG:-Initial release v${VERSION}}"

# Filter packages if specific ones requested
TARGETS=()
if [[ ${#FILTER[@]} -gt 0 ]]; then
  for filter in "${FILTER[@]}"; do
    found=false
    for entry in "${PACKAGES[@]}"; do
      IFS='|' read -r n d t <<< "$entry"
      if [[ "$n" == "$filter" ]]; then
        TARGETS+=("$entry")
        found=true
        break
      fi
    done
    if ! $found; then
      fail "Unknown package: $filter"
      exit 1
    fi
  done
else
  TARGETS=("${PACKAGES[@]}")
fi

count=${#TARGETS[@]}
info "Processing ${count} package(s)"
$DRY_RUN && warn "DRY RUN — no changes will be pushed"
echo ""

CREATED=0; SYNCED=0; PUBLISHED=0; ERRORS=0

for entry in "${TARGETS[@]}"; do
  IFS='|' read -r NAME DESC TIER <<< "$entry"

  src="${SRC_DIR}/${NAME}"
  prepared="/tmp/orchestra-npm-${NAME}"

  if [[ ! -d "$prepared" ]]; then
    fail "${NAME}: prepared dir not found at ${prepared}. Run scripts/publish-components.sh first."
    ERRORS=$((ERRORS + 1))
    continue
  fi

  step "Tier ${TIER}: @orchestra-mcp/${NAME}"

  # ── Step 1: Create GitHub repo if it doesn't exist ──
  repo_url="https://github.com/${GITHUB_ORG}/${NAME}"
  if gh repo view "${GITHUB_ORG}/${NAME}" &>/dev/null; then
    info "${NAME}: repo already exists"
  else
    info "${NAME}: creating repo ${GITHUB_ORG}/${NAME}"
    if $DRY_RUN; then
      info "${NAME}: would create repo"
    else
      gh repo create "${GITHUB_ORG}/${NAME}" \
        --public \
        --description "${DESC}" \
        --clone=false
      ok "${NAME}: repo created"
      CREATED=$((CREATED + 1))
      # Small delay for GitHub API
      sleep 2
    fi
  fi

  $CREATE_ONLY && continue

  # ── Step 2: Push to repo (sync-repos.sh pattern) ──
  tmp="$(mktemp -d)"

  # Try to clone existing repo; if new repo (empty), init fresh
  if git clone --quiet --branch "${BRANCH}" "${repo_url}.git" "${tmp}/repo" 2>/dev/null; then
    info "${NAME}: cloned existing repo"
    cd "${tmp}/repo"
    git pull --quiet origin "${BRANCH}" 2>/dev/null || true
    # Replace contents (keep .git from clone)
    find "${tmp}/repo" -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +
  else
    # Empty/new repo — init from scratch
    info "${NAME}: initializing new repo"
    mkdir -p "${tmp}/repo"
    cd "${tmp}/repo"
    git init --quiet
    git checkout -b "${BRANCH}" 2>/dev/null || true
    git remote add origin "${repo_url}.git"
  fi

  # Copy prepared content (excludes .git)
  rsync -a --exclude '.git' "${prepared}/" "${tmp}/repo/"

  # Remove .npmrc (contains token — don't push to GitHub)
  rm -f "${tmp}/repo/.npmrc"

  git add -A

  if git diff --cached --quiet 2>/dev/null; then
    warn "${NAME}: no changes"
  else
    changes="$(git diff --cached --stat 2>/dev/null | tail -1 || echo 'new files')"
    info "${NAME}: ${changes}"

    if $DRY_RUN; then
      info "${NAME}: would push"
      SYNCED=$((SYNCED + 1))
    else
      git commit -m "${COMMIT_MSG}" --quiet
      if ! git push origin "${BRANCH}" --quiet 2>/dev/null; then
        # Push failed — force push (we are source of truth for new packages)
        warn "${NAME}: push failed, force pushing..."
        git push origin "${BRANCH}" --force --quiet 2>/dev/null || {
          fail "${NAME}: force push also failed"
          ERRORS=$((ERRORS + 1))
          cd "${ROOT}"
          rm -rf "$tmp"
          continue
        }
      fi
      ok "${NAME}: pushed to ${GITHUB_ORG}/${NAME}"
      SYNCED=$((SYNCED + 1))

      # Tag the release
      git tag "v${VERSION}" 2>/dev/null || true
      git push origin "v${VERSION}" --quiet 2>/dev/null || true
    fi
  fi

  cd "${ROOT}"
  rm -rf "$tmp"

  # ── Step 3: Publish to npm ──
  if ! $NO_PUBLISH && ! $DRY_RUN; then
    info "${NAME}: publishing to npm..."
    cd "${prepared}"
    # Write .npmrc for auth (not committed to git)
    echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > .npmrc
    if npm publish --access public --ignore-scripts 2>/dev/null; then
      ok "${NAME}: published @orchestra-mcp/${NAME}@${VERSION}"
      PUBLISHED=$((PUBLISHED + 1))
    else
      warn "${NAME}: npm publish failed (may already exist)"
    fi
    cd "${ROOT}"
  elif $DRY_RUN; then
    info "${NAME}: would publish @orchestra-mcp/${NAME}@${VERSION}"
    PUBLISHED=$((PUBLISHED + 1))
  fi

  echo ""
done

# Summary
echo ""
echo "────────────────────────────────"
ok "Created: ${CREATED}  Synced: ${SYNCED}  Published: ${PUBLISHED}  Failed: ${ERRORS}"
[[ $ERRORS -gt 0 ]] && exit 1
exit 0

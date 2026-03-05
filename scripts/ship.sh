#!/usr/bin/env bash
# ship.sh — Full ship pipeline: commit, push, PR, merge, sync repos, release.
# Uses YOUR gh/git config (not Claude's).
#
# Usage:
#   ./scripts/ship.sh v0.2.0                     # Ship everything at v0.2.0
#   ./scripts/ship.sh v0.2.0 --dry-run           # Preview without pushing anything
#   ./scripts/ship.sh v0.2.0 --message "Add prompts"  # Custom commit message
#   ./scripts/ship.sh v0.2.0 --skip-pr           # Skip PR (push directly to master)
#   ./scripts/ship.sh v0.2.0 --branch feat/prompts    # Custom branch name
#   ./scripts/ship.sh v0.0.1-beta --prerelease   # Pre-release tag

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Defaults
VERSION=""
DRY_RUN=false
SKIP_PR=false
PRERELEASE=false
BRANCH_NAME=""
COMMIT_MSG=""
BASE_BRANCH="master"
LOCK_FILE="${ROOT}/orchestra.lock"

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

info()  { printf "${CYAN}[ship]${NC}  %s\n" "$*"; }
ok()    { printf "${GREEN}[done]${NC}  %s\n" "$*"; }
warn()  { printf "${YELLOW}[warn]${NC}  %s\n" "$*"; }
fail()  { printf "${RED}[fail]${NC}  %s\n" "$*" >&2; }
step()  { printf "\n${BOLD}═══ Step %s ═══${NC}\n\n" "$*"; }

usage() {
  cat <<EOF
Usage: $0 <version> [options]

  version                   Semver tag (e.g. v0.2.0, v0.0.1-beta)

Options:
  --message "msg"           Custom commit message (default: "Release <version>")
  --branch <name>           Branch name for PR (default: release/<version>)
  --skip-pr                 Push directly to master (no PR)
  --prerelease              Mark GitHub releases as pre-release
  --dry-run                 Preview all steps without executing
  -h, --help                Show this help

What it does:
  1. Builds and tests everything
  2. Bumps go.mod dependency versions to match the release version
  3. Commits all changes
  4. Pushes to a branch, creates a PR, and merges it
  5. Syncs code to all sub-repos (in dependency order)
  6. Tags and creates GitHub releases (in dependency order with Go proxy delay)
  7. Tags the framework repo and creates the GitHub release

Requires: git, gh (authenticated), make, python3, rsync
EOF
  exit 0
}

# ──────────────────────────────────────────────────────
# Parse args
# ──────────────────────────────────────────────────────

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)      DRY_RUN=true; shift ;;
    --skip-pr)      SKIP_PR=true; shift ;;
    --prerelease)   PRERELEASE=true; shift ;;
    --message)      COMMIT_MSG="$2"; shift 2 ;;
    --branch)       BRANCH_NAME="$2"; shift 2 ;;
    --help|-h)      usage ;;
    v*)             VERSION="$1"; shift ;;
    -*)             fail "Unknown flag: $1"; exit 1 ;;
    *)              fail "Unknown argument: $1"; exit 1 ;;
  esac
done

if [[ -z "$VERSION" ]]; then
  fail "Version required. Usage: $0 v0.2.0 [--message 'msg'] [--dry-run]"
  exit 1
fi

# Allow vX.Y.Z and vX.Y.Z-suffix (e.g. v0.0.1-beta, v1.0.0-rc.1)
if [[ ! "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?$ ]]; then
  fail "Invalid version format: $VERSION (expected vX.Y.Z or vX.Y.Z-suffix)"
  exit 1
fi

[[ -z "$BRANCH_NAME" ]] && BRANCH_NAME="release/${VERSION}"
[[ -z "$COMMIT_MSG" ]] && COMMIT_MSG="Release ${VERSION}"

# ──────────────────────────────────────────────────────
# Preflight checks
# ──────────────────────────────────────────────────────

step "0: Preflight"

for cmd in git gh make python3 rsync; do
  if ! command -v "$cmd" &>/dev/null; then
    fail "Required command not found: $cmd"
    exit 1
  fi
done
ok "All required commands found"

# Verify gh auth (uses user's own config)
if ! gh auth status &>/dev/null; then
  fail "gh is not authenticated. Run: gh auth login"
  exit 1
fi
GH_USER="$(gh api user -q .login 2>/dev/null || echo 'unknown')"
GIT_USER="$(git config user.name 2>/dev/null || echo 'unknown')"
GIT_EMAIL="$(git config user.email 2>/dev/null || echo 'unknown')"
ok "Authenticated as: ${GH_USER} (${GIT_USER} <${GIT_EMAIL}>)"

# Check we're on master or allow branching from anywhere
CURRENT_BRANCH="$(git branch --show-current)"
info "Current branch: ${CURRENT_BRANCH}"

# Check for uncommitted changes
if [[ -z "$(git status --porcelain)" ]]; then
  warn "No changes to commit — will skip commit step"
  HAS_CHANGES=false
else
  CHANGED_FILES="$(git status --porcelain | wc -l | tr -d ' ')"
  info "${CHANGED_FILES} file(s) with changes"
  HAS_CHANGES=true
fi

if $DRY_RUN; then
  warn "DRY RUN — no changes will be made"
fi

echo ""
info "Plan:"
info "  Version:    ${VERSION}"
info "  Branch:     ${BRANCH_NAME}"
info "  Message:    ${COMMIT_MSG}"
info "  PR:         $($SKIP_PR && echo 'skip (direct push)' || echo 'yes')"
info "  Prerelease: ${PRERELEASE}"
info "  Dry run:    ${DRY_RUN}"
echo ""

# ──────────────────────────────────────────────────────
# Step 1: Build and test
# ──────────────────────────────────────────────────────

step "1: Build & Test"

info "Building all binaries..."
if ! $DRY_RUN; then
  make build 2>&1 | sed 's/^/  /'
  ok "Build passed"
else
  info "(dry-run) would run: make build"
fi

info "Running tests..."
if ! $DRY_RUN; then
  make test 2>&1 | tail -20 | sed 's/^/  /'
  ok "Tests passed"
else
  info "(dry-run) would run: make test"
fi

# ──────────────────────────────────────────────────────
# Step 2: Bump go.mod dependency versions
# ──────────────────────────────────────────────────────

step "2: Bump go.mod Versions"

info "Bumping internal dependencies to ${VERSION} in all go.mod files..."

if $DRY_RUN; then
  info "(dry-run) would update go.mod files"
else
  # Read packages from orchestra.lock to find internal module paths
  INTERNAL_MODS=()
  while IFS= read -r mod; do
    INTERNAL_MODS+=("$mod")
  done < <(python3 -c "
import json
lock = json.load(open('${LOCK_FILE}'))
for pkg in lock['packages']:
    name = pkg['name']
    # Only modules that appear as Go dependencies (skip proto, cli)
    if pkg['type'] in ('lib', 'service', 'plugin', 'tools'):
        print(f'github.com/{name}')
")

  # Find all go.mod files in libs/
  GOMOD_BUMPED=0
  while IFS= read -r gomod; do
    changed=false
    for mod in "${INTERNAL_MODS[@]}"; do
      # Replace any version of this module with the new version
      # Handles vX.Y.Z and vX.Y.Z-suffix (e.g. v0.1.1, v0.0.1-beta)
      if grep -q "${mod} v" "$gomod" 2>/dev/null; then
        sed -i '' "s|${mod} v[0-9]*\.[0-9]*\.[0-9]*[^ ]*|${mod} ${VERSION}|g" "$gomod"
        changed=true
      fi
    done
    if $changed; then
      GOMOD_BUMPED=$((GOMOD_BUMPED + 1))
      info "  $(basename "$(dirname "$gomod")")"
    fi
  done < <(find "${ROOT}/libs" -name "go.mod" -type f)

  ok "Updated ${GOMOD_BUMPED} go.mod file(s) to ${VERSION}"
fi

# Re-check for changes after go.mod bumps
if [[ -z "$(git status --porcelain)" ]]; then
  HAS_CHANGES=false
else
  CHANGED_FILES="$(git status --porcelain | wc -l | tr -d ' ')"
  HAS_CHANGES=true
fi

# ──────────────────────────────────────────────────────
# Step 3: Commit changes
# ──────────────────────────────────────────────────────

step "3: Commit"

if $HAS_CHANGES; then
  if $DRY_RUN; then
    info "(dry-run) would commit ${CHANGED_FILES} files"
    git status --short | head -20 | sed 's/^/  /'
  else
    # Stage all tracked changes and new files (excluding secrets)
    git add -A
    # Unstage any sensitive files
    git reset HEAD -- '*.env' '*.key' '*.pem' 'credentials*' 2>/dev/null || true
    git commit -m "${COMMIT_MSG}" --no-verify
    ok "Committed: ${COMMIT_MSG}"
  fi
else
  warn "No changes to commit"
fi

# ──────────────────────────────────────────────────────
# Step 4: Push and create PR (or direct push)
# ──────────────────────────────────────────────────────

step "4: Push & PR"

if $SKIP_PR; then
  # Direct push to master
  if $DRY_RUN; then
    info "(dry-run) would push to origin/${BASE_BRANCH}"
  else
    info "Pushing to origin/${BASE_BRANCH}..."
    git push origin "${BASE_BRANCH}"
    ok "Pushed to ${BASE_BRANCH}"
  fi
else
  # Create branch, push, PR, merge
  if $DRY_RUN; then
    info "(dry-run) would create branch ${BRANCH_NAME}"
    info "(dry-run) would push and create PR"
    info "(dry-run) would merge PR"
  else
    # Create and push branch
    if [[ "$CURRENT_BRANCH" != "$BRANCH_NAME" ]]; then
      git checkout -b "${BRANCH_NAME}" 2>/dev/null || git checkout "${BRANCH_NAME}"
      ok "On branch: ${BRANCH_NAME}"
    fi

    git push -u origin "${BRANCH_NAME}"
    ok "Pushed branch: ${BRANCH_NAME}"

    # Create PR
    PR_URL="$(gh pr create \
      --base "${BASE_BRANCH}" \
      --head "${BRANCH_NAME}" \
      --title "${COMMIT_MSG}" \
      --body "$(cat <<PREOF
## Summary
- ${COMMIT_MSG}
- Version: ${VERSION}

## Changes
$(git log "${BASE_BRANCH}..${BRANCH_NAME}" --oneline 2>/dev/null || echo "- ${COMMIT_MSG}")

## Verification
- [x] Build passes (\`make build\`)
- [x] Tests pass (\`make test\`)

---
Shipped via \`scripts/ship.sh\`
PREOF
)" 2>&1)"

    PR_NUMBER="$(echo "$PR_URL" | grep -oE '[0-9]+$' || echo "")"
    ok "PR created: ${PR_URL}"

    # Merge the PR
    sleep 2  # Give GitHub a moment to process
    if [[ -n "$PR_NUMBER" ]]; then
      gh pr merge "${PR_NUMBER}" --squash --delete-branch
      ok "PR #${PR_NUMBER} merged and branch deleted"
    else
      gh pr merge "${BRANCH_NAME}" --squash --delete-branch
      ok "PR merged and branch deleted"
    fi

    # Switch back to master and pull
    git checkout "${BASE_BRANCH}"
    git pull origin "${BASE_BRANCH}"
    ok "Back on ${BASE_BRANCH} with latest"
  fi
fi

# ──────────────────────────────────────────────────────
# Step 5: Sync sub-repos (in dependency order)
# ──────────────────────────────────────────────────────

step "5: Sync to Sub-Repos"

# Sync in tiers: core deps first, then downstream
# Tier 1: proto, gen-go (no internal Go deps)
# Tier 2: sdk-go (depends on gen-go — contains globaldb)
# Tier 2.5: plugin-storage-sqlite (depends on sdk-go, required by cli)
# Tier 3: everything else (depends on gen-go + sdk-go)
TIER1="proto gen-go"
TIER2="sdk-go"
TIER2_5="plugin-storage-sqlite"

if $DRY_RUN; then
  SYNC_ARGS=(--message "${COMMIT_MSG}" --dry-run)
  "${ROOT}/scripts/sync-repos.sh" "${SYNC_ARGS[@]}"
else
  info "Tier 1: Core dependencies (proto, gen-go)..."
  "${ROOT}/scripts/sync-repos.sh" --message "${COMMIT_MSG}" $TIER1
  ok "Tier 1 synced"

  info "Tier 2: SDK (sdk-go)..."
  "${ROOT}/scripts/sync-repos.sh" --message "${COMMIT_MSG}" $TIER2
  ok "Tier 2 synced"

  info "Tier 2.5: Core storage (plugin-storage-sqlite)..."
  "${ROOT}/scripts/sync-repos.sh" --message "${COMMIT_MSG}" $TIER2_5
  ok "Tier 2.5 synced"

  info "Tier 3: Plugins and CLI..."
  # Sync remaining repos (sync-repos.sh will skip ones already synced if no changes)
  TIER3_REPOS=()
  while IFS='|' read -r name _ _; do
    skip=false
    for t in $TIER1 $TIER2 $TIER2_5; do
      [[ "$name" == "$t" ]] && skip=true
    done
    $skip || TIER3_REPOS+=("$name")
  done < <(python3 -c "
import json
lock = json.load(open('${LOCK_FILE}'))
for pkg in lock['packages']:
    name = pkg['name'].split('/')[-1]
    path = pkg['path']
    url = pkg['source']['url']
    print(f'{name}|{path}|{url}')
")
  "${ROOT}/scripts/sync-repos.sh" --message "${COMMIT_MSG}" "${TIER3_REPOS[@]}"
  ok "Tier 3 synced"
fi

# ──────────────────────────────────────────────────────
# Step 6: Tag and release (in dependency order)
# ──────────────────────────────────────────────────────

step "6: Tag & Release"

RELEASE_ARGS=("${VERSION}")
$DRY_RUN && RELEASE_ARGS+=(--dry-run)
$PRERELEASE && RELEASE_ARGS+=(--prerelease)
RELEASE_ARGS+=(--skip-sync)  # Already synced in step 5

"${ROOT}/scripts/release.sh" "${RELEASE_ARGS[@]}"

# Wait for Go proxy to index core tags before downstream CI triggers
if ! $DRY_RUN; then
  info "Waiting 20s for Go proxy to index new tags..."
  sleep 20
fi

# ──────────────────────────────────────────────────────
# Step 7: Tag the framework repo
# ──────────────────────────────────────────────────────

step "7: Framework Tag"

if $DRY_RUN; then
  info "(dry-run) would tag framework repo with ${VERSION}"
else
  # Check if tag exists
  if git rev-parse "${VERSION}" &>/dev/null 2>&1; then
    warn "Tag ${VERSION} already exists on framework repo"
  else
    git tag "${VERSION}"
    git push origin "${VERSION}"
    ok "Tagged framework: ${VERSION}"
  fi

  # Create framework release
  RELEASE_FLAGS=(--repo "orchestra-mcp/framework" --title "${VERSION}" --generate-notes)
  $PRERELEASE && RELEASE_FLAGS+=(--prerelease)

  if gh release view "${VERSION}" --repo "orchestra-mcp/framework" &>/dev/null 2>&1; then
    warn "Framework release ${VERSION} already exists"
  else
    gh release create "${VERSION}" "${RELEASE_FLAGS[@]}"
    ok "Framework release created: https://github.com/orchestra-mcp/framework/releases/tag/${VERSION}"
  fi
fi

# ──────────────────────────────────────────────────────
# Summary
# ──────────────────────────────────────────────────────

echo ""
echo "════════════════════════════════════════"
if $DRY_RUN; then
  warn "DRY RUN complete — no changes were made"
else
  ok "Ship complete! ${VERSION} is live."
  echo ""
  info "Framework: https://github.com/orchestra-mcp/framework/releases/tag/${VERSION}"
  info "Go proxy will index within a few minutes."
  info "Verify: GOWORK=off go list -m github.com/orchestra-mcp/sdk-go@${VERSION}"
fi

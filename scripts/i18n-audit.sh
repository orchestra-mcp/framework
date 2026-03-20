#!/usr/bin/env bash
# i18n-audit.sh — Compare EN and AR translation files, report missing keys.
#
# Usage: bash scripts/i18n-audit.sh
#
# Checks:
#   1. Flutter ARB files (apps/flutter/lib/l10n/app_en.arb vs app_ar.arb)
#   2. Next.js message files (apps/next/messages/en.json vs ar.json) if they exist
#
# Output: Lists missing keys in AR that exist in EN, and untranslated values
#         (AR value identical to EN value for non-technical strings).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

total_missing=0
total_untranslated=0

echo "═══════════════════════════════════════════════════"
echo "  Orchestra i18n Audit"
echo "═══════════════════════════════════════════════════"
echo ""

# ── Flutter ARB files ─────────────────────────────────────────────────────

FLUTTER_EN="$ROOT_DIR/apps/flutter/lib/l10n/app_en.arb"
FLUTTER_AR="$ROOT_DIR/apps/flutter/lib/l10n/app_ar.arb"

if [[ -f "$FLUTTER_EN" && -f "$FLUTTER_AR" ]]; then
  echo -e "${YELLOW}Flutter ARB Files${NC}"
  echo "  EN: $FLUTTER_EN"
  echo "  AR: $FLUTTER_AR"
  echo ""

  # Extract keys (skip @-prefixed metadata keys).
  en_keys=$(sed -n 's/^[[:space:]]*"\([a-zA-Z_][a-zA-Z0-9_]*\)".*/\1/p' "$FLUTTER_EN" | tr -d ' "' | grep -v '^@' | sort)
  ar_keys=$(sed -n 's/^[[:space:]]*"\([a-zA-Z_][a-zA-Z0-9_]*\)".*/\1/p' "$FLUTTER_AR" | tr -d ' "' | grep -v '^@' | sort)

  en_count=$(echo "$en_keys" | wc -l | tr -d ' ')
  ar_count=$(echo "$ar_keys" | wc -l | tr -d ' ')

  echo "  EN keys: $en_count"
  echo "  AR keys: $ar_count"

  # Find missing keys (in EN but not in AR).
  missing=$(comm -23 <(echo "$en_keys") <(echo "$ar_keys"))
  missing_count=$(echo "$missing" | grep -c . || true)

  if [[ $missing_count -gt 0 ]]; then
    echo -e "  ${RED}Missing in AR: $missing_count keys${NC}"
    echo "$missing" | head -20 | while read -r key; do
      echo "    - $key"
    done
    if [[ $missing_count -gt 20 ]]; then
      echo "    ... and $((missing_count - 20)) more"
    fi
    total_missing=$((total_missing + missing_count))
  else
    echo -e "  ${GREEN}All EN keys present in AR${NC}"
  fi

  # Check for untranslated values (AR value same as EN value, ignoring technical strings).
  untranslated=0
  while IFS= read -r key; do
    en_val=$(grep "\"$key\":" "$FLUTTER_EN" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*"//;s/".*//')
    ar_val=$(grep "\"$key\":" "$FLUTTER_AR" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*"//;s/".*//')
    # Skip empty, short (<=3 chars), or technical values.
    if [[ -n "$en_val" && -n "$ar_val" && "$en_val" == "$ar_val" && ${#en_val} -gt 3 ]]; then
      # Skip values that look technical (URLs, codes, etc.)
      if [[ ! "$en_val" =~ ^(http|https|ssh|ftp|[A-Z_]+$) ]]; then
        untranslated=$((untranslated + 1))
        if [[ $untranslated -le 10 ]]; then
          echo -e "    ${YELLOW}Untranslated: $key = \"$en_val\"${NC}"
        fi
      fi
    fi
  done <<< "$ar_keys"

  if [[ $untranslated -gt 10 ]]; then
    echo "    ... and $((untranslated - 10)) more potentially untranslated"
  fi
  total_untranslated=$((total_untranslated + untranslated))
  echo ""
else
  echo -e "${RED}Flutter ARB files not found${NC}"
  echo ""
fi

# ── Next.js message files ─────────────────────────────────────────────────

NEXT_EN="$ROOT_DIR/apps/next/messages/en.json"
NEXT_AR="$ROOT_DIR/apps/next/messages/ar.json"

if [[ -f "$NEXT_EN" && -f "$NEXT_AR" ]]; then
  echo -e "${YELLOW}Next.js Message Files${NC}"
  echo "  EN: $NEXT_EN"
  echo "  AR: $NEXT_AR"
  echo ""

  # Extract top-level keys.
  en_web_keys=$(sed -n 's/^[[:space:]]*"\([^"]*\)".*/\1/p' "$NEXT_EN" | tr -d ' "' | sort)
  ar_web_keys=$(sed -n 's/^[[:space:]]*"\([^"]*\)".*/\1/p' "$NEXT_AR" | tr -d ' "' | sort)

  en_web_count=$(echo "$en_web_keys" | wc -l | tr -d ' ')
  ar_web_count=$(echo "$ar_web_keys" | wc -l | tr -d ' ')

  echo "  EN keys: $en_web_count"
  echo "  AR keys: $ar_web_count"

  web_missing=$(comm -23 <(echo "$en_web_keys") <(echo "$ar_web_keys"))
  web_missing_count=$(echo "$web_missing" | grep -c . || true)

  if [[ $web_missing_count -gt 0 ]]; then
    echo -e "  ${RED}Missing in AR: $web_missing_count keys${NC}"
    echo "$web_missing" | head -10 | while read -r key; do
      echo "    - $key"
    done
    total_missing=$((total_missing + web_missing_count))
  else
    echo -e "  ${GREEN}All EN keys present in AR${NC}"
  fi
  echo ""
else
  echo "  Next.js message files not found (skipping)"
  echo ""
fi

# ── Summary ───────────────────────────────────────────────────────────────

echo "═══════════════════════════════════════════════════"
if [[ $total_missing -eq 0 && $total_untranslated -eq 0 ]]; then
  echo -e "  ${GREEN}All translations up to date!${NC}"
else
  echo -e "  Missing keys:      ${RED}$total_missing${NC}"
  echo -e "  Untranslated:      ${YELLOW}$total_untranslated${NC}"
fi
echo "═══════════════════════════════════════════════════"

exit 0

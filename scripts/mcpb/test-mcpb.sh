#!/bin/bash
# test-mcpb.sh — Validate MCPB manifest and build script.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PASS=0
FAIL=0

pass() { echo "  PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL + 1)); }

echo "==> Testing MCPB manifest and build script"

# --- Manifest validation ---

MANIFEST="$SCRIPT_DIR/manifest.json"

# Test 1: Manifest is valid JSON
if python3 -c "import json; json.load(open('$MANIFEST'))" 2>/dev/null; then
    pass "manifest.json is valid JSON"
else
    fail "manifest.json is not valid JSON"
fi

# Test 2: Required fields exist
for field in manifest_version name version description server user_config; do
    if python3 -c "import json; m=json.load(open('$MANIFEST')); assert '$field' in m" 2>/dev/null; then
        pass "manifest has '$field' field"
    else
        fail "manifest missing '$field' field"
    fi
done

# Test 3: manifest_version is 0.3
if python3 -c "import json; m=json.load(open('$MANIFEST')); assert m['manifest_version'] == '0.3'" 2>/dev/null; then
    pass "manifest_version is 0.3"
else
    fail "manifest_version is not 0.3"
fi

# Test 4: server.type is binary
if python3 -c "import json; m=json.load(open('$MANIFEST')); assert m['server']['type'] == 'binary'" 2>/dev/null; then
    pass "server.type is binary"
else
    fail "server.type is not binary"
fi

# Test 5: All 5 platform entry points exist
for platform in darwin-arm64 darwin-x64 linux-arm64 linux-x64 win32-x64; do
    if python3 -c "import json; m=json.load(open('$MANIFEST')); assert '$platform' in m['server']['entry_point']" 2>/dev/null; then
        pass "entry_point has '$platform'"
    else
        fail "entry_point missing '$platform'"
    fi
done

# Test 6: tools_generated is true
if python3 -c "import json; m=json.load(open('$MANIFEST')); assert m['tools_generated'] == True" 2>/dev/null; then
    pass "tools_generated is true"
else
    fail "tools_generated is not true"
fi

# Test 7: user_config.workspace exists and is required
if python3 -c "import json; m=json.load(open('$MANIFEST')); assert m['user_config']['workspace']['required'] == True" 2>/dev/null; then
    pass "user_config.workspace is required"
else
    fail "user_config.workspace is not required"
fi

# Test: name is orchestra-mcp
if python3 -c "import json; m=json.load(open('$MANIFEST')); assert m['name'] == 'orchestra-mcp'" 2>/dev/null; then
    pass "name is orchestra-mcp"
else
    fail "name is not orchestra-mcp"
fi

# Test: display_name is Orchestra MCP
if python3 -c "import json; m=json.load(open('$MANIFEST')); assert m['display_name'] == 'Orchestra MCP'" 2>/dev/null; then
    pass "display_name is Orchestra MCP"
else
    fail "display_name is not Orchestra MCP"
fi

# Test: protocol_version is 2025-06-18
if python3 -c "import json; m=json.load(open('$MANIFEST')); assert m['server']['protocol_version'] == '2025-06-18'" 2>/dev/null; then
    pass "protocol_version is 2025-06-18"
else
    fail "protocol_version is not 2025-06-18"
fi

# Test: capabilities include resources and logging
for cap in tools prompts resources logging; do
    if python3 -c "import json; m=json.load(open('$MANIFEST')); assert m['capabilities']['$cap'] == True" 2>/dev/null; then
        pass "capabilities.$cap is true"
    else
        fail "capabilities.$cap is not true"
    fi
done

# Test: icon.png is a valid PNG
if python3 -c "
f = open('$SCRIPT_DIR/icon.png', 'rb')
assert f.read(8) == b'\\x89PNG\\r\\n\\x1a\\n', 'Not a PNG'
" 2>/dev/null; then
    pass "icon.png is a valid PNG file"
else
    fail "icon.png is not a valid PNG file"
fi

# --- Build script validation ---

BUILD_SCRIPT="$SCRIPT_DIR/build-mcpb.sh"

# Test 8: Build script exists and is executable
if [[ -x "$BUILD_SCRIPT" ]]; then
    pass "build-mcpb.sh is executable"
else
    fail "build-mcpb.sh is not executable"
fi

# Test 9: Build script uses set -euo pipefail
if grep -q 'set -euo pipefail' "$BUILD_SCRIPT"; then
    pass "build-mcpb.sh uses strict mode"
else
    fail "build-mcpb.sh does not use strict mode"
fi

# Test 10: Build script cross-compiles for all 5 targets
for target in "darwin:arm64" "darwin:amd64" "linux:arm64" "linux:amd64" "windows:amd64"; do
    if grep -q "$target" "$BUILD_SCRIPT"; then
        pass "build script targets $target"
    else
        fail "build script missing target $target"
    fi
done

# Test 11: Build script produces .mcpb output
if grep -q 'orchestra.mcpb' "$BUILD_SCRIPT"; then
    pass "build script produces orchestra.mcpb"
else
    fail "build script does not reference orchestra.mcpb"
fi

# Test 12: Icon file exists
if [[ -f "$SCRIPT_DIR/icon.png" ]]; then
    pass "icon.png exists"
else
    fail "icon.png missing"
fi

# --- Makefile validation ---

MAKEFILE="$SCRIPT_DIR/../../Makefile"

# Test 13: Makefile has mcpb target
if grep -q '^mcpb:' "$MAKEFILE"; then
    pass "Makefile has mcpb target"
else
    fail "Makefile missing mcpb target"
fi

# --- Summary ---
echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]

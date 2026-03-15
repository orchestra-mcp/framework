#!/bin/bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/apps/components"
GITHUB_ORG="orchestra-mcp"
VERSION="1.0.0"

# Load NPM_TOKEN from .env
ENV_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/.env"
if [ -f "$ENV_FILE" ]; then
  NPM_TOKEN=$(grep -E '^NPM_TOKEN=' "$ENV_FILE" | cut -d'=' -f2- | tr -d '"' | tr -d "'")
fi
if [ -z "$NPM_TOKEN" ]; then
  echo "ERROR: NPM_TOKEN not found. Set it in .env or export NPM_TOKEN=..."
  exit 1
fi

# Package definitions: name|description|deps (comma-separated @orchestra-mcp/* deps)
PACKAGES=(
  "ui|Orchestra MCP UI component library — desktop-first React components|"
  "icons|React SVG icon components for Orchestra MCP|"
  "theme|Color themes and CSS variables for Orchestra MCP — Tailwind CSS v4|"
  "search|Search spotlight component for Orchestra MCP|"
  "voice|Voice UI components for Orchestra MCP|"
  "widgets|Utility widget components for Orchestra MCP|icons"
  "editor|Code and Markdown editor components for Orchestra MCP|theme,ui,widgets"
  "ai|AI chat and copilot components for Orchestra MCP|editor,icons,ui"
  "tasks|Task management UI components for Orchestra MCP|editor,icons,ui,widgets"
  "devtools|Developer tools components for Orchestra MCP — terminal, debugger|editor,icons,ui"
)

for entry in "${PACKAGES[@]}"; do
  IFS='|' read -r NAME DESC DEPS <<< "$entry"
  PKG_DIR="$ROOT/$NAME"
  WORK_DIR="/tmp/orchestra-npm-$NAME"
  
  echo ""
  echo "============================================"
  echo "Processing @orchestra-mcp/$NAME"
  echo "============================================"
  
  # Clean work dir
  rm -rf "$WORK_DIR"
  mkdir -p "$WORK_DIR"
  
  # Copy source
  if [ -d "$PKG_DIR/src" ]; then
    cp -r "$PKG_DIR/src" "$WORK_DIR/src"
  fi
  
  # Build deps JSON for @orchestra-mcp/* dependencies
  DEPS_JSON=""
  if [ -n "$DEPS" ]; then
    IFS=',' read -ra DEP_ARR <<< "$DEPS"
    for dep in "${DEP_ARR[@]}"; do
      if [ -n "$DEPS_JSON" ]; then DEPS_JSON="$DEPS_JSON, "; fi
      DEPS_JSON="$DEPS_JSON\"@orchestra-mcp/$dep\": \"^$VERSION\""
    done
  fi
  
  # Read existing package.json for non-orchestra deps
  EXISTING_DEPS=""
  if [ -f "$PKG_DIR/package.json" ]; then
    # Extract non-orchestra dependencies
    EXISTING_DEPS=$(python3 -c "
import json, sys
try:
    pkg = json.load(open('$PKG_DIR/package.json'))
    deps = pkg.get('dependencies', {})
    items = []
    for k, v in deps.items():
        if not k.startswith('@orchestra-mcp/'):
            items.append(f'    \"{k}\": \"{v}\"')
    if items:
        print(',\n'.join(items))
except: pass
" 2>/dev/null || echo "")
  fi
  
  # Combine deps
  ALL_DEPS=""
  if [ -n "$DEPS_JSON" ] && [ -n "$EXISTING_DEPS" ]; then
    ALL_DEPS="$DEPS_JSON,
$EXISTING_DEPS"
  elif [ -n "$DEPS_JSON" ]; then
    ALL_DEPS="$DEPS_JSON"
  elif [ -n "$EXISTING_DEPS" ]; then
    ALL_DEPS="$EXISTING_DEPS"
  fi
  
  # Determine extra exports
  EXTRA_EXPORTS=""
  if [ "$NAME" = "theme" ]; then
    EXTRA_EXPORTS=',
    "./styles": "./src/styles/base.css",
    "./themes": { "import": "./dist/themes.mjs", "require": "./dist/themes.js", "types": "./dist/themes.d.ts" },
    "./variants": { "import": "./dist/variants.mjs", "require": "./dist/variants.js", "types": "./dist/variants.d.ts" },
    "./theme-switcher": { "import": "./dist/theme-switcher.mjs", "require": "./dist/theme-switcher.js", "types": "./dist/theme-switcher.d.ts" }'
  elif [ "$NAME" = "icons" ]; then
    EXTRA_EXPORTS=',
    "./code": { "import": "./dist/code/index.js", "types": "./dist/code/index.d.ts" },
    "./launcher": { "import": "./dist/launcher/index.js", "types": "./dist/launcher/index.d.ts" },
    "./boxicons": { "import": "./dist/boxicons/index.js", "types": "./dist/boxicons/index.d.ts" }'
  fi
  
  # Build script varies
  BUILD_SCRIPT="tsup src/index.ts --format cjs,esm --dts --clean"
  if [ "$NAME" = "theme" ]; then
    BUILD_SCRIPT="tsup src/index.ts src/theme-switcher.ts src/themes.ts src/variants.ts --format cjs,esm --dts --clean"
  fi
  
  # Determine files to include
  FILES_FIELD='"dist"'
  if [ "$NAME" = "theme" ]; then
    FILES_FIELD='"dist", "src"'
  fi
  
  # Dependencies section
  DEPS_SECTION=""
  if [ -n "$ALL_DEPS" ]; then
    DEPS_SECTION="\"dependencies\": {
    $ALL_DEPS
  },"
  fi
  
  # Create package.json
  cat > "$WORK_DIR/package.json" << PKGJSON
{
  "name": "@orchestra-mcp/$NAME",
  "version": "$VERSION",
  "description": "$DESC",
  "type": "module",
  "main": "./dist/index.js",
  "module": "./dist/index.mjs",
  "types": "./dist/index.d.ts",
  "exports": {
    ".": {
      "types": "./dist/index.d.ts",
      "import": "./dist/index.mjs",
      "require": "./dist/index.js"
    }$EXTRA_EXPORTS
  },
  "files": [$FILES_FIELD],
  "publishConfig": { "access": "public" },
  "repository": {
    "type": "git",
    "url": "https://github.com/$GITHUB_ORG/$NAME"
  },
  "funding": "https://github.com/sponsors/fadymondy",
  "license": "MIT",
  $DEPS_SECTION
  "peerDependencies": {
    "react": ">=18.0.0",
    "react-dom": ">=18.0.0"
  },
  "devDependencies": {
    "@types/react": "^19.0.0",
    "@types/react-dom": "^19.0.0",
    "tsup": "^8.3.5",
    "typescript": "^5.7.2"
  },
  "scripts": {
    "build": "$BUILD_SCRIPT",
    "dev": "tsup src/index.ts --format cjs,esm --dts --watch",
    "prepublishOnly": "pnpm build"
  },
  "keywords": ["orchestra", "mcp", "react", "components", "$NAME"]
}
PKGJSON

  # Create tsconfig.json
  cat > "$WORK_DIR/tsconfig.json" << 'TSCONF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "jsx": "react-jsx",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
TSCONF

  # Create .gitignore
  cat > "$WORK_DIR/.gitignore" << 'GITIGNORE'
node_modules/
dist/
*.tsbuildinfo
.DS_Store
GITIGNORE

  # Create LICENSE
  cat > "$WORK_DIR/LICENSE" << 'LICENSE'
MIT License

Copyright (c) 2026 Orchestra MCP

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
LICENSE

  # Create README.md
  cat > "$WORK_DIR/README.md" << README
# @orchestra-mcp/$NAME

$DESC

Part of the [Orchestra MCP](https://orchestra-mcp.dev) ecosystem.

## Install

\`\`\`bash
npm install @orchestra-mcp/$NAME
# or
pnpm add @orchestra-mcp/$NAME
\`\`\`

## Usage

\`\`\`tsx
import { } from '@orchestra-mcp/$NAME'
\`\`\`

## Requirements

- React >= 18.0.0

## License

MIT — [Orchestra MCP](https://orchestra-mcp.dev)

## Sponsor

[Sponsor this project](https://github.com/sponsors/fadymondy)
README

  # Create .github/FUNDING.yml
  mkdir -p "$WORK_DIR/.github/workflows"
  cat > "$WORK_DIR/.github/FUNDING.yml" << 'FUNDING'
github: [fadymondy]
FUNDING

  # Create .github/workflows/publish.yml
  cat > "$WORK_DIR/.github/workflows/publish.yml" << 'WORKFLOW'
name: Publish to npm
on:
  push:
    tags: ['v*']
jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
        with:
          version: 9
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          registry-url: 'https://registry.npmjs.org'
      - run: pnpm install --no-frozen-lockfile
      - run: pnpm build || true
      - run: npm publish --access public --ignore-scripts
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
WORKFLOW

  # Create .npmrc for auth
  cat > "$WORK_DIR/.npmrc" << NPMRC
//registry.npmjs.org/:_authToken=${NPM_TOKEN}
NPMRC

  echo "  ✓ Package prepared at $WORK_DIR"
done

echo ""
echo "All 10 packages prepared in /tmp/orchestra-npm-*"
echo "Ready for Phase 2: git init + push + npm publish"

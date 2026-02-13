---
name: chrome-extension
description: Chrome Extension development with Manifest V3. Activates when working on the Chrome extension source, manifest.json, service worker, content scripts, side panel, or Chrome APIs.
---

# Chrome Extension — Manifest V3

The Chrome extension is one of Orchestra's five client platforms, providing a sidebar IDE experience within the browser.

## Project Structure

```
resources/extension/
├── package.json
├── manifest.json
├── vite.config.ts
├── tsconfig.json
├── src/
│   ├── App.tsx                # Side panel root
│   ├── main.tsx               # Entry point
│   ├── pages/
│   │   ├── Editor.tsx         # Code editor view
│   │   ├── Explorer.tsx       # File explorer view
│   │   ├── Search.tsx         # Search view
│   │   ├── Terminal.tsx       # Terminal view
│   │   └── Settings.tsx       # Extension settings
│   ├── components/            # Extension-specific components
│   │   ├── Sidebar.tsx
│   │   ├── Toolbar.tsx
│   │   └── TabBar.tsx
│   ├── background/
│   │   └── service-worker.ts  # Background service worker
│   ├── content/
│   │   └── content-script.ts  # Page content scripts
│   └── hooks/
│       ├── useChromeStorage.ts
│       └── useChromeMessaging.ts
└── public/
    └── icons/
        ├── icon-16.png
        ├── icon-48.png
        └── icon-128.png
```

## Manifest V3

```json
{
  "manifest_version": 3,
  "name": "Orchestra",
  "version": "0.1.0",
  "description": "AI-agentic IDE across OS, browser, server, mobile",
  "permissions": [
    "storage",
    "tabs",
    "activeTab",
    "sidePanel",
    "contextMenus"
  ],
  "host_permissions": [
    "http://localhost:*/*"
  ],
  "background": {
    "service_worker": "service-worker.js",
    "type": "module"
  },
  "side_panel": {
    "default_path": "sidepanel.html"
  },
  "content_scripts": [
    {
      "matches": ["https://github.com/*", "https://gitlab.com/*"],
      "js": ["content-script.js"],
      "run_at": "document_idle"
    }
  ],
  "content_security_policy": {
    "extension_pages": "script-src 'self'; object-src 'self'; connect-src 'self' http://localhost:* ws://localhost:* ws://127.0.0.1:*"
  },
  "icons": {
    "16": "icons/icon-16.png",
    "48": "icons/icon-48.png",
    "128": "icons/icon-128.png"
  }
}
```

## Service Worker Pattern

```typescript
// resources/extension/src/background/service-worker.ts
chrome.runtime.onInstalled.addListener(() => {
  // Set up side panel
  chrome.sidePanel.setPanelBehavior({ openPanelOnActionClick: true });

  // Create context menu
  chrome.contextMenus.create({
    id: 'orchestra-analyze',
    title: 'Analyze with Orchestra',
    contexts: ['selection'],
  });
});

// Handle messages from content scripts and side panel
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  switch (message.type) {
    case 'GET_TAB_INFO':
      chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
        sendResponse({ tab: tabs[0] });
      });
      return true; // Keep channel open for async response

    case 'SYNC_STATE':
      // Forward to side panel or content script
      chrome.runtime.sendMessage(message);
      sendResponse({ ok: true });
      break;
  }
});

// Handle context menu clicks
chrome.contextMenus.onClicked.addListener((info, tab) => {
  if (info.menuItemId === 'orchestra-analyze' && info.selectionText) {
    chrome.runtime.sendMessage({
      type: 'ANALYZE_CODE',
      text: info.selectionText,
      url: tab?.url,
    });
  }
});
```

## Chrome Storage Hook

```typescript
// resources/extension/src/hooks/useChromeStorage.ts
import { useState, useEffect, useCallback } from 'react';

export function useChromeStorage<T>(key: string, defaultValue: T) {
  const [value, setValue] = useState<T>(defaultValue);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    chrome.storage.local.get(key, (result) => {
      if (result[key] !== undefined) {
        setValue(result[key] as T);
      }
      setLoading(false);
    });

    // Listen for external changes
    const listener = (changes: Record<string, chrome.storage.StorageChange>) => {
      if (changes[key]) {
        setValue(changes[key].newValue as T);
      }
    };
    chrome.storage.onChanged.addListener(listener);
    return () => chrome.storage.onChanged.removeListener(listener);
  }, [key]);

  const set = useCallback((newValue: T | ((prev: T) => T)) => {
    setValue((prev) => {
      const resolved = typeof newValue === 'function'
        ? (newValue as (prev: T) => T)(prev)
        : newValue;
      chrome.storage.local.set({ [key]: resolved });
      return resolved;
    });
  }, [key]);

  return [value, set, loading] as const;
}
```

## Content Script Pattern

```typescript
// resources/extension/src/content/content-script.ts

// Inject UI into GitHub/GitLab pages
function injectOrchestraButton() {
  const toolbar = document.querySelector('.file-navigation');
  if (!toolbar || toolbar.querySelector('.orchestra-btn')) return;

  const btn = document.createElement('button');
  btn.className = 'orchestra-btn btn btn-sm';
  btn.textContent = 'Open in Orchestra';
  btn.addEventListener('click', () => {
    const url = window.location.href;
    chrome.runtime.sendMessage({ type: 'OPEN_IN_ORCHESTRA', url });
  });

  toolbar.appendChild(btn);
}

// Run on page load and navigation (SPA support)
const observer = new MutationObserver(() => injectOrchestraButton());
observer.observe(document.body, { childList: true, subtree: true });
injectOrchestraButton();
```

## Side Panel Constraints

- Maximum width: 400px (Chrome enforced for side panel)
- Must be fully functional in compact mode
- Use collapsible sections and sheet-based dialogs
- Scrollable content areas with sticky headers
- No horizontal scrolling

## Vite Build Configuration

```typescript
// resources/extension/vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'path';

export default defineConfig({
  plugins: [react()],
  build: {
    outDir: '../../dist/extension',
    rollupOptions: {
      input: {
        sidepanel: resolve(__dirname, 'sidepanel.html'),
        'service-worker': resolve(__dirname, 'src/background/service-worker.ts'),
        'content-script': resolve(__dirname, 'src/content/content-script.ts'),
      },
      output: {
        entryFileNames: '[name].js',
        chunkFileNames: 'chunks/[name]-[hash].js',
      },
    },
  },
  resolve: {
    alias: {
      '@orchestra/shared': resolve(__dirname, '../shared'),
      '@orchestra/ui': resolve(__dirname, '../ui'),
    },
  },
});
```

## Communication Between Contexts

```
Service Worker ◄──chrome.runtime.sendMessage──► Side Panel
Service Worker ◄──chrome.tabs.sendMessage────► Content Script
Side Panel     ◄──chrome.runtime.sendMessage──► Content Script (via background)
```

## Conventions

- Side panel is the primary UI surface — not popup or new tab
- Use `chrome.storage.local` for persisted state (not localStorage)
- All Chrome API calls go through dedicated hooks, never inline
- Content scripts are minimal — inject a button, send messages to background
- CSP must allow `ws://localhost:*` and `ws://127.0.0.1:*` for local dev server
- Use `chrome.runtime.sendMessage` for inter-context communication
- Build produces static files (no dev server for extension)

## Don'ts

- Don't use `localStorage` or `sessionStorage` — use `chrome.storage`
- Don't make fetch calls from content scripts — route through background
- Don't use inline event handlers — Content Security Policy blocks them
- Don't assume the side panel stays open — save state on every change
- Don't use `eval()` or dynamic `import()` from strings — CSP violation
- Don't request unnecessary permissions — Chrome Web Store review rejects

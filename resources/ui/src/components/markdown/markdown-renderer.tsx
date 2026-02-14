/**
 * MarkdownRenderer -- renders server-rendered markdown HTML with
 * optional TOC sidebar, code-block copy buttons, and mermaid/math stubs.
 */

import { useCallback, useEffect, useRef } from 'react';
import type { FC } from 'react';
import { cn } from '../../lib/utils';

// ── Types ─────────────────────────────────────────────────────────

interface TOCEntry {
  level: number;
  text: string;
  id: string;
}

// ── Props ─────────────────────────────────────────────────────────

export interface MarkdownRendererProps {
  content: string;
  className?: string;
  enableMermaid?: boolean;
  enableMath?: boolean;
  showTOC?: boolean;
  toc?: TOCEntry[];
  onCodeCopy?: (code: string, lang: string) => void;
}

// ── Component ─────────────────────────────────────────────────────

export const MarkdownRenderer: FC<MarkdownRendererProps> = ({
  content,
  className,
  showTOC = false,
  toc,
  onCodeCopy,
}) => {
  const contentRef = useRef<HTMLDivElement>(null);

  // Attach copy buttons to <pre> blocks after mount.
  useEffect(() => {
    const el = contentRef.current;
    if (!el) return;

    const pres = el.querySelectorAll('pre');
    pres.forEach((pre) => {
      if (pre.querySelector('[data-copy-btn]')) return;

      const btn = document.createElement('button');
      btn.setAttribute('data-copy-btn', 'true');
      btn.textContent = 'Copy';
      btn.className =
        'absolute right-2 top-2 rounded bg-gray-200 px-2 py-0.5 text-xs hover:bg-gray-300 dark:bg-gray-700 dark:hover:bg-gray-600';

      btn.addEventListener('click', () => {
        const code = pre.querySelector('code')?.textContent ?? pre.textContent ?? '';
        navigator.clipboard.writeText(code);
        btn.textContent = 'Copied!';
        setTimeout(() => {
          btn.textContent = 'Copy';
        }, 2000);
        const lang = pre.querySelector('code')?.className.match(/language-(\w+)/)?.[1] ?? '';
        onCodeCopy?.(code, lang);
      });

      pre.style.position = 'relative';
      pre.appendChild(btn);
    });
  }, [content, onCodeCopy]);

  const handleTOCClick = useCallback((id: string) => {
    const el = document.getElementById(id);
    el?.scrollIntoView({ behavior: 'smooth' });
  }, []);

  return (
    <div className={cn('flex gap-6', className)}>
      {/* Table of Contents sidebar */}
      {showTOC && toc && toc.length > 0 && (
        <nav className="hidden lg:block w-56 flex-shrink-0" aria-label="Table of contents">
          <ul className="sticky top-4 space-y-1 text-sm">
            {toc.map((entry) => (
              <li key={entry.id} style={{ paddingLeft: `${(entry.level - 1) * 12}px` }}>
                <button
                  type="button"
                  onClick={() => handleTOCClick(entry.id)}
                  className="text-left text-gray-600 hover:text-gray-900 dark:text-gray-400 dark:hover:text-gray-100"
                >
                  {entry.text}
                </button>
              </li>
            ))}
          </ul>
        </nav>
      )}

      {/* Rendered markdown content */}
      <div
        ref={contentRef}
        className={cn(
          'prose prose-gray dark:prose-invert max-w-none',
          'prose-pre:relative prose-pre:bg-gray-50 dark:prose-pre:bg-gray-900',
        )}
        dangerouslySetInnerHTML={{ __html: content }}
      />
    </div>
  );
};

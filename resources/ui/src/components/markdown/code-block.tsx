/**
 * CodeBlock -- renders a fenced code block with language label, line numbers,
 * and a copy-to-clipboard button.
 */

import { useCallback, useState } from 'react';
import type { FC } from 'react';
import { Check, Copy } from 'lucide-react';
import { cn } from '../../lib/utils';

// ── Props ─────────────────────────────────────────────────────────

export interface CodeBlockProps {
  code: string;
  language: string;
  onCopy?: (code: string, lang: string) => void;
}

// ── Component ─────────────────────────────────────────────────────

export const CodeBlock: FC<CodeBlockProps> = ({ code, language, onCopy }) => {
  const [copied, setCopied] = useState(false);

  const handleCopy = useCallback(async () => {
    await navigator.clipboard.writeText(code);
    setCopied(true);
    onCopy?.(code, language);
    setTimeout(() => setCopied(false), 2000);
  }, [code, language, onCopy]);

  const lines = code.split('\n');

  return (
    <div className="group relative rounded-lg border border-gray-200 dark:border-gray-700 overflow-hidden">
      {/* Header bar */}
      <div
        className={cn(
          'flex items-center justify-between px-4 py-1.5',
          'bg-gray-100 dark:bg-gray-800 text-xs text-gray-500 dark:text-gray-400',
        )}
      >
        <span className="font-mono">{language || 'text'}</span>
        <button
          type="button"
          onClick={handleCopy}
          className={cn(
            'flex items-center gap-1 rounded px-2 py-0.5',
            'hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors',
          )}
          aria-label={copied ? 'Copied' : 'Copy code'}
        >
          {copied ? <Check className="size-3.5" /> : <Copy className="size-3.5" />}
          <span>{copied ? 'Copied' : 'Copy'}</span>
        </button>
      </div>

      {/* Code body with line numbers */}
      <pre className="overflow-x-auto bg-gray-50 dark:bg-gray-900 p-4 text-sm leading-relaxed">
        <code className="font-mono">
          {lines.map((line, i) => (
            <div key={i} className="flex">
              <span className="mr-4 inline-block w-8 text-right text-gray-400 dark:text-gray-600 select-none">
                {i + 1}
              </span>
              <span>{line}</span>
            </div>
          ))}
        </code>
      </pre>
    </div>
  );
};

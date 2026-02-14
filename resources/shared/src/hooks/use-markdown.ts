/**
 * Markdown hook for @orchestra/shared.
 * Sends content to POST /markdown/render and returns parsed result.
 */

import { useQuery } from '@tanstack/react-query';
import { apiClient } from '../api/client';

// ── Types ────────────────────────────────────────────────────────

interface TOCEntry {
  level: number;
  text: string;
  id: string;
}

interface CodeBlock {
  language: string;
  code: string;
  line_count: number;
}

interface RenderResult {
  html: string;
  toc: TOCEntry[];
  metadata: Record<string, string>;
  code_blocks: CodeBlock[];
}

// ── API Fetcher ──────────────────────────────────────────────────

async function fetchRenderedMarkdown(content: string): Promise<RenderResult> {
  const { data } = await apiClient.post<RenderResult>('/markdown/render', {
    content,
  });
  return data;
}

// ── Hook ─────────────────────────────────────────────────────────

export function useMarkdown(content: string) {
  const query = useQuery({
    queryKey: ['markdown', content],
    queryFn: () => fetchRenderedMarkdown(content),
    enabled: content.length > 0,
    staleTime: 60_000,
  });

  return {
    html: query.data?.html ?? '',
    toc: query.data?.toc ?? [],
    codeBlocks: query.data?.code_blocks ?? [],
    metadata: query.data?.metadata ?? {},
    isLoading: query.isLoading,
    error: query.error,
  };
}

/**
 * SettingsActions provides Export, Import, and Reset All buttons.
 * Import opens a file picker; Reset All shows a confirmation dialog.
 */

import { useCallback, useRef, useState } from 'react';
import type { FC } from 'react';
import { Download, Upload, RotateCcw, AlertTriangle } from 'lucide-react';
import type { SettingsMap } from '@orchestra/shared/types/settings';
import { cn } from '../../lib/utils';

// ── Props ────────────────────────────────────────────────────────

export interface SettingsActionsProps {
  onExport: () => Promise<SettingsMap>;
  onImport: (data: SettingsMap) => void;
  onReset: () => void;
  className?: string;
}

// ── Shared button styles ─────────────────────────────────────────

const btnBase =
  'inline-flex items-center gap-2 rounded-md px-3 py-2 text-sm font-medium transition-colors ' +
  'border border-gray-200 dark:border-gray-700 ' +
  'hover:bg-gray-50 dark:hover:bg-gray-800';

const btnDanger =
  'inline-flex items-center gap-2 rounded-md px-3 py-2 text-sm font-medium transition-colors ' +
  'bg-red-600 text-white hover:bg-red-700 ' +
  'focus:outline-none focus:ring-2 focus:ring-red-500/40';

// ── Component ────────────────────────────────────────────────────

export const SettingsActions: FC<SettingsActionsProps> = ({
  onExport,
  onImport,
  onReset,
  className,
}) => {
  const fileRef = useRef<HTMLInputElement>(null);
  const [confirmReset, setConfirmReset] = useState(false);

  // Export settings as a downloadable JSON file
  const handleExport = useCallback(async () => {
    const data = await onExport();
    const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'orchestra-settings.json';
    a.click();
    URL.revokeObjectURL(url);
  }, [onExport]);

  // Read uploaded JSON file and forward to onImport
  const handleFileChange = useCallback(
    (e: React.ChangeEvent<HTMLInputElement>) => {
      const file = e.target.files?.[0];
      if (!file) return;

      const reader = new FileReader();
      reader.onload = () => {
        try {
          const data = JSON.parse(reader.result as string) as SettingsMap;
          onImport(data);
        } catch {
          // Silently ignore malformed JSON
        }
      };
      reader.readAsText(file);

      // Reset input so the same file can be re-selected
      e.target.value = '';
    },
    [onImport],
  );

  return (
    <div className={cn('flex flex-wrap items-center gap-2', className)}>
      {/* Export */}
      <button type="button" className={btnBase} onClick={handleExport}>
        <Download className="size-4" />
        Export
      </button>

      {/* Import */}
      <button
        type="button"
        className={btnBase}
        onClick={() => fileRef.current?.click()}
      >
        <Upload className="size-4" />
        Import
      </button>
      <input
        ref={fileRef}
        type="file"
        accept=".json,application/json"
        className="hidden"
        onChange={handleFileChange}
      />

      {/* Reset All */}
      {!confirmReset ? (
        <button
          type="button"
          className={cn(btnBase, 'text-red-600 dark:text-red-400')}
          onClick={() => setConfirmReset(true)}
        >
          <RotateCcw className="size-4" />
          Reset All
        </button>
      ) : (
        <ResetConfirmation
          onConfirm={() => {
            onReset();
            setConfirmReset(false);
          }}
          onCancel={() => setConfirmReset(false)}
        />
      )}
    </div>
  );
};

// ── Inline confirmation ──────────────────────────────────────────

const ResetConfirmation: FC<{
  onConfirm: () => void;
  onCancel: () => void;
}> = ({ onConfirm, onCancel }) => (
  <div className="flex items-center gap-2 rounded-md border border-red-300 bg-red-50 px-3 py-2 dark:border-red-800 dark:bg-red-950">
    <AlertTriangle className="size-4 shrink-0 text-red-600" />
    <span className="text-sm text-red-700 dark:text-red-300">
      Reset all settings to defaults?
    </span>
    <button type="button" className={btnDanger} onClick={onConfirm}>
      Confirm
    </button>
    <button type="button" className={btnBase} onClick={onCancel}>
      Cancel
    </button>
  </div>
);

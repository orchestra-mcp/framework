/**
 * SettingsPage is the full settings UI: sidebar with groups, search bar,
 * setting controls in the main area, and export/import/reset actions.
 */

import { useMemo, useState } from 'react';
import type { FC } from 'react';
import { Search, Settings, RotateCcw } from 'lucide-react';
import {
  useSettings,
  useSettingGroups,
  useUpdateSetting,
  useExportSettings,
  useImportSettings,
  useResetSettings,
} from '@orchestra/shared/hooks/use-settings';
import type { SettingsGroup, SettingDefinition } from '@orchestra/shared/types/settings';
import { cn } from '../../lib/utils';
import { SettingInput } from './setting-input';
import { SettingsActions } from './settings-actions';

// ── Props ────────────────────────────────────────────────────────

export interface SettingsPageProps {
  /** Extra definitions to display (injected by the consumer). */
  definitions?: SettingDefinition[];
  className?: string;
}

// ── Component ────────────────────────────────────────────────────

export const SettingsPage: FC<SettingsPageProps> = ({
  definitions = [],
  className,
}) => {
  const { data: settings = {} } = useSettings();
  const { data: groups = [] } = useSettingGroups();

  const updateSetting = useUpdateSetting();
  const exportSettings = useExportSettings();
  const importSettings = useImportSettings();
  const resetSettings = useResetSettings();

  const [activeGroupId, setActiveGroupId] = useState<string | null>(null);
  const [search, setSearch] = useState('');

  // Sorted groups
  const sortedGroups = useMemo(
    () => [...groups].sort((a, b) => a.order - b.order),
    [groups],
  );

  // Auto-select first group when groups load
  const selectedGroupId = activeGroupId ?? sortedGroups[0]?.id ?? null;

  // Filter definitions by active group and search term
  const visibleDefinitions = useMemo(() => {
    const lower = search.toLowerCase();
    return definitions
      .filter((d) => {
        if (selectedGroupId && d.group_id !== selectedGroupId) return false;
        if (lower) {
          return (
            d.title.toLowerCase().includes(lower) ||
            d.key.toLowerCase().includes(lower)
          );
        }
        return true;
      })
      .sort((a, b) => a.order - b.order);
  }, [definitions, selectedGroupId, search]);

  return (
    <div className={cn('flex h-full min-h-0', className)}>
      {/* Sidebar */}
      <GroupSidebar
        groups={sortedGroups}
        activeId={selectedGroupId}
        onSelect={setActiveGroupId}
      />

      {/* Main content */}
      <div className="flex flex-1 flex-col gap-6 overflow-y-auto p-6">
        {/* Search + actions row */}
        <div className="flex flex-wrap items-center gap-3">
          <SearchBar value={search} onChange={setSearch} />
          <SettingsActions
            className="ml-auto"
            onExport={() => exportSettings.mutateAsync()}
            onImport={(data) => importSettings.mutate(data)}
            onReset={() => resetSettings.mutate(undefined)}
          />
        </div>

        {/* Group heading + reset group button */}
        {selectedGroupId && (
          <GroupHeading
            group={sortedGroups.find((g) => g.id === selectedGroupId)}
            onResetGroup={() => resetSettings.mutate(selectedGroupId)}
          />
        )}

        {/* Setting controls */}
        <div className="space-y-6">
          {visibleDefinitions.map((def) => (
            <SettingInput
              key={def.key}
              definition={def}
              value={settings[def.key] ?? def.default}
              saving={
                updateSetting.isPending &&
                (updateSetting.variables as { key: string } | undefined)?.key === def.key
              }
              onSave={(key, value) => updateSetting.mutate({ key, value })}
            />
          ))}
          {visibleDefinitions.length === 0 && (
            <p className="py-12 text-center text-sm text-gray-400">
              {search ? 'No settings match your search.' : 'No settings in this group.'}
            </p>
          )}
        </div>
      </div>
    </div>
  );
};

// ── Sidebar ──────────────────────────────────────────────────────

const GroupSidebar: FC<{
  groups: SettingsGroup[];
  activeId: string | null;
  onSelect: (id: string) => void;
}> = ({ groups, activeId, onSelect }) => (
  <nav
    className={cn(
      'flex w-56 shrink-0 flex-col gap-0.5 overflow-y-auto border-r p-3',
      'border-gray-200 bg-gray-50 dark:border-gray-800 dark:bg-gray-950',
    )}
    aria-label="Settings groups"
  >
    {groups.map((g) => (
      <button
        key={g.id}
        type="button"
        className={cn(
          'flex items-center gap-2 rounded-md px-3 py-2 text-sm transition-colors text-left',
          'hover:bg-gray-100 dark:hover:bg-gray-800',
          g.id === activeId &&
            'bg-gray-200 font-medium dark:bg-gray-800',
        )}
        onClick={() => onSelect(g.id)}
      >
        <Settings className="size-4 shrink-0 text-gray-400" />
        <span className="truncate">{g.title}</span>
      </button>
    ))}
    {groups.length === 0 && (
      <span className="px-3 py-2 text-xs text-gray-400">No groups</span>
    )}
  </nav>
);

// ── Search bar ───────────────────────────────────────────────────

const SearchBar: FC<{
  value: string;
  onChange: (v: string) => void;
}> = ({ value, onChange }) => (
  <div className="relative w-64">
    <Search className="absolute left-2.5 top-2.5 size-4 text-gray-400" />
    <input
      type="text"
      placeholder="Search settings..."
      className={cn(
        'w-full rounded-md border border-gray-200 bg-white py-2 pl-9 pr-3 text-sm',
        'dark:border-gray-700 dark:bg-gray-900',
        'focus:outline-none focus:ring-2 focus:ring-blue-500/40',
      )}
      value={value}
      onChange={(e) => onChange(e.target.value)}
    />
  </div>
);

// ── Group heading ────────────────────────────────────────────────

const GroupHeading: FC<{
  group?: SettingsGroup;
  onResetGroup: () => void;
}> = ({ group, onResetGroup }) => {
  if (!group) return null;
  return (
    <div className="flex items-start justify-between gap-4">
      <div>
        <h2 className="text-lg font-semibold text-gray-900 dark:text-gray-100">
          {group.title}
        </h2>
        {group.description && (
          <p className="mt-0.5 text-sm text-gray-500">{group.description}</p>
        )}
      </div>
      <button
        type="button"
        className={cn(
          'inline-flex items-center gap-1.5 rounded-md px-2.5 py-1.5 text-xs font-medium transition-colors',
          'text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-800',
        )}
        onClick={onResetGroup}
      >
        <RotateCcw className="size-3.5" />
        Reset group
      </button>
    </div>
  );
};

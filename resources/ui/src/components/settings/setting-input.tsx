/**
 * SettingInput renders the correct form control based on a SettingDefinition's type.
 * Debounces value changes (300ms) and fires onSave automatically.
 */

import { useCallback, useEffect, useRef, useState } from 'react';
import type { FC } from 'react';
import { Loader2 } from 'lucide-react';
import type { SettingDefinition } from '@orchestra/shared/types/settings';
import { cn } from '../../lib/utils';

// ── Props ────────────────────────────────────────────────────────

export interface SettingInputProps {
  definition: SettingDefinition;
  value: unknown;
  onSave: (key: string, value: unknown) => void;
  saving?: boolean;
}

// ── Debounce helper ──────────────────────────────────────────────

function useDebouncedCallback<T extends (...args: never[]) => void>(
  callback: T,
  delay: number,
): T {
  const timer = useRef<ReturnType<typeof setTimeout>>();
  const callbackRef = useRef(callback);
  callbackRef.current = callback;

  useEffect(() => () => clearTimeout(timer.current), []);

  return useCallback(
    (...args: Parameters<T>) => {
      clearTimeout(timer.current);
      timer.current = setTimeout(() => callbackRef.current(...args), delay);
    },
    [delay],
  ) as unknown as T;
}

// ── Shared layout ────────────────────────────────────────────────

const inputBase =
  'w-full rounded-md border border-gray-200 bg-white px-3 py-2 text-sm ' +
  'dark:border-gray-700 dark:bg-gray-900 ' +
  'focus:outline-none focus:ring-2 focus:ring-blue-500/40';

// ── Component ────────────────────────────────────────────────────

export const SettingInput: FC<SettingInputProps> = ({
  definition,
  value,
  onSave,
  saving = false,
}) => {
  const [local, setLocal] = useState(value);

  // Sync external value changes (e.g. after reset)
  useEffect(() => setLocal(value), [value]);

  const debouncedSave = useDebouncedCallback(
    (v: unknown) => onSave(definition.key, v),
    300,
  );

  const handleChange = (next: unknown) => {
    setLocal(next);
    debouncedSave(next);
  };

  return (
    <div className="space-y-1.5">
      <div className="flex items-center justify-between gap-2">
        <label
          htmlFor={definition.key}
          className="text-sm font-medium text-gray-900 dark:text-gray-100"
        >
          {definition.title}
        </label>
        {saving && (
          <Loader2 className="size-3.5 animate-spin text-gray-400" aria-label="Saving" />
        )}
      </div>

      {renderControl(definition, local, handleChange)}

      {definition.description && (
        <p className="text-xs text-gray-500 dark:text-gray-400">
          {definition.description}
        </p>
      )}
    </div>
  );
};

// ── Per-type renderers ───────────────────────────────────────────

function renderControl(
  def: SettingDefinition,
  value: unknown,
  onChange: (v: unknown) => void,
) {
  switch (def.type) {
    case 'boolean':
      return <BooleanInput id={def.key} checked={!!value} onChange={onChange} />;
    case 'number':
      return (
        <NumberInput
          id={def.key}
          value={typeof value === 'number' ? value : 0}
          min={def.min}
          max={def.max}
          onChange={onChange}
        />
      );
    case 'select':
      return (
        <SelectInput
          id={def.key}
          value={String(value ?? '')}
          options={def.enum ?? []}
          labels={def.enum_labels}
          onChange={onChange}
        />
      );
    case 'color':
      return (
        <ColorInput
          id={def.key}
          value={String(value ?? '#000000')}
          onChange={onChange}
        />
      );
    case 'string':
    case 'path':
    default:
      return (
        <StringInput
          id={def.key}
          value={String(value ?? '')}
          onChange={onChange}
        />
      );
  }
}

// ── Primitive inputs ─────────────────────────────────────────────

const StringInput: FC<{
  id: string;
  value: string;
  onChange: (v: string) => void;
}> = ({ id, value, onChange }) => (
  <input
    id={id}
    type="text"
    className={inputBase}
    value={value}
    onChange={(e) => onChange(e.target.value)}
  />
);

const NumberInput: FC<{
  id: string;
  value: number;
  min?: number;
  max?: number;
  onChange: (v: number) => void;
}> = ({ id, value, min, max, onChange }) => (
  <input
    id={id}
    type="number"
    className={cn(inputBase, 'tabular-nums')}
    value={value}
    min={min}
    max={max}
    onChange={(e) => onChange(Number(e.target.value))}
  />
);

const BooleanInput: FC<{
  id: string;
  checked: boolean;
  onChange: (v: boolean) => void;
}> = ({ id, checked, onChange }) => (
  <button
    id={id}
    type="button"
    role="switch"
    aria-checked={checked}
    className={cn(
      'relative inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors',
      checked ? 'bg-blue-600' : 'bg-gray-200 dark:bg-gray-700',
    )}
    onClick={() => onChange(!checked)}
  >
    <span
      className={cn(
        'pointer-events-none inline-block size-5 rounded-full bg-white shadow-sm transition-transform',
        checked ? 'translate-x-5' : 'translate-x-0',
      )}
    />
  </button>
);

const SelectInput: FC<{
  id: string;
  value: string;
  options: unknown[];
  labels?: string[];
  onChange: (v: unknown) => void;
}> = ({ id, value, options, labels, onChange }) => (
  <select
    id={id}
    className={inputBase}
    value={value}
    onChange={(e) => onChange(e.target.value)}
  >
    {options.map((opt, i) => (
      <option key={String(opt)} value={String(opt)}>
        {labels?.[i] ?? String(opt)}
      </option>
    ))}
  </select>
);

const ColorInput: FC<{
  id: string;
  value: string;
  onChange: (v: string) => void;
}> = ({ id, value, onChange }) => (
  <div className="flex items-center gap-2">
    <input
      id={id}
      type="color"
      className="size-9 cursor-pointer rounded border border-gray-200 dark:border-gray-700"
      value={value}
      onChange={(e) => onChange(e.target.value)}
    />
    <span className="text-xs font-mono text-gray-500">{value}</span>
  </div>
);

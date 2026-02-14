/**
 * React Query hooks for the Settings API.
 * Wraps the API functions from @orchestra/shared/api/settings.
 */

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import {
  fetchSettings,
  fetchSettingGroups,
  updateSetting,
  exportSettings,
  importSettings,
  resetSettings,
} from '../api/settings';
import type { SettingsGroup, SettingsMap } from '../types/settings';

// ── Query Keys ──────────────────────────────────────────────────

export const settingsKeys = {
  all: ['settings'] as const,
  groups: ['settings', 'groups'] as const,
};

// ── Queries ─────────────────────────────────────────────────────

/** Fetch all settings as a flat key-value map. */
export function useSettings() {
  return useQuery<SettingsMap>({
    queryKey: settingsKeys.all,
    queryFn: fetchSettings,
  });
}

/** Fetch the list of settings groups. */
export function useSettingGroups() {
  return useQuery<SettingsGroup[]>({
    queryKey: settingsKeys.groups,
    queryFn: fetchSettingGroups,
  });
}

// ── Mutations ───────────────────────────────────────────────────

/** Optimistically update a single setting and refetch on settle. */
export function useUpdateSetting() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ key, value }: { key: string; value: unknown }) =>
      updateSetting(key, value),

    onMutate: async ({ key, value }) => {
      await queryClient.cancelQueries({ queryKey: settingsKeys.all });
      const previous = queryClient.getQueryData<SettingsMap>(settingsKeys.all);

      queryClient.setQueryData<SettingsMap>(settingsKeys.all, (old) =>
        old ? { ...old, [key]: value } : { [key]: value },
      );
      return { previous };
    },

    onError: (_err, _vars, context) => {
      if (context?.previous) {
        queryClient.setQueryData(settingsKeys.all, context.previous);
      }
    },

    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: settingsKeys.all });
    },
  });
}

/** Export all settings as JSON. */
export function useExportSettings() {
  return useMutation({ mutationFn: exportSettings });
}

/** Import settings from a JSON object and refresh caches. */
export function useImportSettings() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (settings: SettingsMap) => importSettings(settings),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: settingsKeys.all });
    },
  });
}

/** Reset settings to defaults (optionally per group) and refresh caches. */
export function useResetSettings() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (groupId?: string) => resetSettings(groupId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: settingsKeys.all });
    },
  });
}

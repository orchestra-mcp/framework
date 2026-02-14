import { apiClient } from './client';
import type {
  SettingsGroup,
  SettingsMap,
  SettingValueResponse,
  UpdateSettingRequest,
  ResetSettingsRequest,
  ResetSettingsResponse,
  ImportSettingsResponse,
} from '../types/settings';

const BASE = '/settings';

/** Fetch all settings as a flat key-value map. */
export async function fetchSettings(): Promise<SettingsMap> {
  const { data } = await apiClient.get<SettingsMap>(BASE);
  return data;
}

/** Fetch all settings groups. */
export async function fetchSettingGroups(): Promise<SettingsGroup[]> {
  const { data } = await apiClient.get<SettingsGroup[]>(`${BASE}/groups`);
  return data;
}

/** Fetch a single setting value by key. */
export async function fetchSetting(key: string): Promise<SettingValueResponse> {
  const { data } = await apiClient.get<SettingValueResponse>(`${BASE}/${key}`);
  return data;
}

/** Update a single setting value. */
export async function updateSetting(
  key: string,
  value: unknown,
): Promise<SettingValueResponse> {
  const body: UpdateSettingRequest = { value };
  const { data } = await apiClient.put<SettingValueResponse>(`${BASE}/${key}`, body);
  return data;
}

/** Export all settings as a JSON blob. */
export async function exportSettings(): Promise<SettingsMap> {
  const { data } = await apiClient.post<SettingsMap>(`${BASE}/export`);
  return data;
}

/** Import settings from a JSON blob. */
export async function importSettings(
  settings: SettingsMap,
): Promise<ImportSettingsResponse> {
  const { data } = await apiClient.post<ImportSettingsResponse>(
    `${BASE}/import`,
    settings,
  );
  return data;
}

/** Reset settings to defaults. Pass groupId to reset a single group. */
export async function resetSettings(
  groupId?: string,
): Promise<ResetSettingsResponse> {
  const body: ResetSettingsRequest = groupId ? { group_id: groupId } : {};
  const { data } = await apiClient.post<ResetSettingsResponse>(`${BASE}/reset`, body);
  return data;
}

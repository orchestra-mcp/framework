/**
 * Settings types matching the Go backend at plugins/settings/.
 * Mirrors types.SettingsGroup, types.SettingDefinition, and API shapes.
 */

/** A logical group of settings (e.g. "Editor", "Terminal", "Appearance"). */
export interface SettingsGroup {
  id: string;
  title: string;
  description: string;
  icon: string;
  order: number;
}

/** Allowed setting value types. */
export type SettingType =
  | 'string'
  | 'number'
  | 'boolean'
  | 'select'
  | 'multi-select'
  | 'color'
  | 'path';

/** A single setting definition from the backend registry. */
export interface SettingDefinition {
  key: string;
  group_id: string;
  title: string;
  description?: string;
  type: SettingType;
  default: unknown;
  enum?: unknown[];
  enum_labels?: string[];
  min?: number;
  max?: number;
  order: number;
}

/** Flat map of setting key to current value returned by GET /api/settings/. */
export type SettingsMap = Record<string, unknown>;

/** Response from GET /api/settings/:key. */
export interface SettingValueResponse {
  key: string;
  value: unknown;
}

/** Request body for PUT /api/settings/:key. */
export interface UpdateSettingRequest {
  value: unknown;
}

/** Request body for POST /api/settings/reset. */
export interface ResetSettingsRequest {
  group_id?: string;
}

/** Response from POST /api/settings/reset. */
export interface ResetSettingsResponse {
  status: 'reset' | 'reset_all';
  group?: string;
}

/** Response from POST /api/settings/import. */
export interface ImportSettingsResponse {
  status: 'imported';
}

/**
 * Shared API response types used across all API clients.
 */

/** Standard API response wrapper. */
export interface ApiResponse<T> {
  data: T;
  message?: string;
}

/** Paginated API response. */
export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  per_page: number;
}

/** Standard API error shape from Go backend. */
export interface ApiError {
  error: string;
  message: string;
  details?: Record<string, unknown>;
}

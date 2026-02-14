/**
 * Notification type definitions for @orchestra/shared.
 * Used across all platforms for toast and notification history.
 */

export type NotificationPriority = 'low' | 'normal' | 'high' | 'urgent';

export interface NotificationAction {
  label: string;
  action: string;
}

export interface Notification {
  id: string;
  channel: string;
  title: string;
  body: string;
  priority: NotificationPriority;
  read: boolean;
  timestamp: string;
  actions?: NotificationAction[];
}

/**
 * Notification Zustand store for @orchestra/shared.
 * Manages notification list, unread count, and ring buffer behavior (max 100).
 */

import { create } from 'zustand';
import type { Notification } from '../types/notification';

const MAX_NOTIFICATIONS = 100;

// ── State ─────────────────────────────────────────────────────────

export interface NotificationState {
  notifications: Notification[];
  unreadCount: number;
}

// ── Actions ───────────────────────────────────────────────────────

export interface NotificationActions {
  addNotification: (notification: Notification) => void;
  markRead: (id: string) => void;
  markAllRead: () => void;
  dismiss: (id: string) => void;
  clearAll: () => void;
}

// ── Store ─────────────────────────────────────────────────────────

export const useNotificationStore = create<NotificationState & NotificationActions>(
  (set) => ({
    notifications: [],
    unreadCount: 0,

    addNotification: (notification) =>
      set((state) => {
        const next = [notification, ...state.notifications].slice(0, MAX_NOTIFICATIONS);
        const unreadCount = next.filter((n) => !n.read).length;
        return { notifications: next, unreadCount };
      }),

    markRead: (id) =>
      set((state) => {
        const notifications = state.notifications.map((n) =>
          n.id === id ? { ...n, read: true } : n,
        );
        const unreadCount = notifications.filter((n) => !n.read).length;
        return { notifications, unreadCount };
      }),

    markAllRead: () =>
      set((state) => ({
        notifications: state.notifications.map((n) => ({ ...n, read: true })),
        unreadCount: 0,
      })),

    dismiss: (id) =>
      set((state) => {
        const notifications = state.notifications.filter((n) => n.id !== id);
        const unreadCount = notifications.filter((n) => !n.read).length;
        return { notifications, unreadCount };
      }),

    clearAll: () => set({ notifications: [], unreadCount: 0 }),
  }),
);

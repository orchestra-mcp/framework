/**
 * NotificationCenter -- bell icon with unread badge, popover history panel.
 * Mark all read, individual dismiss, clear all, and empty state.
 */

import { useState } from 'react';
import type { FC } from 'react';
import { Bell, Check, Trash2, X } from 'lucide-react';
import type { Notification } from '@orchestra/shared/types/notification';
import { cn } from '../../lib/utils';

// ── Props ─────────────────────────────────────────────────────────

export interface NotificationCenterProps {
  notifications: Notification[];
  unreadCount: number;
  onMarkRead: (id: string) => void;
  onMarkAllRead: () => void;
  onDismiss: (id: string) => void;
  onClearAll: () => void;
}

// ── Notification Row ──────────────────────────────────────────────

interface RowProps {
  notification: Notification;
  onMarkRead: (id: string) => void;
  onDismiss: (id: string) => void;
}

const NotificationRow: FC<RowProps> = ({ notification, onMarkRead, onDismiss }) => (
  <div
    className={cn(
      'flex items-start gap-3 rounded-md px-3 py-2.5',
      'hover:bg-gray-50 dark:hover:bg-gray-800/60 transition-colors',
      !notification.read && 'bg-blue-50/50 dark:bg-blue-950/20',
    )}
  >
    {/* Unread indicator */}
    <span
      className={cn(
        'mt-1.5 size-2 shrink-0 rounded-full',
        notification.read ? 'bg-transparent' : 'bg-blue-500',
      )}
      aria-hidden
    />

    {/* Content */}
    <div className="flex-1 min-w-0">
      <p className="text-sm font-medium text-gray-900 dark:text-gray-100 truncate">
        {notification.title}
      </p>
      <p className="text-xs text-gray-500 dark:text-gray-400 line-clamp-2">
        {notification.body}
      </p>
      <p className="mt-0.5 text-xs text-gray-400 dark:text-gray-500">
        {new Date(notification.timestamp).toLocaleTimeString()}
      </p>
    </div>

    {/* Actions */}
    <div className="flex shrink-0 gap-1">
      {!notification.read && (
        <button
          type="button"
          className="rounded p-1 text-gray-400 hover:text-blue-600 dark:hover:text-blue-400"
          onClick={() => onMarkRead(notification.id)}
          aria-label="Mark as read"
          title="Mark as read"
        >
          <Check className="size-3.5" />
        </button>
      )}
      <button
        type="button"
        className="rounded p-1 text-gray-400 hover:text-red-600 dark:hover:text-red-400"
        onClick={() => onDismiss(notification.id)}
        aria-label="Dismiss"
        title="Dismiss"
      >
        <X className="size-3.5" />
      </button>
    </div>
  </div>
);

// ── Empty State ───────────────────────────────────────────────────

const EmptyState: FC = () => (
  <div className="flex flex-col items-center justify-center py-10 text-center">
    <Bell className="size-8 text-gray-300 dark:text-gray-600" />
    <p className="mt-2 text-sm text-gray-500 dark:text-gray-400">
      No notifications
    </p>
  </div>
);

// ── Component ─────────────────────────────────────────────────────

export const NotificationCenter: FC<NotificationCenterProps> = ({
  notifications,
  unreadCount,
  onMarkRead,
  onMarkAllRead,
  onDismiss,
  onClearAll,
}) => {
  const [open, setOpen] = useState(false);

  return (
    <div className="relative inline-block">
      {/* Bell button */}
      <button
        type="button"
        className={cn(
          'relative rounded-md p-2 transition-colors',
          'text-gray-600 hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-800',
        )}
        onClick={() => setOpen((prev) => !prev)}
        aria-label={`Notifications${unreadCount > 0 ? `, ${unreadCount} unread` : ''}`}
        aria-haspopup="dialog"
        aria-expanded={open}
      >
        <Bell className="size-5" />
        {unreadCount > 0 && (
          <span
            className={cn(
              'absolute -right-0.5 -top-0.5 flex items-center justify-center',
              'size-4.5 rounded-full bg-red-500 text-[10px] font-bold text-white',
            )}
          >
            {unreadCount > 99 ? '99+' : unreadCount}
          </span>
        )}
      </button>

      {/* Popover */}
      {open && (
        <>
          <div
            className="fixed inset-0 z-40"
            onClick={() => setOpen(false)}
            aria-hidden
          />
          <div
            className={cn(
              'absolute right-0 z-50 mt-2 w-80 rounded-lg border shadow-xl',
              'border-gray-200 bg-white dark:border-gray-700 dark:bg-gray-900',
            )}
            role="dialog"
            aria-label="Notification center"
          >
            {/* Header */}
            <div className="flex items-center justify-between border-b border-gray-200 px-4 py-3 dark:border-gray-700">
              <h3 className="text-sm font-semibold text-gray-900 dark:text-gray-100">
                Notifications
              </h3>
              <div className="flex gap-2">
                {unreadCount > 0 && (
                  <button
                    type="button"
                    className="text-xs text-blue-600 hover:text-blue-700 dark:text-blue-400"
                    onClick={onMarkAllRead}
                  >
                    Mark all read
                  </button>
                )}
                {notifications.length > 0 && (
                  <button
                    type="button"
                    className="rounded p-1 text-gray-400 hover:text-red-600 dark:hover:text-red-400"
                    onClick={onClearAll}
                    aria-label="Clear all notifications"
                    title="Clear all"
                  >
                    <Trash2 className="size-3.5" />
                  </button>
                )}
              </div>
            </div>

            {/* List */}
            <div className="max-h-96 overflow-y-auto">
              {notifications.length === 0 ? (
                <EmptyState />
              ) : (
                notifications.map((n) => (
                  <NotificationRow
                    key={n.id}
                    notification={n}
                    onMarkRead={onMarkRead}
                    onDismiss={onDismiss}
                  />
                ))
              )}
            </div>
          </div>
        </>
      )}
    </div>
  );
};

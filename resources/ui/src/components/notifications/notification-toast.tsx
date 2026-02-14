/**
 * NotificationToast -- renders a single notification as a toast.
 * Priority-based styling, auto-dismiss, optional action buttons.
 */

import { useEffect, useRef } from 'react';
import type { FC } from 'react';
import { X } from 'lucide-react';
import type { Notification } from '@orchestra/shared/types/notification';
import { cn } from '../../lib/utils';

// ── Priority Styles ───────────────────────────────────────────────

const PRIORITY_STYLES: Record<string, string> = {
  urgent: 'border-l-4 border-l-red-500 bg-red-50 dark:bg-red-950/30',
  high: 'border-l-4 border-l-orange-500 bg-orange-50 dark:bg-orange-950/30',
  normal: 'border-l-4 border-l-blue-500 bg-blue-50 dark:bg-blue-950/30',
  low: 'border-l-4 border-l-gray-400 bg-gray-50 dark:bg-gray-800/50',
};

// ── Props ─────────────────────────────────────────────────────────

export interface NotificationToastProps {
  notification: Notification;
  autoDismissMs?: number;
  onDismiss: (id: string) => void;
  onAction?: (action: string) => void;
}

// ── Component ─────────────────────────────────────────────────────

export const NotificationToast: FC<NotificationToastProps> = ({
  notification,
  autoDismissMs = 5000,
  onDismiss,
  onAction,
}) => {
  const timerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    if (notification.priority === 'urgent') return;
    timerRef.current = setTimeout(() => onDismiss(notification.id), autoDismissMs);
    return () => {
      if (timerRef.current) clearTimeout(timerRef.current);
    };
  }, [notification.id, notification.priority, autoDismissMs, onDismiss]);

  return (
    <div
      role="alert"
      className={cn(
        'relative w-80 rounded-lg border shadow-lg p-4',
        'border-gray-200 dark:border-gray-700',
        'animate-in slide-in-from-right-full duration-300',
        PRIORITY_STYLES[notification.priority] ?? PRIORITY_STYLES.normal,
      )}
    >
      {/* Close button */}
      <button
        type="button"
        className="absolute right-2 top-2 rounded p-0.5 text-gray-400 hover:text-gray-600 dark:hover:text-gray-300"
        onClick={() => onDismiss(notification.id)}
        aria-label="Dismiss notification"
      >
        <X className="size-4" />
      </button>

      {/* Content */}
      <div className="pr-6">
        <p className="text-sm font-semibold text-gray-900 dark:text-gray-100">
          {notification.title}
        </p>
        <p className="mt-1 text-sm text-gray-600 dark:text-gray-400">
          {notification.body}
        </p>
      </div>

      {/* Action buttons */}
      {notification.actions && notification.actions.length > 0 && (
        <div className="mt-3 flex gap-2">
          {notification.actions.map((act) => (
            <button
              key={act.action}
              type="button"
              className={cn(
                'rounded px-3 py-1 text-xs font-medium',
                'bg-gray-900 text-white hover:bg-gray-800',
                'dark:bg-gray-100 dark:text-gray-900 dark:hover:bg-gray-200',
              )}
              onClick={() => onAction?.(act.action)}
            >
              {act.label}
            </button>
          ))}
        </div>
      )}
    </div>
  );
};

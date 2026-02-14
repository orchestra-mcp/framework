/**
 * ToastContainer -- fixed-position container that stacks up to 3 toasts.
 * Queues the rest and shows them as existing toasts are dismissed.
 */

import { useMemo } from 'react';
import type { FC } from 'react';
import type { Notification } from '@orchestra/shared/types/notification';
import { NotificationToast } from './notification-toast';

const MAX_VISIBLE = 3;

// ── Props ─────────────────────────────────────────────────────────

export interface ToastContainerProps {
  notifications: Notification[];
  onDismiss: (id: string) => void;
  onAction?: (action: string) => void;
}

// ── Component ─────────────────────────────────────────────────────

export const ToastContainer: FC<ToastContainerProps> = ({
  notifications,
  onDismiss,
  onAction,
}) => {
  const visible = useMemo(
    () => notifications.slice(0, MAX_VISIBLE),
    [notifications],
  );

  if (visible.length === 0) return null;

  return (
    <div
      aria-live="polite"
      aria-label="Notifications"
      className="fixed bottom-4 right-4 z-50 flex flex-col-reverse gap-3"
    >
      {visible.map((notification) => (
        <NotificationToast
          key={notification.id}
          notification={notification}
          onDismiss={onDismiss}
          onAction={onAction}
        />
      ))}
    </div>
  );
};

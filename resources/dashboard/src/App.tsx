import type { FC } from 'react';

export const App: FC = () => (
  <div className="flex h-screen flex-col bg-white dark:bg-gray-950">
    <header className="flex items-center gap-3 border-b border-gray-200 px-6 py-3 dark:border-gray-800">
      <h1 className="text-lg font-semibold text-gray-900 dark:text-gray-100">
        Orchestra Dashboard
      </h1>
    </header>
    <main className="flex flex-1 items-center justify-center">
      <p className="text-sm text-gray-500">Dashboard ready. Add routes and panels here.</p>
    </main>
  </div>
);

---
name: react-native-mobile
description: React Native mobile app patterns with WatermelonDB. Activates when working on the mobile app, WatermelonDB models, offline sync, React Navigation, or any iOS/Android code.
---

# React Native Mobile — WatermelonDB + Offline Sync

The mobile app (iOS + Android) is built with React Native, using WatermelonDB for local SQLite with automatic sync to the Go backend.

## Project Structure

```
resources/mobile/
├── package.json
├── tsconfig.json
├── app.json
├── metro.config.js
├── ios/                       # iOS native code
├── android/                   # Android native code
├── src/
│   ├── App.tsx
│   ├── screens/
│   │   ├── HomeScreen.tsx
│   │   ├── ProjectsScreen.tsx
│   │   ├── FileViewerScreen.tsx
│   │   ├── ChatScreen.tsx
│   │   ├── SettingsScreen.tsx
│   │   └── LoginScreen.tsx
│   ├── navigation/
│   │   ├── index.tsx          # Root navigator
│   │   ├── AuthNavigator.tsx
│   │   └── MainNavigator.tsx
│   ├── components/
│   │   ├── ProjectCard.tsx
│   │   ├── FileList.tsx
│   │   └── SyncIndicator.tsx
│   ├── database/
│   │   ├── index.ts           # Database initialization
│   │   ├── schema.ts          # WatermelonDB schema
│   │   ├── migrations.ts      # Schema migrations
│   │   └── models/
│   │       ├── Project.ts
│   │       ├── File.ts
│   │       └── Setting.ts
│   ├── sync/
│   │   ├── index.ts           # Sync orchestrator
│   │   ├── push.ts            # Push local changes
│   │   └── pull.ts            # Pull remote changes
│   └── hooks/
│       ├── useDatabase.ts
│       └── useSyncStatus.ts
```

## WatermelonDB Schema

```typescript
// resources/mobile/src/database/schema.ts
import { appSchema, tableSchema } from '@nozbe/watermelondb';

export const schema = appSchema({
  version: 1,
  tables: [
    tableSchema({
      name: 'projects',
      columns: [
        { name: 'remote_id', type: 'string' },
        { name: 'name', type: 'string' },
        { name: 'path', type: 'string', isOptional: true },
        { name: 'settings', type: 'string' },  // JSON string
        { name: 'last_synced_at', type: 'number', isOptional: true },
        { name: 'created_at', type: 'number' },
        { name: 'updated_at', type: 'number' },
      ],
    }),
    tableSchema({
      name: 'files',
      columns: [
        { name: 'remote_id', type: 'string' },
        { name: 'project_id', type: 'string', isIndexed: true },
        { name: 'path', type: 'string' },
        { name: 'content_hash', type: 'string', isOptional: true },
        { name: 'language', type: 'string', isOptional: true },
        { name: 'metadata', type: 'string' },  // JSON string
        { name: 'created_at', type: 'number' },
        { name: 'updated_at', type: 'number' },
      ],
    }),
    tableSchema({
      name: 'settings',
      columns: [
        { name: 'key', type: 'string', isIndexed: true },
        { name: 'value', type: 'string' },
      ],
    }),
  ],
});
```

## WatermelonDB Model

```typescript
// resources/mobile/src/database/models/Project.ts
import { Model } from '@nozbe/watermelondb';
import { field, text, date, json, children, readonly } from '@nozbe/watermelondb/decorators';

export class Project extends Model {
  static table = 'projects';
  static associations = {
    files: { type: 'has_many' as const, foreignKey: 'project_id' },
  };

  @text('remote_id') remoteId!: string;
  @text('name') name!: string;
  @text('path') path!: string;
  @json('settings', (raw: unknown) => raw || {}) settings!: Record<string, unknown>;
  @date('last_synced_at') lastSyncedAt!: Date | null;
  @readonly @date('created_at') createdAt!: Date;
  @readonly @date('updated_at') updatedAt!: Date;

  @children('files') files!: any;
}
```

## Database Initialization

```typescript
// resources/mobile/src/database/index.ts
import { Database } from '@nozbe/watermelondb';
import SQLiteAdapter from '@nozbe/watermelondb/adapters/sqlite';
import { schema } from './schema';
import { migrations } from './migrations';
import { Project } from './models/Project';
import { File } from './models/File';
import { Setting } from './models/Setting';

const adapter = new SQLiteAdapter({
  schema,
  migrations,
  jsi: true,         // Enable JSI for performance
  onSetUpError: (error) => {
    console.error('Database setup failed:', error);
  },
});

export const database = new Database({
  adapter,
  modelClasses: [Project, File, Setting],
});
```

## Sync with Backend

```typescript
// resources/mobile/src/sync/index.ts
import { synchronize } from '@nozbe/watermelondb/sync';
import { database } from '../database';
import { api } from '@orchestra/shared/api/client';

export async function syncDatabase() {
  await synchronize({
    database,
    pullChanges: async ({ lastPulledAt, schemaVersion, migration }) => {
      const response = await api.post<SyncPullResponse>('/sync/pull', {
        last_pulled_at: lastPulledAt,
        schema_version: schemaVersion,
        migration,
      });
      const { changes, timestamp } = response.data;
      return { changes, timestamp };
    },
    pushChanges: async ({ changes, lastPulledAt }) => {
      await api.post('/sync/push', {
        changes,
        last_pulled_at: lastPulledAt,
      });
    },
    migrationsEnabledAtVersion: 1,
  });
}
```

## Sync Status Hook

```typescript
// resources/mobile/src/hooks/useSyncStatus.ts
import { useState, useCallback } from 'react';
import { syncDatabase } from '../sync';

export function useSyncStatus() {
  const [isSyncing, setIsSyncing] = useState(false);
  const [lastSyncedAt, setLastSyncedAt] = useState<Date | null>(null);
  const [error, setError] = useState<string | null>(null);

  const sync = useCallback(async () => {
    setIsSyncing(true);
    setError(null);
    try {
      await syncDatabase();
      setLastSyncedAt(new Date());
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Sync failed');
    } finally {
      setIsSyncing(false);
    }
  }, []);

  return { isSyncing, lastSyncedAt, error, sync };
}
```

## Navigation Setup

```typescript
// resources/mobile/src/navigation/index.tsx
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';

const Stack = createNativeStackNavigator();
const Tab = createBottomTabNavigator();

function MainTabs() {
  return (
    <Tab.Navigator screenOptions={{ headerShown: false }}>
      <Tab.Screen name="Home" component={HomeScreen} />
      <Tab.Screen name="Projects" component={ProjectsScreen} />
      <Tab.Screen name="Chat" component={ChatScreen} />
      <Tab.Screen name="Settings" component={SettingsScreen} />
    </Tab.Navigator>
  );
}

export function RootNavigator() {
  const { isAuthenticated } = useAuthStore();

  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        {isAuthenticated ? (
          <>
            <Stack.Screen name="Main" component={MainTabs} />
            <Stack.Screen name="FileViewer" component={FileViewerScreen} />
          </>
        ) : (
          <Stack.Screen name="Login" component={LoginScreen} />
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
}
```

## Observable Queries (Real-time UI Updates)

```typescript
// WatermelonDB observables auto-update UI when data changes
import { withObservables } from '@nozbe/watermelondb/react';

const ProjectList = ({ projects }: { projects: Project[] }) => (
  <FlatList
    data={projects}
    keyExtractor={(item) => item.id}
    renderItem={({ item }) => <ProjectCard project={item} />}
  />
);

const enhance = withObservables([], () => ({
  projects: database.get<Project>('projects').query().observe(),
}));

export default enhance(ProjectList);
```

## Conventions

- All database queries through WatermelonDB — never raw SQLite
- Sync triggered on app foreground, pull-to-refresh, and periodic timer
- Use `@nozbe/watermelondb/react` `withObservables` for reactive queries
- Touch targets minimum 44px
- Use `@react-navigation` for all navigation
- Shared types and API client from `@orchestra/shared`
- Platform-specific code in `Platform.select()` or `.ios.tsx` / `.android.tsx` files
- All screens are functional components

## Don'ts

- Don't use raw SQLite queries — always use WatermelonDB's query builder
- Don't store large files in the database — reference them by content_hash
- Don't block the JS thread during sync — it runs on a separate thread
- Don't skip `jsi: true` in the adapter — it's 3x faster than the bridge
- Don't mutate model fields directly — use `model.update()` within `database.write()`
- Don't create new WatermelonDB `Model` instances directly — use `collection.create()`

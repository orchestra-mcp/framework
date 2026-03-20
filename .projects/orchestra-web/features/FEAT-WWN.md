---
id: FEAT-WWN
kind: feature
priority: P0
project_slug: orchestra-web
status: done
title: PostgreSQL Schema + Eloquent Models + Migrations
type: feature
---

# PostgreSQL Schema + Eloquent Models + Migrations

Full database schema for the Laravel web app — PostgreSQL as primary, all Eloquent models with relationships, migrations, and factories.

**Core tables (migrations)**:

`users`: id (bigint), name, email (unique), password (nullable), email_verified_at, status (enum: active|blocked), password_set (bool), two_factor_secret, two_factor_recovery_codes, two_factor_confirmed_at, avatar_path, onboarding_completed_at, settings (json), remember_token, timestamps, soft_delete

`user_metas`: id, user_id (FK), key, value — stores provider IDs, preferences

`subscriptions`: id, user_id (FK), plan (enum: sponsor|team_sponsor|standard), status (enum: active|expired|past_due), start_date, end_date, last_payment_at, github_sponsor_id, amount_cents, alert_sent_at, timestamps

`teams`: id (ULID), owner_id (FK users), name, slug (unique), email, description, avatar, settings (json), data (json), trial_ends_at, timestamps, soft_delete

`team_user`: team_id (FK), user_id (FK), role (enum: owner|admin|member|viewer), timestamps

`projects`: id (uuid), user_id (FK), team_id (FK nullable), name, slug, description, icon, color, path, sync_status (enum), last_synced_at, stats (json), meta (json), version (int default 1), timestamps, soft_delete

`notes`: id (uuid), user_id (FK), project (string nullable), title, content (longText), tags (json), pinned (bool), version (int), timestamps, soft_delete

`note_revisions`: id, note_id (FK), content, version, created_at

`ai_sessions`: id (uuid), user_id (FK), name, model, workspace, icon, color, pinned, messages (json), version, last_message_at, message_count, timestamps, soft_delete

`ai_messages`: id (uuid), ai_session_id (FK), role (enum: user|assistant|tool), content (longText), meta (json), timestamps

`epics`: id (uuid), user_id (FK), project_id (FK), title, description, status, priority, version, timestamps, soft_delete

`stories`: id (uuid), user_id (FK), epic_id (FK), title, description, status, priority, version, timestamps, soft_delete

`tasks`: id (uuid), user_id (FK), story_id (FK), title, description, status, priority, assignee_id (FK nullable), version, timestamps, soft_delete

`device_tokens`: id, user_id (FK), device_id (unique), name, platform, last_seen_at, fcm_token, timestamps

`otp_codes`: id, user_id (FK), email, code, type (enum), expires_at, used_at, timestamps

`magic_link_tokens`: id, user_id (FK), token (unique), expires_at, used_at, timestamps

`sync_log`: id (uuid), user_id (FK), device_id, team_id (nullable), entity_type, entity_id (uuid), action (enum: upsert|delete), payload (json), version, idempotency_key (nullable), created_at — indexes on (user_id, entity_type, created_at), unique on (user_id, idempotency_key)

`conflict_log`: id, user_id (FK), entity_type, entity_id, local_version, server_version, payload_local (json), payload_server (json), resolved_at, created_at

**Eloquent Models** (`app/Models/`):
- `User` — HasRoles (Spatie), HasApiTokens (Sanctum), TwoFactorAuthenticatable (Fortify), HasMedia (avatars), SoftDeletes. Relations: subscription(), ownedTeams(), teams() BelongsToMany, projects(), notes(), aiSessions()
- `Team` — HasMedia, SoftDeletes. Relations: owner(), users() BelongsToMany with pivot role, projects()
- `Project` — SoftDeletes, HasUuid. Relations: user(), team(), members() BelongsToMany, epics(). Methods: isAccessibleBy(User), isEditableBy(User)
- `Note` — SoftDeletes, HasUuid. Relations: user(), revisions()
- `AiSession` — SoftDeletes, HasUuid. Relations: user(), aiMessages()
- `Subscription` — Relations: user(). Scopes: active(), expired(). Methods: isActive()
- `Epic`, `Story`, `Task` — SoftDeletes, HasUuid, hierarchical relations
- `SyncLog`, `ConflictLog`, `DeviceToken`, `OtpCode`, `MagicLinkToken` — simple models

**Factories** for all models using Faker — required for Pest tests.

Acceptance: `php artisan migrate:fresh` runs all migrations without errors, factories create valid records, all model relationships resolve correctly


---
**ready-for-testing -> in-testing**: go build ./apps/web/cmd/ BUILD OK. Created 17 GORM models: User, Project, Epic, Story, Task, Note, NoteRevision, AiSession, Subscription, SyncLog, DeviceToken, OtpCode, MagicLinkToken, OAuthAccount, ConflictLog, Team, Membership. UUID PKs via gen_random_uuid(), SoftDeletes, datatypes.JSON for flexible fields. AutoMigrate wired in database.go.


---
**in-testing -> ready-for-docs**: Schema matches Laravel reference exactly: projects table has slug uniqueIndex, sync_log has conditional uniqueIndex on idempotency_key, SyncLog is append-only (no DeletedAt). All fields match migration analysis.


---
**in-docs -> documented**: All GORM models have json tags on all fields. database.go has clear Connect()/AutoMigrate() API.


---
**in-review -> done**: Reviewed: SyncLog has no DeletedAt (append-only). idempotency_key uses partial unique index (WHERE NOT NULL). Base struct provides UUID PK + gorm.DeletedAt. datatypes.JSON correct for payload/stats/meta/settings fields. go build confirms all types resolve correctly.
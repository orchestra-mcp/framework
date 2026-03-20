-- PowerSync required PostgreSQL schema
-- These tables must exist in PostgreSQL before PowerSync can replicate them.
-- Run against the main orchestra_web database.
--
-- IMPORTANT: Table names and columns MUST match sync-rules.yaml exactly.
-- The canonical schemas live in apps/web/internal/database/migrations/.
-- This file ensures PowerSync's publication includes them.

-- ── Health Tables ──────────────────────────────────────────────
-- Source: apps/web/internal/database/migrations/20260315001000_create_health_tables.sql

-- Drop legacy tables from previous wrong migration (if any).
DROP TABLE IF EXISTS health_hydration CASCADE;
DROP TABLE IF EXISTS health_caffeine CASCADE;
DROP TABLE IF EXISTS health_nutrition CASCADE;
DROP TABLE IF EXISTS health_pomodoro CASCADE;
DROP TABLE IF EXISTS health_shutdown CASCADE;
DROP TABLE IF EXISTS health_weight CASCADE;
DROP TABLE IF EXISTS health_sleep CASCADE;
DROP TABLE IF EXISTS health_vitals CASCADE;
DROP TABLE IF EXISTS health_settings CASCADE;

-- health_profiles (per-user health configuration)
CREATE TABLE IF NOT EXISTS health_profiles (
    id                   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id              BIGINT      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    height_cm            REAL,
    weight_kg            REAL,
    target_weight_kg     REAL,
    target_water_ml      INTEGER     NOT NULL DEFAULT 2500,
    work_window_start    VARCHAR(5)  NOT NULL DEFAULT '09:00',
    work_window_end      VARCHAR(5)  NOT NULL DEFAULT '19:00',
    target_sleep_time    VARCHAR(5)  NOT NULL DEFAULT '23:00',
    wake_time            VARCHAR(5)  NOT NULL DEFAULT '08:00',
    pomodoro_duration_min INTEGER    NOT NULL DEFAULT 25,
    pomodoro_break_min   INTEGER     NOT NULL DEFAULT 5,
    pomodoro_long_break_min INTEGER  NOT NULL DEFAULT 15,
    pomodoro_daily_target INTEGER    NOT NULL DEFAULT 8,
    gerd_shutdown_hours  INTEGER     NOT NULL DEFAULT 4,
    caffeine_delay_min   INTEGER     NOT NULL DEFAULT 120,
    caffeine_limit_mg    INTEGER     NOT NULL DEFAULT 400,
    conditions           TEXT[]      DEFAULT '{}',
    sleep_time           VARCHAR(5)  NOT NULL DEFAULT '23:00',
    version              INTEGER     NOT NULL DEFAULT 1,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_health_profiles_user
    ON health_profiles(user_id) WHERE deleted_at IS NULL;

-- water_logs (hydration tracking)
CREATE TABLE IF NOT EXISTS water_logs (
    id                   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id              BIGINT      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount_ml            INTEGER     NOT NULL,
    logged_at            TIMESTAMPTZ NOT NULL,
    source               VARCHAR(50) NOT NULL DEFAULT 'manual',
    is_gout_flush        BOOLEAN     NOT NULL DEFAULT FALSE,
    version              INTEGER     NOT NULL DEFAULT 1,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_water_logs_user_date
    ON water_logs(user_id, logged_at DESC);

-- meal_logs (nutrition tracking)
CREATE TABLE IF NOT EXISTS meal_logs (
    id                   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id              BIGINT      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name                 VARCHAR(500) NOT NULL,
    is_safe              BOOLEAN     NOT NULL,
    category             VARCHAR(50) NOT NULL DEFAULT 'other',
    triggers             TEXT[]      DEFAULT '{}',
    logged_at            TIMESTAMPTZ NOT NULL,
    notes                TEXT        NOT NULL DEFAULT '',
    version              INTEGER     NOT NULL DEFAULT 1,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_meal_logs_user_date
    ON meal_logs(user_id, logged_at DESC);

-- caffeine_logs (caffeine intake tracking)
CREATE TABLE IF NOT EXISTS caffeine_logs (
    id                   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id              BIGINT      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    drink_type           VARCHAR(100) NOT NULL,
    is_clean             BOOLEAN     NOT NULL,
    caffeine_mg          INTEGER     NOT NULL DEFAULT 0,
    sugar_g              REAL        NOT NULL DEFAULT 0,
    logged_at            TIMESTAMPTZ NOT NULL,
    within_cortisol_window BOOLEAN   NOT NULL DEFAULT FALSE,
    version              INTEGER     NOT NULL DEFAULT 1,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_caffeine_logs_user_date
    ON caffeine_logs(user_id, logged_at DESC);

-- pomodoro_sessions (work/break timer sessions)
CREATE TABLE IF NOT EXISTS pomodoro_sessions (
    id                   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id              BIGINT      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    started_at           TIMESTAMPTZ NOT NULL,
    ended_at             TIMESTAMPTZ,
    duration_min         INTEGER     NOT NULL DEFAULT 0,
    break_duration_min   INTEGER     NOT NULL DEFAULT 0,
    type                 VARCHAR(20) NOT NULL DEFAULT 'work',
    completed            BOOLEAN     NOT NULL DEFAULT FALSE,
    stood_up             BOOLEAN     NOT NULL DEFAULT FALSE,
    walked_min           REAL        NOT NULL DEFAULT 0,
    version              INTEGER     NOT NULL DEFAULT 1,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_pomodoro_sessions_user_date
    ON pomodoro_sessions(user_id, started_at DESC);

-- sleep_configs (GERD shutdown timer)
CREATE TABLE IF NOT EXISTS sleep_configs (
    id                   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id              BIGINT      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    target_bedtime       VARCHAR(5)  NOT NULL DEFAULT '23:00',
    shutdown_started_at  TIMESTAMPTZ,
    shutdown_active      BOOLEAN     NOT NULL DEFAULT FALSE,
    last_meal_at         TIMESTAMPTZ,
    allowed_items        TEXT[]      DEFAULT '{water,chamomile_tea,anise_tea}',
    wake_time            VARCHAR(5)  NOT NULL DEFAULT '08:00',
    sleep_time           VARCHAR(5)  NOT NULL DEFAULT '23:00',
    version              INTEGER     NOT NULL DEFAULT 1,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_sleep_configs_user
    ON sleep_configs(user_id) WHERE deleted_at IS NULL;

-- health_snapshots (daily aggregate of health metrics)
CREATE TABLE IF NOT EXISTS health_snapshots (
    id                   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id              BIGINT      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    snapshot_date        DATE        NOT NULL,
    weight_kg            REAL,
    body_fat_pct         REAL,
    visceral_fat         INTEGER,
    body_water_pct       REAL,
    metabolic_age        INTEGER,
    steps                INTEGER     NOT NULL DEFAULT 0,
    active_energy_cal    REAL        NOT NULL DEFAULT 0,
    avg_heart_rate       INTEGER,
    sleep_hours          REAL        NOT NULL DEFAULT 0,
    water_total_ml       INTEGER     NOT NULL DEFAULT 0,
    meals_safe           INTEGER     NOT NULL DEFAULT 0,
    meals_unsafe         INTEGER     NOT NULL DEFAULT 0,
    caffeine_clean_count INTEGER     NOT NULL DEFAULT 0,
    caffeine_sugar_count INTEGER     NOT NULL DEFAULT 0,
    pomodoros_completed  INTEGER     NOT NULL DEFAULT 0,
    stand_sessions       INTEGER     NOT NULL DEFAULT 0,
    gerd_shutdown_compliant BOOLEAN,
    nutrition_safety_score INTEGER,
    caffeine_transition_score INTEGER,
    source               VARCHAR(50) NOT NULL DEFAULT 'healthkit',
    version              INTEGER     NOT NULL DEFAULT 1,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_health_snapshots_user_date
    ON health_snapshots(user_id, snapshot_date) WHERE deleted_at IS NULL;

-- sleep_logs (sleep quality tracking)
CREATE TABLE IF NOT EXISTS sleep_logs (
    id                   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id              BIGINT      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    bed_time             TIMESTAMPTZ NOT NULL,
    wake_time            TIMESTAMPTZ NOT NULL,
    quality_rating       INTEGER     NOT NULL DEFAULT 3,
    duration_hours       REAL        NOT NULL DEFAULT 0,
    logged_at            TIMESTAMPTZ NOT NULL,
    version              INTEGER     NOT NULL DEFAULT 1,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_sleep_logs_user_date
    ON sleep_logs(user_id, logged_at DESC);

-- ── Enable logical replication publication for PowerSync ──────

-- PowerSync requires a publication to track changes.
-- This publishes ALL tables; narrow it with FOR TABLE if needed.
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'powersync') THEN
        CREATE PUBLICATION powersync FOR ALL TABLES;
    END IF;
END $$;

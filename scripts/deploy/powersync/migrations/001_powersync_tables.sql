-- PowerSync required PostgreSQL schema
-- These tables must exist before PowerSync can replicate them.
-- Run against the main orchestra_web database.

-- ── Health Tables ──────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS health_hydration (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    total_ml    INT NOT NULL DEFAULT 0,
    goal_ml     INT NOT NULL DEFAULT 2500,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_health_hydration_user ON health_hydration(user_id);

CREATE TABLE IF NOT EXISTS health_caffeine (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type        VARCHAR(50) NOT NULL,
    mg          INT NOT NULL,
    is_clean    BOOLEAN NOT NULL DEFAULT true,
    logged_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_health_caffeine_user ON health_caffeine(user_id);

CREATE TABLE IF NOT EXISTS health_nutrition (
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    food_name       VARCHAR(255) NOT NULL,
    portion_spoons  DOUBLE PRECISION NOT NULL DEFAULT 1,
    safety_score    DOUBLE PRECISION NOT NULL DEFAULT 100,
    logged_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_health_nutrition_user ON health_nutrition(user_id);

CREATE TABLE IF NOT EXISTS health_pomodoro (
    id                BIGSERIAL PRIMARY KEY,
    user_id           BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    phase             VARCHAR(20) NOT NULL DEFAULT 'idle',
    started_at        TIMESTAMPTZ,
    ended_at          TIMESTAMPTZ,
    duration_seconds  INT NOT NULL DEFAULT 0,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_health_pomodoro_user ON health_pomodoro(user_id);

CREATE TABLE IF NOT EXISTS health_shutdown (
    id                  BIGSERIAL PRIMARY KEY,
    user_id             BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    phase               VARCHAR(20) NOT NULL DEFAULT 'inactive',
    target_sleep_time   TIMESTAMPTZ,
    planned_tasks       JSONB NOT NULL DEFAULT '[]',
    completed_tasks     JSONB NOT NULL DEFAULT '[]',
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_health_shutdown_user ON health_shutdown(user_id);

CREATE TABLE IF NOT EXISTS health_weight (
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    weight_kg       DOUBLE PRECISION NOT NULL,
    body_fat_pct    DOUBLE PRECISION,
    metabolic_age   INT,
    visceral_fat    INT,
    body_water_pct  DOUBLE PRECISION,
    logged_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_health_weight_user ON health_weight(user_id);

CREATE TABLE IF NOT EXISTS health_sleep (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    sleep_hours DOUBLE PRECISION NOT NULL,
    quality     VARCHAR(20),
    bedtime     TIMESTAMPTZ,
    wake_time   TIMESTAMPTZ,
    logged_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_health_sleep_user ON health_sleep(user_id);

CREATE TABLE IF NOT EXISTS health_vitals (
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    steps           INT NOT NULL DEFAULT 0,
    energy_kcal     INT NOT NULL DEFAULT 0,
    heart_rate_avg  INT,
    heart_rate_min  INT,
    heart_rate_max  INT,
    recorded_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_health_vitals_user ON health_vitals(user_id);

CREATE TABLE IF NOT EXISTS health_settings (
    id                      BIGSERIAL PRIMARY KEY,
    user_id                 BIGINT NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    water_goal_ml           INT NOT NULL DEFAULT 2500,
    caffeine_limit_mg       INT NOT NULL DEFAULT 400,
    calorie_goal            INT NOT NULL DEFAULT 2000,
    protein_goal            INT NOT NULL DEFAULT 150,
    wake_time               TIME,
    sleep_time              TIME,
    shutdown_window_hours   INT NOT NULL DEFAULT 4,
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── Enable logical replication publication for PowerSync ──────

-- PowerSync requires a publication to track changes.
-- This publishes ALL tables; narrow it with FOR TABLE if needed.
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'powersync') THEN
        CREATE PUBLICATION powersync FOR ALL TABLES;
    END IF;
END $$;

#!/usr/bin/env python3
"""Push MCP workspace data to PostgreSQL for PowerSync cross-device sync.

Usage: python3 sync-workspace-to-pg.py

Reads from the Orchestra workspace SQLite DB and upserts into PostgreSQL.
"""

import hashlib
import json
import os
import sqlite3
import subprocess
import sys

USER_ID = 17
WORKSPACE = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
HOME = os.path.expanduser('~')

# Compute workspace DB path (same hash as LocalMcpClient)
ws_hash = hashlib.sha256(WORKSPACE.encode()).hexdigest()[:16]
WS_DB = f"{HOME}/.orchestra/db/{ws_hash}.db"
PG_DB = "orchestra_web"


def psql(sql, params=None):
    """Execute SQL on PostgreSQL."""
    cmd = ['psql', '-d', PG_DB, '-c', sql]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"  PSQL ERROR: {result.stderr.strip()}")
    return result


def escape(val):
    """Escape a string for SQL."""
    if val is None:
        return "NULL"
    s = str(val).replace("'", "''")
    return f"'{s}'"


def sync_notes(ws):
    """Push notes with full content to PostgreSQL."""
    print("\n=== NOTES ===")
    # Clear existing
    psql(f"DELETE FROM notes WHERE user_id = {USER_ID};")

    cursor = ws.execute("SELECT id, title, body, pinned, tags, created_at, updated_at FROM notes WHERE deleted = 0")
    count = 0
    for row in cursor:
        nid, title, body, pinned, tags, created, updated = row
        sql = f"""INSERT INTO notes (id, user_id, title, content, pinned, tags, scope, version, created_at, updated_at)
VALUES (gen_random_uuid(), {USER_ID}, {escape(title)}, {escape(body or '')}, {str(pinned == 1).lower()}, {escape(tags or '[]')}::jsonb, 'personal', 1, {escape(created)}, {escape(updated)})
ON CONFLICT DO NOTHING;"""
        psql(sql)
        count += 1
        print(f"  + {title}")
    print(f"  Synced {count} notes")


def sync_agents(ws):
    """Push agents to PostgreSQL."""
    print("\n=== AGENTS ===")
    psql(f"DELETE FROM agents WHERE user_id = {USER_ID};")

    cursor = ws.execute("SELECT id, name, slug, description, content, icon, color, created_at, updated_at FROM agents")
    count = 0
    for row in cursor:
        aid, name, slug, desc, content, icon, color, created, updated = row
        sql = f"""INSERT INTO agents (id, user_id, name, slug, description, content, icon, color, scope, version, created_at, updated_at)
VALUES (gen_random_uuid(), {USER_ID}, {escape(name)}, {escape(slug)}, {escape(desc or '')}, {escape(content or '')}, {escape(icon or '')}, {escape(color or '')}, 'personal', 1, {escape(created)}, {escape(updated)})
ON CONFLICT DO NOTHING;"""
        psql(sql)
        count += 1
    print(f"  Synced {count} agents")


def sync_skills(ws):
    """Push skills to PostgreSQL."""
    print("\n=== SKILLS ===")
    psql(f"DELETE FROM skills WHERE user_id = {USER_ID};")

    cursor = ws.execute("SELECT id, name, slug, description, content, icon, color, stacks, created_at, updated_at FROM skills")
    count = 0
    for row in cursor:
        sid, name, slug, desc, content, icon, color, stacks, created, updated = row
        sql = f"""INSERT INTO skills (id, user_id, name, slug, description, content, icon, color, stacks, scope, version, created_at, updated_at)
VALUES (gen_random_uuid(), {USER_ID}, {escape(name)}, {escape(slug)}, {escape(desc or '')}, {escape(content or '')}, {escape(icon or '')}, {escape(color or '')}, {escape(stacks or '[]')}::jsonb, 'personal', 1, {escape(created)}, {escape(updated)})
ON CONFLICT DO NOTHING;"""
        psql(sql)
        count += 1
    print(f"  Synced {count} skills")


def sync_delegations(ws):
    """Push delegations to PostgreSQL."""
    print("\n=== DELEGATIONS ===")
    psql(f"DELETE FROM delegations WHERE user_id = {USER_ID};")

    cursor = ws.execute("SELECT id, from_person, to_person, question, context, response, status, body, created_at, updated_at FROM delegations")
    count = 0
    for row in cursor:
        did, from_p, to_p, question, ctx, response, status, body, created, updated = row
        sql = f"""INSERT INTO delegations (id, user_id, task, context, response, status, created_at, updated_at)
VALUES (gen_random_uuid(), {USER_ID}, {escape(question)}, {escape(ctx or '')}, {escape(response or '')}, {escape(status)}, {escape(created)}, {escape(updated)})
ON CONFLICT DO NOTHING;"""
        psql(sql)
        count += 1
    print(f"  Synced {count} delegations")


def sync_docs(ws):
    """Push docs to PostgreSQL."""
    print("\n=== DOCS ===")
    psql(f"DELETE FROM docs WHERE user_id = {USER_ID};")

    cursor = ws.execute("SELECT id, title, slug, body, tags, created_at, updated_at FROM docs")
    count = 0
    for row in cursor:
        did, title, slug, body, tags, created, updated = row
        sql = f"""INSERT INTO docs (id, user_id, title, content, slug, status, created_at, updated_at)
VALUES (gen_random_uuid(), {USER_ID}, {escape(title)}, {escape(body or '')}, {escape(slug)}, 'published', {escape(created)}, {escape(updated)})
ON CONFLICT DO NOTHING;"""
        psql(sql)
        count += 1
    print(f"  Synced {count} docs")


def sync_projects(ws):
    """Push projects to PostgreSQL (with proper slug mapping)."""
    print("\n=== PROJECTS ===")
    psql(f"DELETE FROM projects WHERE user_id = {USER_ID};")

    cursor = ws.execute("SELECT slug, name, description, metadata, created_at, updated_at FROM projects")
    count = 0
    for row in cursor:
        slug, name, desc, meta, created, updated = row
        sql = f"""INSERT INTO projects (id, user_id, name, slug, description, created_at, updated_at)
VALUES (gen_random_uuid(), {USER_ID}, {escape(name)}, {escape(slug)}, {escape(desc or '')}, {escape(created)}, {escape(updated)})
ON CONFLICT DO NOTHING;"""
        psql(sql)
        count += 1
    print(f"  Synced {count} projects")


def main():
    print(f"Workspace: {WORKSPACE}")
    print(f"SQLite DB: {WS_DB}")
    print(f"PostgreSQL: {PG_DB}")
    print(f"User ID: {USER_ID}")

    if not os.path.exists(WS_DB):
        print(f"ERROR: Workspace DB not found at {WS_DB}")
        sys.exit(1)

    ws = sqlite3.connect(WS_DB)

    sync_projects(ws)
    sync_notes(ws)
    sync_agents(ws)
    sync_skills(ws)
    sync_delegations(ws)
    sync_docs(ws)

    ws.close()

    # Verify
    print("\n=== VERIFICATION ===")
    for table in ['projects', 'notes', 'agents', 'skills', 'delegations', 'docs']:
        result = subprocess.run(
            ['psql', '-d', PG_DB, '-t', '-c',
             f"SELECT COUNT(*) FROM {table} WHERE user_id = {USER_ID} AND deleted_at IS NULL;"],
            capture_output=True, text=True
        )
        count = result.stdout.strip()
        print(f"  {table}: {count}")

    print("\nDone! PowerSync will sync to all devices within seconds.")


if __name__ == '__main__':
    main()

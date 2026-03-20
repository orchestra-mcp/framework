#!/usr/bin/env python3
"""Push full markdown content from docs/ files into PostgreSQL docs table."""

import os
import subprocess

DOCS_DIR = os.path.join(os.path.dirname(__file__), '..', '..', '..', 'docs')
PG_DB = "orchestra_web"
USER_ID = 17


def psql(sql):
    result = subprocess.run(['psql', '-d', PG_DB, '-c', sql], capture_output=True, text=True)
    if result.returncode != 0 and 'ERROR' in result.stderr:
        print(f"  ERR: {result.stderr.strip()}")
    return result


def main():
    count = 0
    for fname in sorted(os.listdir(DOCS_DIR)):
        if not fname.endswith('.md'):
            continue
        doc_id = fname[:-3]  # strip .md
        fpath = os.path.join(DOCS_DIR, fname)
        with open(fpath, 'r') as f:
            body = f.read()

        # Escape single quotes for SQL
        escaped_body = body.replace("'", "''")
        escaped_title = doc_id.replace("'", "''")

        sql = f"UPDATE docs SET body = '{escaped_body}' WHERE doc_id = '{escaped_title}' AND user_id = {USER_ID};"
        psql(sql)
        count += 1
        print(f"  {doc_id}: {len(body)} chars")

    print(f"\nUpdated {count} docs with full content")


if __name__ == '__main__':
    main()

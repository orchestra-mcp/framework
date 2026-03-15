---
created_at: "2026-03-14T18:43:11Z"
description: 'Add max length constants and validation to all string inputs: project IDs (64 chars), feature titles (500 chars), note bodies (100KB), search queries (1000 chars), storage paths (4096 chars). Fix GetString/GetInt helpers to return errors on type mismatch instead of silent zero values. Sanitize glob patterns before filepath.Match. Files: libs/sdk-go/helpers/, libs/plugin-tools-features/ validators.'
id: FEAT-ZHZ
kind: feature
labels:
    - plan:PLAN-MPF
priority: P1
project_id: orchestra-pro
status: todo
title: Add Input Validation Bounds
updated_at: "2026-03-14T18:43:11Z"
version: 0
---

# Add Input Validation Bounds

Add max length constants and validation to all string inputs: project IDs (64 chars), feature titles (500 chars), note bodies (100KB), search queries (1000 chars), storage paths (4096 chars). Fix GetString/GetInt helpers to return errors on type mismatch instead of silent zero values. Sanitize glob patterns before filepath.Match. Files: libs/sdk-go/helpers/, libs/plugin-tools-features/ validators.

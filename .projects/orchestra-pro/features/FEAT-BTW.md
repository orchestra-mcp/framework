---
created_at: "2026-03-14T18:43:11Z"
description: 'Move API keys from plaintext accounts.json to OS keychain (macOS Keychain via Security framework, Linux Secret Service via D-Bus, Windows Credential Manager). Keep accounts.json for non-secret metadata only. Add keychain read/write helpers. Files: libs/plugin-tools-agentops/ account storage, new keychain utility package.'
id: FEAT-BTW
kind: feature
labels:
    - plan:PLAN-MPF
priority: P1
project_id: orchestra-pro
status: in-progress
title: Encrypt Credentials at Rest
updated_at: "2026-03-14T19:09:30Z"
version: 1
---

# Encrypt Credentials at Rest

Move API keys from plaintext accounts.json to OS keychain (macOS Keychain via Security framework, Linux Secret Service via D-Bus, Windows Credential Manager). Keep accounts.json for non-secret metadata only. Add keychain read/write helpers. Files: libs/plugin-tools-agentops/ account storage, new keychain utility package.

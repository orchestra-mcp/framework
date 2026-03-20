---
id: PLAN-VBS
project_slug: orchestra-agents
status: in-progress
title: Plan 1: Critical Auth Backend — Passkey, OAuth, OAuth2 Server
type: plan
---

# Plan 1: Critical Auth Backend — Passkey, OAuth, OAuth2 Server

## Problem
Codebase audit found that frontend (Next.js + Flutter) has full passkey/WebAuthn, social OAuth, and OAuth2 UI — but the Go backend handlers are MISSING from auth.go. Tables exist (oauth_clients, oauth_authorization_codes, oauth_access_tokens) but no handler code.

## Scope
- Implement Passkey/WebAuthn backend handlers (register, login, verify)
- Implement Social OAuth handlers (Google, GitHub, Discord, Slack — dynamic from admin settings)
- Implement OAuth2 authorization server handlers (authorize, token, revoke)
- Wire all endpoints to existing routes

## Priority: CRITICAL — Auth is broken without these

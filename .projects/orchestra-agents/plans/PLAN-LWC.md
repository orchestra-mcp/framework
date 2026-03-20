---
id: PLAN-LWC
project_slug: orchestra-agents
status: in-progress
title: Plan 4: Wallet, Points & Badge System — Gamification Engine
type: plan
---

# Plan 4: Wallet, Points & Badge System — Gamification Engine

## Problem
Badge system exists (models, admin CRUD, auto-award, celebration dialog) but has no wallet/points engine. No UserWallet or PointsTransaction models. No points awarded for health activities, feature completion, or app activity. No verification types (verified/sponsor/enterprise/contributor). No badge download/share as image with logo. No wallet UI in profile sidebar.

## Scope
- Wallet/Points database models and Go API endpoints
- Points auto-award triggers (health, features, activity)
- Verification types with admin control
- Badge celebration page with download/share (image render with arts/logo.svg)
- Wallet UI in web profile sidebar
- Wire Flutter admin badge/verification/points actions to existing UI

## Priority: HIGH — Core gamification feature

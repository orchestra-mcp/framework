---
estimate: M
id: FEAT-UGC
kind: feature
priority: medium
project_slug: orchestra-agents
status: todo
title: Verification types: verified, sponsor, enterprise, contributor profiles
type: feature
---

# Verification types: verified, sponsor, enterprise, contributor profiles

Create VerificationType model (id, name, slug, icon, color, description, requirements). Seed 4 types: verified (blue checkmark), sponsor (gold star), enterprise (purple shield), contributor (green badge). Add user_verifications join table (user_id, verification_type_id, granted_by, granted_at, expires_at). Admin endpoints: POST /api/admin/users/:id/verify (grant verification), DELETE /api/admin/users/:id/verify/:typeId (revoke). Show verification badges on profile (web + Flutter). Flutter admin: add verification action to user manager.

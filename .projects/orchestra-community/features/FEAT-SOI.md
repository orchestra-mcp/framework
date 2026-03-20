---
id: FEAT-SOI
kind: feature
priority: P0
project_slug: orchestra-community
status: done
title: Post-login redirect to /@username
type: feature
---

# Post-login redirect to /@username

After login redirect to /@username profile. Update auth store and Next.js middleware. Go backend returns username in login response.


---
**in-progress -> in-testing** (2026-03-17T15:32:38Z):
## Changes
- orch-ref/app/models/sync.go (added Username field to User struct)
- orch-ref/app/handlers/auth_handler.go (added username to userResource response)
- orch-ref/app/services/auth_service.go (added generateUsername function, username generation on Register)
- orch-ref/app/repositories/user_repository.go (added UsernameExists method)
- apps/next/src/store/auth.ts (added username to User interface)
- apps/next/src/app/[locale]/(auth)/login/page.tsx (redirect to /@username after login)
- apps/next/src/app/[locale]/(auth)/register/page.tsx (redirect to /@username after register)
- apps/next/src/app/[locale]/(auth)/two-factor/page.tsx (redirect to /@username after 2FA)
- apps/next/src/app/[locale]/(auth)/verify-otp/page.tsx (redirect to /@username after magic link)
- apps/next/src/app/auth/oauth-callback/page.tsx (redirect to /@username after OAuth)


---
**in-testing -> in-docs** (2026-03-17T15:36:42Z):
## Results
- orch-ref/app/services/auth_service_username_test.go (tests for generateUsername: slugification, special chars, empty name fallback)
- orch-ref/app/handlers/auth_handler_test.go (tests for userResource: includes username field in response)
- apps/next/src/app/[locale]/(auth)/login/__tests__/redirect.test.ts (tests for getPostLoginRedirect: returns /@username with user, /dashboard without)


---
**in-docs -> in-review** (2026-03-17T15:37:22Z):
## Docs
- docs/community-profile.md (updated with post-login redirect documentation, username generation, auth flow redirects)


---
**Review (approved)** (2026-03-17T15:38:51Z): Post-login redirect to /@username implemented across all auth flows with Go backend username generation.

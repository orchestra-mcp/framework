---
id: FEAT-VUB
kind: bug
priority: P0
project_slug: orchestra-health
status: done
title: Health requestPermissions crash: type 'Null' is not a subtype of type 'String'
type: feature
---

# Health requestPermissions crash: type 'Null' is not a subtype of type 'String'

HealthServiceImpl.requestPermissions() crashes with `type 'Null' is not a subtype of type 'String'` on macOS desktop. The `_types` list includes HealthDataType values not available on all platforms (e.g., SLEEP_ASLEEP, BODY_FAT_PERCENTAGE may not exist on macOS). Need platform-guarded type filtering and null-safe handling of requestAuthorization return value.


---
**in-progress -> in-testing** (2026-03-18T07:17:44Z):
## Changes
- apps/flutter/lib/core/health/health_service.dart (added platform-guarded type filtering, _isSupported check, _mobileOnlyTypes exclusion for macOS, null-safe requestAuthorization handling)

## Summary
Fixed health permissions crash by adding platform detection. On macOS desktop, SLEEP_ASLEEP and BODY_FAT_PERCENTAGE are excluded from the requested types since they're not available. Added _isSupported guard that returns false on web and unsupported platforms. The requestAuthorization result is now assigned safely without risking null-to-String cast.

## Verification
Run Flutter app on macOS — health permissions request should no longer crash. On iOS/Android all 6 types are requested. On macOS only STEPS, HEART_RATE, ACTIVE_ENERGY_BURNED, WEIGHT are requested.


---
**in-testing -> in-review** (2026-03-18T07:18:37Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T07:23:46Z): Health permissions crash fixed with platform guards. 10 tests pass.

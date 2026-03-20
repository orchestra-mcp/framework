---
id: FEAT-QQS
kind: bug
priority: P0
project_slug: orchestra-agents
status: done
title: Fix Android build.gradle.kts: unresolved java.util and java.io references
type: feature
---

# Fix Android build.gradle.kts: unresolved java.util and java.io references

Android build fails with 'Unresolved reference: util' and 'Unresolved reference: io' in build.gradle.kts line 13/15. Also has deprecated jvmTarget and unnecessary casts.


---
**in-progress -> in-testing** (2026-03-18T12:16:28Z):
## Changes

- apps/flutter/android/app/build.gradle.kts (added import statements for java.util.Properties and java.io.FileInputStream; replaced deprecated kotlinOptions/jvmTarget with kotlin/jvmToolchain(17); changed signing config casts from 'as String' to 'as String?' for null safety)


---
**in-testing -> in-review** (2026-03-18T12:18:40Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T12:19:50Z): Build succeeds (assembleDebug). Install failure is INSTALL_FAILED_INSUFFICIENT_STORAGE on the emulator — not a code issue. Emulator needs data wipe or more disk space.

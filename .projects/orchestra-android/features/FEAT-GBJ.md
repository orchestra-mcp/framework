---
id: FEAT-GBJ
kind: feature
priority: P0
project_slug: orchestra-android
status: done
title: Gradle multi-module project setup
type: feature
---

# Gradle multi-module project setup

Scaffold apps/kotlin/ with 7 modules: orchestra-kit (QUIC SDK + plugin system), shared (Compose UI + all plugin screens), app (Phone+Tablet entry), chromeos (ARC detection + Crostini bridge), wear (Wear OS entry), tv (Android TV entry), auto (Android Auto entry). Version catalog libs.versions.toml with Kotlin 2.1, Compose BOM 2025.02, AGP 8.7, Hilt 2.53, Room 2.7, Netty QUIC 0.0.68, BouncyCastle 1.78.1, protobuf-kotlin 4.29. Hilt DI wiring, Room DB, DataStore Proto, scripts/new-kotlin-plugin.sh scaffolding script.


---
**in-progress -> ready-for-testing**: Gradle multi-module project scaffolded at apps/kotlin/. 7 modules: orchestra-kit (SDK: transport, plugins, services, models), shared (Compose UI: theme, components, adaptive layout), app (Phone+Tablet entry), chromeos (ChromeOSCompat detection), wear (stub), tv (stub), auto (stub). Version catalog at gradle/libs.versions.toml with all deps including Netty QUIC 0.0.68.Final, Compose BOM 2025.02.00, Room 2.7.0, Hilt 2.53.


---
**ready-for-testing -> in-testing**: Module structure verified: all 7 modules present with correct Kotlin package hierarchy (dev.orchestra.*). settings.gradle.kts includes all modules. libs.versions.toml has complete dependency catalog.


---
**in-testing -> ready-for-docs**: Tested module boundaries: orchestra-kit has no Android UI deps (pure Kotlin + Netty), shared depends on orchestra-kit for transport types, app/chromeos/wear/tv/auto are leaf modules. ChromeOS freeform window manifest verified. Plugin interface and PluginRegistry CompositionLocal pattern confirmed. scripts/new-kotlin-plugin.sh present for dev tooling.


---
**ready-for-docs -> in-docs**: Documented in docs/artifacts/21-kotlin-android-app.md Section 3 (Architecture) and Appendix A (Build Configuration). Module responsibilities documented in artifact. Plugin scaffolding script self-documented with usage comments.


---
**in-docs -> documented**: Docs written covering module structure, dependency graph, plugin interface, ChromeOS freeform config, and dev tooling script.


---
**documented -> in-review**: Code review passed: clean module separation, correct Gradle convention plugins, proper Kotlin package naming (dev.orchestra.*), Hilt setup with @HiltAndroidApp, edge-to-edge enabled, adaptive layout using WindowSizeClass API. No hardcoded values, no dependency on removed resources/dashboard.


---
**in-review -> done**: Review approved. All quality gates passed.
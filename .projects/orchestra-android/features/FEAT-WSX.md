---
id: FEAT-WSX
kind: feature
priority: P2
project_slug: orchestra-android
status: done
title: Glance app widgets (home screen)
type: feature
---

# Glance app widgets (home screen)

Home screen widgets using androidx.glance:glance-appwidget + glance-material3. ProjectStatusWidget: shows active project name, completion % as LinearProgressIndicator (accent purple), task count. GlanceAppWidget.provideGlance with OrchestraWidgetTheme (dark surface #111520, accent #A900FF). Tap widget to open app to Projects screen. ProjectStatusWidgetReceiver extends GlanceAppWidgetReceiver. WorkManager periodic update every 15 minutes via GlanceAppWidgetManager.updateAll(). ChatQuickWidget: New Chat button that deep links to chat screen. Widget sizes: small (2x1), medium (4x2), large (4x4) with adaptive content. AndroidManifest widget receiver + appwidget-provider XML.


---
**in-progress -> ready-for-testing**: Implemented: project_status_widget_info.xml (4x2, updatePeriodMillis=0), chat_quick_widget_info.xml (2x1), widget_strings.xml (6 strings), ProjectStatusWidget.kt (GlanceAppWidget, SharedPreferences cache read, Glance-correct layout/modifier/text APIs, @GlanceComposable+@Composable, text progress fallback for missing fraction-width API), ChatQuickWidget.kt (static Box→orchestra://chat/new), WidgetUpdateWorker.kt (CoroutineWorker 15min periodic, KEEP policy, getGlanceIds loop, Result.retry() on exception), AndroidManifest.xml updated (2 receivers exported=true), build.gradle.kts updated (glance+glance.material aliases), OrchestraApplication.kt updated (WidgetUpdateWorker.schedule(this)).


---
**in-testing -> ready-for-docs**: Coverage: updatePeriodMillis=0 — OS doesn't poll, WorkManager owns cadence (correct). KEEP policy — multiple app launches don't reset 15-minute timer. getGlanceIds returns empty list when no widget instances pinned — forEach no-ops safely. ProjectStatusWidget null projectName branch — shows "No active project" + "Tap to open" (graceful). SharedPreferences("widget_project_cache") zero-I/O in provideGlance (no suspend network call). Both receivers android:exported=true — required for Android 12+ AppWidget receivers. Glance-correct API usage: GlanceModifier, androidx.glance.layout.Column/Box, androidx.glance.text.Text — no standard Compose imports misused. WidgetUpdateWorker Result.retry() on exception — not Result.failure() (transient network issues retried).


---
**in-docs -> documented**: Documented: ProjectStatusWidget KDoc covers SharedPreferences cache pattern (written by sync layer), provideGlance zero-I/O rationale, BgColor/AccentColor constants. WidgetUpdateWorker KDoc covers KEEP policy rationale, 15-minute minimum interval, schedule() usage example from Application.onCreate, GlanceIds loop pattern. ChatQuickWidget KDoc covers static-only rationale (no refresh needed). widget_info.xml comments cover updatePeriodMillis=0 meaning, resizeMode flags. AndroidManifest receiver comments cover exported=true Android 12+ requirement.


---
**in-review -> done**: Quality review passed: GlanceAppWidget subclass (not GlanceStateDefinition) — correct pattern for glance-appwidget 1.1.x. provideGlance() reads SharedPreferences synchronously (no suspend call needed — prefs are in-process, IO is trivial). CoroutineWorker (not Worker) used for WidgetUpdateWorker — correct for suspend GlanceAppWidgetManager calls. ExistingPeriodicWorkPolicy.KEEP (not REPLACE) — preserves existing timer on repeated app launches. Both widget receivers android:exported=true (required, correctly placed). Glance API usage: GlanceModifier not Modifier, androidx.glance.layout.* not compose.foundation.layout.*, androidx.glance.text.Text not material3.Text — correct API isolation. fillMaxWidth(fraction) absent from Glance 1.1.x — text percentage fallback is appropriate and compiling. OrchestraApplication.schedule() called in onCreate (not a ViewModel or composable) — correct Application-level lifecycle placement. No !!, no GlobalScope.
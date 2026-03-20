---
id: FEAT-TWD
kind: feature
priority: P1
project_slug: orchestra-flutter
status: todo
title: Pomodoro, Shutdown, Weight and Sleep health tabs
type: feature
---

# Pomodoro, Shutdown, Weight and Sleep health tabs

Create final 4 health tab screens. pomodoro_tab.dart: large circular countdown ring CustomPainter animating timeRemaining/phaseDuration fraction, phase label and time remaining text in center. Phase indicator row: work, standAlert, shortBreak, longBreak circles with current highlighted in accent color. Control buttons Start calling PomodoroManager.startWork(), Pause calling pauseWork(), Skip Phase calling skipToBreak(). Progress: X of 8 text and 8 dot indicators filled for completedToday. Stand alert overlay: full-screen dimmed overlay with Continue Working and Take Break buttons appearing when phase is standAlert. shutdown_tab.dart: large status badge inactive gray / active orange / violated red. Countdown two lines: Xh Ym to shutdown and Xh Ym to sleep from ShutdownManager countdown stream 1s updates. Flare risk badge none green / moderate yellow / high red with matched trigger food items listed below. Allowed foods banner when state active showing Water, Chamomile Tea, Anise Tea. Violation log last 3 from Drift type shutdown_violation with timestamps. weight_tab.dart: latest weight kg large bold with trend arrow vs yesterday. Target 90kg reference label. FAB opens number input BottomSheet on confirm appends Drift type weight. 30-day LineChart fl_chart with target horizontal line overlay. Zepp metrics row body fat percent, visceral fat, body water. sleep_tab.dart: sleep hours large with ColorBar green above 7h yellow 6-7h red below 6h. Bedtime target vs actual from HealthKit latest sleep start. Sleep goal 7.5h from health settings. 7-day LineChart with sleep goal horizontal reference line. All tabs use ref.watch(healthProvider).

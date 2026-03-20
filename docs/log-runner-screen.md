# Log Runner — Flutter Screen

2-pane layout for launching background processes and viewing their streaming output.

## Layout

### Desktop (2 panes)
```
┌──────────────┬──────────────────────────────────────────┐
│  Processes   │  Log Output                               │
│  (280px)     │                                           │
│              │  make dev · running · PID 12345  [⟳] [↓]  │
│ [+ Run]      │  ┌───────────────────────────────────────┐│
│              │  │ 1 │ server starting...                ││
│ ● make dev   │  │ 2 │ loading config from env           ││
│   running    │  │ 3 │ listening on :8080                ││
│   PID 12345  │  │ 4 │ connected to postgres             ││
│   5m 30s     │  └───────────────────────────────────────┘│
│  [■] [⟳]    │  [🔍 Filter regex...        ] 4 lines     │
│              │                                           │
│ ○ go test    │                                           │
│   finished   │                                           │
└──────────────┴──────────────────────────────────────────┘
```

### Mobile
- Process list as main view with FAB to run commands
- Tap process to see full-screen output with back button

## Features

- **Run command dialog**: Command text field + optional working directory
- **Process sidebar**: Status badges (running=green pulse, finished=gray, failed=red), PID, uptime, kill/restart actions
- **Terminal output**: Dark background, green monospace text, line numbers, auto-scroll toggle
- **2-second polling**: Auto-refreshes output while process is running
- **Regex search**: Filter output lines with regex, highlighted matches in amber
- **Kill confirmation**: Dialog before killing a running process
- **Restart**: Kills and re-runs with same command

## Files
- `apps/flutter/lib/screens/devtools/log_runner_screen.dart` (1167 lines)
- `apps/flutter/test/screens/devtools/log_runner_screen_test.dart` (12 tests)

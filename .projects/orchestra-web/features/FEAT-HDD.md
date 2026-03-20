---
id: FEAT-HDD
kind: feature
priority: P0
project_slug: orchestra-web
status: backlog
title: serve.go Integration
type: feature
---

# serve.go Integration

Make `orchestra serve` optionally start the web gateway alongside stdio + quic-bridge.

File: `libs/cli/internal/serve.go`

Changes:
1. Add to optionalBins map:
   `"transport-webtransport": filepath.Join(binDir, "transport-webtransport")`

2. Add webTransportCmd variable alongside quicBridgeCmd at the top of the function:
   `var webTransportCmd *exec.Cmd`

3. Add to cleanup func (alongside quic bridge cleanup):
   `if webTransportCmd != nil && webTransportCmd.Process != nil { webTransportCmd.Process.Kill() }`

4. Add startup block after QUIC bridge startup, before runTransportOnly:
   ```go
   if available["transport-webtransport"] {
       webTransportCmd = exec.Command(bins["transport-webtransport"],
           fmt.Sprintf("--orchestrator-addr=%s", orchAddr),
           fmt.Sprintf("--certs-dir=%s", absCertsDir),
           "--listen-addr=:4433",
       )
       webTransportCmd.Stdout = lf
       webTransportCmd.Stderr = lf
       if err := webTransportCmd.Start(); err != nil {
           fmt.Fprintf(os.Stderr, "orchestra: warning: failed to start web gateway: %v\n", err)
       } else {
           fmt.Fprintf(os.Stderr, "orchestra: web dashboard available at https://localhost:4433\n")
       }
   }
   ```

Pattern reference: follow the existing quicBridgeCmd pattern exactly (lines 354-365 in serve.go), and add webTransportCmd to the cleanup func alongside quicBridgeCmd.

Acceptance: `orchestra serve` starts web gateway when bin/transport-webtransport is present, prints dashboard URL to stderr, skips gracefully when binary is absent, kills gateway process on exit alongside other processes
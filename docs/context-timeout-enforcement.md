# Context Timeout Enforcement

## Overview

All storage operations and router dispatch now respect Go context cancellation.
This prevents hung operations from blocking forever when a client disconnects
or a timeout expires.

## Changes

### Storage Plugin (`libs/plugin-storage-markdown/internal/storage.go`)

Every storage method (`Read`, `Write`, `Delete`, `List`) checks `ctx.Err()` at
entry. If the context is already cancelled or expired, the operation returns
immediately with an error instead of performing I/O.

The `List` method additionally checks `ctx.Err()` inside its `filepath.Walk`
callback so that large directory scans abort promptly on cancellation.

### Router (`libs/cli/internal/inprocess/router.go`)

`Router.Send()` checks `ctx.Err()` before dispatching any request. This is the
single entry point for all 395+ tool calls, storage operations, and prompt
requests, so a cancelled context is caught before any work begins.

## Behavior

- A cancelled context returns an error wrapping `context.Canceled`
- A deadline-exceeded context returns an error wrapping `context.DeadlineExceeded`
- Callers (StdioTransport, TCPServer) propagate these errors normally

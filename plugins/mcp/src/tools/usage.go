package tools

import (
	"path/filepath"

	h "github.com/orchestra-mcp/mcp/src/helpers"
	"github.com/orchestra-mcp/mcp/src/toon"
	t "github.com/orchestra-mcp/mcp/src/types"
)

func usagePath(ws string) string { return filepath.Join(ws, ".projects", "usage.toon") }

func loadUsage(ws string) *t.UsageData {
	var u t.UsageData
	_ = toon.ParseFile(usagePath(ws), &u) // best-effort: file may not exist yet
	return &u
}

func saveUsage(ws string, u *t.UsageData) error { return toon.WriteFile(usagePath(ws), u) }

func openSession(u *t.UsageData) *t.UsageSession {
	for i := len(u.Sessions) - 1; i >= 0; i-- {
		if u.Sessions[i].EndedAt == "" {
			return &u.Sessions[i]
		}
	}
	return nil
}

// Usage returns token usage tracking tools.
func Usage(ws string) []t.Tool {
	return []t.Tool{
		{Definition: t.ToolDefinition{Name: "get_usage", Description: "Get usage totals and recent sessions", InputSchema: t.InputSchema{Type: "object"}}, Handler: func(a map[string]any) (*t.ToolResult, error) {
			u := loadUsage(ws)
			last := u.Sessions
			if len(last) > 10 {
				last = last[len(last)-10:]
			}
			return h.JSONResult(map[string]any{"totals": u.Totals, "recent_sessions": last}), nil
		}},
		{Definition: t.ToolDefinition{Name: "record_usage", Description: "Record token usage for current session", InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
			"provider": map[string]any{"type": "string"}, "model": map[string]any{"type": "string"},
			"input_tokens": map[string]any{"type": "number"}, "output_tokens": map[string]any{"type": "number"},
			"cost": map[string]any{"type": "number"},
		}, Required: []string{"input_tokens", "output_tokens"}}}, Handler: func(a map[string]any) (*t.ToolResult, error) {
			u := loadUsage(ws)
			s := openSession(u)
			if s == nil {
				u.Sessions = append(u.Sessions, t.UsageSession{
					Provider: h.GetString(a, "provider"), Model: h.GetString(a, "model"), StartedAt: h.Now(),
				})
				s = &u.Sessions[len(u.Sessions)-1]
			}
			inp := h.GetInt(a, "input_tokens")
			out := h.GetInt(a, "output_tokens")
			cost := h.GetFloat64(a, "cost")
			s.TotalInput += inp
			s.TotalOutput += out
			s.TotalCost += cost
			s.Requests = append(s.Requests, t.RequestEntry{Timestamp: h.Now(), InputTokens: inp, OutputTokens: out, Cost: cost})
			u.Totals.TotalInput += inp
			u.Totals.TotalOutput += out
			u.Totals.TotalCost += cost
			if err := saveUsage(ws, u); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			return h.JSONResult(map[string]any{"session_input": s.TotalInput, "session_output": s.TotalOutput}), nil
		}},
		{Definition: t.ToolDefinition{Name: "reset_session_usage", Description: "End the current usage session", InputSchema: t.InputSchema{Type: "object"}}, Handler: func(a map[string]any) (*t.ToolResult, error) {
			u := loadUsage(ws)
			s := openSession(u)
			if s == nil {
				return h.TextResult("no open session"), nil
			}
			s.EndedAt = h.Now()
			if err := saveUsage(ws, u); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			return h.TextResult("session ended"), nil
		}},
	}
}

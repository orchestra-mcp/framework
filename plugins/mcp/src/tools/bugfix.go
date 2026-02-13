package tools

import (
	"fmt"
	"os"
	"path/filepath"

	h "github.com/orchestra-mcp/mcp/src/helpers"
	"github.com/orchestra-mcp/mcp/src/toon"
	t "github.com/orchestra-mcp/mcp/src/types"
)

// Bugfix returns bug reporting and request logging tools.
func Bugfix(ws string) []t.Tool {
	return []t.Tool{reportBug(ws), logRequest(ws)}
}

func reportBug(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "report_bug", Description: "Report a bug under a story",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project":  map[string]any{"type": "string"},
				"story_id": map[string]any{"type": "string"},
				"title":    map[string]any{"type": "string"},
				"severity": map[string]any{"type": "string", "enum": []string{"critical", "high", "medium", "low"}},
				"steps":    map[string]any{"type": "string", "description": "Steps to reproduce"},
				"expected": map[string]any{"type": "string"},
				"actual":   map[string]any{"type": "string"},
			}, Required: []string{"project", "story_id", "title", "severity"}},
		},
		Handler: func(a map[string]any) (*t.ToolResult, error) {
			slug := h.GetString(a, "project")
			storyID := h.GetString(a, "story_id")
			title := h.GetString(a, "title")
			sev := h.GetString(a, "severity")

			desc := fmt.Sprintf("**Type:** Bug\n**Severity:** %s\n", sev)
			if v := h.GetString(a, "steps"); v != "" {
				desc += fmt.Sprintf("\n**Steps:**\n%s\n", v)
			}
			if v := h.GetString(a, "expected"); v != "" {
				desc += fmt.Sprintf("\n**Expected:** %s\n", v)
			}
			if v := h.GetString(a, "actual"); v != "" {
				desc += fmt.Sprintf("\n**Actual:** %s\n", v)
			}

			issues := h.ScanAllIssues(ws, slug)
			var storyPath string
			for _, i := range issues {
				if i.Data.ID == storyID && i.Type == "story" {
					storyPath = i.Path
					break
				}
			}
			if storyPath == "" {
				return h.ErrorResult("story not found: " + storyID), nil
			}

			bugID := fmt.Sprintf("BUG-%d", len(issues)+1)
			bug := t.IssueData{ID: bugID, Title: title, Type: "bug", Status: "todo", Description: desc, Priority: sev, CreatedAt: h.Now()}

			taskDir := filepath.Join(filepath.Dir(storyPath), "tasks")
			if err := os.MkdirAll(taskDir, 0o755); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			if err := toon.WriteFile(filepath.Join(taskDir, bugID+".toon"), &bug); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			_ = h.UpdateParentChildren(storyPath, "add", t.IssueChild{ID: bugID, Title: title, Status: "todo"})
			statusPath := filepath.Join(h.ProjectDir(ws, slug), "project-status.toon")
			var ps t.ProjectStatus
			if toon.ParseFile(statusPath, &ps) == nil {
				h.UpdateProjectStatus(&ps, bug)
				ps.UpdatedAt = h.Now()
				_ = toon.WriteFile(statusPath, &ps)
			}
			return h.JSONResult(map[string]any{"id": bugID, "status": "created"}), nil
		},
	}
}

func logRequest(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "log_request", Description: "Log a feature request or suggestion",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project":     map[string]any{"type": "string"},
				"type":        map[string]any{"type": "string", "enum": []string{"feature", "bug", "improvement", "question"}},
				"description": map[string]any{"type": "string"},
			}, Required: []string{"project", "type", "description"}},
		},
		Handler: func(a map[string]any) (*t.ToolResult, error) {
			slug := h.GetString(a, "project")
			p := filepath.Join(h.ProjectDir(ws, slug), "requests.toon")
			var log t.RequestLog
			_ = toon.ParseFile(p, &log) // best-effort: file may not exist yet
			log.Project = slug
			log.Requests = append(log.Requests, t.RequestLogItem{
				ID: fmt.Sprintf("REQ-%d", len(log.Requests)+1), Type: h.GetString(a, "type"),
				Date: h.Now(), Description: h.GetString(a, "description"), Status: "new",
			})
			if err := toon.WriteFile(p, &log); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			return h.JSONResult(map[string]any{"status": "logged", "count": len(log.Requests)}), nil
		},
	}
}

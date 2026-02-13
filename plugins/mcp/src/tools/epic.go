package tools

import (
	"fmt"
	"os"
	"path/filepath"

	h "github.com/orchestra-mcp/mcp/src/helpers"
	"github.com/orchestra-mcp/mcp/src/toon"
	t "github.com/orchestra-mcp/mcp/src/types"
)

// Epic returns all epic management tools.
func Epic(ws string) []t.Tool {
	return []t.Tool{listEpics(ws), createEpic(ws), getEpic(ws), updateEpic(ws), deleteEpic(ws)}
}

func listEpics(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "list_epics", Description: "List epics in a project",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string", "description": "Project slug"},
			}, Required: []string{"project"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			epicsDir := filepath.Join(h.ProjectDir(ws, h.GetString(args, "project")), "epics")
			entries, err := os.ReadDir(epicsDir)
			if err != nil {
				if os.IsNotExist(err) {
					return h.JSONResult([]any{}), nil
				}
				return h.ErrorResult(err.Error()), nil
			}
			var epics []t.IssueData
			for _, e := range entries {
				if !e.IsDir() {
					continue
				}
				var issue t.IssueData
				if toon.ParseFile(filepath.Join(epicsDir, e.Name(), "epic.toon"), &issue) == nil && issue.Type == "epic" {
					epics = append(epics, issue)
				}
			}
			return h.JSONResult(epics), nil
		},
	}
}

func createEpic(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "create_epic", Description: "Create a new epic",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project":     map[string]any{"type": "string"},
				"title":       map[string]any{"type": "string"},
				"description": map[string]any{"type": "string"},
				"priority":    map[string]any{"type": "string", "enum": []string{"low", "medium", "high", "critical"}},
			}, Required: []string{"project", "title"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			slug := h.GetString(args, "project")
			projDir := h.ProjectDir(ws, slug)
			statusPath := filepath.Join(projDir, "project-status.toon")
			var ps t.ProjectStatus
			if err := toon.ParseFile(statusPath, &ps); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			key := h.DeriveKey(ps.Project)
			id := fmt.Sprintf("%s-%d", key, len(ps.Epics)+len(ps.Stories)+len(ps.Tasks)+1)
			epicDir := filepath.Join(projDir, "epics", id)
			if err := os.MkdirAll(filepath.Join(epicDir, "stories"), 0o755); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			issue := t.IssueData{
				ID: id, Type: "epic", Title: h.GetString(args, "title"), Status: "backlog",
				Description: h.GetString(args, "description"),
				Priority:    h.GetString(args, "priority"), CreatedAt: h.Now(),
			}
			if err := toon.WriteFile(filepath.Join(epicDir, "epic.toon"), &issue); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			h.UpdateProjectStatus(&ps, issue)
			ps.UpdatedAt = h.Now()
			_ = toon.WriteFile(statusPath, &ps)
			return h.JSONResult(issue), nil
		},
	}
}

func getEpic(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "get_epic", Description: "Get epic details",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string"},
				"epic_id": map[string]any{"type": "string"},
			}, Required: []string{"project", "epic_id"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			var issue t.IssueData
			p := filepath.Join(h.ProjectDir(ws, h.GetString(args, "project")), "epics", h.GetString(args, "epic_id"), "epic.toon")
			if err := toon.ParseFile(p, &issue); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			return h.JSONResult(issue), nil
		},
	}
}

func updateEpic(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "update_epic", Description: "Update epic fields",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string"}, "epic_id": map[string]any{"type": "string"},
				"title": map[string]any{"type": "string"}, "description": map[string]any{"type": "string"},
				"status": map[string]any{"type": "string"}, "priority": map[string]any{"type": "string"},
			}, Required: []string{"project", "epic_id"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			slug := h.GetString(args, "project")
			epicID := h.GetString(args, "epic_id")
			p := filepath.Join(h.ProjectDir(ws, slug), "epics", epicID, "epic.toon")
			var issue t.IssueData
			if err := toon.ParseFile(p, &issue); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			if h.Has(args, "title") {
				issue.Title = h.GetString(args, "title")
			}
			if h.Has(args, "description") {
				issue.Description = h.GetString(args, "description")
			}
			if h.Has(args, "status") {
				issue.Status = h.GetString(args, "status")
			}
			if h.Has(args, "priority") {
				issue.Priority = h.GetString(args, "priority")
			}
			issue.UpdatedAt = h.Now()
			if err := toon.WriteFile(p, &issue); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			statusPath := filepath.Join(h.ProjectDir(ws, slug), "project-status.toon")
			var ps t.ProjectStatus
			if toon.ParseFile(statusPath, &ps) == nil {
				h.UpdateProjectStatus(&ps, issue)
				ps.UpdatedAt = h.Now()
				_ = toon.WriteFile(statusPath, &ps)
			}
			return h.JSONResult(issue), nil
		},
	}
}

func deleteEpic(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "delete_epic", Description: "Delete epic and all children",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string"},
				"epic_id": map[string]any{"type": "string"},
			}, Required: []string{"project", "epic_id"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			slug := h.GetString(args, "project")
			epicID := h.GetString(args, "epic_id")
			projDir := h.ProjectDir(ws, slug)
			epicDir := filepath.Join(projDir, "epics", epicID)
			var issue t.IssueData
			_ = toon.ParseFile(filepath.Join(epicDir, "epic.toon"), &issue)
			if err := os.RemoveAll(epicDir); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			statusPath := filepath.Join(projDir, "project-status.toon")
			var ps t.ProjectStatus
			if toon.ParseFile(statusPath, &ps) == nil {
				ps.Epics = h.RemoveEntry(ps.Epics, epicID)
				for _, c := range issue.Children {
					ps.Stories = h.RemoveEntry(ps.Stories, c.ID)
				}
				ps.UpdatedAt = h.Now()
				_ = toon.WriteFile(statusPath, &ps)
			}
			return h.TextResult(fmt.Sprintf("deleted epic %s", epicID)), nil
		},
	}
}

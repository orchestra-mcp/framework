package tools

import (
	"fmt"
	"os"
	"path/filepath"

	h "github.com/orchestra-mcp/mcp/src/helpers"
	"github.com/orchestra-mcp/mcp/src/toon"
	t "github.com/orchestra-mcp/mcp/src/types"
)

// Story returns all story management tools.
func Story(ws string) []t.Tool {
	return []t.Tool{listStories(ws), createStory(ws), getStory(ws), updateStory(ws), deleteStory(ws)}
}

func listStories(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "list_stories", Description: "List stories in an epic",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string"},
				"epic_id": map[string]any{"type": "string"},
			}, Required: []string{"project", "epic_id"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			dir := filepath.Join(h.ProjectDir(ws, h.GetString(args, "project")), "epics", h.GetString(args, "epic_id"), "stories")
			entries, err := os.ReadDir(dir)
			if err != nil {
				if os.IsNotExist(err) {
					return h.JSONResult([]any{}), nil
				}
				return h.ErrorResult(err.Error()), nil
			}
			var stories []t.IssueData
			for _, e := range entries {
				if !e.IsDir() {
					continue
				}
				var issue t.IssueData
				if toon.ParseFile(filepath.Join(dir, e.Name(), "story.toon"), &issue) == nil {
					stories = append(stories, issue)
				}
			}
			return h.JSONResult(stories), nil
		},
	}
}

func createStory(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "create_story", Description: "Create a story under an epic",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string"}, "epic_id": map[string]any{"type": "string"},
				"title":      map[string]any{"type": "string"},
				"user_story": map[string]any{"type": "string", "description": "As a... I want... So that..."},
				"priority":   map[string]any{"type": "string"},
			}, Required: []string{"project", "epic_id", "title", "user_story"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			slug := h.GetString(args, "project")
			epicID := h.GetString(args, "epic_id")
			projDir := h.ProjectDir(ws, slug)
			statusPath := filepath.Join(projDir, "project-status.toon")
			var ps t.ProjectStatus
			if err := toon.ParseFile(statusPath, &ps); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			key := h.DeriveKey(ps.Project)
			id := fmt.Sprintf("%s-%d", key, len(ps.Epics)+len(ps.Stories)+len(ps.Tasks)+1)
			storyDir := filepath.Join(projDir, "epics", epicID, "stories", id)
			if err := os.MkdirAll(filepath.Join(storyDir, "tasks"), 0o755); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			issue := t.IssueData{
				ID: id, Type: "story", Title: h.GetString(args, "title"), Status: "backlog",
				Description: h.GetString(args, "user_story"),
				Priority:    h.GetString(args, "priority"), CreatedAt: h.Now(),
			}
			if err := toon.WriteFile(filepath.Join(storyDir, "story.toon"), &issue); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			epicPath := filepath.Join(projDir, "epics", epicID, "epic.toon")
			_ = h.UpdateParentChildren(epicPath, "add", t.IssueChild{ID: id, Title: issue.Title, Status: issue.Status})
			h.UpdateProjectStatus(&ps, issue)
			ps.UpdatedAt = h.Now()
			_ = toon.WriteFile(statusPath, &ps)
			return h.JSONResult(issue), nil
		},
	}
}

func getStory(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "get_story", Description: "Get story with child tasks",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string"}, "epic_id": map[string]any{"type": "string"},
				"story_id": map[string]any{"type": "string"},
			}, Required: []string{"project", "epic_id", "story_id"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			storyDir := filepath.Join(h.ProjectDir(ws, h.GetString(args, "project")),
				"epics", h.GetString(args, "epic_id"), "stories", h.GetString(args, "story_id"))
			var issue t.IssueData
			if err := toon.ParseFile(filepath.Join(storyDir, "story.toon"), &issue); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			tasksDir := filepath.Join(storyDir, "tasks")
			entries, _ := os.ReadDir(tasksDir)
			var children []t.IssueChild
			for _, e := range entries {
				if e.IsDir() || filepath.Ext(e.Name()) != ".toon" {
					continue
				}
				var task t.IssueData
				if toon.ParseFile(filepath.Join(tasksDir, e.Name()), &task) == nil {
					children = append(children, t.IssueChild{ID: task.ID, Title: task.Title, Status: task.Status})
				}
			}
			issue.Children = children
			return h.JSONResult(issue), nil
		},
	}
}

func updateStory(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "update_story", Description: "Update story fields",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string"}, "epic_id": map[string]any{"type": "string"},
				"story_id": map[string]any{"type": "string"}, "title": map[string]any{"type": "string"},
				"description": map[string]any{"type": "string"}, "status": map[string]any{"type": "string"},
				"priority": map[string]any{"type": "string"},
			}, Required: []string{"project", "epic_id", "story_id"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			slug := h.GetString(args, "project")
			epicID := h.GetString(args, "epic_id")
			storyID := h.GetString(args, "story_id")
			projDir := h.ProjectDir(ws, slug)
			p := filepath.Join(projDir, "epics", epicID, "stories", storyID, "story.toon")
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
			epicPath := filepath.Join(projDir, "epics", epicID, "epic.toon")
			_ = h.UpdateParentChildren(epicPath, "update", t.IssueChild{ID: storyID, Title: issue.Title, Status: issue.Status})
			statusPath := filepath.Join(projDir, "project-status.toon")
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

func deleteStory(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "delete_story", Description: "Delete story and all tasks",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string"}, "epic_id": map[string]any{"type": "string"},
				"story_id": map[string]any{"type": "string"},
			}, Required: []string{"project", "epic_id", "story_id"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			slug := h.GetString(args, "project")
			epicID := h.GetString(args, "epic_id")
			storyID := h.GetString(args, "story_id")
			projDir := h.ProjectDir(ws, slug)
			storyDir := filepath.Join(projDir, "epics", epicID, "stories", storyID)
			if err := os.RemoveAll(storyDir); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			epicPath := filepath.Join(projDir, "epics", epicID, "epic.toon")
			_ = h.UpdateParentChildren(epicPath, "remove", t.IssueChild{ID: storyID})
			statusPath := filepath.Join(projDir, "project-status.toon")
			var ps t.ProjectStatus
			if toon.ParseFile(statusPath, &ps) == nil {
				ps.Stories = h.RemoveEntry(ps.Stories, storyID)
				ps.UpdatedAt = h.Now()
				_ = toon.WriteFile(statusPath, &ps)
			}
			return h.TextResult(fmt.Sprintf("deleted story %s", storyID)), nil
		},
	}
}

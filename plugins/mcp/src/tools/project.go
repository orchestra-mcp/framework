package tools

import (
	"fmt"
	"os"
	"path/filepath"

	h "github.com/orchestra-mcp/mcp/src/helpers"
	"github.com/orchestra-mcp/mcp/src/toon"
	t "github.com/orchestra-mcp/mcp/src/types"
)

// Project returns all project management tools.
func Project(ws string) []t.Tool {
	return []t.Tool{
		listProjects(ws), createProject(ws),
		getProjectStatus(ws), readPrd(ws), writePrd(ws),
	}
}

func listProjects(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "list_projects", Description: "List all projects",
			InputSchema: t.InputSchema{Type: "object"},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			dir := h.ProjectsDir(ws)
			entries, err := os.ReadDir(dir)
			if err != nil {
				if os.IsNotExist(err) {
					return h.JSONResult([]any{}), nil
				}
				return h.ErrorResult(err.Error()), nil
			}
			var projects []t.ProjectStatus
			for _, e := range entries {
				if !e.IsDir() {
					continue
				}
				var ps t.ProjectStatus
				if toon.ParseFile(filepath.Join(dir, e.Name(), "project-status.toon"), &ps) == nil {
					projects = append(projects, ps)
				}
			}
			return h.JSONResult(projects), nil
		},
	}
}

func createProject(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "create_project", Description: "Create a new project with PRD",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"name":        map[string]any{"type": "string", "description": "Project name"},
				"description": map[string]any{"type": "string", "description": "Project description"},
			}, Required: []string{"name"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			name := h.GetString(args, "name")
			desc := h.GetString(args, "description")
			slug := h.Slugify(name)
			dir := h.ProjectDir(ws, slug)
			if h.FileExists(dir) {
				return h.ErrorResult(fmt.Sprintf("project %q already exists", slug)), nil
			}
			if err := os.MkdirAll(filepath.Join(dir, "epics"), 0o755); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			ps := t.ProjectStatus{
				Project: name, Slug: slug, Status: "active",
				Description: desc, CreatedAt: h.Now(),
			}
			if err := toon.WriteFile(filepath.Join(dir, "project-status.toon"), &ps); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			prd := fmt.Sprintf("# %s\n\n%s\n", name, desc)
			if err := os.WriteFile(filepath.Join(dir, "prd.md"), []byte(prd), 0o644); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			return h.JSONResult(map[string]any{
				"slug": slug, "key": h.DeriveKey(name), "status": "created",
			}), nil
		},
	}
}

func getProjectStatus(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "get_project_status", Description: "Get project status and summary",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string", "description": "Project slug"},
			}, Required: []string{"project"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			var ps t.ProjectStatus
			p := filepath.Join(h.ProjectDir(ws, h.GetString(args, "project")), "project-status.toon")
			if err := toon.ParseFile(p, &ps); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			return h.JSONResult(ps), nil
		},
	}
}

func readPrd(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "read_prd", Description: "Read project PRD document",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string"},
			}, Required: []string{"project"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			data, err := os.ReadFile(filepath.Join(h.ProjectDir(ws, h.GetString(args, "project")), "prd.md"))
			if err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			return h.TextResult(string(data)), nil
		},
	}
}

func writePrd(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "write_prd", Description: "Write/update project PRD document",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string"},
				"content": map[string]any{"type": "string", "description": "PRD markdown"},
			}, Required: []string{"project", "content"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			p := filepath.Join(h.ProjectDir(ws, h.GetString(args, "project")), "prd.md")
			if err := os.WriteFile(p, []byte(h.GetString(args, "content")), 0o644); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			return h.TextResult("PRD updated"), nil
		},
	}
}

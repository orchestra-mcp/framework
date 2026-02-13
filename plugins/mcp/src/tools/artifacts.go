package tools

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	h "github.com/orchestra-mcp/mcp/src/helpers"
	t "github.com/orchestra-mcp/mcp/src/types"
)

func plansDir(ws, slug string) string {
	return filepath.Join(h.ProjectDir(ws, slug), "plans")
}

// Artifacts returns plan/artifact management tools.
func Artifacts(ws string) []t.Tool {
	return []t.Tool{savePlan(ws), listPlans(ws)}
}

func savePlan(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "save_plan", Description: "Save a plan document as markdown",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project":  map[string]any{"type": "string", "description": "Project slug"},
				"title":    map[string]any{"type": "string", "description": "Plan title"},
				"content":  map[string]any{"type": "string", "description": "Markdown content"},
				"issue_id": map[string]any{"type": "string", "description": "Related issue ID"},
			}, Required: []string{"project", "title", "content"}},
		},
		Handler: func(a map[string]any) (*t.ToolResult, error) {
			slug := h.GetString(a, "project")
			title := h.GetString(a, "title")
			content := h.GetString(a, "content")
			issueID := h.GetString(a, "issue_id")
			dir := plansDir(ws, slug)
			if err := os.MkdirAll(dir, 0o755); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			filename := h.Slugify(title) + ".md"
			header := fmt.Sprintf("---\ntitle: %s\ncreated: %s\n", title, h.Now())
			if issueID != "" {
				header += fmt.Sprintf("issue_id: %s\n", issueID)
			}
			header += "---\n\n"
			p := filepath.Join(dir, filename)
			if err := os.WriteFile(p, []byte(header+content), 0o644); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			return h.JSONResult(map[string]any{"file": filename, "path": p}), nil
		},
	}
}

func listPlans(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "list_plans", Description: "List all plan documents for a project",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string", "description": "Project slug"},
			}, Required: []string{"project"}},
		},
		Handler: func(a map[string]any) (*t.ToolResult, error) {
			slug := h.GetString(a, "project")
			dir := plansDir(ws, slug)
			entries, err := os.ReadDir(dir)
			if err != nil {
				if os.IsNotExist(err) {
					return h.JSONResult([]any{}), nil
				}
				return h.ErrorResult(err.Error()), nil
			}
			type planInfo struct {
				File    string `json:"file"`
				Title   string `json:"title"`
				IssueID string `json:"issue_id,omitempty"`
				Created string `json:"created,omitempty"`
			}
			var plans []planInfo
			for _, e := range entries {
				if e.IsDir() || !strings.HasSuffix(e.Name(), ".md") {
					continue
				}
				p := planInfo{File: e.Name()}
				f, err := os.Open(filepath.Join(dir, e.Name()))
				if err != nil {
					continue
				}
				sc := bufio.NewScanner(f)
				inFront := false
				for sc.Scan() {
					line := sc.Text()
					if line == "---" {
						if inFront {
							break
						}
						inFront = true
						continue
					}
					if inFront {
						if strings.HasPrefix(line, "title: ") {
							p.Title = strings.TrimPrefix(line, "title: ")
						} else if strings.HasPrefix(line, "issue_id: ") {
							p.IssueID = strings.TrimPrefix(line, "issue_id: ")
						} else if strings.HasPrefix(line, "created: ") {
							p.Created = strings.TrimPrefix(line, "created: ")
						}
					}
				}
				f.Close()
				plans = append(plans, p)
			}
			return h.JSONResult(plans), nil
		},
	}
}

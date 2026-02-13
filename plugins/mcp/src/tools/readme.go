package tools

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	h "github.com/orchestra-mcp/mcp/src/helpers"
	"github.com/orchestra-mcp/mcp/src/toon"
	t "github.com/orchestra-mcp/mcp/src/types"
)

func statusBadge(s string) string {
	switch s {
	case statusDone:
		return "![done](https://img.shields.io/badge/-done-green)"
	case statusInProgress, "in_progress":
		return "![in-progress](https://img.shields.io/badge/-in--progress-blue)"
	case "review":
		return "![review](https://img.shields.io/badge/-review-orange)"
	case "blocked":
		return "![blocked](https://img.shields.io/badge/-blocked-red)"
	default:
		return fmt.Sprintf("![%s](https://img.shields.io/badge/-%s-lightgrey)", s, s)
	}
}

// Readme returns the readme generation tool.
func Readme(ws string) []t.Tool {
	return []t.Tool{
		{Definition: t.ToolDefinition{
			Name: "regenerate_readme", Description: "Regenerate project README from issues",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string", "description": "Project slug"},
			}, Required: []string{"project"}},
		}, Handler: func(a map[string]any) (*t.ToolResult, error) {
			slug := h.GetString(a, "project")
			projDir := h.ProjectDir(ws, slug)
			statusPath := filepath.Join(projDir, "project-status.toon")
			var ps t.ProjectStatus
			if err := toon.ParseFile(statusPath, &ps); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			issues := h.ScanAllIssues(ws, slug)
			var b strings.Builder
			b.WriteString(fmt.Sprintf("# %s\n\n", ps.Project))
			if ps.Description != "" {
				b.WriteString(ps.Description + "\n\n")
			}
			b.WriteString(fmt.Sprintf("**Status:** %s\n\n", statusBadge(ps.Status)))
			var epics, stories, tasks []h.ScannedIssue
			for _, i := range issues {
				switch i.Type {
				case "epic":
					epics = append(epics, i)
				case "story":
					stories = append(stories, i)
				default:
					tasks = append(tasks, i)
				}
			}
			writeTable(&b, "Epics", epics)
			writeTable(&b, "Stories", stories)
			writeTable(&b, "Tasks", tasks)
			p := filepath.Join(projDir, "README.md")
			if err := os.WriteFile(p, []byte(b.String()), 0o644); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			return h.TextResult("README.md regenerated"), nil
		}},
	}
}

func writeTable(b *strings.Builder, title string, items []h.ScannedIssue) {
	if len(items) == 0 {
		return
	}
	b.WriteString(fmt.Sprintf("## %s\n\n| ID | Title | Status |\n|---|---|---|\n", title))
	for _, i := range items {
		b.WriteString(fmt.Sprintf("| %s | %s | %s |\n", i.Data.ID, i.Data.Title, statusBadge(i.Data.Status)))
	}
	b.WriteString("\n")
}

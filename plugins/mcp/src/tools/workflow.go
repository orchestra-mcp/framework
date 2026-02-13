package tools

import (
	"fmt"
	"path/filepath"
	"sort"

	h "github.com/orchestra-mcp/mcp/src/helpers"
	"github.com/orchestra-mcp/mcp/src/toon"
	t "github.com/orchestra-mcp/mcp/src/types"
	"github.com/orchestra-mcp/mcp/src/workflow"
)

const (
	statusTodo       = "todo"
	statusInProgress = "in-progress"
	statusBacklog    = "backlog"
	statusDone       = "done"
)

var (
	typePriority   = map[string]int{"hotfix": 0, "bug": 1, "task": 2}
	statusPriority = map[string]int{statusInProgress: 0, statusTodo: 1, statusBacklog: 2}
)

// Workflow returns all workflow management tools.
func Workflow(ws string) []t.Tool {
	return []t.Tool{
		getNextTask(ws), setCurrentTask(ws), completeTask(ws),
		searchIssues(ws), getWorkflowStatus(ws),
	}
}

func getNextTask(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "get_next_task", Description: "Get highest priority actionable task",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string"},
			}, Required: []string{"project"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			tasks := h.ScanAllTasks(ws, h.GetString(args, "project"))
			var actionable []h.ScannedTask
			for _, tk := range tasks {
				s := tk.Data.Status
				if s == statusInProgress || s == statusTodo || s == statusBacklog {
					actionable = append(actionable, tk)
				}
			}
			if len(actionable) == 0 {
				return h.TextResult("no actionable tasks"), nil
			}
			sort.Slice(actionable, func(i, j int) bool {
				ti, tj := typePriority[actionable[i].Data.Type], typePriority[actionable[j].Data.Type]
				if ti != tj {
					return ti < tj
				}
				return statusPriority[actionable[i].Data.Status] < statusPriority[actionable[j].Data.Status]
			})
			return h.JSONResult(actionable[0].Data), nil
		},
	}
}

func setCurrentTask(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "set_current_task", Description: "Set task to in-progress, cascade parents",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string"}, "epic_id": map[string]any{"type": "string"},
				"story_id": map[string]any{"type": "string"}, "task_id": map[string]any{"type": "string"},
			}, Required: []string{"project", "epic_id", "story_id", "task_id"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			slug := h.GetString(args, "project")
			epicID := h.GetString(args, "epic_id")
			storyID := h.GetString(args, "story_id")
			taskID := h.GetString(args, "task_id")
			projDir := h.ProjectDir(ws, slug)
			taskPath := filepath.Join(projDir, "epics", epicID, "stories", storyID, "tasks", taskID+".toon")
			var task t.IssueData
			if err := toon.ParseFile(taskPath, &task); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			if !workflow.IsValid(task.Status, statusInProgress) {
				return h.ErrorResult(fmt.Sprintf("cannot transition %s -> in-progress from %s", taskID, task.Status)), nil
			}
			task.Status = statusInProgress
			task.UpdatedAt = h.Now()
			_ = toon.WriteFile(taskPath, &task)
			// Cascade to story
			storyPath := filepath.Join(projDir, "epics", epicID, "stories", storyID, "story.toon")
			var story t.IssueData
			if toon.ParseFile(storyPath, &story) == nil {
				if story.Status == statusBacklog || story.Status == statusTodo {
					story.Status = statusInProgress
					story.UpdatedAt = h.Now()
				}
				_ = h.UpdateParentChildren(storyPath, "update", t.IssueChild{ID: taskID, Title: task.Title, Status: task.Status})
			}
			// Cascade to epic
			epicPath := filepath.Join(projDir, "epics", epicID, "epic.toon")
			var epic t.IssueData
			if toon.ParseFile(epicPath, &epic) == nil {
				if epic.Status == statusBacklog || epic.Status == statusTodo {
					epic.Status = statusInProgress
					epic.UpdatedAt = h.Now()
					_ = toon.WriteFile(epicPath, &epic)
				}
				_ = h.UpdateParentChildren(epicPath, "update", t.IssueChild{ID: storyID, Title: story.Title, Status: story.Status})
			}
			// Update project status
			statusPath := filepath.Join(projDir, "project-status.toon")
			var ps t.ProjectStatus
			if toon.ParseFile(statusPath, &ps) == nil {
				h.UpdateProjectStatus(&ps, task)
				h.UpdateProjectStatus(&ps, story)
				h.UpdateProjectStatus(&ps, epic)
				ps.UpdatedAt = h.Now()
				_ = toon.WriteFile(statusPath, &ps)
			}
			return h.JSONResult(task), nil
		},
	}
}

func completeTask(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "complete_task", Description: "Complete task, cascade done if all siblings done",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string"}, "epic_id": map[string]any{"type": "string"},
				"story_id": map[string]any{"type": "string"}, "task_id": map[string]any{"type": "string"},
			}, Required: []string{"project", "epic_id", "story_id", "task_id"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			slug := h.GetString(args, "project")
			epicID := h.GetString(args, "epic_id")
			storyID := h.GetString(args, "story_id")
			taskID := h.GetString(args, "task_id")
			projDir := h.ProjectDir(ws, slug)
			taskPath := filepath.Join(projDir, "epics", epicID, "stories", storyID, "tasks", taskID+".toon")
			var task t.IssueData
			if err := toon.ParseFile(taskPath, &task); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			if !workflow.IsValid(task.Status, "review") {
				return h.ErrorResult(fmt.Sprintf("cannot complete %s from %s", taskID, task.Status)), nil
			}
			task.Status = "review"
			task.UpdatedAt = h.Now()
			_ = toon.WriteFile(taskPath, &task)
			// Check story completion
			storyPath := filepath.Join(projDir, "epics", epicID, "stories", storyID, "story.toon")
			var story t.IssueData
			if toon.ParseFile(storyPath, &story) == nil {
				_ = h.UpdateParentChildren(storyPath, "update", t.IssueChild{ID: taskID, Title: task.Title, Status: task.Status})
				_ = toon.ParseFile(storyPath, &story)
				if allChildrenDone(story.Children) {
					story.Status = statusDone
					story.UpdatedAt = h.Now()
					_ = toon.WriteFile(storyPath, &story)
				}
			}
			// Check epic completion
			epicPath := filepath.Join(projDir, "epics", epicID, "epic.toon")
			var epic t.IssueData
			if toon.ParseFile(epicPath, &epic) == nil {
				_ = h.UpdateParentChildren(epicPath, "update", t.IssueChild{ID: storyID, Title: story.Title, Status: story.Status})
				_ = toon.ParseFile(epicPath, &epic)
				if allChildrenDone(epic.Children) {
					epic.Status = statusDone
					epic.UpdatedAt = h.Now()
					_ = toon.WriteFile(epicPath, &epic)
				}
			}
			statusPath := filepath.Join(projDir, "project-status.toon")
			var ps t.ProjectStatus
			if toon.ParseFile(statusPath, &ps) == nil {
				h.UpdateProjectStatus(&ps, task)
				h.UpdateProjectStatus(&ps, story)
				h.UpdateProjectStatus(&ps, epic)
				ps.UpdatedAt = h.Now()
				_ = toon.WriteFile(statusPath, &ps)
			}
			return h.JSONResult(task), nil
		},
	}
}

func allChildrenDone(children []t.IssueChild) bool {
	if len(children) == 0 {
		return false
	}
	for _, c := range children {
		if !workflow.CompletedStatuses[c.Status] {
			return false
		}
	}
	return true
}

func searchIssues(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "search", Description: "Search issues by text, optional type filter",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string"},
				"query":   map[string]any{"type": "string"},
				"type":    map[string]any{"type": "string", "enum": []string{"epic", "story", "task", "bug", "hotfix"}},
			}, Required: []string{"project", "query"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			slug := h.GetString(args, "project")
			query := h.GetString(args, "query")
			typeFilter := h.GetString(args, "type")
			issues := h.ScanAllIssues(ws, slug)
			var matches []t.IssueData
			for _, iss := range issues {
				if typeFilter != "" && iss.Data.Type != typeFilter {
					continue
				}
				text := iss.Data.Title + " " + iss.Data.Description
				if containsCI(text, query) {
					matches = append(matches, iss.Data)
				}
			}
			return h.JSONResult(matches), nil
		},
	}
}

func getWorkflowStatus(ws string) t.Tool {
	return t.Tool{
		Definition: t.ToolDefinition{
			Name: "get_workflow_status", Description: "Get workflow stats: counts, blocked, completion %",
			InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{
				"project": map[string]any{"type": "string"},
			}, Required: []string{"project"}},
		},
		Handler: func(args map[string]any) (*t.ToolResult, error) {
			tasks := h.ScanAllTasks(ws, h.GetString(args, "project"))
			byStatus := map[string]int{}
			byType := map[string]int{}
			var blocked, inProgress, ready []string
			total, done := 0, 0
			for _, tk := range tasks {
				total++
				byStatus[tk.Data.Status]++
				byType[tk.Data.Type]++
				if workflow.CompletedStatuses[tk.Data.Status] {
					done++
				}
				switch tk.Data.Status {
				case "blocked":
					blocked = append(blocked, tk.Data.ID)
				case statusInProgress:
					inProgress = append(inProgress, tk.Data.ID)
				case statusTodo:
					ready = append(ready, tk.Data.ID)
				}
			}
			pct := 0.0
			if total > 0 {
				pct = float64(done) / float64(total) * 100
			}
			return h.JSONResult(map[string]any{
				"total": total, "done": done, "completion_pct": fmt.Sprintf("%.1f", pct),
				"by_status": byStatus, "by_type": byType,
				"blocked": blocked, "in_progress": inProgress, "ready": ready,
			}), nil
		},
	}
}

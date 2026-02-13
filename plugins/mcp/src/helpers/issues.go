package helpers

import (
	"os"
	"path/filepath"
	"strings"

	"github.com/orchestra-mcp/mcp/src/toon"
	"github.com/orchestra-mcp/mcp/src/types"
)

// UpdateProjectStatus adds or updates an issue in the project status.
func UpdateProjectStatus(ps *types.ProjectStatus, issue types.IssueData) {
	entry := types.IssueEntry{ID: issue.ID, Title: issue.Title, Status: issue.Status}
	list := issueList(ps, classifyType(issue.ID))
	for i, e := range *list {
		if e.ID == entry.ID {
			(*list)[i] = entry
			return
		}
	}
	*list = append(*list, entry)
}

// UpdateParentChildren modifies the children list of a parent issue.
func UpdateParentChildren(parentPath, action string, child types.IssueChild) error {
	var parent types.IssueData
	if err := toon.ParseFile(parentPath, &parent); err != nil {
		return err
	}
	switch action {
	case "add":
		parent.Children = append(parent.Children, child)
	case "update":
		for i, c := range parent.Children {
			if c.ID == child.ID {
				parent.Children[i] = child
				break
			}
		}
	case "remove":
		filtered := make([]types.IssueChild, 0, len(parent.Children))
		for _, c := range parent.Children {
			if c.ID != child.ID {
				filtered = append(filtered, c)
			}
		}
		parent.Children = filtered
	}
	parent.UpdatedAt = Now()
	return toon.WriteFile(parentPath, &parent)
}

// RemoveEntry removes an entry by ID from a slice.
func RemoveEntry(entries []types.IssueEntry, id string) []types.IssueEntry {
	var out []types.IssueEntry
	for _, e := range entries {
		if e.ID != id {
			out = append(out, e)
		}
	}
	return out
}

func classifyType(id string) string {
	parts := strings.Split(id, "-")
	if len(parts) < 2 {
		return "tasks"
	}
	prefix := strings.ToUpper(parts[0])
	switch {
	case strings.HasSuffix(prefix, "E"):
		return "epics"
	case strings.HasSuffix(prefix, "S"):
		return "stories"
	default:
		return "tasks"
	}
}

func issueList(status *types.ProjectStatus, t string) *[]types.IssueEntry {
	switch t {
	case "epics":
		return &status.Epics
	case "stories":
		return &status.Stories
	default:
		return &status.Tasks
	}
}

// ScannedTask is a task found during directory scanning.
type ScannedTask struct {
	Data    types.IssueData
	EpicID  string
	StoryID string
	Path    string
}

// ScannedIssue is any issue found during directory scanning.
type ScannedIssue struct {
	Data types.IssueData
	Type string
	Path string
}

// ScanAllTasks walks the project directory to find all tasks.
func ScanAllTasks(workspaceRoot, slug string) []ScannedTask {
	var tasks []ScannedTask
	epicsDir := filepath.Join(ProjectDir(workspaceRoot, slug), "epics")
	epics, _ := os.ReadDir(epicsDir)
	for _, epicEntry := range epics {
		if !epicEntry.IsDir() {
			continue
		}
		epicID := epicEntry.Name()
		storiesDir := filepath.Join(epicsDir, epicID, "stories")
		stories, _ := os.ReadDir(storiesDir)
		for _, storyEntry := range stories {
			if !storyEntry.IsDir() {
				continue
			}
			storyID := storyEntry.Name()
			tasksDir := filepath.Join(storiesDir, storyID, "tasks")
			taskFiles, _ := os.ReadDir(tasksDir)
			for _, tf := range taskFiles {
				if tf.IsDir() || !strings.HasSuffix(tf.Name(), ".toon") {
					continue
				}
				p := filepath.Join(tasksDir, tf.Name())
				var data types.IssueData
				if toon.ParseFile(p, &data) == nil {
					tasks = append(tasks, ScannedTask{
						Data: data, EpicID: epicID, StoryID: storyID, Path: p,
					})
				}
			}
		}
	}
	return tasks
}

// ScanAllIssues walks the project directory to find all issues.
func ScanAllIssues(workspaceRoot, slug string) []ScannedIssue {
	var issues []ScannedIssue
	projectDir := ProjectDir(workspaceRoot, slug)
	epicsDir := filepath.Join(projectDir, "epics")
	epics, _ := os.ReadDir(epicsDir)
	for _, epicEntry := range epics {
		if !epicEntry.IsDir() {
			continue
		}
		epicPath := filepath.Join(epicsDir, epicEntry.Name(), "epic.toon")
		var epicData types.IssueData
		if toon.ParseFile(epicPath, &epicData) == nil {
			issues = append(issues, ScannedIssue{Data: epicData, Type: "epic", Path: epicPath})
		}
		storiesDir := filepath.Join(epicsDir, epicEntry.Name(), "stories")
		stories, _ := os.ReadDir(storiesDir)
		for _, storyEntry := range stories {
			if !storyEntry.IsDir() {
				continue
			}
			storyPath := filepath.Join(storiesDir, storyEntry.Name(), "story.toon")
			var storyData types.IssueData
			if toon.ParseFile(storyPath, &storyData) == nil {
				issues = append(issues, ScannedIssue{Data: storyData, Type: "story", Path: storyPath})
			}
			tasksDir := filepath.Join(storiesDir, storyEntry.Name(), "tasks")
			taskFiles, _ := os.ReadDir(tasksDir)
			for _, tf := range taskFiles {
				if tf.IsDir() || !strings.HasSuffix(tf.Name(), ".toon") {
					continue
				}
				taskPath := filepath.Join(tasksDir, tf.Name())
				var taskData types.IssueData
				if toon.ParseFile(taskPath, &taskData) == nil {
					issues = append(issues, ScannedIssue{Data: taskData, Type: "task", Path: taskPath})
				}
			}
		}
	}
	return issues
}

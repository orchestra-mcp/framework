package tools_test

import (
	"encoding/json"
	"testing"

	"github.com/orchestra-mcp/mcp/src/tools"
)

func TestListProjectsEmptyDir(t *testing.T) {
	ws := t.TempDir()
	toolList := tools.Project(ws)
	list := toolList[0].Handler
	res, err := list(map[string]any{})
	if err != nil {
		t.Fatalf("list error: %v", err)
	}
	if res.IsError {
		t.Fatalf("list returned error: %s", res.Content[0].Text)
	}
	if res.Content[0].Text != "[]" {
		t.Errorf("expected empty JSON array, got %s", res.Content[0].Text)
	}
}

func TestCreateProject(t *testing.T) {
	ws := t.TempDir()
	toolList := tools.Project(ws)
	create := toolList[1].Handler
	res, err := create(map[string]any{"name": "Test App", "description": "A test"})
	if err != nil {
		t.Fatalf("create error: %v", err)
	}
	if res.IsError {
		t.Fatalf("create returned error: %s", res.Content[0].Text)
	}
	var data map[string]any
	if err := json.Unmarshal([]byte(res.Content[0].Text), &data); err != nil {
		t.Fatalf("json parse: %v", err)
	}
	if data["slug"] != "test-app" {
		t.Errorf("slug = %v, want test-app", data["slug"])
	}
	if data["status"] != "created" {
		t.Errorf("status = %v, want created", data["status"])
	}
}

func TestGetProjectStatus(t *testing.T) {
	ws := t.TempDir()
	toolList := tools.Project(ws)
	// Create first
	toolList[1].Handler(map[string]any{"name": "Demo", "description": "d"})
	// Get status
	res, err := toolList[2].Handler(map[string]any{"project": "demo"})
	if err != nil {
		t.Fatalf("get_project_status error: %v", err)
	}
	if res.IsError {
		t.Fatalf("get_project_status error: %s", res.Content[0].Text)
	}
	var ps map[string]any
	json.Unmarshal([]byte(res.Content[0].Text), &ps)
	if ps["slug"] != "demo" {
		t.Errorf("slug = %v, want demo", ps["slug"])
	}
}

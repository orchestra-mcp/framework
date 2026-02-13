package workflow_test

import (
	"testing"

	"github.com/orchestra-mcp/mcp/src/workflow"
)

func TestIsValid(t *testing.T) {
	tests := []struct {
		from, to string
		want     bool
	}{
		{"backlog", "todo", true},
		{"todo", "in-progress", true},
		{"in-progress", "review", true},
		{"review", "done", true},
		{"done", "todo", true},
		{"backlog", "done", false},
		{"todo", "done", false},
		{"unknown", "todo", false},
		{"backlog", "unknown", false},
	}
	for _, tc := range tests {
		got := workflow.IsValid(tc.from, tc.to)
		if got != tc.want {
			t.Errorf("IsValid(%q,%q) = %v, want %v", tc.from, tc.to, got, tc.want)
		}
	}
}

func TestNextStates(t *testing.T) {
	got := workflow.NextStates("todo")
	if len(got) != 2 {
		t.Fatalf("NextStates(todo) len = %d, want 2", len(got))
	}
	if got[0] != "in-progress" || got[1] != "backlog" {
		t.Errorf("NextStates(todo) = %v", got)
	}
	if workflow.NextStates("nonexistent") != nil {
		t.Error("expected nil for unknown state")
	}
}

func TestCompletedStatuses(t *testing.T) {
	if !workflow.CompletedStatuses["done"] || !workflow.CompletedStatuses["cancelled"] {
		t.Error("done and cancelled should be completed")
	}
	if workflow.CompletedStatuses["in-progress"] {
		t.Error("in-progress should not be completed")
	}
}

func TestDoneStatuses(t *testing.T) {
	if !workflow.DoneStatuses["done"] {
		t.Error("done should be in DoneStatuses")
	}
	if workflow.DoneStatuses["cancelled"] {
		t.Error("cancelled should not be in DoneStatuses")
	}
}

package helpers_test

import (
	"testing"

	"github.com/orchestra-mcp/mcp/src/helpers"
)

func TestTextResult(t *testing.T) {
	r := helpers.TextResult("hello")
	if len(r.Content) != 1 {
		t.Fatalf("Content len = %d, want 1", len(r.Content))
	}
	if r.Content[0].Type != "text" || r.Content[0].Text != "hello" {
		t.Errorf("Content[0] = %+v", r.Content[0])
	}
	if r.IsError {
		t.Error("IsError should be false")
	}
}

func TestJSONResult(t *testing.T) {
	r := helpers.JSONResult(map[string]int{"a": 1})
	if len(r.Content) != 1 || r.Content[0].Type != "text" {
		t.Fatalf("unexpected content: %+v", r.Content)
	}
	if r.Content[0].Text == "" {
		t.Error("JSON text should not be empty")
	}
	if r.IsError {
		t.Error("IsError should be false")
	}
}

func TestErrorResult(t *testing.T) {
	r := helpers.ErrorResult("fail")
	if len(r.Content) != 1 || r.Content[0].Text != "fail" {
		t.Fatalf("Content = %+v", r.Content)
	}
	if !r.IsError {
		t.Error("IsError should be true")
	}
}

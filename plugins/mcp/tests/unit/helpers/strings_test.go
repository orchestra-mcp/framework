package helpers_test

import (
	"testing"
	"time"

	"github.com/orchestra-mcp/mcp/src/helpers"
)

func TestIsIssueID(t *testing.T) {
	tests := []struct {
		input string
		want  bool
	}{
		{"EPIC-1", true},
		{"PRJ-123", true},
		{"A1-99", true},
		{"epic-1", false},
		{"EPIC", false},
		{"123-ABC", false},
		{"", false},
	}
	for _, tc := range tests {
		if got := helpers.IsIssueID(tc.input); got != tc.want {
			t.Errorf("IsIssueID(%q) = %v, want %v", tc.input, got, tc.want)
		}
	}
}

func TestNow(t *testing.T) {
	s := helpers.Now()
	if _, err := time.Parse(time.RFC3339, s); err != nil {
		t.Errorf("Now() = %q, not valid RFC3339: %v", s, err)
	}
}

func TestSlugify(t *testing.T) {
	tests := []struct {
		input, want string
	}{
		{"Hello World", "hello-world"},
		{"  My App!  ", "my-app"},
		{"foo--bar__baz", "foo-bar-baz"},
	}
	for _, tc := range tests {
		if got := helpers.Slugify(tc.input); got != tc.want {
			t.Errorf("Slugify(%q) = %q, want %q", tc.input, got, tc.want)
		}
	}
}

func TestDeriveKey(t *testing.T) {
	tests := []struct {
		input, want string
	}{
		{"My Cool Project", "MCP"},
		{"alpha", "A"},
		{"", "PRJ"},
	}
	for _, tc := range tests {
		if got := helpers.DeriveKey(tc.input); got != tc.want {
			t.Errorf("DeriveKey(%q) = %q, want %q", tc.input, got, tc.want)
		}
	}
}

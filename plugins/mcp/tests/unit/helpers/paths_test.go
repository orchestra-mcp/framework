package helpers_test

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/orchestra-mcp/mcp/src/helpers"
)

func TestProjectsDir(t *testing.T) {
	got := helpers.ProjectsDir("/workspace")
	want := filepath.Join("/workspace", ".projects")
	if got != want {
		t.Errorf("ProjectsDir = %q, want %q", got, want)
	}
}

func TestProjectDir(t *testing.T) {
	got := helpers.ProjectDir("/workspace", "my-app")
	want := filepath.Join("/workspace", ".projects", "my-app")
	if got != want {
		t.Errorf("ProjectDir = %q, want %q", got, want)
	}
}

func TestFileExists(t *testing.T) {
	dir := t.TempDir()
	f := filepath.Join(dir, "exists.txt")
	os.WriteFile(f, []byte("hi"), 0o644)

	if !helpers.FileExists(f) {
		t.Error("expected true for existing file")
	}
	if helpers.FileExists(filepath.Join(dir, "nope.txt")) {
		t.Error("expected false for missing file")
	}
}

package toon_test

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/orchestra-mcp/mcp/src/toon"
)

type sample struct {
	Name  string `yaml:"name"`
	Count int    `yaml:"count"`
}

func TestWriteAndParseFile(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, "test.toon")

	want := sample{Name: "alpha", Count: 42}
	if err := toon.WriteFile(path, &want); err != nil {
		t.Fatalf("WriteFile: %v", err)
	}
	if _, err := os.Stat(path); err != nil {
		t.Fatalf("file not created: %v", err)
	}

	var got sample
	if err := toon.ParseFile(path, &got); err != nil {
		t.Fatalf("ParseFile: %v", err)
	}
	if got != want {
		t.Errorf("got %+v, want %+v", got, want)
	}
}

func TestParseFileMissing(t *testing.T) {
	if err := toon.ParseFile("/nonexistent/file.toon", &sample{}); err == nil {
		t.Error("expected error for missing file")
	}
}

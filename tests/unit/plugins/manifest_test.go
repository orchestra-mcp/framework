package plugins_test

import (
	"strings"
	"testing"

	"github.com/orchestra-mcp/framework/app/plugins"
	"github.com/orchestra-mcp/framework/tests/testutil"
)

func TestFromPlugin(t *testing.T) {
	p := testutil.NewMockPlugin("test-id")
	p.PluginName = "Test Plugin"
	p.PluginVersion = "2.0.0"
	m := plugins.FromPlugin(p)
	if m.ID != "test-id" {
		t.Fatalf("expected test-id, got %s", m.ID)
	}
	if m.Name != "Test Plugin" {
		t.Fatalf("expected Test Plugin, got %s", m.Name)
	}
	if m.Version != "2.0.0" {
		t.Fatalf("expected 2.0.0, got %s", m.Version)
	}
	if len(m.Dependencies) != 0 {
		t.Fatal("expected empty deps slice, not nil")
	}
}

func TestValidateMissingID(t *testing.T) {
	m := &plugins.PluginManifest{Name: "n", Version: "1.0.0"}
	err := m.Validate()
	if err == nil || !strings.Contains(err.Error(), "ID") {
		t.Fatalf("expected ID required error, got %v", err)
	}
}

func TestValidateMissingName(t *testing.T) {
	m := &plugins.PluginManifest{ID: "x", Version: "1.0.0"}
	err := m.Validate()
	if err == nil || !strings.Contains(err.Error(), "Name") {
		t.Fatalf("expected Name required error, got %v", err)
	}
}

func TestValidateMissingVersion(t *testing.T) {
	m := &plugins.PluginManifest{ID: "x", Name: "n"}
	err := m.Validate()
	if err == nil || !strings.Contains(err.Error(), "Version") {
		t.Fatalf("expected Version required error, got %v", err)
	}
}

func TestValidateSuccess(t *testing.T) {
	m := &plugins.PluginManifest{ID: "x", Name: "n", Version: "1.0.0"}
	if err := m.Validate(); err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
}

package helpers_test

import (
	"testing"

	"github.com/orchestra-mcp/mcp/src/helpers"
)

func TestGetString(t *testing.T) {
	args := map[string]any{"name": "alice", "count": 5}
	if got := helpers.GetString(args, "name"); got != "alice" {
		t.Errorf("GetString(name) = %q", got)
	}
	if got := helpers.GetString(args, "missing"); got != "" {
		t.Errorf("GetString(missing) = %q, want empty", got)
	}
	if got := helpers.GetString(args, "count"); got != "" {
		t.Errorf("GetString(count) = %q, want empty for non-string", got)
	}
}

func TestGetInt(t *testing.T) {
	args := map[string]any{"a": float64(7), "b": 3, "c": "nope"}
	if got := helpers.GetInt(args, "a"); got != 7 {
		t.Errorf("GetInt(a) = %d, want 7", got)
	}
	if got := helpers.GetInt(args, "b"); got != 3 {
		t.Errorf("GetInt(b) = %d, want 3", got)
	}
	if got := helpers.GetInt(args, "c"); got != 0 {
		t.Errorf("GetInt(c) = %d, want 0", got)
	}
	if got := helpers.GetInt(args, "missing"); got != 0 {
		t.Errorf("GetInt(missing) = %d, want 0", got)
	}
}

func TestGetFloat64(t *testing.T) {
	args := map[string]any{"val": 3.14, "bad": "x"}
	if got := helpers.GetFloat64(args, "val"); got != 3.14 {
		t.Errorf("GetFloat64(val) = %f", got)
	}
	if got := helpers.GetFloat64(args, "bad"); got != 0 {
		t.Errorf("GetFloat64(bad) = %f, want 0", got)
	}
}

func TestHas(t *testing.T) {
	args := map[string]any{"key": nil}
	if !helpers.Has(args, "key") {
		t.Error("Has(key) should be true")
	}
	if helpers.Has(args, "other") {
		t.Error("Has(other) should be false")
	}
}

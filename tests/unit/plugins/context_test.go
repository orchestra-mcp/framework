package plugins_test

import (
	"testing"

	"github.com/orchestra-mcp/framework/app/plugins"
	"github.com/rs/zerolog"
)

func TestNewPluginContext(t *testing.T) {
	sr := plugins.NewServiceRegistry()
	ctx := plugins.NewPluginContext("p1", "/path", "/storage", map[string]any{"k": "v"}, zerolog.Nop(), sr)
	if ctx.PluginID != "p1" {
		t.Fatalf("expected p1, got %s", ctx.PluginID)
	}
	if ctx.PluginPath != "/path" {
		t.Fatalf("expected /path, got %s", ctx.PluginPath)
	}
	if ctx.StoragePath != "/storage" {
		t.Fatalf("expected /storage, got %s", ctx.StoragePath)
	}
	if ctx.Services != sr {
		t.Fatal("services mismatch")
	}
}

func TestGetConfigFound(t *testing.T) {
	ctx := plugins.NewPluginContext("p", "", "", map[string]any{"key": 42}, zerolog.Nop(), nil)
	val, ok := ctx.GetConfig("key")
	if !ok || val != 42 {
		t.Fatalf("expected 42, got %v (ok=%v)", val, ok)
	}
}

func TestGetConfigNotFound(t *testing.T) {
	ctx := plugins.NewPluginContext("p", "", "", map[string]any{}, zerolog.Nop(), nil)
	_, ok := ctx.GetConfig("missing")
	if ok {
		t.Fatal("expected not found")
	}
}

func TestGetConfigNilMap(t *testing.T) {
	ctx := plugins.NewPluginContext("p", "", "", nil, zerolog.Nop(), nil)
	_, ok := ctx.GetConfig("any")
	if ok {
		t.Fatal("expected not found on nil config")
	}
}

func TestGetConfigStringFound(t *testing.T) {
	ctx := plugins.NewPluginContext("p", "", "", map[string]any{"s": "hello"}, zerolog.Nop(), nil)
	if s := ctx.GetConfigString("s"); s != "hello" {
		t.Fatalf("expected hello, got %s", s)
	}
}

func TestGetConfigStringNotString(t *testing.T) {
	ctx := plugins.NewPluginContext("p", "", "", map[string]any{"n": 123}, zerolog.Nop(), nil)
	if s := ctx.GetConfigString("n"); s != "" {
		t.Fatalf("expected empty string for non-string, got %s", s)
	}
}

func TestGetConfigStringNotFound(t *testing.T) {
	ctx := plugins.NewPluginContext("p", "", "", map[string]any{}, zerolog.Nop(), nil)
	if s := ctx.GetConfigString("nope"); s != "" {
		t.Fatalf("expected empty string, got %s", s)
	}
}

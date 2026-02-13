package plugins_test

import (
	"strings"
	"testing"

	"github.com/orchestra-mcp/framework/app/plugins"
	"github.com/orchestra-mcp/framework/tests/testutil"
)

func TestNewPluginLoaderBasePath(t *testing.T) {
	l := plugins.NewPluginLoader("/plugins")
	if l.BasePath() != "/plugins" {
		t.Fatalf("expected /plugins, got %s", l.BasePath())
	}
}

func TestRegisterAllSuccess(t *testing.T) {
	pm := testutil.NewManager()
	l := plugins.NewPluginLoader("/plugins")
	a := testutil.NewMockPlugin("a")
	b := testutil.NewMockPlugin("b")
	if err := l.RegisterAll(pm, a, b); err != nil {
		t.Fatal(err)
	}
	if len(pm.All()) != 2 {
		t.Fatalf("expected 2 plugins, got %d", len(pm.All()))
	}
}

func TestRegisterAllDuplicateFailure(t *testing.T) {
	pm := testutil.NewManager()
	l := plugins.NewPluginLoader("/plugins")
	a := testutil.NewMockPlugin("a")
	pm.Register(a)
	err := l.RegisterAll(pm, a)
	if err == nil || !strings.Contains(err.Error(), "already registered") {
		t.Fatalf("expected duplicate error, got %v", err)
	}
}

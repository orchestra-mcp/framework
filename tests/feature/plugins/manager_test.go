package plugins_test

import (
	"strings"
	"testing"

	"github.com/orchestra-mcp/framework/app/plugins"
	"github.com/orchestra-mcp/framework/tests/testutil"
)

func TestRegisterDuplicate(t *testing.T) {
	pm := testutil.NewManager()
	p := testutil.NewMockPlugin("a")
	if err := pm.Register(p); err != nil {
		t.Fatal(err)
	}
	if err := pm.Register(p); err == nil {
		t.Fatal("expected error on duplicate register")
	}
}

func TestBootTopologicalSort(t *testing.T) {
	pm := testutil.NewManager()
	b := testutil.NewMockPlugin("b")
	b.Deps = []string{"a"}
	pm.Register(testutil.NewMockPlugin("a"))
	pm.Register(b)
	if err := pm.Boot(); err != nil {
		t.Fatal(err)
	}
	if len(pm.Active()) != 2 {
		t.Fatalf("expected 2 active, got %d", len(pm.Active()))
	}
}

func TestBootSkipsDisabled(t *testing.T) {
	pm := testutil.NewManager("a")
	pm.Register(testutil.NewMockPlugin("a"))
	pm.Register(testutil.NewMockPlugin("b"))
	if err := pm.Boot(); err != nil {
		t.Fatal(err)
	}
	if len(pm.Active()) != 1 {
		t.Fatalf("expected 1 active, got %d", len(pm.Active()))
	}
}

func TestShutdownReverseOrder(t *testing.T) {
	pm := testutil.NewManager()
	pm.Register(testutil.NewMockPlugin("a"))
	pm.Register(testutil.NewMockPlugin("b"))
	pm.Boot()
	if err := pm.Shutdown(); err != nil {
		t.Fatal(err)
	}
	if len(pm.Active()) != 0 {
		t.Fatalf("expected 0 active after shutdown, got %d", len(pm.Active()))
	}
}

func TestActivateDeactivateSingle(t *testing.T) {
	pm := testutil.NewManager()
	pm.Register(testutil.NewMockPlugin("a"))
	pm.Boot()
	if err := pm.Deactivate("a"); err != nil {
		t.Fatal(err)
	}
	if len(pm.Active()) != 0 {
		t.Fatal("expected 0 active after deactivate")
	}
	if err := pm.Activate("a"); err != nil {
		t.Fatal(err)
	}
	if len(pm.Active()) != 1 {
		t.Fatal("expected 1 active after re-activate")
	}
}

func TestActivateUnregistered(t *testing.T) {
	pm := testutil.NewManager()
	if err := pm.Activate("nope"); err == nil {
		t.Fatal("expected error for unregistered plugin")
	}
}

func TestGetAllActiveInactive(t *testing.T) {
	pm := testutil.NewManager("b")
	pm.Register(testutil.NewMockPlugin("a"))
	pm.Register(testutil.NewMockPlugin("b"))
	pm.Boot()
	if _, ok := pm.Get("a"); !ok {
		t.Fatal("expected to find plugin a")
	}
	if _, ok := pm.Get("z"); ok {
		t.Fatal("did not expect to find plugin z")
	}
	if len(pm.All()) != 2 {
		t.Fatalf("expected 2 total, got %d", len(pm.All()))
	}
	if len(pm.Inactive()) != 1 {
		t.Fatalf("expected 1 inactive, got %d", len(pm.Inactive()))
	}
}

func TestIsDisabled(t *testing.T) {
	pm := testutil.NewManager("x")
	pm.Register(testutil.NewMockPlugin("x"))
	if !pm.IsDisabled("x") {
		t.Fatal("expected x to be disabled")
	}
}

func TestCollectMcpTools(t *testing.T) {
	pm := testutil.NewManager()
	p := testutil.NewMockPlugin("a")
	p.Tools = []plugins.McpToolDefinition{{Name: "tool1"}}
	pm.Register(p)
	pm.Boot()
	tools := pm.CollectMcpTools()
	if len(tools) != 1 || tools[0].Name != "tool1" {
		t.Fatalf("expected 1 tool named tool1, got %v", tools)
	}
}

func TestCollectJobs(t *testing.T) {
	pm := testutil.NewManager()
	p := testutil.NewMockPlugin("a")
	p.JobList = []plugins.JobDefinition{{Name: "job1"}}
	pm.Register(p)
	pm.Boot()
	jobs := pm.CollectJobs()
	if len(jobs) != 1 || jobs[0].Name != "job1" {
		t.Fatalf("expected 1 job named job1, got %v", jobs)
	}
}

func TestBootMissingDependency(t *testing.T) {
	pm := testutil.NewManager()
	p := testutil.NewMockPlugin("a")
	p.Deps = []string{"missing"}
	pm.Register(p)
	err := pm.Boot()
	if err == nil || !strings.Contains(err.Error(), "missing") {
		t.Fatalf("expected missing dependency error, got %v", err)
	}
}

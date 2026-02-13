package plugins_test

import (
	"testing"

	"github.com/orchestra-mcp/framework/app/plugins"
)

func TestRegistryFactoryGet(t *testing.T) {
	r := plugins.NewServiceRegistry()
	calls := 0
	r.Register("svc", func() any { calls++; return "val" })
	v, ok := r.Get("svc")
	if !ok || v != "val" {
		t.Fatalf("expected val, got %v", v)
	}
	r.Get("svc")
	if calls != 2 {
		t.Fatalf("factory should be called each time, got %d calls", calls)
	}
}

func TestRegistrySingletonGet(t *testing.T) {
	r := plugins.NewServiceRegistry()
	obj := &struct{ X int }{42}
	r.RegisterSingleton("svc", obj)
	v, ok := r.Get("svc")
	if !ok {
		t.Fatal("expected to find singleton")
	}
	if v.(*struct{ X int }).X != 42 {
		t.Fatal("wrong singleton value")
	}
}

func TestRegistryHas(t *testing.T) {
	r := plugins.NewServiceRegistry()
	if r.Has("a") {
		t.Fatal("should not have a")
	}
	r.Register("a", func() any { return nil })
	if !r.Has("a") {
		t.Fatal("should have a")
	}
}

func TestRegistryForget(t *testing.T) {
	r := plugins.NewServiceRegistry()
	r.RegisterSingleton("a", 1)
	r.Forget("a")
	if r.Has("a") {
		t.Fatal("a should be forgotten")
	}
}

func TestRegistryFlush(t *testing.T) {
	r := plugins.NewServiceRegistry()
	r.Register("a", func() any { return 1 })
	r.RegisterSingleton("b", 2)
	r.Flush()
	if r.Has("a") || r.Has("b") {
		t.Fatal("registry should be empty after flush")
	}
}

func TestRegistryGetNotFound(t *testing.T) {
	r := plugins.NewServiceRegistry()
	_, ok := r.Get("missing")
	if ok {
		t.Fatal("expected not found")
	}
}

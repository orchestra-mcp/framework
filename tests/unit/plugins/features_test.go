package plugins_test

import (
	"testing"

	"github.com/orchestra-mcp/framework/app/plugins"
	"github.com/orchestra-mcp/framework/config"
)

func TestNewFeatureManagerDisabledList(t *testing.T) {
	cfg := &config.PluginsConfig{Disabled: []string{"a", "b"}}
	fm := plugins.NewFeatureManager(cfg)
	if !fm.IsDisabled("a") {
		t.Fatal("expected a to be disabled")
	}
	if !fm.IsDisabled("b") {
		t.Fatal("expected b to be disabled")
	}
	if fm.IsDisabled("c") {
		t.Fatal("c should not be disabled")
	}
}

func TestFeatureManagerNilConfig(t *testing.T) {
	fm := plugins.NewFeatureManager(nil)
	if fm.IsDisabled("x") {
		t.Fatal("nothing should be disabled with nil config")
	}
}

func TestFeatureManagerEnable(t *testing.T) {
	cfg := &config.PluginsConfig{Disabled: []string{"a"}}
	fm := plugins.NewFeatureManager(cfg)
	fm.Enable("a")
	if fm.IsDisabled("a") {
		t.Fatal("a should be enabled after Enable()")
	}
}

func TestFeatureManagerDisable(t *testing.T) {
	fm := plugins.NewFeatureManager(nil)
	fm.Disable("x")
	if !fm.IsDisabled("x") {
		t.Fatal("x should be disabled after Disable()")
	}
}

func TestFeatureManagerRegisterFlag(t *testing.T) {
	fm := plugins.NewFeatureManager(nil)
	fm.RegisterFlag("a", false)
	if !fm.IsDisabled("a") {
		t.Fatal("a should be disabled when flag is false")
	}
	fm.RegisterFlag("a", true)
	if fm.IsDisabled("a") {
		t.Fatal("a should be enabled when flag is true")
	}
}

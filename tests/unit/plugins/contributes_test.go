package plugins_test

import (
	"testing"

	"github.com/orchestra-mcp/framework/app/plugins"
)

func TestRegisterAndGetCommands(t *testing.T) {
	cr := plugins.NewContributesRegistry()
	cr.RegisterCommand("p1", plugins.CommandContribution{ID: "cmd1", Title: "Cmd 1"})
	cmds := cr.GetCommands()
	if len(cmds) != 1 || cmds[0].ID != "cmd1" {
		t.Fatalf("expected cmd1, got %v", cmds)
	}
}

func TestRegisterAndGetMenus(t *testing.T) {
	cr := plugins.NewContributesRegistry()
	cr.RegisterMenu("p1", plugins.MenuContribution{ID: "m1", Label: "Menu"})
	if len(cr.GetMenus()) != 1 {
		t.Fatal("expected 1 menu")
	}
}

func TestRegisterAndGetSettings(t *testing.T) {
	cr := plugins.NewContributesRegistry()
	cr.RegisterSetting("p1", plugins.SettingContribution{Key: "s1"})
	if len(cr.GetSettings()) != 1 {
		t.Fatal("expected 1 setting")
	}
}

func TestRegisterAndGetKeybindings(t *testing.T) {
	cr := plugins.NewContributesRegistry()
	cr.RegisterKeybinding("p1", plugins.KeybindingContribution{Command: "kb1", Key: "ctrl+k"})
	if len(cr.GetKeybindings()) != 1 {
		t.Fatal("expected 1 keybinding")
	}
}

func TestRegisterAndGetThemes(t *testing.T) {
	cr := plugins.NewContributesRegistry()
	cr.RegisterTheme("p1", plugins.ThemeContribution{ID: "t1", Label: "Dark"})
	if len(cr.GetThemes()) != 1 {
		t.Fatal("expected 1 theme")
	}
}

func TestRegisterFromPlugin(t *testing.T) {
	cr := plugins.NewContributesRegistry()
	c := &plugins.Contributions{
		Commands:    []plugins.CommandContribution{{ID: "c1"}},
		Menus:       []plugins.MenuContribution{{ID: "m1"}},
		Settings:    []plugins.SettingContribution{{Key: "s1"}},
		Keybindings: []plugins.KeybindingContribution{{Command: "k1"}},
		Themes:      []plugins.ThemeContribution{{ID: "t1"}},
	}
	cr.RegisterFromPlugin("p1", c)
	if len(cr.GetCommands()) != 1 {
		t.Fatal("expected 1 command from RegisterFromPlugin")
	}
	if len(cr.GetThemes()) != 1 {
		t.Fatal("expected 1 theme from RegisterFromPlugin")
	}
}

func TestRegisterFromPluginNil(t *testing.T) {
	cr := plugins.NewContributesRegistry()
	cr.RegisterFromPlugin("p1", nil) // should not panic
}

func TestContributesFlush(t *testing.T) {
	cr := plugins.NewContributesRegistry()
	cr.RegisterCommand("p1", plugins.CommandContribution{ID: "c1"})
	cr.RegisterTheme("p1", plugins.ThemeContribution{ID: "t1"})
	cr.Flush()
	if len(cr.GetCommands()) != 0 || len(cr.GetThemes()) != 0 {
		t.Fatal("expected empty after flush")
	}
}

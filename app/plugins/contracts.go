package plugins

import (
	"github.com/gofiber/fiber/v3"
)

// Plugin is the core interface every plugin must implement.
type Plugin interface {
	ID() string
	Name() string
	Version() string
	Dependencies() []string
	Activate(ctx *PluginContext) error
	Deactivate() error
	IsActive() bool
}

// HasRoutes indicates a plugin that registers HTTP routes.
type HasRoutes interface {
	RegisterRoutes(group fiber.Router)
}

// HasConfig indicates a plugin that provides configuration.
type HasConfig interface {
	ConfigKey() string
	DefaultConfig() map[string]any
}

// HasCommands indicates a plugin that provides CLI commands.
type HasCommands interface {
	Commands() []Command
}

// HasMcpTools indicates a plugin that provides MCP tool definitions.
type HasMcpTools interface {
	McpTools() []McpToolDefinition
}

// HasMigrations indicates a plugin that provides database migrations.
type HasMigrations interface {
	MigrationFiles() []string
}

// HasMiddleware indicates a plugin that provides middleware.
type HasMiddleware interface {
	Middleware() []any
}

// HasJobs indicates a plugin that provides background job definitions.
type HasJobs interface {
	Jobs() []JobDefinition
}

// HasSchedule indicates a plugin that registers scheduled tasks.
type HasSchedule interface {
	RegisterSchedule(scheduler any)
}

// HasServices indicates a plugin that provides service definitions.
type HasServices interface {
	Services() []ServiceDefinition
}

// Contributable indicates a plugin that contributes UI/editor extensions.
type Contributable interface {
	Contributes() *Contributions
}

// HasFeatureFlag indicates a plugin that is gated behind a feature flag.
type HasFeatureFlag interface {
	FeatureFlag() string
}

// Marketable indicates a plugin that can be listed in the marketplace.
type Marketable interface {
	IsMarketable() bool
	MarketplaceCategory() string
	MarketplaceDescription() string
}

// HasDesktopViews indicates a plugin that provides desktop view templates.
type HasDesktopViews interface {
	DesktopViewsPath() string
}

// HasChromeViews indicates a plugin that provides Chrome extension view templates.
type HasChromeViews interface {
	ChromeViewsPath() string
}

// HasWebViews indicates a plugin that provides web view templates.
type HasWebViews interface {
	WebViewsPath() string
}

// Command represents a CLI command provided by a plugin.
type Command struct {
	Name        string
	Description string
	Handler     func(args []string) error
}

// McpToolDefinition represents an MCP tool provided by a plugin.
type McpToolDefinition struct {
	Name        string
	Description string
	InputSchema map[string]any
	Handler     func(input map[string]any) (any, error)
}

// JobDefinition represents a background job provided by a plugin.
type JobDefinition struct {
	Name    string
	Handler func(payload map[string]any) error
	Queue   string
}

// ServiceDefinition represents a service provided by a plugin.
type ServiceDefinition struct {
	ID      string
	Factory func() any
}

// Contributions holds all the UI/editor contributions from a plugin.
type Contributions struct {
	Commands    []CommandContribution
	Menus       []MenuContribution
	Settings    []SettingContribution
	Keybindings []KeybindingContribution
	Themes      []ThemeContribution
}

// CommandContribution represents a command contributed to the editor/UI.
type CommandContribution struct {
	ID       string
	Title    string
	Category string
	Icon     string
}

// MenuContribution represents a menu item contributed to the editor/UI.
type MenuContribution struct {
	ID       string
	Label    string
	Group    string
	Command  string
	When     string
	Priority int
}

// SettingContribution represents a setting contributed by a plugin.
type SettingContribution struct {
	Key         string
	Title       string
	Description string
	Type        string
	Default     any
	Enum        []any
	EnumLabels  []string
}

// KeybindingContribution represents a keyboard shortcut contributed by a plugin.
type KeybindingContribution struct {
	Command  string
	Key      string
	Mac      string
	When     string
	Priority int
}

// ThemeContribution represents a theme contributed by a plugin.
type ThemeContribution struct {
	ID          string
	Label       string
	UITheme     string
	Path        string
	Description string
}

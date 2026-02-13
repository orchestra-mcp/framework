package config

// McpConfig holds configuration for the Orchestra MCP plugin.
type McpConfig struct {
	Enabled bool   `json:"enabled" yaml:"enabled"`
	Binary  string `json:"binary" yaml:"binary"`
}

// Default returns the default MCP configuration.
func Default() McpConfig {
	return McpConfig{Enabled: true, Binary: "orchestra-mcp"}
}

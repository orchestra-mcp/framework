package bootstrap

import (
	_ "embed"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

//go:embed resources/skills/project-manager/SKILL.md
var bundledSkill string

//go:embed resources/agents/scrum-master.md
var bundledAgent string

// Run initializes Orchestra MCP in the given workspace.
func Run(workspaceRoot string) error {
	abs, err := filepath.Abs(workspaceRoot)
	if err != nil {
		return fmt.Errorf("resolve workspace: %w", err)
	}

	projectName := detectProjectName(abs)
	projectType := detectProjectType(abs)

	if err := writeMcpJSON(abs); err != nil {
		return fmt.Errorf("write .mcp.json: %w", err)
	}

	projDir := filepath.Join(abs, ".projects", projectName)
	if err := os.MkdirAll(projDir, 0o755); err != nil {
		return fmt.Errorf("create .projects: %w", err)
	}

	skillDir := filepath.Join(projDir, "skills", "project-manager")
	if err := os.MkdirAll(skillDir, 0o755); err != nil {
		return fmt.Errorf("create skills dir: %w", err)
	}
	if err := os.WriteFile(filepath.Join(skillDir, "SKILL.md"), []byte(bundledSkill), 0o644); err != nil {
		return fmt.Errorf("write SKILL.md: %w", err)
	}

	agentDir := filepath.Join(projDir, "agents")
	if err := os.MkdirAll(agentDir, 0o755); err != nil {
		return fmt.Errorf("create agents dir: %w", err)
	}
	if err := os.WriteFile(filepath.Join(agentDir, "scrum-master.md"), []byte(bundledAgent), 0o644); err != nil {
		return fmt.Errorf("write scrum-master.md: %w", err)
	}

	fmt.Printf("Orchestra MCP initialized!\n")
	fmt.Printf("  Project:  %s\n", projectName)
	fmt.Printf("  Type:     %s\n", projectType)
	fmt.Printf("  Root:     %s\n", abs)
	fmt.Printf("  Config:   .mcp.json\n")
	fmt.Printf("  Skills:   .projects/%s/skills/\n", projectName)
	fmt.Printf("  Agents:   .projects/%s/agents/\n", projectName)
	return nil
}

func writeMcpJSON(root string) error {
	mcpPath := filepath.Join(root, ".mcp.json")
	config := map[string]any{}
	if data, err := os.ReadFile(mcpPath); err == nil {
		_ = json.Unmarshal(data, &config)
	}
	if config["mcpServers"] == nil {
		config["mcpServers"] = map[string]any{}
	}
	servers := config["mcpServers"].(map[string]any)
	servers["orchestra-mcp"] = map[string]any{
		"command": "orchestra-mcp",
		"args":    []string{"--workspace", root},
	}
	data, err := json.MarshalIndent(config, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(mcpPath, append(data, '\n'), 0o644)
}

func detectProjectName(root string) string {
	if data, err := os.ReadFile(filepath.Join(root, "package.json")); err == nil {
		var pkg map[string]any
		if json.Unmarshal(data, &pkg) == nil {
			if name, ok := pkg["name"].(string); ok && name != "" {
				return name
			}
		}
	}
	if data, err := os.ReadFile(filepath.Join(root, "go.mod")); err == nil {
		for _, line := range strings.Split(string(data), "\n") {
			if strings.HasPrefix(line, "module ") {
				parts := strings.Split(strings.TrimPrefix(line, "module "), "/")
				return parts[len(parts)-1]
			}
		}
	}
	if data, err := os.ReadFile(filepath.Join(root, "Cargo.toml")); err == nil {
		for _, line := range strings.Split(string(data), "\n") {
			line = strings.TrimSpace(line)
			if strings.HasPrefix(line, "name") && strings.Contains(line, "=") {
				val := strings.TrimSpace(strings.SplitN(line, "=", 2)[1])
				return strings.Trim(val, "\"'")
			}
		}
	}
	return filepath.Base(root)
}

func detectProjectType(root string) string {
	checks := []struct {
		file     string
		projType string
	}{
		{"package.json", "Node.js"},
		{"go.mod", "Go"},
		{"Cargo.toml", "Rust"},
		{"composer.json", "PHP"},
		{"pyproject.toml", "Python"},
		{"requirements.txt", "Python"},
		{"Gemfile", "Ruby"},
	}
	for _, c := range checks {
		if _, err := os.Stat(filepath.Join(root, c.file)); err == nil {
			return c.projType
		}
	}
	return "Unknown"
}

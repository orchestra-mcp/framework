package toon

import (
	"os"

	"gopkg.in/yaml.v3"
)

// ParseFile reads a TOON file (YAML) and decodes it into v.
func ParseFile(path string, v any) error {
	data, err := os.ReadFile(path)
	if err != nil {
		return err
	}
	return yaml.Unmarshal(data, v)
}

// WriteFile encodes v as YAML and writes it to the given path.
func WriteFile(path string, v any) error {
	data, err := yaml.Marshal(v)
	if err != nil {
		return err
	}
	return os.WriteFile(path, data, 0o644)
}

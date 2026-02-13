package helpers

import (
	"os"
	"path/filepath"
)

// ProjectsDir returns the .projects directory path.
func ProjectsDir(workspaceRoot string) string {
	return filepath.Join(workspaceRoot, ".projects")
}

// ProjectDir returns the directory for a specific project.
func ProjectDir(workspaceRoot, slug string) string {
	return filepath.Join(workspaceRoot, ".projects", slug)
}

// FileExists checks whether a file or directory exists.
func FileExists(path string) bool {
	_, err := os.Stat(path)
	return err == nil
}

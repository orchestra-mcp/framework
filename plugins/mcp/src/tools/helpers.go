package tools

import "strings"

// containsCI performs case-insensitive substring search.
func containsCI(text, query string) bool {
	return strings.Contains(strings.ToLower(text), strings.ToLower(query))
}

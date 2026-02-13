package helpers

import (
	"regexp"
	"strings"
	"time"
)

var issueIDRegex = regexp.MustCompile(`^[A-Z][A-Z0-9]*-\d+$`)

// IsIssueID checks if a string matches the issue ID pattern.
func IsIssueID(name string) bool { return issueIDRegex.MatchString(name) }

// Now returns the current UTC time as RFC3339.
func Now() string { return time.Now().UTC().Format(time.RFC3339) }

// Slugify converts a string to a URL-friendly slug.
func Slugify(s string) string {
	s = strings.ToLower(strings.TrimSpace(s))
	s = regexp.MustCompile(`[^a-z0-9]+`).ReplaceAllString(s, "-")
	return strings.Trim(s, "-")
}

// DeriveKey extracts an uppercase key prefix from a name.
func DeriveKey(name string) string {
	words := regexp.MustCompile(`[^a-zA-Z0-9]+`).Split(name, -1)
	var key string
	for _, w := range words {
		if len(w) > 0 {
			key += strings.ToUpper(w[:1])
		}
	}
	if key == "" {
		key = "PRJ"
	}
	return key
}

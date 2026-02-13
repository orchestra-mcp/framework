package helpers

// GetString extracts a string argument from the args map.
func GetString(args map[string]any, key string) string {
	if v, ok := args[key]; ok {
		if s, ok := v.(string); ok {
			return s
		}
	}
	return ""
}

// GetInt extracts an int argument (handles JSON float64).
func GetInt(args map[string]any, key string) int {
	if v, ok := args[key]; ok {
		switch n := v.(type) {
		case float64:
			return int(n)
		case int:
			return n
		}
	}
	return 0
}

// GetFloat64 extracts a float64 argument.
func GetFloat64(args map[string]any, key string) float64 {
	if v, ok := args[key]; ok {
		if f, ok := v.(float64); ok {
			return f
		}
	}
	return 0
}

// Has checks if a key exists in the args map.
func Has(args map[string]any, key string) bool {
	_, ok := args[key]
	return ok
}

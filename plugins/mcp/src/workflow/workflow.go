package workflow

// Transitions defines valid state transitions for issues.
var Transitions = map[string][]string{
	"backlog":     {"todo"},
	"todo":        {"in-progress", "backlog"},
	"in-progress": {"review", "blocked", "todo"},
	"blocked":     {"in-progress", "todo"},
	"review":      {"done", "in-progress"},
	"done":        {"todo"},
	"cancelled":   {"backlog"},
}

// CompletedStatuses are terminal states that count as resolved.
var CompletedStatuses = map[string]bool{
	"done":      true,
	"cancelled": true,
}

// DoneStatuses are states where work finished successfully.
var DoneStatuses = map[string]bool{
	"done": true,
}

// IsValid checks whether transitioning from -> to is allowed.
func IsValid(from, to string) bool {
	targets, ok := Transitions[from]
	if !ok {
		return false
	}
	for _, t := range targets {
		if t == to {
			return true
		}
	}
	return false
}

// NextStates returns the valid transitions from a given state.
func NextStates(current string) []string {
	if targets, ok := Transitions[current]; ok {
		return targets
	}
	return nil
}

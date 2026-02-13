package types

// UsageData tracks token usage across sessions.
type UsageData struct {
	Sessions []UsageSession `yaml:"sessions" json:"sessions"`
	Totals   UsageTotals    `yaml:"totals" json:"totals"`
}

// UsageSession is a single usage tracking session.
type UsageSession struct {
	Provider    string         `yaml:"provider" json:"provider"`
	Model       string         `yaml:"model" json:"model"`
	StartedAt   string         `yaml:"started_at" json:"started_at"`
	EndedAt     string         `yaml:"ended_at,omitempty" json:"ended_at,omitempty"`
	Requests    []RequestEntry `yaml:"requests,omitempty" json:"requests,omitempty"`
	TotalInput  int            `yaml:"total_input" json:"total_input"`
	TotalOutput int            `yaml:"total_output" json:"total_output"`
	TotalCost   float64        `yaml:"total_cost" json:"total_cost"`
}

// UsageTotals aggregates usage across all sessions.
type UsageTotals struct {
	TotalInput  int     `yaml:"total_input" json:"total_input"`
	TotalOutput int     `yaml:"total_output" json:"total_output"`
	TotalCost   float64 `yaml:"total_cost" json:"total_cost"`
}

// RequestEntry is a single API request's usage.
type RequestEntry struct {
	Timestamp    string  `yaml:"timestamp" json:"timestamp"`
	InputTokens  int     `yaml:"input_tokens" json:"input_tokens"`
	OutputTokens int     `yaml:"output_tokens" json:"output_tokens"`
	Cost         float64 `yaml:"cost" json:"cost"`
}

// RequestLog tracks feature requests and suggestions.
type RequestLog struct {
	Project  string           `yaml:"project" json:"project"`
	Requests []RequestLogItem `yaml:"requests" json:"requests"`
}

// RequestLogItem is a single logged request.
type RequestLogItem struct {
	ID          string `yaml:"id" json:"id"`
	Type        string `yaml:"type" json:"type"`
	Date        string `yaml:"date" json:"date"`
	Description string `yaml:"description" json:"description"`
	Status      string `yaml:"status" json:"status"`
}

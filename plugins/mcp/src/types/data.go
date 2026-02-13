package types

// ProjectStatus is the root tracking file for a project.
type ProjectStatus struct {
	Project     string       `yaml:"project" json:"project"`
	Slug        string       `yaml:"slug" json:"slug"`
	Status      string       `yaml:"status" json:"status"`
	Description string       `yaml:"description,omitempty" json:"description,omitempty"`
	CreatedAt   string       `yaml:"created_at" json:"created_at"`
	UpdatedAt   string       `yaml:"updated_at,omitempty" json:"updated_at,omitempty"`
	Epics       []IssueEntry `yaml:"epics,omitempty" json:"epics,omitempty"`
	Stories     []IssueEntry `yaml:"stories,omitempty" json:"stories,omitempty"`
	Tasks       []IssueEntry `yaml:"tasks,omitempty" json:"tasks,omitempty"`
}

// IssueEntry is a summary row in project status.
type IssueEntry struct {
	ID     string `yaml:"id" json:"id"`
	Title  string `yaml:"title" json:"title"`
	Status string `yaml:"status" json:"status"`
}

// IssueChild is a child reference stored on a parent issue.
type IssueChild struct {
	ID     string `yaml:"id" json:"id"`
	Title  string `yaml:"title" json:"title"`
	Status string `yaml:"status" json:"status"`
}

// IssueData is the full data for any issue (epic/story/task/bug).
type IssueData struct {
	ID          string       `yaml:"id" json:"id"`
	Title       string       `yaml:"title" json:"title"`
	Type        string       `yaml:"type" json:"type"`
	Status      string       `yaml:"status" json:"status"`
	Description string       `yaml:"description,omitempty" json:"description,omitempty"`
	Priority    string       `yaml:"priority,omitempty" json:"priority,omitempty"`
	CreatedAt   string       `yaml:"created_at" json:"created_at"`
	UpdatedAt   string       `yaml:"updated_at,omitempty" json:"updated_at,omitempty"`
	Children    []IssueChild `yaml:"children,omitempty" json:"children,omitempty"`
}

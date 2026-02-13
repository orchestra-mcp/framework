package types

// PrdSession tracks a guided PRD creation session.
type PrdSession struct {
	ProjectName  string      `yaml:"project_name" json:"project_name"`
	Slug         string      `yaml:"slug" json:"slug"`
	Status       string      `yaml:"status" json:"status"`
	CurrentIndex int         `yaml:"current_index" json:"current_index"`
	Answers      []PrdAnswer `yaml:"answers,omitempty" json:"answers,omitempty"`
}

// PrdAnswer stores one answered PRD question.
type PrdAnswer struct {
	Question string `yaml:"question" json:"question"`
	Answer   string `yaml:"answer" json:"answer"`
}

// PrdQuestion defines a PRD questionnaire item.
type PrdQuestion struct {
	Index    int    `yaml:"index" json:"index"`
	Key      string `yaml:"key" json:"key"`
	Section  string `yaml:"section" json:"section"`
	Question string `yaml:"question" json:"question"`
	Required bool   `yaml:"required" json:"required"`
}

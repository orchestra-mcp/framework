package tools

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	h "github.com/orchestra-mcp/mcp/src/helpers"
	"github.com/orchestra-mcp/mcp/src/toon"
	t "github.com/orchestra-mcp/mcp/src/types"
)

var prdQuestions = []t.PrdQuestion{
	{Index: 0, Key: "project_name", Section: "overview", Question: "What is the project name?", Required: true},
	{Index: 1, Key: "project_description", Section: "overview", Question: "Describe the project.", Required: true},
	{Index: 2, Key: "target_audience", Section: "overview", Question: "Who is the target audience?", Required: true},
	{Index: 3, Key: "primary_goals", Section: "goals", Question: "What are the primary goals?", Required: true},
	{Index: 4, Key: "success_metrics", Section: "goals", Question: "How will success be measured?", Required: false},
	{Index: 5, Key: "functional_requirements", Section: "requirements", Question: "Functional requirements?", Required: true},
	{Index: 6, Key: "non_functional_requirements", Section: "requirements", Question: "Non-functional requirements?", Required: false},
	{Index: 7, Key: "constraints", Section: "requirements", Question: "Constraints or limitations?", Required: false},
	{Index: 8, Key: "tech_stack", Section: "technical", Question: "Tech stack?", Required: false},
	{Index: 9, Key: "integrations", Section: "technical", Question: "Third-party integrations?", Required: false},
	{Index: 10, Key: "milestones", Section: "timeline", Question: "Key milestones?", Required: false},
	{Index: 11, Key: "deadline", Section: "timeline", Question: "Target deadline?", Required: false},
}

var sectionTitles = map[string]string{
	"overview": "Overview", "goals": "Goals", "requirements": "Requirements",
	"technical": "Technical", "timeline": "Timeline",
}

var questionLabels = map[string]string{
	"project_name": "Project Name", "project_description": "Description",
	"target_audience": "Target Audience", "primary_goals": "Primary Goals",
	"success_metrics": "Success Metrics", "functional_requirements": "Functional Requirements",
	"non_functional_requirements": "Non-Functional Requirements", "constraints": "Constraints",
	"tech_stack": "Tech Stack", "integrations": "Integrations",
	"milestones": "Milestones", "deadline": "Deadline",
}

func prdFile(ws, slug string) string {
	return filepath.Join(h.ProjectDir(ws, slug), "prd-session.toon")
}

func loadPrd(ws, slug string) (*t.PrdSession, error) {
	var s t.PrdSession
	return &s, toon.ParseFile(prdFile(ws, slug), &s)
}

func savePrd(ws string, s *t.PrdSession) error { return toon.WriteFile(prdFile(ws, s.Slug), s) }

func generatePrdMarkdown(s *t.PrdSession) string {
	ans := map[string]string{}
	for _, a := range s.Answers {
		ans[a.Question] = a.Answer
	}
	var b strings.Builder
	b.WriteString(fmt.Sprintf("# %s\n\n", s.ProjectName))
	sec := ""
	for _, q := range prdQuestions {
		v := ans[q.Key]
		if v == "" {
			continue
		}
		if q.Section != sec {
			sec = q.Section
			b.WriteString(fmt.Sprintf("## %s\n\n", sectionTitles[sec]))
		}
		b.WriteString(fmt.Sprintf("### %s\n\n%s\n\n", questionLabels[q.Key], v))
	}
	return b.String()
}

func nextQ(s *t.PrdSession) map[string]any {
	if s.CurrentIndex >= len(prdQuestions) {
		return map[string]any{"status": "complete"}
	}
	q := prdQuestions[s.CurrentIndex]
	return map[string]any{"status": "in_progress", "question": q.Question, "key": q.Key, "index": s.CurrentIndex, "required": q.Required}
}

func finishPrd(ws string, s *t.PrdSession) *t.ToolResult {
	s.Status = "complete"
	if err := os.WriteFile(filepath.Join(h.ProjectDir(ws, s.Slug), "prd.md"), []byte(generatePrdMarkdown(s)), 0o644); err != nil {
		return h.ErrorResult(err.Error())
	}
	if err := savePrd(ws, s); err != nil {
		return h.ErrorResult(err.Error())
	}
	return h.JSONResult(map[string]any{"status": "complete", "file": "prd.md"})
}

func advancePrd(ws string, s *t.PrdSession) *t.ToolResult {
	s.CurrentIndex++
	if s.CurrentIndex >= len(prdQuestions) {
		return finishPrd(ws, s)
	}
	if err := savePrd(ws, s); err != nil {
		return h.ErrorResult(err.Error())
	}
	return h.JSONResult(nextQ(s))
}

func sp() t.InputSchema {
	return t.InputSchema{Type: "object", Properties: map[string]any{
		"project": map[string]any{"type": "string", "description": "Project slug"},
	}, Required: []string{"project"}}
}

// Prd returns all PRD management tools.
func Prd(ws string) []t.Tool {
	return []t.Tool{
		{Definition: t.ToolDefinition{Name: "start_prd_session", Description: "Start guided PRD creation", InputSchema: sp()}, Handler: func(a map[string]any) (*t.ToolResult, error) {
			slug := h.GetString(a, "project")
			if !h.FileExists(h.ProjectDir(ws, slug)) {
				return h.ErrorResult("project not found"), nil
			}
			s := &t.PrdSession{Slug: slug, ProjectName: slug, Status: "in_progress"}
			if err := savePrd(ws, s); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			return h.JSONResult(nextQ(s)), nil
		}},
		{Definition: t.ToolDefinition{Name: "answer_prd_question", Description: "Answer current PRD question", InputSchema: t.InputSchema{Type: "object", Properties: map[string]any{"project": map[string]any{"type": "string"}, "answer": map[string]any{"type": "string"}}, Required: []string{"project", "answer"}}}, Handler: func(a map[string]any) (*t.ToolResult, error) {
			s, err := loadPrd(ws, h.GetString(a, "project"))
			if err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			q := prdQuestions[s.CurrentIndex]
			s.Answers = append(s.Answers, t.PrdAnswer{Question: q.Key, Answer: h.GetString(a, "answer")})
			return advancePrd(ws, s), nil
		}},
		{Definition: t.ToolDefinition{Name: "get_prd_session", Description: "Get PRD session state", InputSchema: sp()}, Handler: func(a map[string]any) (*t.ToolResult, error) {
			s, err := loadPrd(ws, h.GetString(a, "project"))
			if err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			return h.JSONResult(s), nil
		}},
		{Definition: t.ToolDefinition{Name: "abandon_prd_session", Description: "Abandon PRD session", InputSchema: sp()}, Handler: func(a map[string]any) (*t.ToolResult, error) {
			os.Remove(prdFile(ws, h.GetString(a, "project")))
			return h.TextResult("abandoned"), nil
		}},
		{Definition: t.ToolDefinition{Name: "skip_prd_question", Description: "Skip optional PRD question", InputSchema: sp()}, Handler: func(a map[string]any) (*t.ToolResult, error) {
			s, err := loadPrd(ws, h.GetString(a, "project"))
			if err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			if prdQuestions[s.CurrentIndex].Required {
				return h.ErrorResult("cannot skip required question"), nil
			}
			return advancePrd(ws, s), nil
		}},
		{Definition: t.ToolDefinition{Name: "back_prd_question", Description: "Go back to previous PRD question", InputSchema: sp()}, Handler: func(a map[string]any) (*t.ToolResult, error) {
			s, err := loadPrd(ws, h.GetString(a, "project"))
			if err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			if s.CurrentIndex == 0 {
				return h.ErrorResult("at first question"), nil
			}
			s.CurrentIndex--
			prev := prdQuestions[s.CurrentIndex].Key
			if n := len(s.Answers); n > 0 && s.Answers[n-1].Question == prev {
				s.Answers = s.Answers[:n-1]
			}
			if err := savePrd(ws, s); err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			return h.JSONResult(nextQ(s)), nil
		}},
		{Definition: t.ToolDefinition{Name: "preview_prd", Description: "Preview PRD markdown", InputSchema: sp()}, Handler: func(a map[string]any) (*t.ToolResult, error) {
			s, err := loadPrd(ws, h.GetString(a, "project"))
			if err != nil {
				return h.ErrorResult(err.Error()), nil
			}
			return h.TextResult(generatePrdMarkdown(s)), nil
		}},
	}
}

---
name: ai-agentic
description: AI and agentic features with Anthropic SDK, OpenAI SDK, langchaingo, chromem-go, and pgvector. Activates when building AI chat, agent orchestration, embeddings, RAG, vector search, tool use, streaming, or any AI/LLM integration.
---

# AI & Agentic — LLM Integration + RAG + Agent Orchestration

Orchestra's AI system provides chat, code generation, embeddings, vector search, and autonomous agent capabilities across the IDE. The Go backend orchestrates AI interactions, while the Rust engine handles local vector operations.

## Architecture

```
User (any platform)
  │
  └── AI Chat / Agent / Inline Assist
        │
        ▼
  ┌──────────────────────────────────────┐
  │         Go Backend (AI Layer)         │
  │                                       │
  │  ┌─────────────┐  ┌───────────────┐  │
  │  │ Anthropic SDK│  │ OpenAI SDK    │  │
  │  │ (Claude)     │  │ (GPT, embed)  │  │
  │  └──────┬───────┘  └──────┬────────┘  │
  │         │                  │           │
  │  ┌──────▼──────────────────▼────────┐  │
  │  │     langchaingo (orchestration)  │  │
  │  └──────────────┬───────────────────┘  │
  │                 │                      │
  │  ┌──────────────▼───────────────────┐  │
  │  │   pgvector (cloud vector store)  │  │
  │  └──────────────────────────────────┘  │
  └──────────────────┬─────────────────────┘
                     │ gRPC
  ┌──────────────────▼─────────────────────┐
  │        Rust Engine (local)             │
  │  ┌────────────────────────────────┐    │
  │  │  chromem-go equivalent (local) │    │
  │  │  Tantivy (code search)         │    │
  │  └────────────────────────────────┘    │
  └────────────────────────────────────────┘
```

## Project Structure

```
app/
├── services/
│   ├── ai/
│   │   ├── anthropic.go        # Claude API client wrapper
│   │   ├── openai.go           # OpenAI API client wrapper
│   │   ├── provider.go         # AI provider interface + factory
│   │   ├── chat.go             # Chat service (multi-provider)
│   │   ├── agent.go            # Agent orchestration (langchaingo)
│   │   ├── embedding.go        # Embedding service
│   │   ├── rag.go              # RAG pipeline (retrieve → augment → generate)
│   │   ├── tools.go            # Tool definitions for agents
│   │   └── stream.go           # SSE/WebSocket streaming helper
│   └── vector/
│       ├── pgvector.go         # Cloud vector store (PostgreSQL + pgvector)
│       └── chromem.go          # Local vector store (chromem-go)
├── handlers/
│   ├── ai_handler.go           # Chat, agent, embedding API endpoints
│   └── ws/ai_stream.go         # WebSocket streaming for AI responses
├── models/
│   └── ai_conversation.go      # Conversation history model
└── gen/proto/ai/               # Generated AI proto code
```

## AI Provider Interface

```go
package ai

import "context"

// Provider abstracts LLM backends (Anthropic, OpenAI, etc.)
type Provider interface {
    Chat(ctx context.Context, req ChatRequest) (*ChatResponse, error)
    ChatStream(ctx context.Context, req ChatRequest) (<-chan StreamEvent, error)
    Embed(ctx context.Context, input []string) ([][]float32, error)
    ListModels(ctx context.Context) ([]Model, error)
}

type ChatRequest struct {
    Model       string     `json:"model"`
    Messages    []Message  `json:"messages"`
    MaxTokens   int        `json:"max_tokens,omitempty"`
    Temperature float64    `json:"temperature,omitempty"`
    Tools       []Tool     `json:"tools,omitempty"`
    System      string     `json:"system,omitempty"`
    Stream      bool       `json:"stream,omitempty"`
}

type Message struct {
    Role    string        `json:"role"`    // "user", "assistant", "system"
    Content []ContentPart `json:"content"`
}

type ContentPart struct {
    Type string `json:"type"` // "text", "image", "tool_use", "tool_result"
    Text string `json:"text,omitempty"`
    // Tool use fields
    ID    string `json:"id,omitempty"`
    Name  string `json:"name,omitempty"`
    Input any    `json:"input,omitempty"`
}

type ChatResponse struct {
    ID           string    `json:"id"`
    Model        string    `json:"model"`
    Messages     []Message `json:"messages"`
    StopReason   string    `json:"stop_reason"`
    InputTokens  int       `json:"input_tokens"`
    OutputTokens int       `json:"output_tokens"`
}

type StreamEvent struct {
    Type  string `json:"type"` // "text", "tool_use", "done", "error"
    Text  string `json:"text,omitempty"`
    Error string `json:"error,omitempty"`
}

type Tool struct {
    Name        string `json:"name"`
    Description string `json:"description"`
    InputSchema any    `json:"input_schema"`
}
```

## Anthropic SDK Integration

```go
package ai

import (
    "context"

    "github.com/anthropics/anthropic-sdk-go"
    "github.com/anthropics/anthropic-sdk-go/option"
)

type AnthropicProvider struct {
    client *anthropic.Client
}

func NewAnthropicProvider(apiKey string) *AnthropicProvider {
    client := anthropic.NewClient(option.WithAPIKey(apiKey))
    return &AnthropicProvider{client: client}
}

func (p *AnthropicProvider) Chat(ctx context.Context, req ChatRequest) (*ChatResponse, error) {
    messages := make([]anthropic.MessageParam, len(req.Messages))
    for i, msg := range req.Messages {
        messages[i] = anthropic.NewUserMessage(
            anthropic.NewTextBlock(msg.Content[0].Text),
        )
    }

    resp, err := p.client.Messages.New(ctx, anthropic.MessageNewParams{
        Model:     anthropic.F(anthropic.Model(req.Model)),
        MaxTokens: anthropic.F(int64(req.MaxTokens)),
        Messages:  anthropic.F(messages),
    })
    if err != nil {
        return nil, err
    }

    return mapAnthropicResponse(resp), nil
}

func (p *AnthropicProvider) ChatStream(ctx context.Context, req ChatRequest) (<-chan StreamEvent, error) {
    ch := make(chan StreamEvent)

    go func() {
        defer close(ch)

        stream := p.client.Messages.NewStreaming(ctx, anthropic.MessageNewParams{
            Model:     anthropic.F(anthropic.Model(req.Model)),
            MaxTokens: anthropic.F(int64(req.MaxTokens)),
            Messages:  anthropic.F(mapMessages(req.Messages)),
        })

        for stream.Next() {
            event := stream.Current()
            if delta, ok := event.Delta.(anthropic.ContentBlockDeltaEventDelta); ok {
                ch <- StreamEvent{Type: "text", Text: delta.Text}
            }
        }

        if err := stream.Err(); err != nil {
            ch <- StreamEvent{Type: "error", Error: err.Error()}
        } else {
            ch <- StreamEvent{Type: "done"}
        }
    }()

    return ch, nil
}

func (p *AnthropicProvider) Embed(ctx context.Context, input []string) ([][]float32, error) {
    // Anthropic doesn't have embeddings — delegate to OpenAI or local
    return nil, fmt.Errorf("anthropic does not support embeddings, use OpenAI provider")
}
```

## OpenAI SDK Integration

```go
package ai

import (
    "context"

    openai "github.com/sashabaranov/go-openai"
)

type OpenAIProvider struct {
    client *openai.Client
}

func NewOpenAIProvider(apiKey string) *OpenAIProvider {
    return &OpenAIProvider{
        client: openai.NewClient(apiKey),
    }
}

func (p *OpenAIProvider) Chat(ctx context.Context, req ChatRequest) (*ChatResponse, error) {
    resp, err := p.client.CreateChatCompletion(ctx, openai.ChatCompletionRequest{
        Model:       req.Model,
        Messages:    mapOpenAIMessages(req.Messages),
        MaxTokens:   req.MaxTokens,
        Temperature: float32(req.Temperature),
    })
    if err != nil {
        return nil, err
    }
    return mapOpenAIResponse(&resp), nil
}

func (p *OpenAIProvider) Embed(ctx context.Context, input []string) ([][]float32, error) {
    resp, err := p.client.CreateEmbeddings(ctx, openai.EmbeddingRequest{
        Model: openai.AdaEmbeddingV2,
        Input: input,
    })
    if err != nil {
        return nil, err
    }

    embeddings := make([][]float32, len(resp.Data))
    for i, d := range resp.Data {
        embeddings[i] = d.Embedding
    }
    return embeddings, nil
}
```

## Agent Orchestration (langchaingo)

```go
package ai

import (
    "context"

    "github.com/tmc/langchaingo/agents"
    "github.com/tmc/langchaingo/chains"
    "github.com/tmc/langchaingo/llms/anthropic"
    "github.com/tmc/langchaingo/tools"
    "github.com/tmc/langchaingo/schema"
)

type AgentService struct {
    llm   *anthropic.LLM
    tools []tools.Tool
}

func NewAgentService(apiKey string) (*AgentService, error) {
    llm, err := anthropic.New(anthropic.WithToken(apiKey))
    if err != nil {
        return nil, err
    }

    orchestraTools := []tools.Tool{
        NewFileSearchTool(),
        NewCodeEditTool(),
        NewTerminalTool(),
        NewWebSearchTool(),
    }

    return &AgentService{llm: llm, tools: orchestraTools}, nil
}

func (s *AgentService) Execute(ctx context.Context, task string, projectID string) (*AgentResult, error) {
    executor, err := agents.Initialize(
        s.llm,
        s.tools,
        agents.WithMaxIterations(10),
    )
    if err != nil {
        return nil, err
    }

    result, err := chains.Run(ctx, executor, task)
    if err != nil {
        return nil, err
    }

    return &AgentResult{
        Output: result,
        Steps:  executor.Steps(),
    }, nil
}
```

## Vector Store — pgvector (Cloud)

```go
package vector

import (
    "context"
    "fmt"

    "gorm.io/gorm"
)

type PgVectorStore struct {
    db *gorm.DB
}

func NewPgVectorStore(db *gorm.DB) *PgVectorStore {
    return &PgVectorStore{db: db}
}

func (s *PgVectorStore) Store(ctx context.Context, id string, embedding []float32, metadata map[string]string) error {
    return s.db.WithContext(ctx).Exec(
        "INSERT INTO embeddings (id, embedding, metadata) VALUES (?, ?::vector, ?) ON CONFLICT(id) DO UPDATE SET embedding = EXCLUDED.embedding",
        id, fmt.Sprintf("[%s]", floatsToString(embedding)), metadata,
    ).Error
}

func (s *PgVectorStore) Search(ctx context.Context, query []float32, limit int, filter map[string]string) ([]VectorResult, error) {
    var results []VectorResult
    err := s.db.WithContext(ctx).Raw(
        `SELECT id, metadata, 1 - (embedding <=> ?::vector) AS similarity
         FROM embeddings
         ORDER BY embedding <=> ?::vector
         LIMIT ?`,
        fmt.Sprintf("[%s]", floatsToString(query)),
        fmt.Sprintf("[%s]", floatsToString(query)),
        limit,
    ).Scan(&results).Error
    return results, err
}

type VectorResult struct {
    ID         string            `json:"id"`
    Metadata   map[string]string `json:"metadata"`
    Similarity float64           `json:"similarity"`
}
```

## Vector Store — chromem-go (Local)

```go
package vector

import (
    "context"

    "github.com/philippgille/chromem-go"
)

type LocalVectorStore struct {
    db         *chromem.DB
    collection *chromem.Collection
}

func NewLocalVectorStore(path string) (*LocalVectorStore, error) {
    db, err := chromem.NewPersistentDB(path, false)
    if err != nil {
        return nil, err
    }

    collection, err := db.GetOrCreateCollection("code-embeddings", nil, nil)
    if err != nil {
        return nil, err
    }

    return &LocalVectorStore{db: db, collection: collection}, nil
}

func (s *LocalVectorStore) Add(ctx context.Context, id string, content string, metadata map[string]string) error {
    return s.collection.AddDocument(ctx, chromem.Document{
        ID:       id,
        Content:  content,
        Metadata: metadata,
    })
}

func (s *LocalVectorStore) Query(ctx context.Context, query string, nResults int) ([]chromem.Result, error) {
    return s.collection.Query(ctx, query, nResults, nil, nil)
}
```

## RAG Pipeline

```go
package ai

import (
    "context"
    "fmt"
    "strings"

    "orchestra/app/services/vector"
)

type RAGService struct {
    chat      Provider
    embedder  Provider
    pgvector  *vector.PgVectorStore
    local     *vector.LocalVectorStore
}

func NewRAGService(chat, embedder Provider, pgv *vector.PgVectorStore, local *vector.LocalVectorStore) *RAGService {
    return &RAGService{chat: chat, embedder: embedder, pgvector: pgv, local: local}
}

func (s *RAGService) Answer(ctx context.Context, question string, projectID string) (*ChatResponse, error) {
    // 1. Embed the question
    embeddings, err := s.embedder.Embed(ctx, []string{question})
    if err != nil {
        return nil, err
    }

    // 2. Search for relevant code (cloud + local)
    results, err := s.pgvector.Search(ctx, embeddings[0], 10, map[string]string{"project_id": projectID})
    if err != nil {
        return nil, err
    }

    // 3. Build context from search results
    var contextParts []string
    for _, r := range results {
        contextParts = append(contextParts, fmt.Sprintf("File: %s\n%s", r.Metadata["path"], r.Metadata["content"]))
    }
    codeContext := strings.Join(contextParts, "\n---\n")

    // 4. Generate answer with augmented context
    return s.chat.Chat(ctx, ChatRequest{
        Model:     "claude-sonnet-4-5-20250929",
        MaxTokens: 4096,
        System:    "You are a code assistant. Answer questions using the provided code context.",
        Messages: []Message{
            {Role: "user", Content: []ContentPart{
                {Type: "text", Text: fmt.Sprintf("Code context:\n%s\n\nQuestion: %s", codeContext, question)},
            }},
        },
    })
}
```

## AI Chat Handler

```go
package handlers

import (
    "orchestra/app/services/ai"

    "github.com/gofiber/fiber/v3"
)

type AIHandler struct {
    chat  *ai.ChatService
    agent *ai.AgentService
    rag   *ai.RAGService
}

func (h *AIHandler) Chat(c fiber.Ctx) error {
    var req ai.ChatRequest
    if err := c.Bind().JSON(&req); err != nil {
        return c.Status(422).JSON(fiber.Map{"error": "validation_error", "message": err.Error()})
    }

    resp, err := h.chat.Send(c.Context(), req)
    if err != nil {
        return c.Status(500).JSON(fiber.Map{"error": "ai_error", "message": err.Error()})
    }

    return c.JSON(fiber.Map{"data": resp})
}

func (h *AIHandler) Stream(c fiber.Ctx) error {
    var req ai.ChatRequest
    if err := c.Bind().JSON(&req); err != nil {
        return c.Status(422).JSON(fiber.Map{"error": "validation_error", "message": err.Error()})
    }

    c.Set("Content-Type", "text/event-stream")
    c.Set("Cache-Control", "no-cache")
    c.Set("Connection", "keep-alive")

    events, err := h.chat.Stream(c.Context(), req)
    if err != nil {
        return c.Status(500).JSON(fiber.Map{"error": "ai_error", "message": err.Error()})
    }

    for event := range events {
        c.Write([]byte(fmt.Sprintf("data: %s\n\n", toJSON(event))))
        c.Context().Flush()
    }

    return nil
}

func (h *AIHandler) Agent(c fiber.Ctx) error {
    var req struct {
        Task      string `json:"task"`
        ProjectID string `json:"project_id"`
    }
    if err := c.Bind().JSON(&req); err != nil {
        return c.Status(422).JSON(fiber.Map{"error": "validation_error", "message": err.Error()})
    }

    result, err := h.agent.Execute(c.Context(), req.Task, req.ProjectID)
    if err != nil {
        return c.Status(500).JSON(fiber.Map{"error": "agent_error", "message": err.Error()})
    }

    return c.JSON(fiber.Map{"data": result})
}
```

## Conversation Model

```go
package models

import "gorm.io/datatypes"

type AIConversation struct {
    SyncModel
    UserID     uuid.UUID      `gorm:"type:uuid;not null;index" json:"user_id"`
    ProjectID  *uuid.UUID     `gorm:"type:uuid;index" json:"project_id,omitempty"`
    Title      string         `json:"title"`
    Model      string         `json:"model"`
    Messages   datatypes.JSON `gorm:"type:jsonb" json:"messages"`
    TokenCount int            `json:"token_count"`
    Cost       float64        `gorm:"type:decimal(10,6)" json:"cost"`

    User    User     `gorm:"foreignKey:UserID" json:"user,omitempty"`
    Project *Project `gorm:"foreignKey:ProjectID" json:"project,omitempty"`
}
```

## API Routes

```go
func RegisterAIRoutes(api fiber.Router, h *handlers.AIHandler) {
    ai := api.Group("/ai")
    ai.Post("/chat", h.Chat)              // Single response
    ai.Post("/chat/stream", h.Stream)     // SSE streaming
    ai.Post("/agent", h.Agent)            // Agent execution
    ai.Post("/embed", h.Embed)            // Generate embeddings
    ai.Post("/rag", h.RAG)                // RAG query
    ai.Get("/conversations", h.ListConversations)
    ai.Get("/conversations/:id", h.GetConversation)
    ai.Delete("/conversations/:id", h.DeleteConversation)
    ai.Get("/models", h.ListModels)       // Available models
}
```

## Conventions

- AI provider interface abstracts Anthropic/OpenAI — never call SDKs directly from handlers
- Default model: `claude-sonnet-4-5-20250929` (Anthropic), fallback to OpenAI if configured
- Stream AI responses via SSE (REST) or WebSocket (real-time chat)
- Embeddings: OpenAI `text-embedding-3-small` for cloud (pgvector), `chromem-go` for local
- RAG pipeline: Embed question → vector search → augment prompt → generate answer
- Agent orchestration via langchaingo with Orchestra-specific tools
- Token usage tracked per conversation for billing
- AI conversations stored with JSONB messages (append-only within conversation)
- Local vector store for offline AI features (desktop/mobile)
- All AI API calls require authentication and rate limiting

## Don'ts

- Don't call AI SDKs directly from handlers — always go through the Provider interface
- Don't store API keys in code — use environment variables and Secret Manager
- Don't skip token counting — it's needed for billing and usage limits
- Don't allow unbounded agent iterations — cap at `MaxIterations` (default 10)
- Don't embed entire files — chunk into ~500 token segments for better retrieval
- Don't expose raw AI errors to users — wrap with user-friendly messages
- Don't use synchronous AI calls for long operations — always stream or use background jobs

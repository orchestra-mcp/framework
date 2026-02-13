---
name: go-backend
description: Go backend patterns with Fiber v3 and GORM. Activates when writing Go handlers, models, services, middleware, routes, tests, or any backend server code.
---

# Go Backend — Fiber v3 + GORM

The Go backend is the central orchestrator handling REST API, WebSocket sync, job queue, auth, and coordination with the Rust engine via gRPC.

## Project Structure

```
cmd/
├── server/main.go          # HTTP server entry point
├── daemon/main.go          # Desktop tray daemon
├── desktop/main.go         # Wails desktop app
└── cli/main.go             # CLI tool (make:handler, migrate, etc.)

app/
├── handlers/               # HTTP request handlers (controllers)
│   ├── auth_handler.go
│   ├── user_handler.go
│   ├── project_handler.go
│   └── api/v1/             # Versioned API handlers
├── models/                 # GORM models
│   ├── base.go             # SyncModel base, common types
│   ├── user.go
│   ├── project.go
│   └── file.go
├── services/               # Business logic layer
│   ├── auth_service.go
│   ├── sync_service.go
│   └── engine_client.go    # gRPC client to Rust engine
├── middleware/              # Fiber middleware
│   ├── auth.go
│   ├── cors.go
│   ├── rate_limit.go
│   └── logger.go
├── routes/                 # Route registration
│   ├── web.go
│   ├── api.go
│   ├── ws.go               # WebSocket routes
│   └── admin.go
├── repositories/           # Data access layer
│   ├── user_repo.go
│   ├── project_repo.go
│   └── sync_repo.go
├── events/                 # Event definitions
├── listeners/              # Event listeners
├── jobs/                   # Background jobs
├── mail/                   # Email templates
├── policies/               # Authorization policies
├── requests/               # Request validation structs
├── resources/              # Response transformers
├── providers/              # Service providers (DI setup)
├── helpers/                # Utility functions
└── gen/proto/              # Generated protobuf Go code
```

## Handler Pattern

```go
package handlers

import (
    "orchestra/app/models"
    "orchestra/app/requests"
    "orchestra/app/resources"
    "orchestra/app/services"

    "github.com/gofiber/fiber/v3"
)

type ProjectHandler struct {
    projects *services.ProjectService
}

func NewProjectHandler(projects *services.ProjectService) *ProjectHandler {
    return &ProjectHandler{projects: projects}
}

func (h *ProjectHandler) Index(c fiber.Ctx) error {
    userID := c.Locals("user_id").(string)

    projects, err := h.projects.ListByUser(c.Context(), userID)
    if err != nil {
        return c.Status(500).JSON(fiber.Map{
            "error":   "internal_error",
            "message": "Failed to fetch projects",
        })
    }

    return c.JSON(fiber.Map{
        "data": resources.ProjectCollection(projects),
    })
}

func (h *ProjectHandler) Store(c fiber.Ctx) error {
    var req requests.CreateProjectRequest
    if err := c.Bind().JSON(&req); err != nil {
        return c.Status(422).JSON(fiber.Map{
            "error":   "validation_error",
            "message": "Invalid request body",
            "details": err.Error(),
        })
    }

    if errors := req.Validate(); len(errors) > 0 {
        return c.Status(422).JSON(fiber.Map{
            "error":   "validation_error",
            "details": errors,
        })
    }

    userID := c.Locals("user_id").(string)
    project, err := h.projects.Create(c.Context(), userID, req)
    if err != nil {
        return c.Status(500).JSON(fiber.Map{
            "error":   "internal_error",
            "message": "Failed to create project",
        })
    }

    return c.Status(201).JSON(fiber.Map{
        "data": resources.ProjectResource(project),
    })
}

func (h *ProjectHandler) Show(c fiber.Ctx) error {
    id := c.Params("id")
    project, err := h.projects.FindByID(c.Context(), id)
    if err != nil {
        return c.Status(404).JSON(fiber.Map{
            "error":   "not_found",
            "message": "Project not found",
        })
    }

    return c.JSON(fiber.Map{
        "data": resources.ProjectResource(project),
    })
}

func (h *ProjectHandler) Update(c fiber.Ctx) error {
    id := c.Params("id")
    var req requests.UpdateProjectRequest
    if err := c.Bind().JSON(&req); err != nil {
        return c.Status(422).JSON(fiber.Map{
            "error":   "validation_error",
            "message": "Invalid request body",
        })
    }

    project, err := h.projects.Update(c.Context(), id, req)
    if err != nil {
        return c.Status(500).JSON(fiber.Map{
            "error":   "internal_error",
            "message": "Failed to update project",
        })
    }

    return c.JSON(fiber.Map{
        "data": resources.ProjectResource(project),
    })
}

func (h *ProjectHandler) Delete(c fiber.Ctx) error {
    id := c.Params("id")
    if err := h.projects.Delete(c.Context(), id); err != nil {
        return c.Status(500).JSON(fiber.Map{
            "error":   "internal_error",
            "message": "Failed to delete project",
        })
    }

    return c.SendStatus(204)
}
```

## GORM Model Pattern

```go
package models

import (
    "time"

    "github.com/google/uuid"
    "gorm.io/datatypes"
    "gorm.io/gorm"
)

// Base model for all syncable entities
type SyncModel struct {
    ID        uuid.UUID      `gorm:"type:uuid;primaryKey;default:gen_random_uuid()" json:"id"`
    Version   int64          `gorm:"not null;default:0" json:"version"`
    CreatedAt time.Time      `json:"created_at"`
    UpdatedAt time.Time      `json:"updated_at"`
    DeletedAt gorm.DeletedAt `gorm:"index" json:"deleted_at,omitempty"`
}

type User struct {
    SyncModel
    Email           string         `gorm:"uniqueIndex;not null" json:"email"`
    Name            string         `gorm:"not null" json:"name"`
    PasswordHash    string         `gorm:"not null" json:"-"`
    AvatarURL       string         `json:"avatar_url,omitempty"`
    Plan            string         `gorm:"default:free" json:"plan"`
    Settings        datatypes.JSON `gorm:"type:jsonb;default:'{}'" json:"settings"`
    EmailVerifiedAt *time.Time     `json:"email_verified_at,omitempty"`

    // Relations
    Projects      []Project      `gorm:"foreignKey:UserID" json:"projects,omitempty"`
    Subscriptions []Subscription `gorm:"foreignKey:UserID" json:"subscriptions,omitempty"`
}

type Project struct {
    SyncModel
    UserID       uuid.UUID      `gorm:"type:uuid;not null;index" json:"user_id"`
    Name         string         `gorm:"not null" json:"name"`
    Path         string         `json:"path,omitempty"`
    Settings     datatypes.JSON `gorm:"type:jsonb;default:'{}'" json:"settings"`
    LastSyncedAt *time.Time     `json:"last_synced_at,omitempty"`

    // Relations
    User  User   `gorm:"foreignKey:UserID" json:"user,omitempty"`
    Files []File `gorm:"foreignKey:ProjectID" json:"files,omitempty"`
}
```

## Service Pattern

```go
package services

import (
    "context"

    "orchestra/app/models"
    "orchestra/app/repositories"
    "orchestra/app/requests"
)

type ProjectService struct {
    repo   *repositories.ProjectRepo
    sync   *SyncService
}

func NewProjectService(repo *repositories.ProjectRepo, sync *SyncService) *ProjectService {
    return &ProjectService{repo: repo, sync: sync}
}

func (s *ProjectService) Create(ctx context.Context, userID string, req requests.CreateProjectRequest) (*models.Project, error) {
    project := &models.Project{
        UserID: uuid.MustParse(userID),
        Name:   req.Name,
        Path:   req.Path,
    }

    if err := s.repo.Create(ctx, project); err != nil {
        return nil, err
    }

    // Log to sync system
    s.sync.LogChange(ctx, userID, "projects", project.ID.String(), "create", project)

    return project, nil
}
```

## Repository Pattern

```go
package repositories

import (
    "context"

    "orchestra/app/models"
    "gorm.io/gorm"
)

type ProjectRepo struct {
    db *gorm.DB
}

func NewProjectRepo(db *gorm.DB) *ProjectRepo {
    return &ProjectRepo{db: db}
}

func (r *ProjectRepo) FindByID(ctx context.Context, id string) (*models.Project, error) {
    var project models.Project
    err := r.db.WithContext(ctx).First(&project, "id = ?", id).Error
    return &project, err
}

func (r *ProjectRepo) ListByUser(ctx context.Context, userID string) ([]models.Project, error) {
    var projects []models.Project
    err := r.db.WithContext(ctx).Where("user_id = ?", userID).Find(&projects).Error
    return projects, err
}

func (r *ProjectRepo) Create(ctx context.Context, project *models.Project) error {
    return r.db.WithContext(ctx).Create(project).Error
}

func (r *ProjectRepo) Update(ctx context.Context, project *models.Project) error {
    return r.db.WithContext(ctx).Save(project).Error
}

func (r *ProjectRepo) Delete(ctx context.Context, id string) error {
    return r.db.WithContext(ctx).Delete(&models.Project{}, "id = ?", id).Error
}
```

## Route Registration

```go
package routes

import (
    "orchestra/app/handlers"
    "orchestra/app/middleware"

    "github.com/gofiber/fiber/v3"
)

func RegisterAPI(app *fiber.App, h *handlers.Handlers) {
    api := app.Group("/api/v1", middleware.Auth())

    // Projects
    projects := api.Group("/projects")
    projects.Get("/", h.Project.Index)
    projects.Post("/", h.Project.Store)
    projects.Get("/:id", h.Project.Show)
    projects.Put("/:id", h.Project.Update)
    projects.Delete("/:id", h.Project.Delete)

    // Users
    users := api.Group("/users")
    users.Get("/me", h.User.Me)
    users.Put("/me", h.User.UpdateMe)

    // Sync
    sync := api.Group("/sync")
    sync.Post("/push", h.Sync.Push)
    sync.Post("/pull", h.Sync.Pull)
}

func RegisterWS(app *fiber.App, h *handlers.Handlers) {
    app.Get("/ws", middleware.WSAuth(), h.Sync.WebSocket)
}

func RegisterPublic(app *fiber.App, h *handlers.Handlers) {
    app.Get("/health", h.Health.Check)
    app.Post("/auth/login", h.Auth.Login)
    app.Post("/auth/register", h.Auth.Register)
    app.Post("/auth/refresh", h.Auth.Refresh)
}
```

## Request Validation

```go
package requests

type CreateProjectRequest struct {
    Name string `json:"name"`
    Path string `json:"path"`
}

func (r CreateProjectRequest) Validate() map[string]string {
    errors := make(map[string]string)
    if r.Name == "" {
        errors["name"] = "Name is required"
    }
    if len(r.Name) > 255 {
        errors["name"] = "Name must be 255 characters or less"
    }
    return errors
}
```

## Response Resources

```go
package resources

import "orchestra/app/models"

type ProjectResponse struct {
    ID        string `json:"id"`
    Name      string `json:"name"`
    Path      string `json:"path,omitempty"`
    CreatedAt string `json:"created_at"`
    UpdatedAt string `json:"updated_at"`
}

func ProjectResource(p *models.Project) ProjectResponse {
    return ProjectResponse{
        ID:        p.ID.String(),
        Name:      p.Name,
        Path:      p.Path,
        CreatedAt: p.CreatedAt.Format("2006-01-02T15:04:05Z"),
        UpdatedAt: p.UpdatedAt.Format("2006-01-02T15:04:05Z"),
    }
}

func ProjectCollection(projects []models.Project) []ProjectResponse {
    result := make([]ProjectResponse, len(projects))
    for i, p := range projects {
        result[i] = ProjectResource(&p)
    }
    return result
}
```

## Middleware Pattern

```go
package middleware

import (
    "strings"

    "orchestra/app/services"

    "github.com/gofiber/fiber/v3"
)

func Auth() fiber.Handler {
    return func(c fiber.Ctx) error {
        auth := c.Get("Authorization")
        if auth == "" || !strings.HasPrefix(auth, "Bearer ") {
            return c.Status(401).JSON(fiber.Map{
                "error":   "unauthorized",
                "message": "Missing or invalid authorization header",
            })
        }

        token := strings.TrimPrefix(auth, "Bearer ")
        claims, err := services.ValidateJWT(token)
        if err != nil {
            return c.Status(401).JSON(fiber.Map{
                "error":   "unauthorized",
                "message": "Invalid or expired token",
            })
        }

        c.Locals("user_id", claims.UserID)
        c.Locals("user_email", claims.Email)
        return c.Next()
    }
}
```

## Testing Pattern

```go
package handlers_test

import (
    "bytes"
    "encoding/json"
    "net/http/httptest"
    "testing"

    "orchestra/app/handlers"
    "orchestra/app/models"

    "github.com/gofiber/fiber/v3"
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/require"
)

func TestProjectHandler_Index(t *testing.T) {
    app := fiber.New()
    handler := setupTestProjectHandler(t)
    app.Get("/api/v1/projects", handler.Index)

    req := httptest.NewRequest("GET", "/api/v1/projects", nil)
    req.Header.Set("Authorization", "Bearer test-token")

    resp, err := app.Test(req)
    require.NoError(t, err)
    assert.Equal(t, 200, resp.StatusCode)
}

func TestProjectHandler_Store(t *testing.T) {
    app := fiber.New()
    handler := setupTestProjectHandler(t)
    app.Post("/api/v1/projects", handler.Store)

    body, _ := json.Marshal(map[string]string{
        "name": "My Project",
        "path": "/home/user/project",
    })
    req := httptest.NewRequest("POST", "/api/v1/projects", bytes.NewReader(body))
    req.Header.Set("Content-Type", "application/json")
    req.Header.Set("Authorization", "Bearer test-token")

    resp, err := app.Test(req)
    require.NoError(t, err)
    assert.Equal(t, 201, resp.StatusCode)
}
```

## Error Response Format

All API errors follow this structure:
```json
{
    "error": "error_code",
    "message": "Human-readable description",
    "details": {}
}
```

Error codes: `validation_error`, `unauthorized`, `forbidden`, `not_found`, `conflict`, `rate_limited`, `internal_error`.

## Conventions

- Handler methods: `Index`, `Show`, `Store`, `Update`, `Delete` (Laravel-style)
- Services: business logic, orchestration, transactions
- Repositories: pure data access, no business logic
- Use `fiber.Map{}` for JSON responses
- Always pass `context.Context` through the call chain
- Use `uuid.UUID` for all entity IDs
- Use interfaces for services to enable testing
- Error wrapping with `fmt.Errorf("operation: %w", err)`

## Job Queue (asynq)

```go
// app/jobs/processor.go
package jobs

import (
    "context"
    "encoding/json"

    "github.com/hibiken/asynq"
)

const (
    TypeEmailWelcome   = "email:welcome"
    TypeSyncBroadcast  = "sync:broadcast"
    TypeIndexFile      = "index:file"
    TypeBillingInvoice = "billing:invoice"
)

func NewEmailWelcomeTask(userID string) (*asynq.Task, error) {
    payload, _ := json.Marshal(map[string]string{"user_id": userID})
    return asynq.NewTask(TypeEmailWelcome, payload, asynq.MaxRetry(3), asynq.Queue("default")), nil
}

func HandleEmailWelcome(ctx context.Context, t *asynq.Task) error {
    var payload struct {
        UserID string `json:"user_id"`
    }
    json.Unmarshal(t.Payload(), &payload)
    return mailService.SendWelcome(ctx, payload.UserID)
}

// cmd/server/main.go — start worker alongside server
func startWorker(redisAddr string) {
    srv := asynq.NewServer(
        asynq.RedisClientOpt{Addr: redisAddr},
        asynq.Config{
            Concurrency: 10,
            Queues: map[string]int{"critical": 6, "default": 3, "low": 1},
        },
    )
    mux := asynq.NewServeMux()
    mux.HandleFunc(TypeEmailWelcome, HandleEmailWelcome)
    mux.HandleFunc(TypeSyncBroadcast, HandleSyncBroadcast)
    srv.Run(mux)
}
```

## Task Scheduler (gocron)

```go
// app/scheduler/scheduler.go
package scheduler

import (
    "time"
    "github.com/go-co-op/gocron/v2"
)

func Start(services *Services) (gocron.Scheduler, error) {
    s, err := gocron.NewScheduler()
    if err != nil {
        return nil, err
    }
    s.NewJob(gocron.DurationJob(1*time.Hour), gocron.NewTask(services.Auth.CleanupSessions))
    s.NewJob(gocron.DurationJob(6*time.Hour), gocron.NewTask(services.Extensions.CheckUpdates))
    s.NewJob(gocron.CronJob("0 0 * * *", false), gocron.NewTask(services.Analytics.AggregateDailyStats))
    s.Start()
    return s, nil
}
```

## Email (go-mail)

```go
// app/mail/mailer.go
package mail

import "github.com/wneessen/go-mail"

type Mailer struct {
    client *mail.Client
    from   string
}

func NewMailer(host string, port int, user, pass, from string) (*Mailer, error) {
    client, err := mail.NewClient(host,
        mail.WithPort(port),
        mail.WithSMTPAuth(mail.SMTPAuthPlain),
        mail.WithUsername(user),
        mail.WithPassword(pass),
        mail.WithTLSPolicy(mail.TLSMandatory),
    )
    if err != nil {
        return nil, err
    }
    return &Mailer{client: client, from: from}, nil
}

func (m *Mailer) Send(to, subject, htmlBody string) error {
    msg := mail.NewMsg()
    msg.From(m.from)
    msg.To(to)
    msg.Subject(subject)
    msg.SetBodyString(mail.TypeTextHTML, htmlBody)
    return m.client.DialAndSend(msg)
}
```

## Billing (stripe-go)

```go
// app/services/billing.go
package services

import (
    "github.com/stripe/stripe-go/v80"
    "github.com/stripe/stripe-go/v80/checkout/session"
    "github.com/stripe/stripe-go/v80/webhook"
)

type BillingService struct {
    repo *repositories.SubscriptionRepo
}

func (s *BillingService) CreateCheckout(userID, priceID string) (*stripe.CheckoutSession, error) {
    return session.New(&stripe.CheckoutSessionParams{
        Mode: stripe.String(string(stripe.CheckoutSessionModeSubscription)),
        LineItems: []*stripe.CheckoutSessionLineItemParams{
            {Price: stripe.String(priceID), Quantity: stripe.Int64(1)},
        },
        SuccessURL:        stripe.String("https://orchestra.dev/billing/success"),
        CancelURL:         stripe.String("https://orchestra.dev/billing/cancel"),
        ClientReferenceID: stripe.String(userID),
    })
}

func (s *BillingService) HandleWebhook(payload []byte, sig string) error {
    event, err := webhook.ConstructEvent(payload, sig, os.Getenv("STRIPE_WEBHOOK_SECRET"))
    if err != nil {
        return err
    }
    switch event.Type {
    case "checkout.session.completed":
        return s.handleCheckoutComplete(event)
    case "customer.subscription.updated":
        return s.handleSubscriptionUpdate(event)
    case "customer.subscription.deleted":
        return s.handleSubscriptionCancel(event)
    case "invoice.payment_failed":
        return s.handlePaymentFailed(event)
    }
    return nil
}
```

## Logging (zerolog)

```go
import "github.com/rs/zerolog/log"

// In handlers
log.Info().Str("user_id", userID).Str("project", name).Msg("project created")
// In services
log.Error().Err(err).Str("service", "sync").Msg("failed to broadcast")
// Structured context
logger := log.With().Str("request_id", reqID).Logger()
logger.Info().Msg("processing")
```

## Request Validation (go-playground/validator)

```go
package requests

import "github.com/go-playground/validator/v10"

var validate = validator.New()

type CreateProjectRequest struct {
    Name string `json:"name" validate:"required,min=1,max=255"`
    Path string `json:"path" validate:"omitempty,max=1024"`
}

func (r *CreateProjectRequest) Validate() map[string]string {
    errors := make(map[string]string)
    if err := validate.Struct(r); err != nil {
        for _, e := range err.(validator.ValidationErrors) {
            errors[e.Field()] = formatValidationError(e)
        }
    }
    return errors
}
```

## Don'ts

- Don't put business logic in handlers — delegate to services
- Don't use `gorm.DB` directly in handlers — use repositories
- Don't skip validation — always validate in request structs
- Don't return raw GORM errors to clients — wrap them
- Don't use global variables — use dependency injection
- Don't process long-running tasks in handlers — use asynq job queue
- Don't log with `fmt.Println` — use zerolog for structured logging
- Don't hardcode Stripe price IDs — store in config or database
- Don't skip webhook signature verification for Stripe events

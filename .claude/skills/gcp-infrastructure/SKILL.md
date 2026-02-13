---
name: gcp-infrastructure
description: GCP infrastructure, CI/CD, Docker, monitoring, and deployment. Activates when working with Cloud Run, Cloud SQL, Memorystore, CDN, Cloud Build, Artifact Registry, Secret Manager, Pub/Sub, Docker, nginx, Sentry, PostHog, or any deployment/infrastructure task.
---

# GCP Infrastructure — Deploy, CI/CD, Monitoring

Orchestra runs on Google Cloud Platform with Docker containers, managed databases, and CDN-hosted frontends.

## Architecture

```
                    Internet
                       │
                ┌──────▼──────┐
                │  Cloud CDN  │ ← Static frontend assets (React builds)
                │  (GCS bucket)│
                └──────┬──────┘
                       │
                ┌──────▼──────┐
                │   nginx     │ ← Reverse proxy, SSL termination (Certbot)
                │  (Cloud Run)│
                └──────┬──────┘
                       │
           ┌───────────┼────────────┐
           │           │            │
    ┌──────▼──────┐ ┌──▼───────┐ ┌─▼──────────┐
    │  Go Backend │ │  Rust    │ │  Worker     │
    │  (Cloud Run)│ │  Engine  │ │  (asynq)    │
    │  Fiber v3   │ │(Cloud Run│ │  (Cloud Run)│
    └──────┬──────┘ └──┬───────┘ └──────┬──────┘
           │           │                │
    ┌──────▼──────┐ ┌──▼───────┐ ┌─────▼──────┐
    │ Cloud SQL   │ │ (local   │ │ Memorystore│
    │ PostgreSQL  │ │  SQLite) │ │ Redis      │
    └─────────────┘ └──────────┘ └────────────┘
           │
    ┌──────▼──────┐    ┌──────────────┐
    │  Cloud      │    │  Secret      │
    │  Storage    │    │  Manager     │
    │  (GCS)      │    │  (keys/creds)│
    └─────────────┘    └──────────────┘
```

## Docker Setup

### docker-compose.yml (Local Development)

```yaml
version: '3.8'

services:
  postgres:
    image: pgvector/pgvector:pg16
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: orchestra
      POSTGRES_USER: orchestra
      POSTGRES_PASSWORD: orchestra
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U orchestra"]
      interval: 5s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redisdata:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  pgdata:
  redisdata:
```

### Dockerfile — Go Backend

```dockerfile
# Build stage
FROM golang:1.23-alpine AS builder
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o server ./cmd/server

# Runtime stage
FROM alpine:3.20
RUN apk --no-cache add ca-certificates tzdata
WORKDIR /app

COPY --from=builder /app/server .
COPY --from=builder /app/database/migrations ./database/migrations

EXPOSE 3000
CMD ["./server"]
```

### Dockerfile — Rust Engine

```dockerfile
# Build stage
FROM rust:1.80-alpine AS builder
RUN apk add --no-cache musl-dev protobuf-dev
WORKDIR /app

COPY engine/Cargo.toml engine/Cargo.lock ./
COPY engine/build.rs ./
COPY proto/ ../proto/

# Cache dependencies
RUN mkdir src && echo "fn main(){}" > src/main.rs && cargo build --release && rm -rf src

COPY engine/src/ ./src/
RUN cargo build --release

# Runtime stage
FROM alpine:3.20
RUN apk --no-cache add ca-certificates
WORKDIR /app

COPY --from=builder /app/target/release/orchestra-engine .

EXPOSE 50051
CMD ["./orchestra-engine"]
```

## GCP Cloud Run Deployment

```yaml
# deploy/cloud-run/server.yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: orchestra-server
spec:
  template:
    metadata:
      annotations:
        autoscaling.knative.dev/minScale: "1"
        autoscaling.knative.dev/maxScale: "10"
        run.googleapis.com/cloudsql-instances: PROJECT:REGION:orchestra-db
    spec:
      containerConcurrency: 250
      timeoutSeconds: 300
      containers:
        - image: REGION-docker.pkg.dev/PROJECT/orchestra/server:latest
          ports:
            - containerPort: 3000
          resources:
            limits:
              memory: 512Mi
              cpu: "1"
          env:
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: database-url
                  key: latest
            - name: REDIS_URL
              valueFrom:
                secretKeyRef:
                  name: redis-url
                  key: latest
            - name: JWT_SECRET
              valueFrom:
                secretKeyRef:
                  name: jwt-secret
                  key: latest
          startupProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 5
            periodSeconds: 5
```

## CI/CD — Cloud Build

```yaml
# deploy/cloudbuild.yaml
steps:
  # Run Go tests
  - name: 'golang:1.23'
    entrypoint: 'bash'
    args:
      - '-c'
      - |
        go test ./... -v -race -coverprofile=coverage.out
    dir: '.'

  # Run Rust tests
  - name: 'rust:1.80'
    entrypoint: 'bash'
    args:
      - '-c'
      - |
        cd engine && cargo test --release
    dir: '.'

  # Run frontend tests
  - name: 'node:20-alpine'
    entrypoint: 'bash'
    args:
      - '-c'
      - |
        cd resources && pnpm install --frozen-lockfile && pnpm test
    dir: '.'

  # Lint
  - name: 'golangci/golangci-lint:v1.61'
    args: ['run', '--timeout', '5m']
    dir: '.'

  # Build Go server image
  - name: 'gcr.io/cloud-builders/docker'
    args:
      - 'build'
      - '-t'
      - '${_REGION}-docker.pkg.dev/${PROJECT_ID}/orchestra/server:${SHORT_SHA}'
      - '-f'
      - 'deploy/docker/Dockerfile.server'
      - '.'

  # Build Rust engine image
  - name: 'gcr.io/cloud-builders/docker'
    args:
      - 'build'
      - '-t'
      - '${_REGION}-docker.pkg.dev/${PROJECT_ID}/orchestra/engine:${SHORT_SHA}'
      - '-f'
      - 'deploy/docker/Dockerfile.engine'
      - '.'

  # Push images to Artifact Registry
  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', '${_REGION}-docker.pkg.dev/${PROJECT_ID}/orchestra/server:${SHORT_SHA}']
  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', '${_REGION}-docker.pkg.dev/${PROJECT_ID}/orchestra/engine:${SHORT_SHA}']

  # Run database migrations
  - name: '${_REGION}-docker.pkg.dev/${PROJECT_ID}/orchestra/server:${SHORT_SHA}'
    args: ['./server', 'migrate']
    env:
      - 'DATABASE_URL=${_DATABASE_URL}'

  # Deploy to Cloud Run
  - name: 'gcr.io/cloud-builders/gcloud'
    args:
      - 'run'
      - 'deploy'
      - 'orchestra-server'
      - '--image=${_REGION}-docker.pkg.dev/${PROJECT_ID}/orchestra/server:${SHORT_SHA}'
      - '--region=${_REGION}'
      - '--platform=managed'

  # Build and deploy frontend to Cloud CDN
  - name: 'node:20-alpine'
    entrypoint: 'bash'
    args:
      - '-c'
      - |
        cd resources && pnpm install --frozen-lockfile && pnpm build
        gsutil -m rsync -r dashboard/dist gs://${_FRONTEND_BUCKET}/dashboard
    dir: '.'

substitutions:
  _REGION: us-central1
  _FRONTEND_BUCKET: orchestra-frontend

options:
  logging: CLOUD_LOGGING_ONLY
  machineType: E2_HIGHCPU_8
```

## Makefile Commands

```makefile
# Deploy commands (add to root Makefile)
deploy:
	gcloud builds submit --config=deploy/cloudbuild.yaml

deploy-server:
	gcloud run deploy orchestra-server \
		--source=. \
		--region=$(GCP_REGION) \
		--allow-unauthenticated

deploy-engine:
	gcloud run deploy orchestra-engine \
		--source=engine/ \
		--region=$(GCP_REGION)

deploy-frontend:
	cd resources && pnpm build
	gsutil -m rsync -r resources/dashboard/dist gs://$(FRONTEND_BUCKET)/dashboard
	gcloud compute url-maps invalidate-cdn-cache $(URL_MAP) --path="/*"

# Secret management
secret-set:
	echo -n "$(VALUE)" | gcloud secrets create $(NAME) --data-file=-

secret-get:
	gcloud secrets versions access latest --secret=$(NAME)

# Database
db-proxy:
	cloud-sql-proxy $(GCP_PROJECT):$(GCP_REGION):orchestra-db --port=5432

# Logs
logs-server:
	gcloud logging read 'resource.type="cloud_run_revision" resource.labels.service_name="orchestra-server"' --limit=100 --format=json

logs-engine:
	gcloud logging read 'resource.type="cloud_run_revision" resource.labels.service_name="orchestra-engine"' --limit=100 --format=json
```

## Nginx Configuration

```nginx
# deploy/nginx/nginx.conf
upstream go_backend {
    server localhost:3000;
}

upstream rust_engine {
    server localhost:50051;
}

server {
    listen 80;
    server_name api.orchestra.dev;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.orchestra.dev;

    ssl_certificate /etc/letsencrypt/live/api.orchestra.dev/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.orchestra.dev/privkey.pem;

    # API routes
    location /api/ {
        proxy_pass http://go_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # WebSocket
    location /ws {
        proxy_pass http://go_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 86400;
    }

    # Health
    location /health {
        proxy_pass http://go_backend;
    }
}
```

## Monitoring — Sentry (Error Tracking)

```go
// config/sentry.go
package config

import (
    "github.com/getsentry/sentry-go"
    sentryfiber "github.com/getsentry/sentry-go/fiber"
)

func InitSentry(dsn string) error {
    return sentry.Init(sentry.ClientOptions{
        Dsn:              dsn,
        Environment:      os.Getenv("APP_ENV"),
        Release:          os.Getenv("APP_VERSION"),
        TracesSampleRate: 0.1, // 10% of transactions
        EnableTracing:    true,
    })
}

// Fiber middleware
func SentryMiddleware() fiber.Handler {
    return sentryfiber.New(sentryfiber.Options{
        Repanic: true,
    })
}
```

## Analytics — PostHog

```go
// config/posthog.go
package config

import "github.com/posthog/posthog-go"

var analytics posthog.Client

func InitPostHog(apiKey string) error {
    client, err := posthog.NewWithConfig(apiKey, posthog.Config{
        Endpoint: "https://app.posthog.com",
    })
    if err != nil {
        return err
    }
    analytics = client
    return nil
}

func TrackEvent(userID, event string, properties map[string]interface{}) {
    analytics.Enqueue(posthog.Capture{
        DistinctId: userID,
        Event:      event,
        Properties: posthog.NewProperties().Set("$lib", "orchestra-go").
            Set("platform", properties["platform"]),
    })
}
```

## Monitoring — Zerolog + Cloud Logging

```go
// config/logger.go
package config

import (
    "os"

    "github.com/rs/zerolog"
    "github.com/rs/zerolog/log"
)

func InitLogger(env string) {
    zerolog.TimeFieldFormat = zerolog.TimeFormatUnix

    if env == "development" {
        log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})
    } else {
        // JSON output for Cloud Logging structured logs
        log.Logger = zerolog.New(os.Stdout).With().Timestamp().
            Str("service", "orchestra-server").
            Logger()
    }
}

// Usage in handlers/services:
// log.Info().Str("user_id", uid).Msg("project created")
// log.Error().Err(err).Str("handler", "project.store").Msg("failed to create")
```

## GCP Secret Manager

```go
// config/secrets.go
package config

import (
    "context"
    "fmt"

    secretmanager "cloud.google.com/go/secretmanager/apiv1"
    smpb "cloud.google.com/go/secretmanager/apiv1/secretmanagerpb"
)

type SecretManager struct {
    client    *secretmanager.Client
    projectID string
}

func NewSecretManager(ctx context.Context, projectID string) (*SecretManager, error) {
    client, err := secretmanager.NewClient(ctx)
    if err != nil {
        return nil, err
    }
    return &SecretManager{client: client, projectID: projectID}, nil
}

func (s *SecretManager) Get(ctx context.Context, name string) (string, error) {
    result, err := s.client.AccessSecretVersion(ctx, &smpb.AccessSecretVersionRequest{
        Name: fmt.Sprintf("projects/%s/secrets/%s/versions/latest", s.projectID, name),
    })
    if err != nil {
        return "", err
    }
    return string(result.Payload.Data), nil
}
```

## GCP Cloud Storage (gocloud.dev/blob)

```go
// app/services/storage.go
package services

import (
    "context"
    "io"

    "gocloud.dev/blob"
    _ "gocloud.dev/blob/gcsblob"
)

type StorageService struct {
    bucket *blob.Bucket
}

func NewStorageService(ctx context.Context, bucketURL string) (*StorageService, error) {
    bucket, err := blob.OpenBucket(ctx, bucketURL)
    if err != nil {
        return nil, err
    }
    return &StorageService{bucket: bucket}, nil
}

func (s *StorageService) Upload(ctx context.Context, key string, data io.Reader, contentType string) error {
    w, err := s.bucket.NewWriter(ctx, key, &blob.WriterOptions{ContentType: contentType})
    if err != nil {
        return err
    }
    if _, err := io.Copy(w, data); err != nil {
        w.Close()
        return err
    }
    return w.Close()
}

func (s *StorageService) Download(ctx context.Context, key string) (io.ReadCloser, error) {
    return s.bucket.NewReader(ctx, key, nil)
}

func (s *StorageService) Delete(ctx context.Context, key string) error {
    return s.bucket.Delete(ctx, key)
}

func (s *StorageService) SignedURL(ctx context.Context, key string, expiry time.Duration) (string, error) {
    return s.bucket.SignedURL(ctx, key, &blob.SignedURLOptions{Expiry: expiry})
}
```

## Environment Configuration

```bash
# .env (local development)
APP_ENV=development
APP_PORT=3000
APP_URL=http://localhost:3000

# Database
DATABASE_URL=postgres://orchestra:orchestra@localhost:5432/orchestra?sslmode=disable
REDIS_URL=redis://localhost:6379

# Auth
JWT_SECRET=your-dev-secret
JWT_EXPIRY=24h

# AI
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...

# GCP (production)
GCP_PROJECT=orchestra-prod
GCP_REGION=us-central1
GCS_BUCKET=gs://orchestra-storage

# Monitoring
SENTRY_DSN=https://...@sentry.io/...
POSTHOG_API_KEY=phc_...

# Stripe
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
```

## Conventions

- Local dev uses docker-compose for PostgreSQL + Redis only — Go and Rust run natively for fast iteration
- Production: Cloud Run for compute, Cloud SQL for PostgreSQL, Memorystore for Redis
- All secrets in GCP Secret Manager (never in .env for production)
- Frontend deployed to GCS bucket with Cloud CDN in front
- Docker images stored in Artifact Registry, tagged with git SHA
- Zerolog for structured JSON logging (parsed by Cloud Logging)
- Sentry for error tracking with 10% trace sampling
- PostHog for product analytics (user actions, feature usage)
- gocloud.dev/blob abstracts cloud storage (GCS in prod, filesystem in dev)
- nginx handles SSL termination, WebSocket upgrade, and reverse proxy

## Don'ts

- Don't expose database ports in production — use Cloud SQL proxy or private VPC
- Don't store secrets in environment variables for production — use Secret Manager
- Don't skip health checks in Cloud Run config — needed for zero-downtime deploys
- Don't deploy without running tests first — CI/CD pipeline enforces this
- Don't log sensitive data (passwords, tokens, API keys) — even in development
- Don't use `latest` Docker tag in production — always use git SHA tags
- Don't skip Sentry in production — untracked errors are invisible errors

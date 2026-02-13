---
name: extension-marketplace
description: Extension marketplace and publishing system. Activates when building the extension store, publishing extensions, managing reviews/ratings, handling extension updates, versioning, or the extension CLI.
---

# Extension Marketplace — Publishing & Distribution

Orchestra's extension marketplace allows developers to publish, discover, and install extensions (native, Raycast-compat, and VS Code-compat).

## Architecture

```
Developer                        User
   │                               │
   └── orchestra ext publish       └── orchestra ext install my-ext
         │                               │
         ▼                               ▼
   ┌──────────────────────────────────────────┐
   │          Extension Registry API           │
   │         (Go backend endpoints)            │
   ├──────────────────────────────────────────┤
   │  PostgreSQL: extensions, versions,        │
   │              reviews, downloads           │
   │  GCP Storage: extension packages (.tar.gz)│
   └──────────────────────────────────────────┘
```

## Database Schema

```sql
-- Extension registry tables
CREATE TABLE extensions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,       -- e.g., "git-lens"
    display_name VARCHAR(255) NOT NULL,
    description TEXT,
    author_id UUID NOT NULL REFERENCES users(id),
    repository_url TEXT,
    homepage_url TEXT,
    icon_url TEXT,
    license VARCHAR(50),
    compat VARCHAR(20) DEFAULT 'native',     -- native, raycast, vscode
    categories TEXT[] DEFAULT '{}',           -- ['productivity', 'languages']
    tags TEXT[] DEFAULT '{}',
    download_count INT DEFAULT 0,
    rating_average DECIMAL(3,2) DEFAULT 0,
    rating_count INT DEFAULT 0,
    featured BOOLEAN DEFAULT FALSE,
    verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);
CREATE INDEX idx_extensions_name ON extensions(name);
CREATE INDEX idx_extensions_compat ON extensions(compat);
CREATE INDEX idx_extensions_categories ON extensions USING gin(categories);
CREATE INDEX idx_extensions_featured ON extensions(featured) WHERE featured = true;

CREATE TABLE extension_versions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    extension_id UUID NOT NULL REFERENCES extensions(id) ON DELETE CASCADE,
    version VARCHAR(50) NOT NULL,            -- semver: "1.2.3"
    changelog TEXT,
    package_url TEXT NOT NULL,               -- GCS path to .tar.gz
    package_hash VARCHAR(64) NOT NULL,       -- SHA-256 of package
    package_size BIGINT NOT NULL,
    min_orchestra_version VARCHAR(50),       -- ">=0.1.0"
    permissions TEXT[] DEFAULT '{}',
    manifest JSONB NOT NULL,                 -- Full package.json
    published_at TIMESTAMPTZ DEFAULT NOW(),
    yanked BOOLEAN DEFAULT FALSE
);
CREATE UNIQUE INDEX idx_ext_version ON extension_versions(extension_id, version);

CREATE TABLE extension_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    extension_id UUID NOT NULL REFERENCES extensions(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id),
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title VARCHAR(255),
    body TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE UNIQUE INDEX idx_review_user_ext ON extension_reviews(extension_id, user_id);

CREATE TABLE extension_installs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    extension_id UUID NOT NULL REFERENCES extensions(id),
    user_id UUID NOT NULL REFERENCES users(id),
    version VARCHAR(50) NOT NULL,
    installed_at TIMESTAMPTZ DEFAULT NOW(),
    uninstalled_at TIMESTAMPTZ
);
```

## API Endpoints

```go
// app/routes/api.go — extension marketplace routes
func RegisterExtensionRoutes(api fiber.Router, h *handlers.ExtensionHandler) {
    ext := api.Group("/extensions")

    // Public (browsing)
    ext.Get("/", h.Search)                    // Search/list extensions
    ext.Get("/featured", h.Featured)          // Featured extensions
    ext.Get("/categories", h.Categories)      // List categories
    ext.Get("/:name", h.Show)                 // Extension details
    ext.Get("/:name/versions", h.Versions)    // Version history
    ext.Get("/:name/reviews", h.Reviews)      // User reviews

    // Authenticated
    ext.Post("/:name/install", h.Install)     // Install extension
    ext.Delete("/:name/uninstall", h.Uninstall) // Uninstall
    ext.Post("/:name/reviews", h.CreateReview)  // Submit review

    // Publisher (extension owner)
    ext.Post("/", h.Publish)                  // Publish new extension
    ext.Post("/:name/versions", h.PublishVersion) // Publish new version
    ext.Delete("/:name/versions/:version", h.YankVersion) // Yank a version
}
```

## Extension CLI

```bash
# Initialize new extension
orchestra ext init my-extension
orchestra ext init my-extension --template raycast
orchestra ext init my-extension --template vscode-lsp

# Develop locally
orchestra ext dev                    # Start extension in dev mode
orchestra ext dev --watch            # With hot reload

# Package
orchestra ext pack                   # Creates my-extension-1.0.0.tar.gz

# Publish
orchestra ext login                  # Authenticate with marketplace
orchestra ext publish                # Publish to marketplace
orchestra ext publish --pre-release  # Publish as pre-release

# Manage
orchestra ext versions               # List published versions
orchestra ext yank 1.0.0             # Yank a version

# Install (user)
orchestra ext install git-lens       # Install from marketplace
orchestra ext install ./my-ext.tar.gz # Install from local file
orchestra ext update                 # Update all extensions
orchestra ext list                   # List installed extensions
orchestra ext uninstall git-lens     # Uninstall
```

## Extension Package Format

```
my-extension-1.0.0.tar.gz
├── package.json          # Manifest
├── dist/                 # Compiled JavaScript
│   ├── index.js
│   └── index.js.map
├── assets/               # Static assets
│   ├── icon.png
│   └── logo.svg
├── themes/               # Theme files (if any)
├── snippets/             # Snippet files (if any)
├── syntaxes/             # TextMate grammars (if any)
├── README.md             # Extension docs (shown in marketplace)
├── CHANGELOG.md          # Version history
└── LICENSE
```

## Publishing Flow

```
1. Developer runs `orchestra ext publish`
2. CLI reads package.json, validates manifest
3. CLI creates .tar.gz of dist/ + assets/ + metadata
4. CLI computes SHA-256 hash of package
5. CLI uploads to POST /api/v1/extensions (if new) or POST /api/v1/extensions/:name/versions
6. Backend validates:
   - Version doesn't exist
   - Manifest is valid
   - Package hash matches
   - Permissions are declared
7. Backend stores package in GCS
8. Backend creates extension_versions record
9. Backend triggers review for first-time publishers (if verified badge desired)
```

## Search & Discovery

```go
// app/handlers/extension_handler.go
func (h *ExtensionHandler) Search(c fiber.Ctx) error {
    query := c.Query("q")
    category := c.Query("category")
    compat := c.Query("compat")        // native, raycast, vscode
    sort := c.Query("sort", "popular") // popular, recent, rating, name
    page := c.QueryInt("page", 1)
    perPage := c.QueryInt("per_page", 20)

    results, total, err := h.extensions.Search(c.Context(), SearchParams{
        Query:    query,
        Category: category,
        Compat:   compat,
        Sort:     sort,
        Page:     page,
        PerPage:  perPage,
    })

    return c.JSON(fiber.Map{
        "data": resources.ExtensionCollection(results),
        "meta": fiber.Map{
            "total":     total,
            "page":      page,
            "per_page":  perPage,
            "last_page": (total + perPage - 1) / perPage,
        },
    })
}
```

## Extension Categories

```
Languages          # Language support (LSP, grammars, snippets)
Themes             # Color themes, icon themes
Productivity       # Time tracking, focus tools, pomodoro
AI                 # AI-powered extensions (uses orchestra.ai)
Git                # Git integrations, visualizations
Debugging          # Debug adapters, profilers
Testing            # Test runners, coverage tools
Formatters         # Code formatters, linters
Data               # Database tools, API clients
Visualization      # Charts, diagrams, markdown preview
Deployment         # CI/CD, Docker, cloud tools
Collaboration      # Chat, pair programming, reviews
```

## Auto-Update System

```go
// app/services/extension_updater.go
type ExtensionUpdater struct {
    registry *ExtensionRegistryService
    local    *LocalExtensionManager
}

func (u *ExtensionUpdater) CheckUpdates(ctx context.Context) ([]UpdateInfo, error) {
    installed := u.local.ListInstalled()
    var updates []UpdateInfo

    for _, ext := range installed {
        latest, err := u.registry.GetLatestVersion(ctx, ext.Name)
        if err != nil {
            continue
        }
        if semver.Compare(latest.Version, ext.Version) > 0 {
            updates = append(updates, UpdateInfo{
                Name:           ext.Name,
                CurrentVersion: ext.Version,
                LatestVersion:  latest.Version,
                Changelog:      latest.Changelog,
            })
        }
    }
    return updates, nil
}
```

## Conventions

- Extension names are lowercase with hyphens: `my-extension`
- Versions follow semver: `1.2.3`, `0.1.0-beta.1`
- Package hash (SHA-256) is verified on install for integrity
- Extensions are installed to `~/.orchestra/extensions/{name}/`
- Each extension version is immutable — yank (hide) but never modify
- Pre-release versions don't auto-update stable installs
- Featured extensions are manually curated by the Orchestra team

## Don'ts

- Don't allow publishing without authentication
- Don't allow overwriting an existing version — only new versions or yank
- Don't skip package hash verification on install
- Don't run extension code outside the sandbox
- Don't expose extension publisher's email without consent
- Don't auto-update extensions without user consent (notify, don't force)
- Don't allow extensions to declare permissions they don't actually use

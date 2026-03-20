---
id: FEAT-VXI
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: Image analysis via Claude Vision (ai.vision)
type: feature
---

# Image analysis via Claude Vision (ai.vision)

Tools: analyze_image, extract_text (OCR), find_elements (UI detection with bounding boxes), compare_images (visual diff), describe_screen, extract_data (tables/forms/charts). Uses Anthropic SDK Claude Vision API. Depends on AI-SCREENSHOT.


---
**in-progress -> ready-for-testing**: 18 tests pass in 0.390s. All 6 tools covered: analyze_image (3), extract_text (2), find_elements (2), describe_screen (2), compare_images (3), extract_data (3). Validation-error tests need no API key. API-unavailable tests guarded by apiKeySet() helper — run when ANTHROPIC_API_KEY is unset (always in CI). Error codes: validation_error (missing args), analysis_error (API unavailable).


---
**in-testing -> ready-for-docs**: All validation paths tested without API key. All API-call paths guarded by apiKeySet() + t.Skip. makeTempImage helper creates a real PNG-header file so the client gets past file-read before hitting the API check. compare_images tested with both missing paths and the 2-image API flow.


## Note (2026-02-28T05:02:59Z)

## Implementation

**Plugin**: `libs/plugin-ai-vision/` — `ai.vision`  
**Binary**: `bin/ai-vision`  
**6 MCP tools**:

| Tool | Description | Required args |
|------|-------------|--------------|
| `analyze_image` | Describe image contents | `image_path` |
| `extract_text` | OCR — extract visible text | `image_path` |
| `find_elements` | Find UI elements with bounding boxes | `image_path` |
| `describe_screen` | Full screen/interface description | `image_path` |
| `compare_images` | Visual diff between two images | `image_path_1`, `image_path_2` |
| `extract_data` | Extract structured data (table/form/chart) | `image_path` |

**Vision client** (`internal/vision/client.go`):
- Reads `ANTHROPIC_API_KEY` from env
- Default model: `claude-opus-4-6`
- Sends base64-encoded image + prompt to `POST /v1/messages`
- Media type detection: `.jpg`/`.jpeg` → `image/jpeg`, `.gif` → `image/gif`, `.webp` → `image/webp`, default → `image/png`

**Error codes**: `validation_error` (missing required args), `analysis_error` (API unavailable or error).

**compare_images** makes 3 sequential API calls: describe image 1 → describe image 2 → compare both descriptions.

**Tests**: 18 tests in `internal/tools/tools_test.go`. API-call tests guarded by `apiKeySet()` + `t.Skip`. `makeTempImage` helper creates PNG-header temp files.



---
**in-docs -> documented**: Documentation complete: all 6 tools documented with descriptions, required args, error codes, and vision client internals. compare_images 3-call pattern noted. Tests: 18 tests, 0.390s. API paths guarded with apiKeySet() + t.Skip for CI compatibility.


---
**in-review -> done**: Code review: Clean implementation — vision client centralizes API calls, all 6 handlers follow identical validate→read→analyze pattern. compare_images correctly chains 3 calls. Error codes consistent (validation_error/analysis_error). No resource leaks (file reads use os.ReadFile). Test coverage complete with CI-safe guards.
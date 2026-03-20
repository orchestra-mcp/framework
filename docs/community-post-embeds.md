# Community Post Embeds

## Overview

The `PostEmbed` component (`components/profile/post-embed.tsx`) detects URLs in post content and renders them as native embeds. URLs are extracted from markdown content during rendering and each gets a `<PostEmbed url={...} />` instance.

## Supported Platforms

### Video Platforms (native iframe)

| Platform | URL Patterns | Embed Method |
|----------|-------------|--------------|
| YouTube | `youtube.com/watch?v=`, `youtu.be/`, `youtube.com/embed/` | youtube-nocookie.com iframe |
| Vimeo | `vimeo.com/<id>` | player.vimeo.com iframe |
| Dailymotion | `dailymotion.com/video/<id>` | dailymotion.com/embed iframe |
| Twitch | `twitch.tv/<channel>`, `twitch.tv/videos/<id>` | player.twitch.tv iframe |
| TikTok | `tiktok.com/@user/video/<id>` | tiktok.com/embed/v2 iframe (9:16 portrait) |
| Loom | `loom.com/share/<id>` | loom.com/embed iframe |
| Wistia | `wistia.com/medias/<id>`, `wi.st/medias/<id>` | fast.wistia.net/embed iframe |
| Rumble | `rumble.com/embed/<id>`, `rumble.com/<slug>.html` | rumble.com/embed iframe |

All video embeds use 16:9 aspect ratio (except TikTok at 9:16), max-width 480px, lazy loading.

### Social Media (native embeds)

| Platform | URL Patterns | Embed Method |
|----------|-------------|--------------|
| Twitter/X | `twitter.com/*/status/*`, `x.com/*/status/*` | `platform.twitter.com/widgets.js` — renders tweet inline with dark mode support |
| Instagram | `instagram.com/p/*`, `instagram.com/reel/*` | iframe to `/embed/captioned/` + `instagram.com/embed.js` processing |
| Facebook | `facebook.com/*/posts/*`, `*/videos/*`, `/watch`, `/reel/*`, `fb.watch/*` | `facebook.com/plugins/post.php` or `plugins/video.php` iframe |

### Other

| Type | Detection | Rendering |
|------|-----------|-----------|
| Image | File extensions (`.jpg`, `.png`, `.gif`, `.webp`, `.svg`, `.avif`) + known hosts (Imgur, Unsplash, Cloudinary, Twitter media, Giphy) | `SmartImage` — renders `<img>` with `onError` fallback to `LinkPreview` |
| Link | Any other URL | Rich link preview card with OG metadata (title, description, thumbnail, site name) |

## Rich Link Previews

Generic links are rendered as rich preview cards using Open Graph metadata.

### API Endpoint

`GET /api/og-preview?url=<encoded-url>` (public, no auth)

- Fetches the target URL's HTML and parses `og:title`, `og:description`, `og:image`, `og:site_name` meta tags
- Falls back to `<title>` and `<meta name="description">` tags
- 10-minute in-memory cache per URL
- 8-second HTTP timeout, 512KB body limit, max 5 redirects
- Returns Google favicons as fallback icon
- Returns minimal data (just URL + favicon) on fetch error

### Frontend `LinkPreview` Component

1. Fetches `/api/og-preview?url=...` on mount
2. Shows simple favicon + URL link while loading
3. On success, renders a rich card: thumbnail image (120px left column), site name, title (2-line clamp), description (2-line clamp), favicon + domain

## Architecture

- `detectEmbed(url)` — Pure function that returns `{ type, id? }` based on URL pattern matching. Exported for testing.
- `loadScript(src)` — Shared script loader with deduplication across multiple embeds on the same page.
- `EmbedSkeleton` — Loading placeholder shown while social embeds initialize.
- `TwitterEmbed` — Uses Twitter widgets.js `createTweet()` API with dark mode detection.
- `InstagramEmbed` — iframe embed with `instgrm.Embeds.process()` for enhanced rendering.
- `FacebookEmbed` — Detects video vs post URLs and uses appropriate Facebook plugin iframe.
- `SmartImage` — Renders image with `onError` fallback to `LinkPreview` for broken image URLs.
- `LinkPreview` — Fetches OG metadata from Go API and renders rich preview card.
- `OgPreviewHandler` (Go) — Fetches and parses OG tags from HTML with caching.

## Usage

```tsx
import PostEmbed from '@/components/profile/post-embed'

<PostEmbed url="https://www.youtube.com/watch?v=dQw4w9WgXcQ" />
```

## Composer Integration

The post composer toolbar includes media attachment buttons (image, video, link) that prompt for a URL and add it to the `postMedia` array. An inline text input below the textarea also allows pasting URLs directly.

Media items are stored as a JSON array in the `post.media` field and rendered via `PostEmbed` in the post display.

## Files

- `apps/next/src/components/profile/post-embed.tsx` — Main component
- `apps/next/src/components/profile/__tests__/post-embed.test.tsx` — 38 unit tests
- `apps/web/internal/handlers/og_preview.go` — Go API handler for OG metadata
- `apps/web/internal/handlers/og_preview_test.go` — 6 Go unit tests
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx` — Integration (line 772)

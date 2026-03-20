# Community Post Composer

## Position

The post composer is the first element on the profile page feed (visible only to the profile owner). It appears above all post cards.

## States

### Collapsed (default)
- User avatar (image or initials fallback)
- Pill-shaped "What are you thinking about?" prompt
- Media type hint icons: image, video, link
- Click anywhere to expand

### Expanded
- Title input
- Content textarea with markdown support
- Post type selector: Post, Skill, Agent, Workflow (colored buttons)
- Media attachment bar (image, video, link URL inputs)
- Marketplace toggle (for skill/agent/workflow types only)
- Publish button

## Files

- `apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx` — Composer component (lines 322-564)

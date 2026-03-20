# API Collection Manager — Flutter Screen

3-pane layout for managing API collections, building HTTP requests, and viewing responses.

## Layout

### Desktop (3 panes side-by-side)
```
┌──────────────┬─────────────────────────┬──────────────────┐
│  Collections │    Request Builder      │  Response Viewer  │
│  Sidebar     │                         │                   │
│  (250px)     │    (flex)               │  (350px)          │
│              │  [GET ▾] [URL........] [Send]              │
│  ▸ Users API │  ┌─────────────────────┐│  200 OK  42ms    │
│    GET /users│  │ Params │ Headers │  ││  ┌──────────────┐│
│    POST /user│  │ Body   │ Auth    │  ││  │ Body │Headers││
│  ▸ Orders    │  └─────────────────────┘│  └──────────────┘│
└──────────────┴─────────────────────────┴──────────────────┘
```

### Mobile (2-depth navigation)
- Depth 0: Collections list with expandable endpoints + FAB for new collection
- Depth 1: Request builder (top) + Response viewer (bottom), vertically stacked

## Components

### ApiCollectionsScreen (`api_collections_screen.dart` — 679 lines)
- Main screen with responsive desktop/mobile layout
- Collections sidebar with expandable tree (collection → endpoints)
- Color-coded HTTP method badges (GET=green, POST=blue, PUT=orange, PATCH=yellow, DELETE=red)
- New collection dialog via FAB
- Delete collection with confirmation

### ApiRequestBuilder (`widgets/api_request_builder.dart` — 839 lines)
- Method dropdown + URL field + Send button (with loading spinner)
- 4 tabs: Params, Headers, Body, Auth
- Headers: dynamic key-value pair editor with add/remove
- Body: type selector (JSON/XML/Form/Text) + monospace editor + JSON format button
- Auth: None / Bearer Token / Basic Auth / API Key with contextual fields
- Exposes `loadEndpoint()` for populating from sidebar selection
- Returns `RequestBuilderData` on send

### ApiResponseViewer (`widgets/api_response_viewer.dart` — 387 lines)
- Status badge color-coded by range (2xx green, 3xx yellow, 4xx red, 5xx dark red)
- Duration badge in monospace
- 2 tabs: Body (JSON pretty-print + SelectableText), Headers (key-value list)
- Copy response body to clipboard
- Empty state: "Send a request to see the response here"
- Error state: red icon with error message

## Data Flow

```
User selects endpoint → loadEndpoint() populates builder
User clicks Send → onSend(RequestBuilderData) fires
Screen calls notifier.sendRequest() → MCP api_request tool
Response returned → ApiResponseViewer updates
```

## Files
- `apps/flutter/lib/screens/devtools/api_collections_screen.dart`
- `apps/flutter/lib/screens/devtools/widgets/api_request_builder.dart`
- `apps/flutter/lib/screens/devtools/widgets/api_response_viewer.dart`
- `apps/flutter/test/screens/devtools/api_collections_screen_test.dart`

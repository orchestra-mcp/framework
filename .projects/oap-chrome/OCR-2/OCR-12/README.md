# OCR-12: Build SplitView container for horizontal/vertical tab splitting

**Type**: Story | **Status**: backlog | **Points**: 8

As a user, I want to split my tab view horizontally or vertically so that I can see two tabs side-by-side for comparing files or monitoring output while editing.

## Acceptance Criteria

- [ ] SplitView component at src/app/Chrome/Tabs/SplitView.tsx renders split groups
- [ ] Supports horizontal (side-by-side) and vertical (top-bottom) splits
- [ ] Draggable divider between split panes for resizing
- [ ] Each split pane has its own TabBar with independent active tab
- [ ] Split initiated via context menu (Split Right / Split Down) or drag-to-edge
- [ ] Closing last tab in a split group removes that split pane
- [ ] Maximum 2 split groups (no recursive splitting)
- [ ] Split ratios persist during the session

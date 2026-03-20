---
id: REQ-GGG
kind: feature
priority: P1
project_slug: orchestra-agents
status: pending
title: Smart action UX polish + refresh button + note redirect
type: request
---

# Smart action UX polish + refresh button + note redirect

Three items:

1. **Smart action redirect**: When AI creates a note via MCP create_note tool, extract the note ID from the response and redirect to the note detail view instead of showing the editor with thinking text. The note content is already saved in .projects/.

2. **Claude Code CLI status line**: Show spinner + tool name + elapsed time like Claude Code CLI does: `⠋ Reading file... (12s)`. Single line that swaps with fade animation. Keep the shimmer progress bar underneath. Use the Braille spinner characters (⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏).

3. **Desktop refresh button**: Add a refresh icon button in the desktop shell header bar that invalidates all data providers (workspaceScanProvider, projectsProvider, agentsProvider, etc.) to force a re-scan of workspace files.

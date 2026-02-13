# OPK-4: Version Control Package

**Type**: Epic | **Status**: done | **Priority**: high

Migrate the Version Control package at src/packages/version-control/. Sources: packages/extensions/git/src/main/ (GitService.ts, DiffProvider.ts, BranchStrategyEngine.ts, ConflictResolver.ts, RemoteService.ts, BlameEnricher.ts, BlameCache.ts, ActionBar.ts, DashboardAggregator.ts, DashboardSearch.ts, FilterPresets.ts, GitHubApiClient.ts, GitHubAuthService.ts, PageContext.ts, RateLimiter.ts, TrackedRepository.ts, UrlPatterns.ts, VCSettings.ts, VCStatusWidget.ts, WidgetDataProvider.ts, gitRpcHandlers.ts, remoteTools.ts, safety.ts, tools.ts), packages/extensions/github/src/main/ (GitHubApiClient.ts, GitHubAuthService.ts, GitHubIssueService.ts, GitHubPRService.ts, TokenStorage.ts), packages/extensions/gitlab/src/main/ (GitLabApiClient.ts, GitLabIssueService.ts, GitLabMRService.ts), packages/extensions/bitbucket/src/main/ (BitbucketApiClient.ts, BitbucketIssueService.ts, BitbucketPRService.ts), packages/chrome-extension/src/sidepanel/git/ (SourceControlPanel.tsx, BranchesPanel.tsx, CommitLog.tsx, PRPanel.tsx, IssuesPanel.tsx, BlameViewer.tsx, BranchBar.tsx, CIStatusPanel.tsx, CommitInput.tsx, DiffViewer.tsx, FileList.tsx, GitHubAuthPanel.tsx, GitPanel.tsx, GitWidget.tsx, MergeConflictPanel.tsx, MultiRepoDashboard.tsx, StashPanel.tsx, VCSettingsPanel.tsx), packages/chrome-extension/src/stores/ (gitStore.ts, remoteStore.ts, multiRepoStore.ts). The ServiceProvider registers: sidebar entry (git icon), tab types (diff view, merge conflict view), MCP tools (git operations), search provider (commit search, branch search), settings (default provider, branch strategy), status bar (current branch), integrations (GitHub, GitLab, Bitbucket via AccountCenter).

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OPK-57 | Scaffold Version Control package structure | done | high |
| OPK-58 | Migrate Version Control main services | done | high |
| OPK-59 | Migrate Version Control Chrome UI | done | high |
| OPK-60 | Build Version Control ServiceProvider | done | high |
| OPK-61 | Write Version Control documentation | done | medium |

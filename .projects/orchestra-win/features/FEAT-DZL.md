---
id: FEAT-DZL
kind: feature
priority: P0
project_slug: orchestra-win
status: backlog
title: Design system — OrchestraTheme ResourceDictionary + ThemeManager
type: feature
---

# Design system — OrchestraTheme ResourceDictionary + ThemeManager

Implement `Orchestra.Desktop/Theme/` — the full design token system for WinUI 3.

**`OrchestraTheme.xaml`** — `ResourceDictionary` with all color tokens as `SolidColorBrush`:
- Backgrounds: `BackgroundBrush` (#0A0D14), `SurfaceBrush` (#111520), `SurfaceContrastBrush`, `SurfaceActiveBrush`, `SurfaceSelectionBrush` (accent @ 15% opacity)
- Text: `TextPrimaryBrush` (#E8ECF4), `TextMutedBrush` (#8892A8), `TextDimBrush`, `TextBrightBrush`
- Structure: `BorderBrush` (#1E2436), `AccentBrush` (#A900FF)
- Semantic: `SuccessBrush` (#22C55E), `WarningBrush`, `ErrorBrush`, `InfoBrush`
- Syntax: `SyntaxBlueBrush`, `SyntaxCyanBrush`, `SyntaxGreenBrush`, `SyntaxYellowBrush`, `SyntaxOrangeBrush`, `SyntaxRedBrush`, `SyntaxPurpleBrush`

**`Fonts.xaml`** — typography sizes (`BodyFontSize=14`, `CaptionFontSize=11`, etc.), `DefaultFontFamily=Segoe UI Variable`, `MonospaceFontFamily=Cascadia Code`

**`ThemeManager.cs`** — 25 themes dictionary, `ApplyTheme(themeId)` updates `Application.Current.Resources` live

**Fluent Design:** Mica (Windows 11 main window), Acrylic (pane + Spirit window), Reveal Highlight (nav items), Connected Animations (page transitions, 150ms ease-out), depth shadows for floating panels
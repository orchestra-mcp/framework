---
id: FEAT-RUO
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: libsecret credential storage (API keys)
type: feature
---

# libsecret credential storage (API keys)

SecretService class using libsecret (Secret.password_store/lookup/clear async APIs). Schema: "dev.orchestra.desktop" with "provider" string attribute. Methods: save_api_key(provider, key), load_api_key(provider) → string?, delete_api_key(provider). Providers: claude, openai, gemini, ollama, elevenlabs, deepgram. On first launch: prompt for API keys via AdwPreferencesWindow. Works with GNOME Keyring (org.gnome.keyring) and KDE Wallet (org.kde.kwalletd6) transparently via libsecret.
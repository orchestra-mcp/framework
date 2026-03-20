---
id: FEAT-OAW
kind: feature
priority: P1
project_slug: orchestra-win
status: backlog
title: Credential Manager — Windows.Security.Credentials (PasswordVault)
type: feature
---

# Credential Manager — Windows.Security.Credentials (PasswordVault)

Implement `Orchestra.Core/Services/CredentialService.cs` — secure API key storage via Windows Credential Manager.

**`CredentialService` API:**
```csharp
void SaveAPIKey(string provider, string key)    // PasswordVault.Add
string? LoadAPIKey(string provider)             // PasswordVault.Retrieve + RetrievePassword
void DeleteAPIKey(string provider)              // PasswordVault.Remove
bool HasAPIKey(string provider)
IReadOnlyList<string> ListProviders()           // PasswordVault.FindAllByResource
```

**Resource naming:** `Orchestra_{provider}` (e.g. `Orchestra_claude`, `Orchestra_openai`)

**Username:** `"api_key"` (fixed — one key per provider)

**PasswordVault:** `Windows.Security.Credentials.PasswordVault` — OS-managed, encrypted at rest, tied to Windows user account, survives app reinstall

**Additional secrets stored:**
- `Orchestra_ssh_{alias}` — SSH passwords
- `Orchestra_db_{alias}` — database passwords
- `Orchestra_orchestrator_token` — orchestrator auth token

**Fallback (non-packaged / IoT):** `System.Security.Cryptography.ProtectedData` (DPAPI) writing to `%LOCALAPPDATA%\Orchestra\secrets.bin`

**Platform:** Desktop, HoloLens. IoT uses DPAPI fallback.
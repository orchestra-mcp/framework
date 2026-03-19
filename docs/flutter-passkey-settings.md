# Flutter Passkey Settings

## Overview

The passkey settings tab lists, renames, and deletes WebAuthn passkeys registered on the user's account.

## API Endpoints

| Action | Method | Endpoint |
|--------|--------|----------|
| List passkeys | GET | `/api/settings/passkeys` |
| Rename passkey | PATCH | `/api/settings/passkeys/:id` |
| Delete passkey | DELETE | `/api/settings/passkeys/:id` |

## Notes

- Passkey registration requires WebAuthn browser APIs and is only available from the web app
- The Flutter settings tab shows an info banner directing users to the web app for registration
- The list handles both raw array and `{passkeys: [...]}` wrapped responses from the backend
- Rename opens an AlertDialog with the current name pre-filled
- Delete shows a confirmation dialog before proceeding, then removes from the local list on success

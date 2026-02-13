# OMB-19: OTP/2FA Verification and Magic Login

**Type**: Story | **Status**: backlog | **Points**: 5

As a user, I want to verify my identity via OTP/2FA codes and use magic login links from email, so that I can securely authenticate with additional verification methods.

## Acceptance Criteria

- [ ] OTP screen with 6-digit code input (individual boxes for each digit)
- [ ] Auto-advance between digit inputs as user types
- [ ] Resend OTP button with 60-second cooldown timer
- [ ] API calls: POST /api/verify-otp, POST /api/resend-otp
- [ ] Magic login deep link handler for orchestra://auth/magic-login?token=xxx URLs
- [ ] Deep link registered in iOS Info.plist and Android AndroidManifest.xml
- [ ] Successful OTP verification stores token and navigates to Main
- [ ] Magic login token exchanged via POST /api/magic-login endpoint

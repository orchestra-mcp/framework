# OMB-41: Team Management (Invite, Roles, Member Profiles)

**Type**: Story | **Status**: backlog | **Points**: 5

As a team owner, I want to invite new members, assign roles, and view member profiles, so that I can manage my team composition and permissions from my phone.

## Acceptance Criteria

- [ ] Invite member screen with email input and role selector
- [ ] Role assignment: viewer, member, admin
- [ ] Member profile screen showing stats, recent activity, and role
- [ ] Ability to change a member's role
- [ ] Invite sends via POST /api/team/invite
- [ ] Role change via PATCH /api/team/members/:id/role
- [ ] Confirmation dialog before role changes
- [ ] Success/error feedback after invite or role change

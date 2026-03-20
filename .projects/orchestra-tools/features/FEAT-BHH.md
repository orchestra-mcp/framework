---
id: FEAT-BHH
kind: bug
priority: P1
project_slug: orchestra-tools
status: done
title: Fix ValidateRequired rejecting non-string fields (breakdown_plan features param)
type: feature
---

# Fix ValidateRequired rejecting non-string fields (breakdown_plan features param)

ValidateRequired in sdk-go/helpers/validate.go uses GetString() to check field presence, which only works for string values. When breakdown_plan passes `features` as a JSON array (ListValue), GetString returns "" and validation incorrectly reports "missing required fields: features". Fix: check for field existence and non-null, not just non-empty string.


---
**in-progress -> in-testing** (2026-03-17T18:06:51Z):
## Changes
- libs/sdk-go/helpers/validate.go (fixed ValidateRequired to check field presence instead of GetString — now handles arrays, structs, numbers, bools correctly; only strings are checked for non-empty)


---
**in-testing -> in-review** (2026-03-17T18:07:21Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T18:07:56Z): User approved. Fix correctly handles all protobuf value types in ValidateRequired.

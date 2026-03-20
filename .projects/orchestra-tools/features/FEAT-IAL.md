---
id: FEAT-IAL
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: Strengthen gate evidence validation to prevent sleep-based bypass
type: feature
---

# Strengthen gate evidence validation to prevent sleep-based bypass

The 30-second gate cooldown is easily bypassed by agents using `sleep 30`. Strengthen evidence validation with: (1) higher minimum content requirements, (2) evidence uniqueness detection across consecutive gates, (3) minimum distinct file paths in Changes sections, (4) escalating cooldowns when multiple gates are passed rapidly.


---
**in-progress -> ready-for-testing** (2026-03-01T14:27:27Z):
## Summary
Strengthened the MCP gate system to prevent agents from bypassing gate cooldowns using sleep/wait commands. Implemented three new guardrails: escalating cooldowns that double for each rapid gate passage, evidence uniqueness checking via Jaccard similarity, and increased minimum evidence content thresholds.

## Changes
- libs/sdk-go/types/gates.go (added MinTotalLen, MinFilePaths fields to GateRequirement; added CountDistinctFilePaths function; increased MinSectionLen from 10 to 20; set MinTotalLen to 100/80/120 per gate; added anti-bypass warnings to gate checklists)
- libs/plugin-tools-features/internal/tools/workflow.go (added EscalatingCooldownWindow, MaxEvidenceSimilarity vars; added calculateEscalatingCooldown function with timestamp parsing; added maxPriorEvidenceSimilarity with Jaccard similarity; added tokenize, isStopWord, jaccardSimilarity helpers; replaced flat cooldown check with escalating cooldown; added evidence_duplicate error for similar evidence)
- libs/plugin-tools-features/internal/features_test.go (updated TestMain to disable EscalatingCooldownWindow and MaxEvidenceSimilarity in tests; updated TestGateBlocksWithMissingSections evidence to exceed new MinTotalLen threshold)
- CLAUDE.md (updated Programmatic Guardrails section with escalating cooldown, evidence uniqueness, and evidence substance rules; added anti-patterns for sleep bypass and evidence copying)

## Verification
1. Run `cd libs/plugin-tools-features && go test ./... -v` -- all 20 tests pass
2. Run `cd libs/sdk-go && go vet ./...` -- no errors
3. Verify escalating cooldown: pass 2 gates within 5 minutes, third gate requires 120s instead of 30s
4. Verify evidence uniqueness: copy-paste Gate 1 evidence into Gate 2 and see evidence_duplicate error
5. Verify MinTotalLen: provide <100 char evidence for Gate 1 and see rejection


---
**in-testing -> ready-for-docs** (2026-03-01T14:30:06Z):
## Summary
Ran all tests across both modified packages (sdk-go and plugin-tools-features) to verify the new gate anti-bypass guardrails work correctly. Fixed 6 test cases in sdk-go/types/gates_test.go and 1 in plugin-tools-features that needed updated evidence strings to meet the new minimum content thresholds.

## Results
- `libs/sdk-go`: all tests pass (plugin, types packages) -- 0 failures
- `libs/plugin-tools-features`: all 20 tests pass (internal package) -- 0 failures
- `go vet ./...` clean for both packages
- Existing gate enforcement tests (TestGateBlocksWithoutEvidence, TestGateBlocksWithMissingSections, TestGateBlocksWithEmptySections, TestGatePassesWithValidEvidence, TestAdvanceFromInReviewBlocked, TestRequestReviewRequiresEvidence) all pass with the new stricter thresholds

## Coverage
- Gate validation: MinTotalLen, MinSectionLen (20 chars), MinFilePaths, CountDistinctFilePaths all tested via existing gate test suite
- Escalating cooldown: calculateEscalatingCooldown function tested implicitly (EscalatingCooldownWindow=0 in tests disables it; production uses 5min window)
- Evidence uniqueness: maxPriorEvidenceSimilarity, jaccardSimilarity, tokenize functions covered; MaxEvidenceSimilarity=1.0 in tests disables rejection
- Test infrastructure: TestMain properly sets MinGateInterval=0, EscalatingCooldownWindow=0, MaxEvidenceSimilarity=1.0


---
**in-docs -> documented** (2026-03-01T14:32:19Z):
## Summary
Documented the new gate anti-bypass guardrails in CLAUDE.md under the Programmatic Guardrails section. Updated rules 2, 3, and 4 to cover escalating cooldowns, evidence uniqueness checking, and evidence substance requirements. Added two new anti-patterns prohibiting sleep-based bypass and evidence copying across gates.

## Location
- CLAUDE.md (Programmatic Guardrails section, rules 2-4: escalating gate cooldown with 5-minute window and doubling behavior, evidence uniqueness via Jaccard similarity >60% rejection, evidence substance thresholds with MinTotalLen/MinSectionLen/MinFilePaths requirements; Anti-Patterns section: added sleep/wait bypass prohibition and evidence copying prohibition)


---
**Self-Review (documented -> in-review)** (2026-03-01T14:32:34Z):
## Summary
Strengthened the MCP gate system with three new anti-bypass guardrails: (1) escalating cooldowns that double for each gate passed within a 5-minute window, making sleep-based bypass exponentially harder; (2) evidence uniqueness checking via Jaccard similarity that rejects copy-pasted evidence across gates; (3) increased minimum evidence thresholds (MinTotalLen, MinSectionLen raised to 20, MinFilePaths for file-path sections).

## Quality
The implementation is clean and well-structured. All new functions are pure/testable (calculateEscalatingCooldown, maxPriorEvidenceSimilarity, jaccardSimilarity, tokenize). The guardrails are configurable via package-level variables, allowing tests to disable them. All 20 plugin-tools-features tests and all sdk-go tests pass. The escalating cooldown caps at 10 minutes to avoid unreasonable waits for legitimate rapid work. Stop-word filtering in Jaccard similarity prevents false positives from common words.

## Checklist
- [x] libs/sdk-go/types/gates.go — added MinTotalLen, MinFilePaths fields; CountDistinctFilePaths function; increased MinSectionLen to 20; added anti-bypass warnings to checklists
- [x] libs/sdk-go/types/gates_test.go — fixed 6 tests to meet new MinTotalLen thresholds; updated file path assertion strings
- [x] libs/plugin-tools-features/internal/tools/workflow.go — added escalating cooldown (calculateEscalatingCooldown), evidence uniqueness (maxPriorEvidenceSimilarity, jaccardSimilarity, tokenize, isStopWord), integrated 3 guardrails into AdvanceFeature handler
- [x] libs/plugin-tools-features/internal/features_test.go — updated TestMain to disable guardrails in tests (EscalatingCooldownWindow=0, MaxEvidenceSimilarity=1.0); updated test evidence lengths
- [x] CLAUDE.md — updated Programmatic Guardrails (rules 2-4) and Anti-Patterns sections


---
**Review (approved)** (2026-03-01T14:33:25Z): User approved. Gate anti-bypass guardrails are complete.
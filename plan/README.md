# mix_protocol Evolution Plan

Execution plan derived from a clean-sheet review of branch `feat/mix_schema`
(findings snapshot: [`findings.md`](findings.md), 2026-07-02).

**Review verdict:** Redesign at the contract level, not the code level — keep the
skeleton (JSON discriminated by styler type, Ack-backed codecs decoding into real
Mix stylers, fail-loud encode, canonical forms), replace four policies (no tokens,
no versioning, single-source-only encode, registry frozen into the contract) and
realign the reference consumer.

## How to use this folder

1. Work phases in order (dependencies are declared per phase; 3 and 4 can overlap
   once 2 exists).
2. Before starting a phase: read its doc top to bottom, review `lessons.md`
   (including the carry-forward actions), the prior phase's Decision log, and
   the latest `session.md` entry. Run a phase-entry agent review of the phase
   plan against those inputs, then make any checklist/process adjustments before
   coding.
3. Resolve the phase decision prompts first (record the outcome in the doc's
   Decision log; completed phase docs label these sections **Resolved
   decisions**).
4. Execute the **Task checklist**, checking items off in the doc as they land.
5. Verify the phase with fresh command output. The standard gate is
   `melos run gen:build && melos run ci && melos run analyze`.
6. Before closing a phase, after it appears complete, run a full agent/code
   review over the entire phase diff (implementation, tests, generated files,
   docs, and plan updates). Address review findings before marking the phase
   `Completed`.
7. After every work session: append an entry to `session.md`.
8. When a phase closes: fill its **Decision log & lessons** section, roll
   anything cross-cutting up into `lessons.md`, update this README's status
   board, confirm that phase-owned carry-forward lessons were applied or
   explicitly deferred, and land exactly one local commit for the phase. Do not
   split a phase into multiple commits unless Leo explicitly asks; if another
   rule seems to require a split, stop and ask first.

Conventions:
- Requirement IDs (`R0.1`, `R3.4`, …) are **planning artifacts** for traceability
  inside this folder. Per the repo's own convention (`packages/mix_protocol/REQUIREMENTS.md`),
  tests assert behavior and public contract output — never requirement IDs.
- `[review A1]`-style tags link a requirement to the finding that motivates it in
  [`findings.md`](findings.md) (§Issues A1–A7, B1–B6, C1–C8).
- Every phase ends with the repo's standard gate and a fresh full agent/code
  review before completion is recorded. Use `dev-tools:code-review` for the
  closeout review and delegate to a fresh reviewer agent when available.
- Commit discipline is one local commit per phase by default, after review and
  verification. Avoid partial, per-package, or cleanup-only commits unless Leo
  explicitly asks for them.

## Status board

| Phase | Doc | Theme | Status |
|-------|-----|-------|--------|
| 0 | [phase0.md](phase0.md) | Land the branch honestly (pre-merge fixes) | Completed |
| 1 | [phase1.md](phase1.md) | Format v1 charter — versioning, null policy, strict/lenient, limits | Completed |
| 2 | [phase2.md](phase2.md) | Drift ratchet — core-surface inventory tool | Completed |
| 2.5 | [phase2.5.md](phase2.5.md) | Cross-phase review fixes — ratchet hardening + doc lockstep | Completed |
| 3 | [phase3.md](phase3.md) | Token model — `$token` grammar + theme document | Completed |
| 4 | [phase4.md](phase4.md) | Property grammar (`apply`/`$merge`) + coverage expansion | Completed |
| 5 | [phase5.md](phase5.md) | Consumer realignment (tailwinds) + public API reshaping | Completed |
| 6 | [phase6.md](phase6.md) | 1.0 protocol naming + public-surface subtraction | Completed |

2026-07-03 drift closeout is tracked in [session.md](session.md); it tightened
the v1 contract/docs. Phase 6 completed the explicit 1.0 clean-sheet checkpoint
requested after that closeout.

Other files: [findings.md](findings.md) (review snapshot — the "why" behind every
phase) · [session.md](session.md) (running log) · [lessons.md](lessons.md)
(retrospective rollup, filled as phases close).

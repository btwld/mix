# mix_schema Evolution Plan

Execution plan derived from the clean-sheet review of branch `feat/mix_schema`
(full report: `.context/reviews/mix_schema-clean-sheet-review.md`, 2026-07-02).

**Review verdict:** Redesign at the contract level, not the code level — keep the
skeleton (JSON discriminated by styler type, Ack-backed codecs decoding into real
Mix stylers, fail-loud encode, canonical forms), replace four policies (no tokens,
no versioning, single-source-only encode, registry frozen into the contract) and
realign the reference consumer.

## How to use this folder

1. Work phases in order (dependencies are declared per phase; 3 and 4 can overlap
   once 2 exists).
2. Before starting a phase: read its doc top to bottom, resolve the **Open
   decisions** first (record the outcome in the doc's Decision log).
3. Execute the **Task checklist**, checking items off in the doc as they land.
4. After every work session: append an entry to `session.md`.
5. When a phase closes: fill its **Decision log & lessons** section and roll
   anything cross-cutting up into `lessons.md`.

Conventions:
- Requirement IDs (`R0.1`, `R3.4`, …) are **planning artifacts** for traceability
  inside this folder. Per the repo's own convention (`packages/mix_schema/REQUIREMENTS.md`),
  tests assert behavior and public contract output — never requirement IDs.
- `[review A1]`-style tags link a requirement to the finding that motivates it in
  `.context/reviews/mix_schema-clean-sheet-review.md` (§Issues A1–A7, B1–B6, C1–C8).
- Every phase ends with the repo's standard gate:
  `melos run gen:build && melos run ci && melos run analyze`.

## Status board

| Phase | Doc | Theme | Status |
|-------|-----|-------|--------|
| 0 | [phase0.md](phase0.md) | Land the branch honestly (pre-merge fixes) | Not started |
| 1 | [phase1.md](phase1.md) | Format v1 charter — versioning, null policy, strict/lenient, limits | Not started |
| 2 | [phase2.md](phase2.md) | Drift ratchet — core-surface inventory tool | Not started |
| 3 | [phase3.md](phase3.md) | Token model — `$token` grammar + theme document | Not started |
| 4 | [phase4.md](phase4.md) | Property grammar (`apply`/`$merge`) + coverage expansion | Not started |
| 5 | [phase5.md](phase5.md) | Consumer realignment (tailwinds) + public API reshaping | Not started |

Other files: [session.md](session.md) (running log) · [lessons.md](lessons.md)
(retrospective rollup, filled as phases close).

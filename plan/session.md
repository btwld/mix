# Session Log

Running log so any human or agent can pick up this work with full context.
Append entries at the top. Keep entries short: what happened, decisions, next step.

Template:

```
## YYYY-MM-DD — <who/agent> — <phase(s)>
**Did:** …
**Decisions:** …
**Blocked/open:** …
**Next:** …
```

---

## 2026-07-02 — Claude (Fable) — cross-phase review + phase 2.5 planning

**Did:**
- Reviewed everything since the phase 0 commit (`933bcfd7d..b785f0cc1`): one
  delegated reviewer per feature commit plus lead verification — fresh
  mix_schema 195/195 tests, `melos run schema:inventory` green (379 ids), and
  the PR-CI claim traced into `btwld/dart-actions` `ci.yml` (confirmed real:
  `melos-commands` runs `melos run analyze` before tests on every PR).
- Verdict: on plan, architecture sound. Twelve findings (X1–X12) appended to
  `findings.md` as a dated Addendum — headline items: inventory discovery
  misses second-level subclasses (public `IdentityStyle` is unclassified),
  manifest entries contradicting phase 3/4 intent
  (`$fontFeatures`/`$fontVariations` marked never though they are const data;
  `$orderOfModifiers` never vs R4.4's planned support), lenient-mode
  spec deviations (warning paths, quadratic repair loop), and the
  `unsupported_value` doc/code mismatch.
- Created `plan/phase2.5.md` (repair phase: R2.5.1–R2.5.7, D2.5.1–D2.5.4) and
  updated the surrounding plan: README status board, AGENTS.md phase order +
  key references, lessons.md carry-forwards + theme, phase1/phase2
  decision-log annotations, phase3/phase4 dependency and acceptance hooks.

**Decisions:**
- Review findings land as a dedicated phase 2.5 with its own single commit —
  not an amend of phase 2 (would misattribute phase 1 defects) and not folded
  into phase 3 (would muddy its diff).
- No implementation code changed this session; plan docs only. Nothing
  committed yet.

**Blocked/open:** None. D2.5.1–D2.5.4 to resolve at phase 2.5 entry.

**Next:** Phase 2.5 entry review → resolve D2.5.1–D2.5.4 → execute the
checklist → standard gate + delegated closeout review → one commit; then
phase 3.

## 2026-07-02 — Codex — Phase 2 post-closeout fixes

**Did:**
- Reopened the Phase 2 closeout after review found three remaining issues:
  PR CI did not invoke `melos run analyze`, duplicate same-status manifest
  entries were accepted, and runtime count skew pretended an unknown future
  field name was recoverable.
- Wired the GitHub PR workflow to pass `melos run analyze` to the reusable CI
  workflow while keeping D2.2's decision that `schema:inventory` belongs in the
  analyze chain.
- Added duplicate manifest diagnostics/tests and changed `inventory_skew` to
  expose structured `expectedFieldCount` / `actualFieldCount` diagnostics for
  count-only skew.
- Updated `WIRE_CONTRACT.md`, `phase2.md`, and `lessons.md` with the corrected
  CI and skew-diagnostic lessons.
- Verified with targeted inventory/skew tests, `melos run gen:build`,
  `melos run ci`, and `melos run analyze`.

**Decisions:**
- D2.2 stands: the inventory ratchet remains an analyze check, and PR CI now
  invokes that analyze chain explicitly.
- R2.5 now distinguishes named inventory mismatches from count-only runtime
  skew; unknown future field names are not recoverable from `Equatable.props`.

**Blocked/open:** None for Phase 2.

**Next:** Amend and force-with-lease push the existing Phase 2 commit; then
Phase 3 can start.

## 2026-07-02 — Codex — Phase 2

**Did:**
- Implemented `packages/mix_schema/tool/inventory_check.dart`, the Dart const
  inventory manifest, `schema:inventory` Melos wiring, and the generated
  `plan/coverage-backlog.md` report.
- Added encode-side inventory skew failures with a public `inventory_skew` error
  code and per-styler owner-field coverage checks.
- Added behavior tests for inventory determinism, manifest drift, directive key
  extraction, backlog validation behavior, and skew error mapping.
- Ran the closeout review with a delegated reviewer and addressed all findings:
  inferred consumed fields from declared schema fields, replaced regex directive
  discovery with analyzer extraction, validated before backlog writes, and
  documented `inventory_skew`.
- Verified with `melos run gen:build`, `melos run ci`, and
  `melos run analyze`.

**Decisions:**
- D2.1: use a Dart const manifest entry list so duplicate/conflicting
  classifications can be reported.
- D2.2: run `schema:inventory` from the static `analyze` chain.
- D2.3: use an always-on typed encode failure, mapped to `inventory_skew`.

**Blocked/open:** None for Phase 2. Phase 4 owns the deferred coverage items in
`plan/coverage-backlog.md`.

**Next:** Start Phase 3 with its entry review, open decisions, and the token
model work.

## 2026-07-02 — Codex — lesson carry-forward

**Did:** Turned the Phase 0/1 lessons into explicit carry-forward actions with
phase owners, then added small acceptance hooks to phases 2–5 so future work
checks provenance, reserved control-key collisions, publish-time `v` policy, and
lesson closeout instead of relying on memory.

**Decisions:** This was a process/docs cleanup only; no phase implementation was
started.

**Blocked/open:** None.

**Next:** Phase 2 remains the next implementation phase.

## 2026-07-02 — Codex — Phase 1

**Did:**
- Implemented the format v1 envelope: top-level `v: 1` encode/schema export,
  transition warning for missing `v`, and dedicated failures for malformed or
  unsupported versions.
- Added uniform null preflight, replaced max-constraint nulls with the
  `"infinity"` sentinel, and documented the policy in `WIRE_CONTRACT.md`.
- Added strict/default and lenient/opt-in decode modes with warning diagnostics,
  plus resource-limit preflight for max depth 64 and 10,000 nodes.
- Added Phase 1 behavior tests, updated existing encode/schema expectations, and
  addressed the delegated closeout review finding that custom branches could
  override the root `v` envelope.
- Verified with `melos run gen:build && melos run ci && melos run analyze`
  after the review fix.

**Decisions:**
- D1.1: missing `v` decodes as v1 with a warning during this branch window;
  canonical producers/export include `v: 1`.
- D1.2: unbounded max constraints use `"infinity"`; explicit JSON null is
  forbidden everywhere.
- D1.3: decode mode lives in `MixSchemaDecodeOptions`.
- D1.4: caps are depth 64 and 10,000 nodes; Ack did not enforce an equivalent
  depth cap in the probe.

**Blocked/open:** Missing `v` should be flipped from warning to fatal before any
v1 contract publish.

**Next:** Start Phase 2 with its entry review and open decisions.

## 2026-07-02 — Codex — process follow-up

**Did:** Updated the plan process docs to require lesson/prior-phase review
before starting a phase, full agent/code review before closing a phase, and one
local commit per phase. Reconciled Phase 2/Phase 4 wording that still implied
extra commits.

**Decisions:** One commit per phase is now the default. If another rule appears
to require splitting commits, stop and ask Leo before committing.

**Blocked/open:** None.

**Next:** Phase 1 can start after its entry review and open decisions.

## 2026-07-02 — Codex — Phase 0

**Did:**
- Merged `origin/main`, unpinned `packages/mix_schema` from the git-SHA `ack`
  dependency to `ack: ^1.0.0`, and verified against the published package.
- Made the shared `builtInMixSchemaContract` registry-free for icon/image, added
  explicit guidance failures for missing registry-backed branches, and kept
  `MixSchemaContractBuilder().builtIn()` as the full branch set for consumers
  that build their own contract.
- Added the empty-contract `StateError`, the `mixSchemaVersion`/pubspec guard,
  public API docs for the consumer-facing contract/error/registry surface, and
  updated `README.md`/`WIRE_CONTRACT.md`.
- Updated tailwinds to use its own full built-in contract for runtime payload
  decoding, documented the mix core changelog entries, deleted the stray iml
  file, and applied a narrow `mix_lint` DCM cleanup needed after syncing main.
- Full gate passed: `melos run gen:build && melos run ci && melos run analyze`.

**Decisions:**
- D0.1 uses Option 2: the singleton excludes registry-backed icon/image, while
  `builtIn()` remains complete.
- Generated tailwinds `card` spacing/radius keys stay until their generator
  input is available; generated files were not hand-edited.
- DCM dev-deps for `mix_schema`/`mix_tailwinds` are deferred because trial
  enablement exposed package-wide pre-existing style debt outside Phase 0 scope.

**Blocked/open:** None for Phase 0.

**Next:** Start Phase 1 by resolving its open decisions before changing code.

## 2026-07-02 — Claude (Fable, clean-sheet review session) — planning

**Did:**
- Completed a clean-sheet review of `feat/mix_schema` (multi-agent: 3 explorers,
  baseline verification, 4 evidence probes on Sonnet, 1 isolated clean-sheet
  designer on Fable, synthesis by lead). Findings snapshot committed to
  `plan/findings.md` (the working session's original scratch copy lived in a
  gitignored `.context/` path and is not otherwise available).
- Baseline verified green before judging: mix_schema 163/163, mix_tailwinds
  477/477, mix scoped 199/199, mix_generator 257/257; `dart analyze` + DCM clean.
- Verdict: **Redesign at the contract level** — keep skeleton/engine/tests,
  replace policies (tokens, versioning, single-source encode, frozen registry),
  realign tailwinds' runtime payload round-trip to test-time.
- Created this `plan/` folder: README, findings.md, phase0–phase5 requirement
  docs with checklists, lessons.md, session.md.

**Decisions (from the review, carried into the plan):**
- Keep ack as the engine (stable 1.0.0 exists on pub.dev; swap the git-SHA pin);
  hide `AckSchema` from the public extension API instead of replacing the engine.
- Keep existing wire spellings (`w100`, `scrolled_under`, …); apply
  "wire names = Dart names" only to new vocabulary.
- Build the drift ratchet (phase 2) **before** coverage expansion (phase 4) —
  its first run generates the coverage backlog.
- Calibrated targets (Leo): anchor = preset packages (tailwinds); design targets
  = server-driven styling + shared tokens (defined separately, referenced on the
  wire, resolved via MixScope inheritance); extensibility check = future widget-
  tree document layer (separate package, composes on top).

**Blocked/open:**
- Upstream coordination with btwld/ack `flutter_codec` (overlaps
  `common_codecs.dart`) — decide before phase 4 grows that file further.
- Tailwinds runtime decode cost unmeasured — phase 5 starts with a benchmark.
- Publishing intent/timing for mix_schema — affects whether phase 1 moves first.

**Next:** Phase 0 — resolve its open decisions (singleton icon/image fix shape),
then execute its checklist.

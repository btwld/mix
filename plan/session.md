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

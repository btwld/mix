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

## 2026-07-03 — Codex — follow-up drift cleanup

**Did:** Implemented the review follow-up for `mix_schema`: identity value
forms now preserve `IconData.fontFamilyFallback` plus supported `NetworkImage`
state, unmodeled image state fails encode, lenient repair removes nested enum
drift at the smallest safe path, one-item `$merge` carriers collapse after
lenient directive cleanup, and box-shadow token encode failures now mirror
shadow-list handling. The delegated Dart/Flutter review found the same
one-source `$merge` collapse issue after invalid `$merge` source removal; fixed
that edge with a regression test too.

**Decisions:** Keep `NetworkImage.headers` and `AssetImage.bundle` fail-loud
instead of adding arbitrary-map or bundle identity wire forms. Leave Tailwinds
unchanged because the follow-up review did not find an actionable Tailwinds
issue.

**Verification:** Focused follow-up suite passed:
`fvm flutter test test/resolver_options_test.dart test/format_v1_contract_test.dart test/property_grammar_codec_test.dart test/token_codec_test.dart test/schema_export_golden_test.dart --reporter expanded`
reported `+91`. Full gate passed:
`melos run gen:build --no-select`, `melos run ci --no-select`,
`melos run analyze --no-select`, and `git diff --check origin/main...HEAD`.
Targeted `ast-grep` scans found no stale `_removeEmptyApplyList` calls and
confirmed the box-shadow token guard shape.

**Blocked/open:** None.

**Next:** Push/open PR when ready.

## 2026-07-03 — Codex — drift closeout

**Did:** Closed the attached drift plan without compatibility shims. Tightened
`mix_schema` runtime/schema/WIRE behavior for theme aliases, directive params,
numeric constraints, token terms, single-item `$merge`, theme text styles, and
schema vocabulary. Removed the unpublished `encode.dart` entry point and moved
payload helpers to `mix_schema/testing.dart`. Updated Tailwinds basis warnings
and made the parser registry regenerate deterministically from a committed
compact snapshot.

**Decisions:** Keep `mix_schema` unpublished and allow the no-legacy cleanup;
do not restore old `TwConfig` helpers; keep unsupported percentage/full basis
out of scope; document the Phase 5 benchmark harness as ephemeral and rely on
the runtime import/bypass tests as durable guardrails.

**Review:** Full diff review found one schema-export gap before closeout:
double-valued nested fields modeled by exported literal schemas and double-field
`$merge` sources still rejected token `kind`. Fixed the exporter and added
schema golden coverage for nested text/strut double fields and merge sources.
A second pass found that a one-element `$merge` with `apply: []` bypassed the
single-source merge guard. Fixed runtime/schema/WIRE parity so present `apply`
lists must be non-empty.

**Verification:**
- Focused `mix_schema` drift suite passed (`+116`).
- Second-pass focused `$merge`/schema export tests passed (`+3`).
- Focused Tailwinds basis/registry suite passed (`+5`).
- Synced with `origin/main` via merge commit `5eeec23be`.
- Full gate passed: `melos run gen:build --no-select`,
  `melos run ci --no-select`, and `melos run analyze --no-select` all reported
  `SUCCESS`. The pub kernel-cache warning still printed, but each command
  exited 0; final analyzer rerun reported no Dart or DCM issues.

**Blocked/open:** None.

**Next:** Commit the drift closeout, then push when ready.

## 2026-07-03 — Codex — final plan audit

**Did:** Audited the completed plan against the status board, phase docs,
session log, lessons, and current git state after Phase 5 landed. Reconciled
two stale plan-doc signals: Phase 3's phase doc status now matches its completed
implementation/session evidence, and Phase 0's optional fold-ins now record
that S7 landed in Phase 5 while the helper-dedup preference is deferred
non-gating cleanup.

**Decisions:** Keep the final history shape as one Phase 5 implementation
commit plus the allowed retrospective/docs commit, matching the user's
retrospective-commit instruction; amend this reconciliation into that existing
retrospective/docs commit instead of adding a third closeout commit.

**Blocked/open:** None for the plan. `mix_schema` publishing remains
intentionally deferred until the tree-layer demo.

**Next:** Amend and force-with-lease push the existing retrospective/docs
commit, then verify the remote branch and close the goal.

## 2026-07-03 — Codex — Phase 5

**Did:**
- Completed Phase 5 consumer realignment: `mix_tailwinds` now builds stylers
  directly, no runtime `mix_schema` imports remain in the public/runtime path,
  payload producer duplication was removed, and flex-item helpers construct
  `FlexibleModifierMix` directly.
- Reshaped `mix_schema` public API around `mix_schema.dart`: shared
  `builtInMixSchemaContract`, wire vocabulary, owned `JsonMap`, per-call
  icon/image resolver and encode options, hidden Ack wrapper types, and
  `testing.dart` for payload helper support.
- Replaced public frozen-registry identity policy with resolver/value forms for
  icon/image, removed callback-over-wire support for animation `onEnd`, and
  reduced registry types to internal legacy support.
- Removed the Tailwinds gradient bypass. The default CSS-corner gradient path is
  now wire-representable via core `CssKeywordLinearTransform` and schema
  `css_linear` transform payloads, while `TwCssKeywordLinearTransform` remains a
  compatibility subclass.
- Restored `mix_tailwinds` semantic public API compatibility and added compile
  coverage for the kept barrel symbols.
- Ran the required delegated closeout review and addressed its doc finding by
  adding the Flutter icon tree-shaking caveat for raw `IconData` value forms.
  Closeout hardening also covered image `resolveImage` / `imageNames` success
  paths and fail-loud invalid CSS gradient directions.

**Decisions:**
- D5.1: retire Tailwinds runtime decode to test-time encode/validate checks.
- D5.2: drop `onEnd` callbacks from v1 wire; revisit callbacks in the future
  event/tree layer.
- D5.3: keep producer payload helpers as `mix_schema/testing.dart` and remove
  the unpublished `encode.dart` entry point.
- D5.4: restore the Tailwinds semantic compatibility facade.
- D5.5: keep MixSchema-prefixed option names.
- D5.6: keep `mix_schema` unpublished until the tree-layer demo; keep missing
  `v` warning-only for this internal phase.

**Verification:**
- Focused schema tests: `fvm flutter test test/resolver_options_test.dart
  test/box_styler_codec_test.dart --reporter expanded` passed (`+26`).
- Full package and focused consumer suites passed: full `packages/mix_schema`
  (`+306`), Tailwinds realignment/compatibility set (`+100`), visual parity
  goldens (`+6`), and Phase 5 benchmark (`+1`, 0 runtime schema imports, 0
  gradient bypasses).
- Final post-review gate passed: `melos run gen:build`, `melos run ci`, and
  `melos run analyze` all reported `SUCCESS`. `analyze` still printed sandbox
  pub-log write warnings but exited 0 after schema inventory, Dart analyze, and
  DCM succeeded.

**Blocked/open:** None for Phase 5. Publishing remains intentionally deferred
until the tree-layer demo.

**Next:** Push the completed phase commits.

## 2026-07-03 — Codex — Phase 4

**Did:**
- Completed Phase 4: `apply` directives, `$merge` source stacks, gradient
  codecs, expanded modifiers, spring/cubic animation support, context variant
  expansion, and remaining data-only field coverage.
- Regenerated `plan/coverage-backlog.md`; the manifest now has zero deferred
  entries and only `supported` / explicit v1 unsupported classifications.
- Added R4.8 closeout hardening: nested `TextStyleMix` / `StrutStyleMix` skew
  guards, explicit lenient-removal coverage for new list-valued fields, and
  token-first shadow-list encode so unresolved tokens report schema errors.
- Ran the required delegated closeout review and fixed its findings: nested
  text/strut/box-shadow fields now accept property terms, gradient fields are
  kind-specific and fail-loud, lenient repair keeps the smallest recoverable
  nested field/list entry, and JSON Schema export attaches property-control
  refs to representative nested fields instead of only defining them globally.
- Verified with focused R4.8 tests, the full `packages/mix_schema` suite, and
  the fresh full gate after review fixes: `melos run gen:build`,
  `melos run ci`, and `melos run analyze` all reported `SUCCESS`.

**Decisions:**
- Preserve explicit nested `context_not` variants instead of normalizing
  `not(not(x))`.
- Keep Flutter primitive codecs local for this phase; Ack's branch-only
  `flutter_codec` remains a reference, not a dependency.
- Treat decoration images, shape/directional border families, and
  `ElevationShadow` as explicit v1 unsupported coverage, not future deferred
  backlog.
- Gradient codecs are discriminated by `kind`: fields from another gradient
  kind are strict errors, while lenient mode removes only the incompatible
  nested field.
- Shared JSON Schema definitions are used for nested text-style, strut-style,
  and box-decoration literal shapes to avoid bloating the exported schema while
  still exposing field-level property-control branches. Runtime codecs remain
  authoritative for exact field-specific Flutter/Mix semantics.

**Blocked/open:** None for Phase 4.

**Next:** Commit Phase 4 as one local commit, then start Phase 5.

## 2026-07-02 — Codex — Phase 3

**Did:**
- Completed Phase 3 token-model work: public `MixSchemaBranch` /
  `MixSchemaRootSchema`, canonical `$token` decode/encode, theme document codec
  and JSON Schema export, token-reference preflight walker, breakpoint token
  variant coverage, and MixScope inheritance demos.
- Added the small public `tokenFromReferenceValue` helper in `packages/mix` so
  schema/tooling code can inspect unresolved token refs without importing
  internals, and documented the core changelog entry.
- Regenerated the coverage backlog after moving Phase 3 token constructs and
  breakpoint convenience variants to supported.
- Ran the required closeout review with a fresh delegated reviewer. Addressed
  all findings: field token reads are now opt-in, theme schema export is
  concrete-only below the whole-value alias layer, breakpoint variant token
  encode uses the shared canonical-token policy, and the inventory scanner
  recognizes the new token field helpers.
- Verified with fresh final gate output: `melos run gen:build`, `melos run ci`,
  and `melos run analyze` all reported `SUCCESS`.

**Decisions:**
- Theme documents remain a dedicated `type: "theme"` entry point outside the
  styler root union.
- Token field reads are explicit (`tokenValueField` / `tokenMixField`) instead
  of global defaults, so literal-only codecs keep failing loudly.
- Theme aliases are same-kind whole-value aliases only; nested theme token refs
  stay invalid at runtime and in exported schema.

**Blocked/open:** None for Phase 3.

**Next:** Start Phase 4 with its phase-entry review and open decisions before
property grammar work.

## 2026-07-02 — Codex — pre-Phase 3 feature-loss audit

**Did:**
- Reviewed the branch diff against `origin/main` for feature-loss risk before
  starting Phase 3. Runtime behavior risk is covered by the tailwinds
  characterization suite; public API surface risk needed an explicit owner.
- Ran `dart run tool/inventory_check.dart --check` in `packages/mix_schema`
  after the Phase 2.5 commit; it passed with 380 ids at
  `642c54fb7c32f48cbe04dfe0cce0bdd5069ee49f`.
- Ran targeted tailwinds characterization checks:
  `fvm flutter test test/tw_parser_characterization_test.dart
  test/schema_payload_contract_test.dart`; 116 tests passed.
- Found that `origin/main` exported `src/tw_semantic.dart` from
  `package:mix_tailwinds/mix_tailwinds.dart`, while the branch replaces that
  with `tw_types.dart`. Runtime semantics are preserved by tests, but public
  semantic-AST symbols (`TwValue`, `TwProperty`, `TwParsedClass`, plugin
  registry constants, preset maps, etc.) need an explicit Phase 5 compatibility
  decision.
- Updated Phase 5 with R5.8 and added a carry-forward lesson so this cannot be
  lost during tailwinds realignment.

**Decisions:** No code change needed before Phase 3. Treat the `tw_semantic`
export removal as a Phase 5 public API compatibility decision, not a blocker for
the token-model work.

**Blocked/open:** None for Phase 3 entry. Open for Phase 5: restore
compatibility facade vs document breaking alpha cleanup vs replace with a new
public API.

**Next:** Start Phase 3 with R3.0 first, then resolve D3.1-D3.3 before token
grammar work.

## 2026-07-02 — Codex — Phase 2.5

**Did:**
- Resolved D2.5.1-D2.5.4 after phase-entry review: Phase 3 owns AckSchema
  hiding first; lenient warnings preserve original payload paths; `v: null`
  fails as `unsupported_version`; `btwld/dart-actions` is pinned by SHA.
- Hardened `inventory_check.dart`: transitive tracked-base closure finds
  `style:IdentityStyle`, unknown enum-like field types fail loudly, dirty
  worktrees stamp `<sha>+dirty`, and supported styler-field manifest entries
  must have declared codec fields.
- Reclassified `TextStyleMix.$fontFeatures`, `TextStyleMix.$fontVariations`,
  and `WidgetModifierConfig.$orderOfModifiers` to Phase 4 deferred backlog;
  regenerated `plan/coverage-backlog.md`.
- Repaired contract/doc lockstep: `unsupported_encode_value`, styler-root-only
  skew guard guarantee, original lenient warning paths, 256-removal cap,
  null-version diagnostics, validate/decode warning parity, exact limit
  boundaries, composite-skew tests, and nested schema export `v` coverage.
- Ran the dummy drift demo with a temporary `Phase25ProbeStyler`; `dart run
  tool/inventory_check.dart --check` failed as expected with missing entries for
  `Phase25ProbeStyler.$animation`, `$modifier`, `$phase25Probe`, and
  `$variants`, then passed again after removing the probe.
- Pinned the reusable workflow to
  `btwld/dart-actions@9075ce1232ec77b8747953f2ff4a349190e5a805`.
- Full gate passed: `melos run gen:build && melos run ci && melos run analyze`
  (environment emitted pub cache kernel-format warnings, but each Melos step
  reported `SUCCESS` and the command exited 0).
- Fresh closeout review found four issues; all were addressed before phase
  close: broader enum-like detection, explicit Phase 3/Phase 5 AckSchema wrapper
  ownership, session/status logging, and numeric-key lenient path handling.

**Decisions:**
- `IdentityStyle` is classified `never`: resolved-spec identity style, not a
  serializable styler document.
- `orderOfModifiers` stays visible in Phase 4 as modifier codec expansion work.
- Dirty provenance is expected for phase-local regenerated backlog files before
  the phase commit exists.

**Blocked/open:** None for Phase 2.5.

**Next:** Start Phase 3 with R3.0 first: hide AckSchema behind mix_schema-owned
extension wrapper types before adding token grammar.

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

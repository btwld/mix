# Lessons Learned & Retrospective

Rollup across the plan. Fill the per-phase sections as each phase closes (source
material: the "Decision log & lessons" section inside each phase doc). Cross-cutting
insights go under **Themes**. Be honest — record what we'd do differently, not a
victory lap.

## Seeded from the review (2026-07-02, before execution)

Things the review itself surfaced that qualify as lessons already:

1. **Scope your contract to the problem, not the first consumer.** The wire
   contract's coverage converged on "what tailwinds needed minus gradients" —
   nobody decided that; it accreted. The drift ratchet (phase 2) exists so
   coverage becomes a deliberate decision (`supported` vs `knownUnsupported(reason)`)
   instead of an accident.
2. **A recommended API path must have a test that uses it.** The
   `builtInMixSchemaContract` icon/image failure was invisible because every test
   built its own registry-populated contract — the documented pattern was the one
   thing never exercised. Rule going forward: every usage pattern the docs
   recommend gets an end-to-end test.
3. **Encode semantics must be defined against values, not construction history.**
   `.width(1).merge(.height(2))` failing encode while the equivalent single
   constructor call succeeds taught us: policies keyed to `Prop.sources.length`
   leak implementation history into the contract.
4. **Dogfooding a format at runtime has a cost and an expiry.** Tailwinds' build-
   payload→decode loop was valuable while the contract was being proven; once
   gradients forced a bypass, the "everything we render is wire-representable"
   guarantee was already broken while the runtime cost remained. Re-evaluate
   dogfooding mechanisms once they stop guaranteeing what they were built to
   guarantee.
5. **Isolated redesign is cheap insurance.** The firewalled clean-sheet design
   converged on the existing skeleton (validating it) and diverged on exactly the
   policies the probes had flagged — one agent-day of work that turned "opinions"
   into corroborated findings.
6. **Agent claims need verification.** One exploration agent fabricated a website
   docs page (with a commit hash) that never existed in repo history. Every
   load-bearing claim in the review was re-verified against source or by dynamic
   probe before it reached the verdict.

## Per-phase retrospectives

### Phase 0 — Land the branch honestly

- **Keep shared singletons honest about what they can decode.** The built-in
  contract API now separates the complete branch set from the registry-free
  singleton so documented producer paths do not depend on an empty registry.
- **Treat analyzer coverage expansion as its own cleanup.** Trial-enabling DCM
  for `mix_schema`/`mix_tailwinds` surfaced broad pre-existing style debt; adding
  the dev-deps belongs with a package-wide cleanup, not a correctness landing
  phase.
- **Do not patch generated artifacts without their source.** The remaining
  tailwinds `card` keys live only in generated output in this workspace, so the
  phase recorded the reason instead of hand-editing `default_theme.g.dart`.

### Phase 1 — Format v1 charter

- **Keep the envelope authoritative over branch payloads.** Root `v` is a
  contract boundary, not a styler field. Write it last during encode/schema
  export and cover custom branches that try to declare the same key.
- **Reparse after each lenient skip.** Removing multiple list entries from one
  stale validation pass can shift indices; one removal per parse attempt keeps
  warnings and retained data coherent.
- **Uniform null policy simplifies preflight.** Moving unbounded constraints to
  `"infinity"` lets the contract reject explicit JSON null before any field
  codec runs.
- **Do not assume the schema engine owns resource limits.** Ack handled a
  250-deep nested style probe, so untrusted-input depth/node caps belong in the
  contract wrapper.

### Phase 2 — Drift ratchet

- **Inventory coverage must compare owner fields, not wire aliases.** Composite
  stylers flatten `$box`/`$flex`/`$stack` into many wire keys, while simple
  stylers have metadata aliases such as `$modifier` -> `modifiers`. The skew
  guard now tracks owner-field names on schema fields and infers coverage from
  what the encoder actually declares.
- **AST ratchets should fail on unclassifiable source, not skip it.** Directive
  keys moved from regex discovery to analyzer extraction of static string
  getters; dynamic keys fail the inventory run so drift is visible.
- **Generated backlog writes must validate first.** `--write-backlog` now runs
  the same manifest exhaustiveness check before writing, so Phase 4 cannot start
  from a silently incomplete generated file.
- **Enum coverage needs an explicit source review.** Syntax-only analyzer passes
  catch local enum declarations, but Flutter enum field types need a maintained
  allowlist and manifest entries.
- **CI ratchets must be verified at the workflow boundary.** Adding a Melos
  script to `analyze` did not put the check on PRs until the GitHub workflow
  invoked the analyze chain explicitly.
- **Do not invent field names when runtime metadata cannot provide them.**
  Known inventory mismatches can name missing/stale fields; future runtime
  fields discovered only through `props.length` need structured expected/actual
  count diagnostics.
- **Entry-list manifests need duplicate tests, not just conflict tests.**
  Conflicting buckets and duplicate same-status entries are different failure
  modes and both should be readable in CI output.

### Phase 2.5 — Cross-phase review fixes

- **Inheritance closure must follow declarations, not generic arguments.** The
  inventory ratchet now walks direct supertypes transitively so second-level
  tracked subclasses are visible without mistaking generic type arguments for
  inheritance.
- **Generated provenance should admit dirtiness.** Regenerated backlogs now stamp
  `<sha>+dirty` when the worktree is dirty, which is honest for phase work that
  regenerates files before the phase commit exists.
- **Manifest truthfulness needs its own ratchet.** A `supported` styler-field
  entry now has to correspond to a declared codec field, so the manifest cannot
  silently overstate coverage.
- **Lenient diagnostics are consumer-facing coordinates.** Warning paths now map
  back to the original payload, and lenient cleanup has a 256-removal cap so
  opt-in repair cannot become an unbounded parse loop.

### Phase 3 — Token model
_(fill when closed)_

### Phase 4 — Property grammar + coverage
_(fill when closed)_

### Phase 5 — Consumer realignment + API reshaping
_(fill when closed)_

## Themes (cross-cutting, update as they emerge)

- Analyzer/tool coverage changes can be larger than the feature they accompany;
  scope them explicitly so correctness work does not inherit unrelated lint debt.
- Generated files need traceable inputs before cleanup work touches them.
- Phase boundaries need their own review loop: review lessons and prior phase
  decisions before starting, then run a full agent/code review after the phase
  appears complete but before marking it completed.
- One commit per phase keeps review, rollback, and handoff at the same
  granularity as the plan. Older "separate commit" instincts should become
  explicit stop-and-ask moments, not unilateral splits.
- Wire-format envelope keys are reserved across built-in and custom branches;
  custom extension points need regression tests for those contract boundaries.
- Inventory tools need tests for their own blind spots: alias fields, dynamic
  directive keys, missing/stale/conflicting manifest entries, and generated
  artifact validation.
- Ratchets that claim PR coverage must be traced through the actual GitHub
  workflow path, not just local Melos scripts.
- Checked boxes rot: a doc-lockstep claim verified at one phase close can be
  invalidated by later edges or missed cases; cross-phase reviews re-verify
  predecessor claims (phase 2.5 exists because of this).

## Carry-forward actions

| Lesson | Owner | Action |
|--------|-------|--------|
| Coverage should be a decision, not an accident. | Phase 2 | Inventory output and the coverage backlog must be generated deterministically, classify every reviewed gap, and record enough provenance that later agents know what produced it. |
| Recommended API paths need tests. | Every phase | Any README/WIRE_CONTRACT usage path introduced or recommended in a phase gets an end-to-end test in the same phase. |
| Encode semantics must be value-based, not construction-history-based. | Phase 4 | The `$merge` work must keep named construction-history regressions and resolution-equivalence tests, not just byte round-trips. |
| Runtime dogfooding has an expiry. | Phase 5 | Benchmark before deciding, then move the schema guarantee to test-time unless data justifies keeping runtime decode. |
| Generated files need traceable inputs. | Phase 2 / Phase 4 | Generated backlog or schema artifacts need a source/tool header; if the input is missing, record the blocker instead of hand-editing generated output. |
| Phase boundary checks prevent stale assumptions. | Every phase | Run the lesson/prior-decision entry review before work and the full agent/code review before closeout. |
| CI ratchets need workflow-level proof. | Every phase | Before marking a check as "runs on every PR", inspect the workflow path and verify it invokes the relevant Melos chain. |
| Root/control keys are reserved contract boundaries. | Phase 3 / Phase 4 | `$token`, `$merge`, `apply`, and future control markers need collision/unknown-marker tests analogous to the Phase 1 custom-branch `v` test. |
| Missing `v` is a transition compromise. | Phase 5 / publish checkpoint | Before publishing the v1 contract, explicitly decide whether to flip missing `v` from warning to fatal and update tests/docs together. |
| Lenient granule grammar lives away from codec owners. | Phase 4 | Every new list-valued wire field gets an explicit lenient-removal granule and a loud test; review `_lenientRemovalPath` when adding families. `[review X12]` |
| Manifest `supported` must be provably true. | Phase 2.5 | Land the manifest↔codec truthfulness test so a false `supported` entry fails CI; keep it green thereafter. `[review X10]` |
| Cross-phase reviews complement closeout reviews. | Post-phase-4 milestone | Per-diff closeout reviews missed cross-phase contract drift (X3/X4 survived two closeouts); run the next cross-phase review after phase 4 lands. |
| Runtime parity does not prove public API compatibility. | Phase 5 | Before tailwinds realignment lands, compare `package:mix_tailwinds/mix_tailwinds.dart` against `origin/main` and explicitly decide the fate of the removed `tw_semantic.dart` symbols. |

## Decisions we reversed (and why)

| Date | Original decision | Reversal | Why |
|------|-------------------|----------|-----|
| 2026-07-02 | `TextStyleMix.$fontFeatures` / `$fontVariations` were classified `never: runtime-only`. | Reclassified as `deferred: phase 4 - codec coverage backlog`. | `FontFeature(String, [int])` and `FontVariation(String, double)` are const data and already named by Phase 4 coverage work, so hiding them from the backlog was wrong. |
| 2026-07-02 | `WidgetModifierConfig.$orderOfModifiers` was classified `never: internal or merge-control implementation detail`. | Reclassified as `deferred: phase 4 - modifier codec expansion`. | Phase 4 R4.4 plans `modifierOrder` support, so the inventory backlog must keep this visible until that decision is implemented or explicitly revised. |

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
_(fill when closed)_

### Phase 2 — Drift ratchet
_(fill when closed)_

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

## Decisions we reversed (and why)

| Date | Original decision | Reversal | Why |
|------|-------------------|----------|-----|
| | | | |

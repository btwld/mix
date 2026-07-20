# BorderDirectionalMix Optimization Investigation Design

Date: 2026-07-19
Status: Completed; candidate rejected at the directional stage gate
Branch checkpoint: `7d9433d70`

## Purpose

Determine whether resolving one shared uniform side in `BorderDirectionalMix`
is a safe and reproducible rendering-pipeline optimization. The investigation
must measure a workload that genuinely executes `BorderDirectionalMix`; the
accepted `BorderMix` result is supporting context, not evidence for this
candidate.

The final repository state must contain either:

- an accepted, verified production optimization with supporting raw evidence;
  or
- the exact baseline production implementation, generally useful directional
  benchmark instrumentation, and a documented rejection.

No commit, push, or pull-request action is part of this investigation.

## Final outcome (2026-07-20)

The approved experiment completed as designed. The manual directional resolver
improved the direct merged-border stage by 21.89% static and 47.89% all-active,
both 6/6, but the containing static premerged-spec stage regressed 3.79% in 0/6
wins and failed Gate 2. The 20-pair primary, profile, and cadence gates were not
run. Production and generated files were restored byte-for-byte to the frozen
baseline; only the generally useful directional selector, fixtures, metadata,
stage support, and behavior contracts remain.

## Authoritative Baseline

The experiment begins from the clean `chore/benchmarking` checkpoint
`7d9433d70`, synchronized with `origin/chore/benchmarking`. The accepted
`BorderMix` uniform-side optimization remains in place. The rejected isolated
single-active variant helper must not be restored without materially new
evidence.

The following sources define the baseline and reporting conventions:

- `benchmarks/rendering_pipeline/FINDINGS.md`;
- `benchmarks/rendering_pipeline/INSTRUMENTATION.md`;
- `benchmarks/rendering_pipeline/README.md`;
- `.context/rendering-pipeline-session.md`; and
- preserved raw results under `.context/benchmark-results/`, especially the
  two uniform-border primary campaigns.

The branch has no pull request. Draft PR #976 remains based on `main`, and
draft PR #977 remains stacked on #976. This investigation does not modify
either PR or its worktree.

## Goals

1. Add a minimal physical-versus-directional border selector to the existing
   benchmark fixtures without changing S0/S2 lifecycle semantics.
2. Retain equivalent Flutter controls and deterministic card visuals.
3. Pin uniform and nonuniform `BorderDirectionalMix` behavior before changing
   production resolution.
4. Test the smallest attributable production candidate.
5. Decide acceptance or rejection from frozen binaries and predefined stage
   and primary gates.
6. Leave raw evidence, documentation, and the session handoff consistent with
   the final source.

## Non-goals

- Reopening the single-active variant experiment.
- General border, decoration, variant, allocation, or caching refactors.
- Treating a physical `BorderMix` workload as directional evidence.
- Timing both LTR and RTL as separate primary matrices.
  `BorderDirectionalMix.resolve` does not consume `TextDirection`; LTR and RTL
  remain correctness cases for the resulting Flutter `BorderDirectional`.
- Making mobile raster, energy, or missed-frame claims from this macOS CPU
  experiment.

## Chosen Approach

Add a border-geometry axis to the existing benchmark harness. The default is
`physical`, so current commands, scenarios, and historical interpretation stay
unchanged. Selecting `directional` changes only the card border representation:

- Mix uses `BorderDirectionalMix` sources;
- Flutter uses equivalent `BorderDirectional` values; and
- S0 and S2 retain the same cards, state transitions, renderer, frame clock,
  viewport, warmup, and measurement duration.

This is preferred to new `S0D`/`S2D` scenario labels because border geometry
is fixture configuration, not a new action. It is preferred to a separate
executable because the existing harness already owns fair Flutter controls,
fresh-case lifecycle, metadata, and result shape.

## Benchmark Architecture

### Shared border-geometry contract

Introduce a small `BenchmarkBorderGeometry` enum with `physical` and
`directional` labels and one strict parser. Unsupported labels fail before any
measurement. This type is shared by card fixtures, the release microbenchmark,
and the resolution-stage diagnostic.

The release microbenchmark accepts `--border=physical|directional` through
`BenchmarkRunOptions`. Omission means `physical`. The selected value is added
to `metadata.case_selection` and to each result record so a directional result
cannot be mistaken for the historical physical workload.

The resolution-stage executable has no runtime argument interface, so it reads
the same labels from a `BORDER_GEOMETRY` Dart define. Omission also means
`physical`. Its metadata records the selected geometry.

### Mix fixture

Both physical and directional style families are created outside timed work.
They have the same padding, background, radius, shadow, scale, variants,
animation, and colors. Only their border sources differ:

- physical styles use the existing `BorderMix`/`borderAll` path;
- directional styles use `BorderDirectionalMix.all` through the existing
  `border(BoxBorderMix)` API.

Base, hovered, and selected sources must all use the selected geometry. Tests
must resolve the styles and assert the final `BoxDecoration.border` runtime
type, preventing a partially converted fixture from passing unnoticed.

### Flutter fixture

Flutter continues to build the same `BoxSpec` consumed by
`SharedCardRenderer`. The directional mode constructs `BorderDirectional`
with the same uniform color, width, style, and stroke alignment as the physical
`Border`. No additional wrapper, resolver, state provider, or paint boundary is
introduced.

The timed app stays under its existing deterministic LTR `MaterialApp`.
Uniform sides make the rendered card identical in LTR and RTL. Separate
asymmetric correctness tests prove that `start` and `end` map to the expected
physical sides in both directions.

### Resolution-stage diagnostic

Keep the existing 34 stage labels. They are border-geometry-neutral and need
not be duplicated. Parameterize the realistic card fixture and the border
substage helpers so they accept exactly one configured border type.

Border extraction must fail if a fixture contains a physical/directional mix
or a type different from the selected geometry. Merging remains type-specific.
The uniform counterfactual and construction stages create either `Border` or
`BorderDirectional` as configured. Higher-level decoration, property,
premerged-spec, and full-build stages then automatically measure the same
directional fixture.

This design keeps the default physical 102-case protocol intact while allowing
targeted directional screens through existing profile and stage filters.

## Behavioral Contract and Test-first Candidate

### Clean baseline

Before adding the production candidate, run the existing focused border tests,
benchmark unit/widget tests, and focused analysis on the clean baseline. Record
the commands and results in the session handoff.

Add instrumentation tests while production remains unchanged, and make those
tests pass. Then add the desired uniform resolver-call test and run it against
the baseline. It must fail for the expected reason: a shared resolver is called
four times instead of once. Preserve that red output as the TDD baseline.

### Required production tests

Focused `BorderDirectionalMix` tests cover:

1. A shared uniform `BorderSideMix` containing a context token resolves the
   token exactly once and returns four equal logical sides.
2. A nonuniform mix retains `top`, `bottom`, `start`, and `end` values and the
   generated baseline's observable resolution order: bottom, end, start, top.
3. An empty mix returns the same default `BorderDirectional` behavior as the
   generated resolver.
4. An asymmetric resolved `BorderDirectional` maps start/end correctly under
   both `TextDirection.ltr` and `TextDirection.rtl`.
5. Existing constructor, merge, equality, lerp, and utility behavior remains
   green.

### Production candidate

Only `BorderDirectionalMix.resolve` changes. Mark generated resolution as
skipped and add a manual implementation parallel to the accepted `BorderMix`
shape:

- evaluate uniformity once;
- resolve one shared non-null side once;
- construct one uniform `BorderDirectional` from the resolved side;
- return the normal default for an empty mix; and
- preserve bottom/end/start/top per-side resolution for nonuniform input.

Run repository generation after the annotation change. Generated files must
contain no stale generated resolver or unrelated differences.

## Evidence Isolation

Instrumentation and tests are established before the production candidate.
Create exact source snapshots under a new ignored `.context` experiment
directory:

- `baseline`: directional instrumentation plus baseline generated production
  resolution;
- `candidate`: byte-identical instrumentation plus only the production
  candidate and its generated consequence.

Record a deterministic source manifest and SHA-256 digest for each snapshot.
Build release apps from those snapshots, move them to named immutable
`.context/benchmark-binaries/` paths, and record executable and embedded
Flutter framework hashes. Each result must carry the checkpoint SHA,
implementation label, Flutter revision, run ID, border geometry, build mode,
case selector, viewport, and host metadata.

Baseline and candidate comparisons use those frozen apps only. Rebuilding one
side mid-campaign invalidates the campaign.

## Gate Sequence

### Gate 1: correctness and static checks

Before timing:

- focused package tests pass, including the new resolver-call and direction
  contracts;
- benchmark selector, fixture, metadata, stage-protocol, and rebuild-contract
  tests pass;
- touched packages analyze cleanly; and
- generated output is current.

Any correctness failure stops timing.

### Gate 2: repeated directional stage screen

Run three adjacent baseline/candidate pairs in both forward and reverse order
for static and all-active profiles. Use the directional fixture and select the
smallest useful set of stages:

- `decoration_border_mix_merge` as an unchanged control;
- `decoration_border_merged_mix_resolve` as the direct target;
- `decoration_property_resolve`;
- `property_resolve`;
- `premerged_spec_resolve`; and
- `full_style_build`.

The direct target must improve in both process orders and in at least five of
six adjacent comparisons per profile. A containing stage or merge control is
materially regressed when both its aggregate and median-paired changes are at
least +1%, or when it is slower in at least five of six comparisons. Neither
profile may contain such a regression. Report aggregate, median-paired,
trimmed-mean, win-count, and order-split results. A failed stage gate rejects
the candidate before primary work.

### Gate 3: frozen directional primary workload

Run 20 adjacent pairs for each of S0 and S2. Every pair contains separate
fresh processes for:

- baseline Flutter;
- baseline Mix;
- candidate Flutter; and
- candidate Mix.

Alternate revision-first, scenario, and implementation order from a
deterministic schedule. Leave a two-second lifecycle gap after every process,
require the result-file marker, terminate/reap the runner, and confirm that no
workspace benchmark app remains before the next process.

Use matched Flutter adjustment to distinguish candidate movement from host
drift. For each scenario report raw Flutter and Mix aggregates plus adjusted
aggregate, median-paired, 20% trimmed mean, win count, and both revision-order
subsets.

The intended static S0 workload advances only when adjusted aggregate,
median-paired, and trimmed-mean deltas all improve, at least 12/20 pairs improve,
and order subsets do not contradict the aggregate conclusion. S2 is a
state-heavy non-regression control: no aggregate, median, or trimmed view may
regress by more than 0.5%, and at least 8/20 pairs must improve. The raw
candidate-versus-baseline Flutter aggregate and median changes must each stay
within +/-1%; otherwise the campaign is host-contended and must be labeled
invalid rather than adjusted into an optimization claim.

If these conditions are not met, reject the production candidate. Do not
extend a losing campaign selectively or reinterpret a stage-only win as a
whole-pipeline win.

### Stable-host and exclusion rules

Before every campaign:

- verify no stale benchmark app, `flutter run`, or driver process exists;
- use AC power and the same display/viewport configuration;
- identify the known competing Conductor renderer, suspend it only for the
  timing window, and install an unconditional resume trap; and
- record process and host preflight information.

Exclude a case only for a predefined validity failure: missing or malformed
result marker/file, metadata mismatch, wrong frozen binary, overlapping stale
benchmark process, interrupted lifecycle, or independently observed host
contention. Keep excluded evidence in a separately labeled directory with the
reason; never delete or silently replace it.

## Acceptance, Rejection, and Follow-up Gates

### Accepted candidate

Retain production code only when all three gates pass. If the adjusted primary
effect is at least 1% or at least 5 microseconds per S0 iteration, run a
proportional profile and release-cadence confirmation using the same
directional fixture. Do not make raster or frame-budget claims beyond what
those tracks directly measure.

Then run repository-level generation, relevant Flutter and Dart tests,
repository analysis, and fatal DCM verification. Investigate any failure;
never waive it because timing passed.

### Rejected candidate

Restore only the experimental production source and its generated consequence
to the exact instrumented-baseline manifest. Retain the geometry selector,
matched fixture, metadata, and generally useful tests. Skip profile and
release-cadence work. Re-run focused border tests, benchmark tests, generation
consistency, analysis, and fatal DCM on the retained state.

## Documentation and Handoff

Update all affected sources before declaring the investigation complete:

- `FINDINGS.md`: accepted or rejected verdict, exact statistics, validity
  limits, and raw paths;
- `INSTRUMENTATION.md`: directional question, fixture, stage screen, and
  conclusion;
- `README.md`: `--border=directional` and `BORDER_GEOMETRY=directional`
  commands if implemented;
- `.context/rendering-pipeline-session.md`: commands, manifests, binary hashes,
  raw-evidence paths, excluded cases, validation, final source state, and next
  recommendation.

At handoff, verify the process table is clear, inspect the complete diff for
unrelated changes, and state whether production was accepted or restored.

## Completion Conditions

The investigation is complete only when all of the following are true:

1. Valid raw directional evidence supports an explicit accepted or rejected
   verdict.
2. No unverified production experiment remains.
3. Generated files match the final annotations and source.
4. Required tests, analysis, and DCM checks pass at the scope dictated by the
   verdict.
5. Findings, instrumentation, commands, and session handoff agree with the
   source and evidence.
6. No benchmark process remains running.
7. The worktree is review-ready and has not been committed or published.

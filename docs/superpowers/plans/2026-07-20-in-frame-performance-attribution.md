# Plan: In-Frame Rendering Attribution

> Add compile-time-gated timing to the real Mix build path, quantify its
> observer overhead, and use a bounded release/AOT campaign to identify the
> largest remaining in-frame cost without promoting speculative production
> code.

## Objective

- Primary outcome: answer the next highest-value pending benchmark question by
  measuring real S0/S2 style, renderer, layout, and paint work inside one
  pumped frame, with matched Flutter controls and an explicit unlabeled
  residual.
- Out of scope: changing `VariantStyle`/`StyleVariation`, implementing a new
  production optimization, revisiting R1-R20, mobile/profile/cadence work, CI,
  commits, pushes, and PR changes.
- Constraint: use three local release pairs per scenario, keep Conductor
  running, do not stop unrelated applications, and preserve invalid/partial
  evidence separately.

## Execution outcome

Completed with the rollback verdict. The 24-process campaign had zero
exclusions, but the observer gate failed: +14.20% adjusted aggregate / +15.15%
paired median for S0 and +16.92% / +16.63% for S2, slower in 3/3 pairs for
both. Timing-order subsets agreed. The recorder and all local timing hooks were
removed, no optimization target was promoted, and tracked source is back at
`4269d387a`.

Two non-material deviations were recorded. The first attempted source snapshot
included ignored build artifacts and was rejected before any binary build; the
replacement contains the 660-file checkpoint plus exactly seven approved new
files. Fatal DCM was run on all new and production timing files; the existing
`style_builder_test.dart` was excluded from the fatal DCM command because it
already contains 40 unrelated findings, while its full analyzer and both test
modes passed.

## Context

- Clean source/upstream checkpoint:
  `4269d387abd4fc468f195b6b6750add67a307e07`.
- `packages/mix/lib/src/core/style.dart` proves that public `const
  VariantStyle` accepts `Style<S>` and dynamically discovers
  `StyleVariation<S>`. A non-breaking classification field already failed as
  R13, so a structural boundary requires a separate public API/migration
  design and is deferred.
- `packages/mix/lib/src/core/style_builder.dart` owns inherited-style assembly,
  `Style.build`, the renderer callback, and provider/modifier assembly on the
  real path.
- `packages/mix/lib/src/animation/style_animation_builder.dart` remains
  unmodified; its state/update/dispatch cost stays in the unlabeled residual.
- `benchmarks/rendering_pipeline/lib/microbenchmark.dart` owns warmups, S0/S2
  actions, one-frame iteration timing, result output, and fresh-case selectors.
- `benchmarks/rendering_pipeline/lib/scenarios/card_grid.dart` owns
  `SharedCardRenderer` and `PipelineProbe`; `flutter_card.dart` owns direct
  `_boxSpecFor` mapping; `mix_card.dart` supplies the existing `StyleBuilder`
  path.
- Existing correctness coverage is in
  `packages/mix/test/src/core/style_builder_test.dart` and
  `benchmarks/rendering_pipeline/test/rebuild_contract_test.dart`.
- R4 in `FINDINGS.md` is invalid because it subtracts separately pumped widget
  trees. This plan reports events from one iteration and does not reuse that
  method.

## Approach

Add a non-exported `MixBenchmarkTiming` utility guarded by the compile-time
`MIX_BENCHMARK_TIMINGS` boolean. `StyleBuilder` and `StyleSpecBuilder` call it
only inside const-guarded branches. The benchmark installs a synchronous sink
during measured iterations, combines Mix events with benchmark-local Flutter
mapping, shared renderer, layout, and paint events, and emits aligned
per-iteration stage arrays. The same instrumented source builds once with the
flag false and once with it true; their total-pump comparison measures observer
overhead before stage shares are interpreted.

- Alternatives considered:
  - Profile timeline spans — rejected for this step because they do not answer
    the requested release/AOT question directly.
  - Benchmark-only replicas of Mix builders — rejected because copied wrapper
    logic is not authoritative production-path attribution.
  - Structural variant payload redesign — deferred because it is a public
    compatibility project, not a bounded experiment.

## Compatibility and rollback

- Breaking change: no. The recorder is under `lib/src`, is not exported from
  `mix.dart`, and defaults off.
- Migration: none. The benchmark uses one explicit internal import and the
  release define.
- Normal builds: no result fields or timing sink are installed when the flag is
  false; const guards make timing bodies tree-shakeable.
- Rollback: if default behavior changes, code generation changes, contracts
  fail, or observer overhead exceeds the gate, restore
  `style_builder.dart` and remove the Mix recorder. Retain benchmark-local
  contracts only when useful without the invalid recorder.

## Work breakdown

- [x] Task 1: Freeze the clean pre-instrumentation baseline
  - Dependencies: None.
  - Files/evidence: read-only source plus
    `.context/benchmark-build-sources/in-frame-attribution-v1/pre-instrumentation/`
    and `.context/rendering-pipeline-session.md`.
  - Actions:
    - record branch/upstream SHA, status, Flutter/Dart revisions, production
      border hashes, power/display state, Conductor identity, and process table;
    - run current focused Mix builder tests, all benchmark tests, both
      analyzers, and `git diff --check`;
    - archive exact tracked source excluding `.git`, `.context`, `.dart_tool`,
      and build output; write sorted per-file SHA-256 and aggregate manifests.
  - Acceptance: the only worktree files are the approved uncommitted design and
    plan; baseline checks pass; no benchmark process exists.
  - Verification:
    - `cd packages/mix && fvm flutter test test/src/core/style_builder_test.dart`
    - `cd benchmarks/rendering_pipeline && fvm flutter test`
    - `cd packages/mix && fvm flutter analyze lib/src/core/style_builder.dart test/src/core/style_builder_test.dart`
    - `cd benchmarks/rendering_pipeline && fvm flutter analyze`
    - `git diff --check`
  - Scope: S.

- [x] Task 2: Implement the internal timing contract test-first
  - Dependencies: Task 1.
  - Files:
    - new `packages/mix/lib/src/core/internal/benchmark_timing.dart`;
    - new `packages/mix/test/src/core/internal/benchmark_timing_test.dart`;
    - `packages/mix/lib/src/core/style_builder.dart`;
    - `packages/mix/test/src/core/style_builder_test.dart` only for default-path
      and stage-contract coverage.
  - Actions:
    - first add failing tests for missing-sink no-op behavior, elapsed tick and
      frequency delivery, nested-depth cleanup, exception cleanup, and reset;
    - define the false-by-default `MIX_BENCHMARK_TIMINGS` const, the four Mix
      stage labels, synchronous sink, `measure`, depth, and reset/check APIs;
    - const-guard and time inherited-style assembly, `Style.build`, the user
      renderer callback, and provider/modifier assembly as non-overlapping
      bodies;
    - do not change animation behavior, style algorithms, constructors, or
      exports.
  - Acceptance: recorder tests fail for the intended missing contract before
    implementation, then pass; default `StyleBuilder` tests remain unchanged;
    no generated input changes.
  - Verification:
    - `cd packages/mix && fvm flutter test test/src/core/internal/benchmark_timing_test.dart test/src/core/style_builder_test.dart`
    - `cd packages/mix && fvm flutter analyze lib/src/core/internal/benchmark_timing.dart lib/src/core/style_builder.dart test/src/core/internal/benchmark_timing_test.dart test/src/core/style_builder_test.dart`
  - Scope: M.

- [x] Task 3: Add benchmark-local per-iteration attribution test-first
  - Dependencies: Task 2.
  - Files:
    - new `benchmarks/rendering_pipeline/lib/src/in_frame_timing.dart`;
    - new `benchmarks/rendering_pipeline/test/in_frame_timing_test.dart`;
    - new `benchmarks/rendering_pipeline/test/in_frame_timing_contract_test.dart`;
    - `benchmarks/rendering_pipeline/lib/scenarios/card_grid.dart`;
    - `benchmarks/rendering_pipeline/lib/scenarios/flutter_card.dart`;
    - `benchmarks/rendering_pipeline/lib/scenarios/mix_card.dart`.
  - Actions:
    - first add failing collector tests for begin/end lifecycle, zero-filled
      absent stages, out-of-iteration rejection, Mix-stage mapping, count and
      duration aggregation, and aligned JSON samples;
    - add an optional timing collector independent of `PipelineCounters` and
      thread it through `BenchmarkApp`, `BenchmarkGrid`, isolation cards,
      `SharedCardRenderer`, and `PipelineProbe`;
    - time direct Flutter spec mapping, shared renderer build, layout, and
      paint; route completed Mix events into the same active iteration;
    - wrap the render probe when either counters or timing is active while
      preserving the default null path;
    - characterize and pin scenario-specific S0/S2 stage counts rather than
      assuming layout or paint occurs in every iteration.
  - Acceptance: collector unit tests pass; timing-enabled widget contracts see
    the expected implementation/scenario stages; existing rebuild counts remain
    green with no collector.
  - Verification:
    - `cd benchmarks/rendering_pipeline && fvm flutter test test/in_frame_timing_test.dart`
    - `cd benchmarks/rendering_pipeline && fvm flutter test --dart-define=MIX_BENCHMARK_TIMINGS=true test/in_frame_timing_contract_test.dart test/rebuild_contract_test.dart`
  - Scope: M.

- Checkpoint A: instrumentation correctness
  - Run both default and timing-enabled focused suites.
  - Confirm no public export or generated file changed.
  - Confirm every recorded duration is nonnegative and each iteration closes
    with recorder depth zero.
  - Stop and correct the contract before release work if any stage/count is
    ambiguous.

- [x] Task 4: Integrate validated timing output into the release microbenchmark
  - Dependencies: Checkpoint A.
  - Files:
    - `benchmarks/rendering_pipeline/lib/microbenchmark.dart`;
    - `benchmarks/rendering_pipeline/lib/src/in_frame_timing.dart`;
    - relevant tests from Task 3.
  - Actions:
    - record `in_frame_timings_enabled` in metadata;
    - install the collector and Mix sink only around measured iterations, not
      mounting or warmups;
    - add `in_frame_timings` only to timing-enabled results, including stage
      counts, aggregate microseconds, and total-sample-aligned stage arrays;
    - validate no event occurs outside an active iteration and fail the process
      on incomplete state;
    - keep every existing result key and timing-disabled result shape intact.
  - Acceptance: a default smoke result has the flag false and no diagnostic
    section; a timing-enabled smoke result has valid aligned S0/S2 data.
  - Verification:
    - `cd benchmarks/rendering_pipeline && fvm flutter test`
    - `cd benchmarks/rendering_pipeline && fvm flutter analyze`
  - Scope: M.

- [x] Task 5: Verify, snapshot, and freeze disabled/enabled release apps
  - Dependencies: Task 4.
  - Files/evidence:
    - `.context/benchmark-build-sources/in-frame-attribution-v1/instrumented/`;
    - `.context/benchmark-binaries/in-frame-attribution-v1/`;
    - SHA-256/source manifests and smoke logs beside those artifacts.
  - Actions:
    - run formatting, full benchmark tests, focused Mix tests, both analyzers,
      fatal DCM, code generation, and diff checks;
    - require code generation to write zero outputs;
    - archive the exact instrumented source and manifest it;
    - build timing-disabled and timing-enabled macOS release apps from the same
      source with `BENCHMARK_SECONDS=3`, unique labels/run IDs, and Flutter
      revision `cc0734ac71`;
    - deep-verify signatures; record runner, AOT, Flutter framework, source
      manifest, and compile-time metadata hashes;
    - run one selected S0 smoke process per binary and validate result shape.
  - Acceptance: both frozen apps pass signature/hash/metadata checks; disabled
    output has no stage payload; enabled output is aligned and complete.
  - Verification:
    - `cd packages/mix && fvm flutter pub run build_runner build`
    - `cd packages/mix && dcm analyze lib/src/core/internal/benchmark_timing.dart lib/src/core/style_builder.dart test/src/core/internal/benchmark_timing_test.dart test/src/core/style_builder_test.dart --fatal-style --fatal-warnings`
    - `dart format --output=none --set-exit-if-changed packages/mix/lib/src/core/internal/benchmark_timing.dart packages/mix/lib/src/core/style_builder.dart packages/mix/test/src/core/internal/benchmark_timing_test.dart packages/mix/test/src/core/style_builder_test.dart benchmarks/rendering_pipeline/lib/microbenchmark.dart benchmarks/rendering_pipeline/lib/src/in_frame_timing.dart benchmarks/rendering_pipeline/lib/scenarios/card_grid.dart benchmarks/rendering_pipeline/lib/scenarios/flutter_card.dart benchmarks/rendering_pipeline/lib/scenarios/mix_card.dart benchmarks/rendering_pipeline/test/in_frame_timing_test.dart benchmarks/rendering_pipeline/test/in_frame_timing_contract_test.dart`
    - `git diff --check`
  - Scope: M.

- Checkpoint B: frozen evidence isolation
  - Disabled and enabled binaries must use the same instrumented source
    manifest and differ only in compile-time label/run ID/timing defines.
  - Do not rebuild either side after the first valid campaign process.
  - If smoke validation fails, invalidate both apps and rebuild a new versioned
    pair; never repair one side in place.

- [x] Task 6: Run and analyze the bounded release/AOT campaign
  - Dependencies: Checkpoint B.
  - Files/evidence:
    - new ignored `.context/run_in_frame_attribution_v1.sh`;
    - new ignored `.context/analyze_in_frame_attribution_v1.py`;
    - `.context/benchmark-results/in-frame-attribution-v1/`.
  - Actions:
    - syntax-check both helpers and verify analyzer formulas with a synthetic
      fixture before using measured data;
    - run three adjacent pairs each for S0/S2, four fresh processes per pair:
      disabled/enabled Flutter and disabled/enabled Mix;
    - alternate scenario, implementation, and timing-first order; use
      two-second lifecycle gaps, AC power, stale-process checks, exact result
      markers, and frozen hashes;
    - keep Conductor running and use only the existing reversible verified
      renderer suspension; record unrelated >=20% CPU events as limitations
      rather than stopping those applications;
    - reject malformed/partial processes, preserve them separately, and never
      include them in aggregates;
    - report raw and Flutter-adjusted overhead aggregate, paired median,
      20%-trimmed value, wins, and timing-order subsets; then report per-stage
      average/median/share/rank and unlabeled residual.
  - Acceptance:
    - all 24 required processes are valid or the entire versioned campaign is
      explicitly rejected;
    - attribution passes only if adjusted enabled overhead is <=5% for S0 and
      S2 aggregate and paired median, with no contradictory order subset;
    - a next target is named only if average/median rank agree, at least two of
      three pairs agree, and cost is material above recorder overhead.
  - Stop condition: if the overhead gate fails, do not reinterpret stage
    percentages; restore Mix instrumentation and document the method as
    rejected.
  - Scope: M due to process count, not source breadth.

- [x] Task 7: Apply the attribution verdict and complete the repository audit
  - Dependencies: Task 6.
  - Files:
    - `benchmarks/rendering_pipeline/FINDINGS.md`;
    - `benchmarks/rendering_pipeline/INSTRUMENTATION.md`;
    - `benchmarks/rendering_pipeline/PERFORMANCE_IMPACT_REPORT.md`;
    - `benchmarks/rendering_pipeline/README.md`;
    - this plan and the approved design;
    - `.context/rendering-pipeline-session.md`.
  - Actions:
    - if valid, retain the compile-time-gated recorder and benchmark collector,
      document exact shares/overhead/limitations, and rank the next measured
      target without implementing it;
    - if invalid, restore `style_builder.dart` exactly, remove the Mix recorder,
      retain only independently useful benchmark-local contracts, and document
      the rejection;
    - reconcile the complete disposition/opportunity matrix, exact raw paths,
      commands, hashes, exclusions, and remaining recommendations;
    - rerun verdict-proportional tests, code generation, analysis, fatal DCM,
      formatting, and `git diff --check`;
    - audit every design/plan completion condition, final diff, process table,
      Conductor state, and absence of commits/pushes/PR/CI changes.
  - Acceptance: source, generated state, tests, docs, raw evidence, and process
    state agree; no benchmark process remains; the worktree is review-ready and
    uncommitted.
  - Scope: M.

- Must stay sequential: all tasks share recorder/output contracts, frozen
  source, binary identity, and host measurement state.
- Safe to parallelize: none; parallel edits or measurements would contaminate
  the worktree or host.

## Test strategy

- Unit: Mix recorder lifecycle and benchmark collector aggregation/alignment.
- Widget: timing-enabled S0/S2 stage/count contracts plus all existing rebuild
  contracts.
- Release smoke: one selected S0 process from each frozen app before campaign.
- Measurement: three matched disabled/enabled pairs for S0 and S2, never a
  multi-case process for a small delta.
- Final verification: complete benchmark tests; focused Mix recorder/builder
  tests; both analyzers; fatal DCM; zero-output generation; formatting; diff and
  process audit.

## Risks and stop conditions

- Observer effect: event timing may distort the path — quantify disabled versus
  enabled first and reject shares above the 5% gate.
- Stage overlap: nested measurements would inflate totals — record only the
  non-overlapping bodies named in the design and test recorder depth.
- Missing layout/paint: Flutter may legitimately skip a phase — characterize
  scenario-specific counts and zero-fill absent per-iteration samples.
- Const gate fails to disappear: default source/binary inspection or behavior
  changes — restore Mix instrumentation and reject the method.
- Host activity: preserve host-event logs and matched controls; do not stop
  unrelated processes. Rebuild/rerun only a wholly invalid versioned campaign.
- No open user decision remains. The written design was approved before this
  plan.

## Rollout

- Flag: compile-time `MIX_BENCHMARK_TIMINGS`, default false.
- External rollout: none; this is local diagnostic instrumentation.
- Rollback: exact checkpoint restoration of Mix instrumentation plus retained
  benchmark-local evidence when independently valid.
- Communication: repository reports, approved plan/design, and ignored session
  handoff. No commit, push, PR, or CI action.

# Plan: BorderDirectionalMix optimization investigation

> Add a real directional-border workload, test one attributable resolver fast
> path, and retain or reject it from frozen stage and primary evidence.

## Objective

- Primary outcome: reach a defensible accepted or rejected verdict for resolving
  one shared uniform `BorderDirectionalMix` side once, with final source,
  generated files, raw evidence, findings, instrumentation notes, and session
  handoff all agreeing.
- Out of scope: the rejected single-active helper, unrelated decoration or
  variant refactors, allocation claims, publication, commits, pushes, and PR
  changes.
- Constraint: preserve checkpoint `7d9433d70` and the accepted `BorderMix`
  optimization. Stop new work and block the goal at 2:00 PM EST on Monday,
  July 20, 2026 if completion has not already been proved. Interpreting `EST`
  literally as UTC-5, this is 19:00 UTC / 3:00 PM EDT in the workspace locale.
- Approved design:
  `docs/superpowers/specs/2026-07-19-border-directional-mix-optimization-design.md`.

## Context

- `packages/mix/lib/src/properties/painting/border_mix.dart` contains the
  accepted manual `BorderMix.resolve` implementation and a generated
  `BorderDirectionalMix.resolve` path that resolves bottom, end, start, and top
  independently.
- `packages/mix/lib/src/properties/painting/border_mix.g.dart` is generated.
  Changing the `BorderDirectionalMix` annotation must remove only its generated
  resolver and preserve generated merge, diagnostics, and props behavior.
- `packages/mix/test/src/properties/painting/border_mix_test.dart` already
  proves the physical uniform-side call-count contract and contains the
  existing directional shorthand test.
- `benchmarks/rendering_pipeline/lib/scenarios/mix_card.dart` uses `borderAll`
  for base, hover, and selected sources. The current S0/S2 workloads therefore
  exercise `BorderMix`, not `BorderDirectionalMix`.
- `benchmarks/rendering_pipeline/lib/scenarios/flutter_card.dart` constructs
  the matched Flutter `BoxSpec` with `Border.all`.
- `benchmarks/rendering_pipeline/lib/scenarios/card_grid.dart` owns shared card
  data, lifecycle, renderer, `BenchmarkGrid`, and `BenchmarkApp`.
- `benchmarks/rendering_pipeline/lib/src/benchmark_run_options.dart` parses
  fresh-process implementation, scenario, and output selectors.
- `benchmarks/rendering_pipeline/lib/microbenchmark.dart` owns the release
  S0/S2 loop and case metadata.
- `benchmarks/rendering_pipeline/lib/resolution_stage_microbenchmark.dart`
  currently requires `BorderMix` sources in its border substages. Its existing
  34-stage protocol and profile/stage filters are defined in
  `benchmarks/rendering_pipeline/lib/src/resolution_stage_protocol.dart`.
- `benchmarks/rendering_pipeline/integration_test/state_transition_perf_test.dart`
  uses `BenchmarkApp` for optional profile/release-cadence work.
- `benchmarks/rendering_pipeline/test/benchmark_run_options_test.dart`,
  `benchmarks/rendering_pipeline/test/resolution_stage_protocol_test.dart`, and
  `benchmarks/rendering_pipeline/test/rebuild_contract_test.dart` define the
  current selector, stage-order, and lifecycle contracts.
- `.context/run_uniform_border_primary_ab.sh` is prior art for alternating
  revision/scenario/implementation order and two-second lifecycle gaps. The
  stable-host single-active handoff records the validated Conductor-renderer
  suspension procedure and excluded-data policy.
- `melos.yaml` defines repository generation, Flutter/Dart tests, Dart
  analysis, and fatal-style/fatal-warning DCM analysis.

## Approach

Add one additive `BenchmarkBorderGeometry` contract with `physical` and
`directional` values. Keep physical as the default. Thread the selected value
through the existing card workload, record it in result metadata, and
parameterize the existing border substages instead of duplicating scenario or
stage enums. After the instrumentation baseline is green, add the desired
resolver-call test, preserve its expected baseline failure, implement only the
manual directional resolver, and let the approved gates decide whether that
production change remains.

- Alternatives considered:
  - Add `S0D`/`S2D` scenarios — rejected because border representation is a
    fixture axis, not a different action, and duplicated scenario labels would
    spread through result tooling.
  - Add a second directional benchmark executable — rejected because it would
    duplicate lifecycle and Flutter-control logic and weaken comparability.
  - Infer the outcome from physical-border evidence — rejected because the
    current primary workload never executes `BorderDirectionalMix`.

## Compatibility and migration

- Breaking change: no. Benchmark callers that omit the selector remain on the
  physical workload.
- Migration path: additive runtime selector for the release microbenchmark and
  additive Dart define for stage/profile executables.
- Data migration: none.
- Production behavior: the candidate changes only repeated evaluation of one
  structurally shared uniform property. Nonuniform and empty cases must retain
  the generated baseline semantics and evaluation order.
- Rollback: remove the manual directional resolver, restore generated
  resolution through code generation, and verify production/generated hashes
  against the frozen instrumented baseline. Directional instrumentation may
  remain.

## Work breakdown

- [x] Task 1: Prove and record the untouched baseline
  - Dependencies: None.
  - Files: read-only source inspection plus
    `.context/rendering-pipeline-session.md` for the eventual command record.
  - Actions:
    - record `git status`, local/remote checkpoint SHAs, branch/PR topology,
      Flutter revision, host time/power/display state, and a clear benchmark
      process table;
    - run the existing Mix border tests and the benchmark selector, stage
      protocol, and rebuild-contract tests before source edits;
    - run focused analysis for the Mix border source/test and the benchmark
      package.
  - Acceptance: checkpoint `7d9433d70` is clean apart from approved design and
    plan documents; every baseline command is green; no stale benchmark process
    exists.
  - Verification:
    - `cd packages/mix && fvm flutter test test/src/properties/painting/border_mix_test.dart`
    - `cd benchmarks/rendering_pipeline && fvm flutter test test/benchmark_run_options_test.dart test/resolution_stage_protocol_test.dart test/rebuild_contract_test.dart`
    - `cd packages/mix && fvm flutter analyze lib/src/properties/painting/border_mix.dart test/src/properties/painting/border_mix_test.dart`
    - `cd benchmarks/rendering_pipeline && fvm flutter analyze`
  - Scope: S.

- [x] Task 2: Add the border-geometry contract and matched card fixture test-first
  - Dependencies: Task 1.
  - Files:
    - new `benchmarks/rendering_pipeline/lib/src/benchmark_border_geometry.dart`;
    - new `benchmarks/rendering_pipeline/test/benchmark_border_geometry_test.dart`;
    - `benchmarks/rendering_pipeline/lib/src/benchmark_run_options.dart`;
    - `benchmarks/rendering_pipeline/test/benchmark_run_options_test.dart`;
    - `benchmarks/rendering_pipeline/lib/scenarios/card_grid.dart`;
    - `benchmarks/rendering_pipeline/lib/scenarios/mix_card.dart`;
    - `benchmarks/rendering_pipeline/lib/scenarios/flutter_card.dart`;
    - `benchmarks/rendering_pipeline/lib/microbenchmark.dart`;
    - new `benchmarks/rendering_pipeline/test/border_geometry_contract_test.dart`;
    - update `benchmarks/rendering_pipeline/test/rebuild_contract_test.dart`
      only where constructors require the new additive value.
  - Actions:
    - write failing parser and fixture tests first;
    - parse `--border=physical|directional`, default to physical, reject unknown
      labels, and record the selected value in case metadata and each result;
    - create hoisted physical and directional Mix style families with matching
      base/hover/selected sources;
    - construct matched Flutter `Border` or `BorderDirectional` values without
      adding wrappers or timed style construction;
    - thread the value through `BenchmarkApp`, `BenchmarkGrid`, and both card
      implementations while keeping default call sites physical;
    - assert that resolved Flutter and Mix decorations use the selected border
      type and identical side values.
  - Acceptance: both modes satisfy the same rebuild/layout/paint contracts;
    directional S0/S2 resolve `BorderDirectional` in both implementations; the
    physical default is unchanged.
  - Verification:
    - `cd benchmarks/rendering_pipeline && fvm flutter test test/benchmark_border_geometry_test.dart test/benchmark_run_options_test.dart test/border_geometry_contract_test.dart test/rebuild_contract_test.dart`
    - `cd benchmarks/rendering_pipeline && fvm flutter analyze`
  - Scope: M.

- [x] Task 3: Parameterize the existing resolution-stage diagnostic
  - Dependencies: Task 2.
  - Files:
    - `benchmarks/rendering_pipeline/lib/resolution_stage_microbenchmark.dart`;
    - `benchmarks/rendering_pipeline/lib/src/benchmark_border_geometry.dart`;
    - `benchmarks/rendering_pipeline/test/benchmark_border_geometry_test.dart`;
    - `benchmarks/rendering_pipeline/test/resolution_stage_protocol_test.dart`
      only if a default-protocol assertion needs adjustment.
  - Actions:
    - parse `BORDER_GEOMETRY` with the shared strict parser and record it in
      metadata;
    - select the corresponding realistic card style;
    - generalize border extraction to the configured `BoxBorderMix` subtype,
      fail on mixed or unexpected types, merge with type preservation, and
      construct the corresponding uniform Flutter border;
    - keep all 34 labels and the default 102-case physical protocol unchanged.
  - Acceptance: unit tests prove selector/default/error behavior; a compile or
    smoke path reaches directional border substages without a `BorderMix` type
    failure; no new stage enum is introduced.
  - Verification:
    - `cd benchmarks/rendering_pipeline && fvm flutter test test/benchmark_border_geometry_test.dart test/resolution_stage_protocol_test.dart`
    - `cd benchmarks/rendering_pipeline && fvm flutter analyze`
  - Scope: M.

- Checkpoint A: instrumentation baseline
  - All benchmark tests pass and physical defaults remain unchanged.
  - Run `dart format --set-exit-if-changed` on touched Dart files after
    formatting them.
  - Create a fresh, explicit `.context` experiment directory; do not reuse or
    delete an older campaign directory.

- [x] Task 4: Pin directional behavior and preserve the expected red baseline
  - Dependencies: Checkpoint A.
  - Files: `packages/mix/test/src/properties/painting/border_mix_test.dart` and
    ignored evidence under `.context/benchmark-results/border-directional-v1/`.
  - Actions:
    - add tests for empty/default behavior, asymmetric logical sides and
      LTR/RTL mapping, nonuniform bottom/end/start/top resolver order, and one
      shared uniform context-token call;
    - run nonuniform/default/direction tests green on the generated baseline;
    - run the shared uniform call-count test against baseline and preserve the
      expected failure showing four calls instead of one;
    - snapshot the complete instrumented baseline source into a new ignored
      `.context/benchmark-build-sources/border-directional-v1/baseline/`
      directory, excluding `.git`, `.context`, `.dart_tool`, and build output;
    - write a sorted per-file SHA-256 manifest and an aggregate manifest hash.
  - Acceptance: the only red expectation is the intended one-versus-four call
    contract; the baseline snapshot contains the same tests and instrumentation
    that the candidate will use.
  - Final rejected-path outcome: the preserved red log retains the one-call
    candidate expectation; the live test now documents the restored baseline's
    four output-field resolutions.
  - Verification:
    - `cd packages/mix && fvm flutter test test/src/properties/painting/border_mix_test.dart --plain-name 'resolves directional shared uniform side only once'`
    - `cd packages/mix && fvm flutter test test/src/properties/painting/border_mix_test.dart --plain-name 'resolves nonuniform directional sides in generated order'`
    - `cd packages/mix && fvm flutter test test/src/properties/painting/border_mix_test.dart --plain-name 'resolves empty directional mix to default'`
    - `cd packages/mix && fvm flutter test test/src/properties/painting/border_mix_test.dart --plain-name 'maps directional start and end in LTR and RTL'`
  - Scope: S.

- [x] Task 5: Implement and verify the smallest production candidate
  - Dependencies: Task 4.
  - Files:
    - `packages/mix/lib/src/properties/painting/border_mix.dart`;
    - `packages/mix/lib/src/properties/painting/border_mix.g.dart` generated;
    - `packages/mix/test/src/properties/painting/border_mix_test.dart`.
  - Actions:
    - replace `@mixable` on `BorderDirectionalMix` with
      `@Mixable(methods: GeneratedMixMethods.skipResolve)`;
    - add a manual resolver parallel to `BorderMix.resolve`: evaluate
      `uniformBorderSide` once, resolve one shared side once, handle the empty
      default, and preserve bottom/end/start/top nonuniform evaluation;
    - run package generation and inspect the generated diff for removal of only
      the directional generated resolver;
    - run the complete focused border test file, analysis, and fatal DCM.
  - Acceptance: all directional and existing physical tests pass; resolver
    order/default semantics match baseline; generated output is current; no
    unrelated production code changes.
  - Verification:
    - `cd packages/mix && fvm flutter pub run build_runner build --delete-conflicting-outputs`
    - `cd packages/mix && fvm flutter test test/src/properties/painting/border_mix_test.dart`
    - `cd packages/mix && fvm flutter analyze lib/src/properties/painting/border_mix.dart test/src/properties/painting/border_mix_test.dart`
    - `cd packages/mix && dcm analyze lib/src/properties/painting/border_mix.dart test/src/properties/painting/border_mix_test.dart --fatal-style --fatal-warnings`
  - Scope: S.

- Checkpoint B: candidate correctness and isolation
  - Snapshot candidate source beside baseline and generate the same manifests.
  - Diff the snapshots. Outside expected manifests, candidate must differ from
    baseline only in `border_mix.dart` and its generated consequence.
  - If isolation or correctness fails, fix before any timing.

- [x] Task 6: Build frozen apps and execute the directional stage gate
  - Dependencies: Checkpoint B.
  - Files/evidence:
    - immutable apps under
      `.context/benchmark-binaries/border-directional-stage-v1/`;
    - runner and analysis helpers under `.context/`;
    - JSON/logs under
      `.context/benchmark-results/border-directional-stage-v1/`.
  - Actions:
    - build baseline/candidate forward and reverse release apps from their exact
      snapshots with `BORDER_GEOMETRY=directional`, three measured seconds,
      static/all-active profiles, and the six approved stage labels;
    - record application executable and embedded Flutter framework SHA-256
      values plus source manifest hashes;
    - preflight the process table and host, suspend only the verified Conductor
      renderer with an unconditional resume trap, and run three adjacent pairs
      in each order with lifecycle gaps;
    - validate every marker, metadata field, selected case count, positive
      sample count, binary identity, and exclusion reason;
    - calculate aggregate, median-paired, 20% trimmed mean, win count, and
      forward/reverse splits for both profiles and all selected stages.
  - Acceptance: the direct merged directional-border resolver improves in both
    orders and at least 5/6 comparisons per profile; no containing stage or
    merge control meets the predefined material-regression rule.
  - Stop condition: reject immediately on a failed stage gate; do not run the
    primary campaign.
  - Scope: M.

- [x] Task 7: Apply the primary-gate stop condition
  - Outcome: not executed because the valid Task 6 stage screen failed on a
    repeatable static premerged-spec regression.
  - Dependencies: Task 6 passing.
  - Files/evidence:
    - immutable apps under
      `.context/benchmark-binaries/border-directional-primary-v1/`;
    - deterministic runner/analysis helpers under `.context/`;
    - valid and separately labeled excluded data under
      `.context/benchmark-results/border-directional-primary-v1/`.
  - Actions:
    - build one exact baseline and candidate release microbenchmark app with
      matched build metadata;
    - run 20 adjacent pairs per scenario; each pair contains fresh baseline and
      candidate Flutter and Mix processes selected with
      `--border=directional`;
    - alternate revision-first, scenario, and implementation order, enforce
      two-second lifecycle gaps, require/reap result markers, and keep the host
      procedure identical to the valid stage screen;
    - report raw Flutter/Mix aggregates and matched-control adjusted aggregate,
      median-paired, 20% trimmed mean, win count, and order subsets.
  - Acceptance:
    - S0 adjusted aggregate, median, and trimmed mean all improve, at least
      12/20 pairs improve, and order subsets agree;
    - S2 has no aggregate/median/trimmed regression above 0.5% and at least
      8/20 pairs improve;
    - candidate-versus-baseline Flutter aggregate and median changes stay
      within +/-1%; otherwise label the campaign contended/invalid and rerun it
      from the start rather than cherry-picking cases.
  - Stop condition: reject production on a valid failed primary gate.
  - Scope: L due to process count, not code breadth.

- [x] Task 8: Apply the verdict and proportional follow-up
  - Dependencies: Task 6 failure or Task 7 completion.
  - Accepted path:
    - retain the candidate only if every promotion condition passes;
    - if adjusted S0 improves by at least 1% or 5 microseconds, thread the same
      geometry define through
      `benchmarks/rendering_pipeline/integration_test/state_transition_perf_test.dart`,
      record it in metadata, run proportional S2 profile confirmation, and run
      S0/S2 release-cadence confirmation from exact baseline/candidate sources.
  - Rejected path:
    - use `apply_patch` and generation to restore `border_mix.dart` and
      `border_mix.g.dart` to the baseline manifest exactly;
    - retain only generally useful selector, fixture, metadata, protocol, and
      behavioral instrumentation;
    - skip profile and release-cadence work.
  - Acceptance: source state matches the verdict, and no unmeasured production
    candidate remains.
  - Scope: S for rejection, M for accepted material follow-up.

- [x] Task 9: Complete repository verification, documentation, and audit
  - Dependencies: Task 8.
  - Files:
    - `benchmarks/rendering_pipeline/FINDINGS.md`;
    - `benchmarks/rendering_pipeline/INSTRUMENTATION.md`;
    - `benchmarks/rendering_pipeline/README.md`;
    - `.context/rendering-pipeline-session.md`;
    - this plan and the approved design only if actual protocol decisions
      changed.
  - Actions:
    - document exact stage/primary/profile/cadence numbers, hashes, manifests,
      valid/excluded raw paths, limitations, verdict, final production state,
      and next recommendation;
    - add release and stage directional commands to README;
    - run verdict-proportional focused checks, then repository generation,
      Flutter/Dart tests, analysis, and fatal DCM for an accepted candidate;
    - for a rejected candidate, prove the production/generated baseline hashes
      and run all retained-instrumentation tests plus focused analysis/DCM;
    - run `git diff --check`, inspect the complete diff and status, verify every
      completion criterion against authoritative evidence, and verify no
      benchmark/runner process remains.
  - Acceptance: findings, instrumentation, README, session, source, generated
    files, raw evidence, and process table agree; the worktree is review-ready
    and uncommitted.
  - Verification for accepted production:
    - `melos run gen:build`
    - `melos run ci`
    - `melos run analyze`
    - `git diff --check`
  - Verification for rejected production:
    - `cd packages/mix && fvm flutter test test/src/properties/painting/border_mix_test.dart`
    - `cd benchmarks/rendering_pipeline && fvm flutter test`
    - `cd packages/mix && fvm flutter analyze lib/src/properties/painting/border_mix.dart test/src/properties/painting/border_mix_test.dart`
    - `cd packages/mix && dcm analyze lib/src/properties/painting/border_mix.dart test/src/properties/painting/border_mix_test.dart --fatal-style --fatal-warnings`
    - `cd benchmarks/rendering_pipeline && fvm flutter analyze`
    - `git diff --check`
  - Scope: M.

- Must stay sequential: Tasks 1-8 share the benchmark contract, candidate
  source, frozen snapshots, and promotion decision. Documentation drafting may
  begin after results exist, but its final claims wait for the verdict.
- Safe to parallelize: none. Parallel edits or measurements would contaminate
  the shared worktree or stable-host timing protocol.

## Test strategy

- Unit:
  - strict geometry parsing/default/error cases in
    `benchmark_border_geometry_test.dart` and
    `benchmark_run_options_test.dart`;
  - existing forward/reverse/default stage protocol in
    `resolution_stage_protocol_test.dart`;
  - uniform call count, default, nonuniform order, and LTR/RTL behavior in
    `border_mix_test.dart`.
- Widget/integration:
  - physical/directional Flutter/Mix decoration equivalence in
    `border_geometry_contract_test.dart`;
  - unchanged S0/S2 lifecycle counts in `rebuild_contract_test.dart`;
  - conditional profile/release-cadence coverage through
    `state_transition_perf_test.dart` only for an accepted material result.
- Measurement:
  - three forward/reverse stage pairs before primary;
  - 20 matched fresh-process pairs per S0/S2 scenario after the stage gate;
  - no invalid case mixed into valid aggregates.
- Final verification: use the exact verdict-specific commands in Task 9 and
  preserve their output in the session handoff.

## Risks and stop conditions

- AOT code-shape movement can affect S2 even when S2 does not use the intended
  branch — mitigation: frozen matched Flutter controls and an explicit S2 stop
  rule.
- A fixture can claim directional mode while retaining one physical variant
  source — mitigation: resolve base/hover/selected fixture contracts and fail
  stage extraction on unexpected types.
- Baseline and candidate can drift during rebuilds — mitigation: immutable
  source snapshots, manifests, frozen binaries, and no mid-campaign rebuild.
- Background Conductor rendering can dominate small effects — mitigation: use
  the previously validated reversible suspension procedure, record preflight,
  and label contention separately.
- Generated code can hide an unintended behavior change — mitigation: inspect
  the generated diff and test empty/nonuniform evaluation explicitly.
- The deadline can arrive before proof is complete — mitigation: stop starting
  new cases with enough margin to reap the current process, preserve partial
  evidence as incomplete, ensure the renderer is resumed, clear benchmark
  processes, update the handoff, and block the goal at the requested time.
- Open questions: none. Promotion thresholds and the LTR timing choice are
  fixed by the approved design.

## Rollout

- Feature flag: none. The benchmark selector is additive and defaults to
  physical; the production resolver is retained only after all gates.
- Staged deployment: no external deployment is authorized.
- Rollback: exact baseline production/generated restoration plus focused
  retained-instrumentation verification.
- Communication: repository findings, instrumentation notes, README commands,
  and the `.context` session handoff. No commit, push, or PR action.

## Post-plan combined evidence audit (2026-07-20)

The later review did not reopen the rejected directional candidate or change
this plan's design. It directly compared clean pre-optimization commit
`2140e609d` with current accepted commit `38511e842` using a deliberately
bounded local release protocol: three matched fresh-process pairs each for S0
and S2, alternating order, three measured seconds, matched Flutter controls,
and strict binary/result validation.

Campaign `combined-accepted-quick-v8` completed 24/24 valid processes. Adjusted
S0 improved 11.56% aggregate / 11.94% median-paired with 3/3 wins. Adjusted S2
improved 1.41% / 1.79% with 2/3 wins and is classified as noisy rather than a
strong speed claim. Conductor remained open by explicit user request; its
renderer was suspended only for timing, and two transient non-Conductor CPU
bursts were recorded. This evidence updates the combined performance picture
without changing production source or the directional rejection verdict.

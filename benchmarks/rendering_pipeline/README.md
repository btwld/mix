# Mix rendering-pipeline benchmarks

This isolated Flutter app compares Mix with an equivalent Flutter implementation
without adding timing work to the normal Mix package test suite. It targets the
repository-pinned Flutter 3.41.7 and Dart 3.11.

The first results are characterization data, not regression thresholds or
marketing claims. Compare absolute frame-budget impact as well as ratios; a
large ratio over a tiny baseline can still be immaterial.

## Pipeline references

- [Mix styling and rendering pipeline](../../guides/mix-styling-rendering-pipeline.md)
  documents the framework stages and implementation map.
- [Rendering-pipeline instrumentation](INSTRUMENTATION.md) maps those stages to
  primary measurements, diagnostic counters, confirmed behavior, and the
  quick-win experiment queue.
- [Investigation findings](FINDINGS.md) records valid and invalid datasets,
  accepted and rejected optimizations, and the remaining cost map.
- [Performance impact report](PERFORMANCE_IMPACT_REPORT.md) synthesizes the
  Flutter/Mix comparison, state-change behavior, remaining bottlenecks, and
  practical frame-budget impact. Its responsive web companion is available at
  <https://mix-rendering-performance.leo510228.chatgpt.site>.

## What is measured

The benchmark uses a deterministic 60-card `GridView.builder` inside a fixed
1200×800 logical viewport. About 24 cards are fully visible and a fifth row is
partially visible at the initial scroll position. Every card uses the same
cached content widget: icon, title, subtitle, badge, padding, rounded
decoration, border, and shadow. There is no network access or image decoding.

Two complementary tracks are available:

- **Isolation:** Flutter and Mix consume the same `WidgetStatesController` and
  render through the same `SharedCardRenderer`. The only intentional difference
  is Flutter's state mapper versus Mix's `StyleBuilder<BoxSpec>` pipeline.
- **Idiomatic:** Flutter uses matched gesture, mouse, focus, cursor, and
  semantics wrappers; Mix uses `Pressable` plus `StyleBuilder<BoxSpec>`. This
  includes normal automatic interaction ownership.

`RepaintBoundary` is placed once around every card in both implementations.
Styles, immutable configuration, and child widgets are hoisted out of timed
builds. Contract counters are nullable and are not installed in timed runs.

| Scenario | Action | Timed layer |
| --- | --- | --- |
| S0 | Rebuild the static grid. | Release CPU microbenchmark |
| S1 | Toggle hover on state-free and pressed-only cards. | Contract + release CPU microbenchmark |
| S2 | Toggle one card's pressed and selected states. | Contract + release/profile |
| S0I | Rebuild the static grid through idiomatic wrappers. | Idiomatic release CPU microbenchmark |
| S1I | Toggle irrelevant hover through idiomatic providers. | Contract + idiomatic release CPU microbenchmark |
| S3 | Sweep a real mouse pointer over visible cards. | Idiomatic profile track on macOS |
| S4 | Alternate hover/press every frame with a 150 ms `easeInOut` animation. | Isolation profile track |
| S5 | Change one inherited `ThemeData` color seed. | Isolation profile track |

Use precise pipeline terms in reports:

- **Rebuild:** a widget builder or Mix resolver/builder executes.
- **Layout:** a render object runs `performLayout`.
- **Paint:** a render object paints again.
- **Raster:** the engine raster thread processes the layer tree.
- **Frame latency:** `FrameTiming.totalSpan`, from vsync through raster
  completion.

## Files

```text
lib/main.dart                                  manual scenario app
lib/scenarios/card_grid.dart                   data, grid, shared renderer, probes
lib/scenarios/flutter_card.dart                Flutter isolation/idiomatic cards
lib/scenarios/mix_card.dart                    Mix isolation/idiomatic cards
lib/microbenchmark.dart                        release S0-S2 and S0I-S1I
lib/variant_microbenchmark.dart                diagnostic 0/1/4/12 variant probe
lib/resolution_stage_microbenchmark.dart       diagnostic merge/resolve/full-build split
lib/allocation_microbenchmark.dart             retained-result heap target
lib/post_build_microbenchmark.dart             exploratory wrapper probe; timing inconclusive
lib/src/allocation_benchmark_protocol.dart     allocation target/driver protocol
lib/src/allocation_profile_summary.dart        per-class retained-delta summary
lib/src/benchmark_case_host.dart               persistent root for replacing timed cases
lib/src/benchmark_frame_clock.dart             monotonic synthetic frame clock
lib/src/benchmark_frame_guard.dart             exclusive manual-frame ownership
lib/src/benchmark_run_options.dart             fresh-process case selectors
lib/src/resolution_stage_protocol.dart         diagnostic stage/order contract
test/rebuild_contract_test.dart                strict rebuild/layout/paint contracts
test/benchmark_case_host_test.dart              case replacement/disposal contract
test/benchmark_frame_clock_test.dart           cross-case clock contract
test/benchmark_run_options_test.dart            selector parsing contracts
test/allocation_benchmark_protocol_test.dart   stage-order contract
test/allocation_profile_summary_test.dart      class-delta summary contract
test/resolution_stage_protocol_test.dart       resolution-stage order contract
integration_test/state_transition_perf_test.dart  profile S2-S5 benchmark
test_driver/perf_driver.dart                   raw JSON writer
tool/allocation_driver.dart                    external VM-service heap profiler
tool/compare_results.dart                      Mix-minus-Flutter comparison
```

## Setup and contract tests

Run commands from this directory unless a command says otherwise.

```bash
fvm flutter pub get
fvm flutter test test/rebuild_contract_test.dart
fvm flutter test test
fvm flutter analyze
```

The contract suite asserts that:

- hover does not rebuild or resolve a state-free Mix card;
- hover does not rebuild or resolve a pressed-only Mix card;
- a declared target state resolves/rebuilds and paints the target only;
- an external controller does not rebuild, lay out, or paint unrelated
  siblings;
- two S2 notifications coalesce into one Mix resolution; and
- idiomatic press resolves once per pressed-state transition.

These are pass/fail correctness gates, not timing claims.

## Required metadata

Comparison runs must supply the repository and Flutter revisions. Defaults are
`unknown` so ad-hoc local runs remain possible, but such output is not suitable
for a comparison report.

```bash
MIX_SHA=$(git -C ../.. rev-parse HEAD)
FLUTTER_REVISION=$(fvm flutter --version --machine | jq -r .frameworkRevision)
```

Every result records the run ID/order, Mix SHA and label, Flutter revision,
timestamp, OS, build mode, physical resolution, pixel ratio, refresh rate,
fixed logical viewport, locale, brightness, text scale, and animation contract.
Pass a stable device label with `--dart-define=DEVICE_NAME=<label>`.

## Release CPU microbenchmark

Debug/JIT results are invalid. This harness follows Flutter's
`benchmarkWidgets` plus `LiveTestWidgetsFlutterBindingFramePolicy.benchmark`
and `pumpBenchmark` pattern. It keeps one mounted root, enters benchmark policy
once, shares one monotonic synthetic clock, and detaches engine begin/draw
callbacks while manual frames own the binding. The final guard passed 30
independent release stress processes without a frame-pairing failure.

For small A/B deltas, run one implementation/scenario per fresh process. A
multi-case process is useful as a smoke test, but later cases can inherit heap
and GC phase from earlier cases. Runtime selectors avoid rebuilding the binary
for every case on desktop.
The harness warms each case for 100 iterations, measures for a fixed duration,
then emits every raw iteration plus average, median, p90, p99, worst, standard
deviation, and sample count in microseconds.

```bash
fvm flutter run --release -d macos -t lib/microbenchmark.dart \
  --dart-define=MIX_SHA="$MIX_SHA" \
  --dart-define=FLUTTER_REVISION="$FLUTTER_REVISION" \
  --dart-define=IMPLEMENTATION_LABEL=origin-main \
  --dart-define=DEVICE_NAME=benchmark-mac \
  --dart-define=RUN_ID=origin-main-01 \
  --dart-define=BENCHMARK_ORDER=flutter-first \
  --dart-define=BENCHMARK_SECONDS=3 \
  --dart-entrypoint-args=--implementation=mix \
  --dart-entrypoint-args=--scenario=S0 \
  --dart-entrypoint-args=--output="$(pwd)/../../.context/benchmark-results/origin-main-mix-s0-01.json"
```

Supported implementations are `flutter` and `mix`; supported scenarios are
`S0`, `S1`, `S2`, `S0I`, and `S1I`. Omit both selectors to run the complete
matrix. Runtime `--output` overrides `BENCHMARK_OUTPUT_PATH`; the default is
`$TMPDIR/rendering_pipeline_micro.json`. The app prints a short
`BENCHMARK_RESULT_FILE:` confirmation.

## Variant diagnostic microbenchmark

This Mix-only diagnostic rebuilds one `StyleBuilder` with 0, 1, 4, and 12
active interleaved context/widget-state variants. It is intended for paired
before/after variant-resolution experiments, not Mix-versus-Flutter claims.

```bash
fvm flutter run --release -d macos -t lib/variant_microbenchmark.dart \
  --dart-define=MIX_SHA="$MIX_SHA" \
  --dart-define=FLUTTER_REVISION="$FLUTTER_REVISION" \
  --dart-define=IMPLEMENTATION_LABEL=variant-experiment \
  --dart-define=DEVICE_NAME=benchmark-mac \
  --dart-define=RUN_ID=variant-experiment-01 \
  --dart-define=BENCHMARK_SECONDS=3 \
  --dart-define=BENCHMARK_OUTPUT_PATH="$(pwd)/../../.context/benchmark-results/variant-experiment-01.json"
```

## Resolution-stage diagnostic microbenchmark

This Mix-only diagnostic uses realistic card styles and measures synchronous
batched paths across both the complete pipeline and variant-merge sub-stages:

- a store-only harness control;
- active-variant predicate evaluation and collection;
- stable widget-state priority sorting of a preselected list;
- active-style extraction from a presorted list;
- context-builder extraction from preselected builder variants;
- ordinary-style extraction with the production StyleVariation check;
- ordinary-style extraction with a raw StyleVariation prefilter;
- ordinary-style extraction with warmed identity-cached classification;
- a counterfactual ordinary-style extraction without that check, used only to
  attribute generic interface-dispatch cost;
- merging pre-extracted styles while preserving variant metadata;
- a counterfactual pre-extracted merge with variant metadata stripped, used
  only to locate metadata-carrying cost;
- active-variant evaluation and merge;
- property-source resolution of an already merged style;
- independent null-control, padding, constraints, decoration, transform, and
  modifier-resolution probes;
- `BoxSpec`/`StyleSpec` construction from already resolved fields;
- generated spec resolution of an already merged style; and
- the complete `Style.build` call.

It runs inactive-only (no selected variant), static (one active variant), and
all-active (five active variants) profiles. The cases are independent tight
loops, so their values characterize the composition of style computation; they
are not additive attribution of the primary grid's widget/layout/paint time.
The stripped-metadata case intentionally produces a different intermediate
style and is not evidence that removing public variant metadata is safe.
Alternate `STAGE_ORDER=forward` and `reverse` across processes.
In agent/PTY environments, confirm that no earlier workspace benchmark app or
`flutter run` wrapper remains before launching, and explicitly reap the runner
after the `BENCHMARK_RESULT_FILE` marker. Sleeping wrappers retain memory even
when they use no CPU.

```bash
fvm flutter run --release -d macos \
  -t lib/resolution_stage_microbenchmark.dart \
  --dart-define=MIX_SHA="$MIX_SHA" \
  --dart-define=FLUTTER_REVISION="$FLUTTER_REVISION" \
  --dart-define=IMPLEMENTATION_LABEL=resolution-stage-diagnostic \
  --dart-define=DEVICE_NAME=benchmark-mac \
  --dart-define=RUN_ID=resolution-stage-01 \
  --dart-define=STAGE_ORDER=forward \
  --dart-define=BENCHMARK_SECONDS=3 \
  --dart-define=BENCHMARK_OUTPUT_PATH="$(pwd)/../../.context/benchmark-results/resolution-stage-01.json"
```

## Retained-result heap diagnostic

This diagnostic answers which objects remain reachable from each returned
stage result. It does **not** measure transient allocation throughput. The VM's
`getAllocationProfile` endpoint is a live-heap census; its reset option only
updates the accumulation timestamp in this runtime. The driver therefore runs
in a separate OS process, forces GC before both snapshots, and subtracts the
baseline from a second GC'd snapshot after the app retains every operation
result.

Start the profile target and leave it running:

```bash
SERVICE_FILE="$(pwd)/../../.context/allocation-vm-service.txt"
rm -f "$SERVICE_FILE"
fvm flutter run --profile --no-dds -d macos \
  --vmservice-out-file="$SERVICE_FILE" \
  -t lib/allocation_microbenchmark.dart \
  --dart-define=MIX_SHA="$MIX_SHA" \
  --dart-define=FLUTTER_REVISION="$FLUTTER_REVISION" \
  --dart-define=IMPLEMENTATION_LABEL=pr976-baseline \
  --dart-define=DEVICE_NAME=benchmark-mac \
  --dart-define=RUN_ID=retained-forward-01
```

From a second terminal, drive the target and write the result:

```bash
fvm dart run tool/allocation_driver.dart \
  --service-uri-file="$SERVICE_FILE" \
  --output="$(pwd)/../../.context/benchmark-results/retained-forward-01.json" \
  --order=forward \
  --operation-count=5000 \
  --warmup-operation-count=10000
```

Repeat with a fresh target and `--order=reverse`. The report records per-class
and total retained instance/byte deltas. Control-case list backing is part of
the measurement floor. Do not call those deltas "allocations per operation" or
compare their profile timing with release/AOT timing.

## Exploratory post-build probe

`post_build_microbenchmark.dart` compares a pre-resolved direct renderer, null
`StyleAnimationBuilder`, `StyleSpecBuilder`, and full `StyleBuilder`. It is
retained to make the rejected experiment reproducible, not as a source of
standalone wrapper-cost claims. Forward/reverse results were order-dependent,
and repeated live macOS runs exposed application-activation and frame-pairing
failures. See [the findings](FINDINGS.md#r4-subtracting-pumped-widget-wrapper-cases)
before using it.

Run only one process/order at a time:

```bash
fvm flutter run --release -d macos \
  -t lib/post_build_microbenchmark.dart \
  --dart-define=MIX_SHA="$MIX_SHA" \
  --dart-define=FLUTTER_REVISION="$FLUTTER_REVISION" \
  --dart-define=IMPLEMENTATION_LABEL=post-build-exploration \
  --dart-define=DEVICE_NAME=benchmark-mac \
  --dart-define=RUN_ID=post-build-01 \
  --dart-define=POST_BUILD_ORDER=forward \
  --dart-define=BENCHMARK_SECONDS=3 \
  --dart-define=BENCHMARK_OUTPUT_PATH="$(pwd)/../../.context/benchmark-results/post-build-01.json"
```

## Profile integration benchmark

The primary profile run uses `watchPerformance`; no tracing flags, screenshots,
logging, or DevTools recording are enabled during the sample. It retains
Flutter's raw build/raster durations and GC counts and adds raw `totalSpan`
values, total-span p90/p99/worst, and a missed-frame count based on the actual
display refresh budget. Flutter's fixed 16 ms missed-build/raster fields remain
in the raw summary for compatibility but are not the target-display gate.

macOS hover run:

```bash
BENCHMARK_OUTPUT_BASENAME=origin-main-profile-01 \
fvm flutter drive --profile -d macos \
  --driver=test_driver/perf_driver.dart \
  --target=integration_test/state_transition_perf_test.dart \
  --dart-define=MIX_SHA="$MIX_SHA" \
  --dart-define=FLUTTER_REVISION="$FLUTTER_REVISION" \
  --dart-define=IMPLEMENTATION_LABEL=origin-main \
  --dart-define=DEVICE_NAME=benchmark-mac \
  --dart-define=RUN_ID=origin-main-01 \
  --dart-define=SCENARIOS=S2 \
  --dart-define=TRACKS=isolation \
  --dart-define=IMPLEMENTATIONS=mix \
  --dart-define=BENCHMARK_ORDER=flutter-first
```

Physical Android/iOS press, animation, and theme run (S3 is intentionally
excluded because it is the real-mouse track):

```bash
BENCHMARK_OUTPUT_BASENAME=origin-main-device-01 \
fvm flutter drive --profile --no-dds -d <physical-device> \
  --driver=test_driver/perf_driver.dart \
  --target=integration_test/state_transition_perf_test.dart \
  --dart-define=SCENARIOS=S2,S4,S5 \
  --dart-define=MIX_SHA="$MIX_SHA" \
  --dart-define=FLUTTER_REVISION="$FLUTTER_REVISION" \
  --dart-define=IMPLEMENTATION_LABEL=origin-main \
  --dart-define=DEVICE_NAME=<stable-device-label> \
  --dart-define=RUN_ID=origin-main-01 \
  --dart-define=BENCHMARK_ORDER=flutter-first
```

The driver writes `build/<BENCHMARK_OUTPUT_BASENAME>.json`. Copy each raw file
to a durable result directory before the next checkout or clean build.

## Release/AOT cadence benchmark

Flutter Driver does not support non-web release mode. The same integration
target can write `FrameTiming` data itself when built as a release app. Build
one frozen app per implementation/revision:

```bash
OUTPUT="$(pwd)/../../.context/benchmark-results/release-cadence-latest.json"
fvm flutter build macos --release \
  -t integration_test/state_transition_perf_test.dart \
  --dart-define=MIX_SHA="$MIX_SHA" \
  --dart-define=FLUTTER_REVISION="$FLUTTER_REVISION" \
  --dart-define=IMPLEMENTATION_LABEL=release-cadence \
  --dart-define=DEVICE_NAME=benchmark-mac \
  --dart-define=RUN_ID=release-cadence-01 \
  --dart-define=SCENARIOS=S2 \
  --dart-define=TRACKS=isolation \
  --dart-define=IMPLEMENTATIONS=mix \
  --dart-define=BENCHMARK_OUTPUT_PATH="$OUTPUT"
```

Launch the copied/frozen app executable directly. It warms 100 transitions,
measures 200 at display cadence, writes the configured JSON, and exits:

```bash
build/macos/Build/Products/Release/rendering_pipeline.app/Contents/MacOS/rendering_pipeline
```

This mode records build, raster, total-span, and refresh-budget data. It does
not report GC or cache metrics; use the profile benchmark for those.

## Experimental protocol

1. Use `fvm flutter` 3.41.7. Do not combine data from another Flutter revision.
2. Use one physical Android/iOS device for S2/S4/S5 and one fixed macOS machine
   for S3. Never compare numbers across devices.
3. Fix device resolution, refresh rate, locale, power mode, brightness, and
   thermal conditions. The app fixes its internal viewport, text scale,
   brightness, locale, card data, duration, and curve.
4. The release A/B protocol runs one selected case in each fresh process. The
   profile harness prebuilds its selected screen, performs 100 warm-up
   transitions, then measures 200 transitions.
5. Capture at least 10 independent release process pairs. Rotate case order
   across pairs and alternate which revision runs first. When intentionally
   running a multi-case smoke/profile matrix, also alternate
   `BENCHMARK_ORDER=flutter-first` and `mix-first`.
6. For revision A/B work, pair adjacent baseline/changed processes and
   alternate which revision runs first. Retain every per-pair delta.
7. Label and retain every raw JSON/log. A comparison set must identify the Mix
   SHA/checkout as `origin-main`, `pr-962`, or the future no-animation path.
8. Do not add a CI threshold until repeated runs on a stable runner establish
   normal variance.

PR and future-path comparisons use the same app because `mix` is a path
dependency on `../../packages/mix`. Run the protocol from each checkout at the
desired SHA; do not change the benchmark implementation between checkouts.
S0 is the baseline for evaluating a future no-animation fast path.

## Compare results

The tool accepts one or more microbenchmark or integration JSON files. It
averages matching numeric metrics across independent documents, then reports
the absolute `Mix - Flutter` delta and `Mix / Flutter` ratio for each
scenario/track.

```bash
fvm dart run tool/compare_results.dart \
  ../../.context/benchmark-results/origin-main-micro-*.json \
  > ../../.context/benchmark-results/origin-main-micro-comparison.json

fvm dart run tool/compare_results.dart \
  build/origin-main-profile-*.json \
  > ../../.context/benchmark-results/origin-main-profile-comparison.json
```

Interpret higher raster time with an equivalent isolation tree as a fairness
problem first. Treat cost that scales with all cards during S2 as an
architectural issue even when the current device remains under budget.

## Deferred

- VM-service retained/allocation-class snapshots.
- Web/Chrome benchmarking.
- Startup, app size, energy, and battery measurements.
- Phase/keyframe animation stress.
- Primary-sample tracing. Use `traceAction` and enhanced build/layout/paint
  tracing only in a separately labeled diagnostic run because tracing changes
  the workload.

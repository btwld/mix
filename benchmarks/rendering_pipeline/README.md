# Mix rendering-pipeline benchmarks

This isolated Flutter app compares Mix with an equivalent Flutter implementation
without adding timing work to the normal Mix package test suite. It targets the
repository-pinned Flutter 3.41.7 and Dart 3.11.

The first results are characterization data, not regression thresholds or
marketing claims. Compare absolute frame-budget impact as well as ratios; a
large ratio over a tiny baseline can still be immaterial.

## What is measured

The benchmark uses a deterministic 60-card `GridView.builder` inside a fixed
1200×800 logical viewport. About 24 cards are fully visible and a fifth row is
partially visible at the initial scroll position. Every card uses the same cached content widget: icon, title,
subtitle, badge, padding, rounded decoration, border, and shadow. There is no
network access or image decoding.

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
lib/microbenchmark.dart                        release benchmarkWidgets S0-S2
test/rebuild_contract_test.dart                strict rebuild/layout/paint contracts
integration_test/state_transition_perf_test.dart  profile S2-S5 benchmark
test_driver/perf_driver.dart                   raw JSON writer
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
- a declared target state resolves/rebuilds and paints the target only; and
- an external controller does not rebuild, lay out, or paint unrelated
  siblings.

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
and `pumpBenchmark` pattern. It warms each case for 100 iterations, measures
for a fixed duration, then emits every raw iteration plus average, median, p90,
p99, worst, standard deviation, and sample count in microseconds.

```bash
fvm flutter run --release -d macos -t lib/microbenchmark.dart \
  --dart-define=MIX_SHA="$MIX_SHA" \
  --dart-define=FLUTTER_REVISION="$FLUTTER_REVISION" \
  --dart-define=IMPLEMENTATION_LABEL=origin-main \
  --dart-define=DEVICE_NAME=benchmark-mac \
  --dart-define=RUN_ID=origin-main-01 \
  --dart-define=BENCHMARK_ORDER=flutter-first \
  --dart-define=BENCHMARK_SECONDS=3 \
  --dart-define=BENCHMARK_OUTPUT_PATH="$(pwd)/../../.context/benchmark-results/origin-main-micro-01.json"
```

The app writes the complete raw document to `BENCHMARK_OUTPUT_PATH` and prints
a short `BENCHMARK_RESULT_FILE:` confirmation. The default path is
`$TMPDIR/rendering_pipeline_micro.json`.

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

## Experimental protocol

1. Use `fvm flutter` 3.41.7. Do not combine data from another Flutter revision.
2. Use one physical Android/iOS device for S2/S4/S5 and one fixed macOS machine
   for S3. Never compare numbers across devices.
3. Fix device resolution, refresh rate, locale, power mode, brightness, and
   thermal conditions. The app fixes its internal viewport, text scale,
   brightness, locale, card data, duration, and curve.
4. The harness prebuilds each screen and performs 100 transitions before each
   measured action. Each profile case then performs 200 transitions.
5. Capture at least 10 independent process runs. Alternate
   `BENCHMARK_ORDER=flutter-first` and `mix-first` to reduce order/thermal bias.
6. Label and retain every raw JSON/log. A comparison set must identify the Mix
   SHA/checkout as `origin-main`, `pr-962`, or the future no-animation path.
7. Do not add a CI threshold until repeated runs on a stable runner establish
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

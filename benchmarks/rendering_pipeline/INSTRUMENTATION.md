# Rendering-pipeline instrumentation

This document maps the Mix style-to-widget pipeline to the measurements in this
benchmark. Use it with the repository-wide
[Mix styling and rendering pipeline guide](../../guides/mix-styling-rendering-pipeline.md).

The primary benchmark and diagnostic instrumentation have different jobs:

- **Primary runs** measure the workload with minimal observer overhead. They
  answer whether Mix changes CPU cost, frame timing, raster timing, or GC
  behavior.
- **Diagnostic runs** instrument individual stages. They answer where the cost
  came from and whether work ran more often than intended.

Do not enable diagnostic counters, timeline spans, allocation profiling, or
verbose logging in a primary comparison run.

## What is recorded today

### Contract tests

`PipelineCounters` records:

- screen builds;
- card renderer builds;
- Mix style-resolution invocations;
- card-level layout invocations; and
- card-level paint invocations.

These counters are installed only in widget contract tests. They establish
fan-out invariants but do not measure duration. The idiomatic Mix card does not
currently count its concrete `Box` builder execution, so its counters are not a
complete stage trace.

### Release CPU microbenchmark

The microbenchmark records elapsed time for one complete pumped iteration. It
includes controller updates and all framework work performed by
`pumpBenchmark`, but does not divide that time between notification, variant
merge, Prop resolution, widget build, layout, and paint.

### Profile integration benchmark

The profile benchmark records:

- Flutter frame build and raster distributions;
- `FrameTiming.totalSpan` distributions;
- refresh-budget misses;
- layer and picture cache summaries;
- new- and old-generation GC event counts; and
- raw build, raster, and total-span arrays.

This is aggregate frame evidence. It does not currently associate a frame with
a transition ID or record `vsyncOverhead`, so scheduling/boundary delays cannot
always be separated from Mix work.

## Stage map for diagnostic instrumentation

Every diagnostic event should include `run_id`, scenario, implementation,
track, transition ID, frame number when known, card ID, and event source.

| Stage | Questions | Diagnostic fields |
| --- | --- | --- |
| Input | Which pointer/controller action began the work? | update attempts, changed states, source, timestamp |
| Controller | Did the value actually change and notify? | notification count, state before/after |
| State provider | Which provider rebuilt and which aspects changed? | provider builds, changed aspects, dependent count |
| `StyleBuilder` | Did inheritance or state-scope assembly rerun? | builder count, inherited-style merge count/duration |
| Variants | How much conditional work ran? | evaluated, active, nested, sorted/partitioned, merge count/duration |
| Props | Which fields resolved and from what sources? | field count, source count/type, token/Mix/directive count, duration |
| `StyleSpec` | How often was a new target allocated? | resolve count/duration, equality changed, modifier count |
| Animation | Was this a target update or an animation tick? | driver type, target updates, lerp ticks/duration, completion/interruption |
| Widget | Which Mix and concrete builders ran? | `StyleSpecBuilder`, concrete widget, target/sibling build counts |
| Flutter pipeline | What downstream work followed? | layout, paint, raster, total span, vsync overhead |
| Memory | Which classes create pressure? | allocated bytes/instances by class, retained bytes in separate run |

Use lightweight integer counters for invocation questions. Use diagnostic-only
`TimelineTask`/timeline spans or stopwatches for stage duration. Use a single
timings callback to emit per-frame records instead of independent arrays.

## Confirmed behavior

Focused counter probes against the current code established:

- S2 intentionally updates `pressed` and `selected`, producing two controller
  notifications but one Mix resolution and one isolation renderer build in the
  pumped frame. The updates are coalesced; the style is not resolved twice.
- S4 has the same two-update target pattern. Its later animation-tick builds are
  intentional interpolation work, not duplicate state notifications.
- `Pressable` and `MixInteractionDetector` both attempt to update pressed state
  during an automatic press. `WidgetStatesController.update` notifies only when
  its set changes, so the second identical setter attempt is a no-op.
- Moving a pointer from one card to another normally changes two controllers:
  hover exits the old card and enters the new card. Two card resolutions are
  expected when both styles use hover.

## Observed avoidable work

`StyleBuilder` currently checks for an existing state scope with
`WidgetStateProvider.of(context)` without an aspect. That lookup establishes a
dependency on the whole provider. In the idiomatic `Pressable` path, a hover
change therefore causes one style resolution even for:

- a state-free style; and
- a pressed-only style.

The existing S1 negative-control contract uses the isolation path and does not
cover this idiomatic provider arrangement.

## Quick-win experiment queue

These are hypotheses, not accepted optimizations. Change one variable at a time
and compare paired runs.

### QW1: Non-listening state-scope presence lookup

Replace the dependency-forming provider-presence check with a non-listening
ancestor lookup while keeping aspect-specific dependencies inside widget-state
variants.

Proof:

- add idiomatic state-free and pressed-only hover contracts;
- require zero resolutions/build/layout/paint for irrelevant hover;
- rerun S3 and a matched controlled-hover case; and
- confirm relevant hover/press/focus states still update.

Expected scope: removes avoidable resolutions. It should not change the cost of
a style that actually consumes the changed state.

### QW2: No-animation fast path

`StyleSpecBuilder` always creates `StyleAnimationBuilder`, and a null animation
creates `NoAnimationDriver`. Evaluate a direct path for stable null-animation
styles without changing transitions where animation config is added or removed.

Proof:

- S0 release CPU delta;
- S2 isolation release/profile delta;
- lifecycle tests for adding and removing animation config; and
- allocation counts for drivers/controllers/spec wrappers.

### QW3: Stable linear variant partition

Replace sorting used only to place widget-state variants last with a stable
linear partition. This is also part of the behavior discussed around PR #962.

Proof:

- same-bucket ordering contracts;
- S0/S2 resolution microbenchmarks with 1, 4, and 12 variants; and
- temporary allocation counters for active-variant lists.

### QW4: Resolve only after relevant state changes

Before attempting field-level caching, measure how often full style resolution
runs for state changes that affect no declared variant. QW1 should remove the
known broad-provider cause first.

Proof:

- state-by-state matrix: hover, press, selected, disabled, focus;
- state-free, single-state, and all-state styles; and
- resolver counts across 1, 24, 60, and 240 cards.

### QW5: Interaction-wrapper cost

Measure identical hover and press sequences through:

1. direct controller updates;
2. `MixInteractionDetector`;
3. `Pressable` without styled state; and
4. `Pressable` plus `Box` state variants.

This separates state ownership from style computation. Duplicate setter
attempts during press are lower priority because the controller suppresses
duplicate notifications, but the extra callbacks can be quantified here.

## Experiment rules

- Keep primary and diagnostic result files separately labeled.
- Do not infer allocation volume from GC event counts alone.
- Pair Flutter and Mix within each run, alternate order across runs, and retain
  each paired delta.
- Do not attribute a total-span outlier to Mix unless its build/raster/vsync
  phases and transition boundary identify the source.
- Promote a quick win only when its contract tests pass and repeated primary
  runs improve the intended scenario without moving cost elsewhere.

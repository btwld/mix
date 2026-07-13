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

Focused diagnostic contracts additionally attach controller listeners to
count notifications and pressed-state transitions. These listeners are not
installed in timed runs.

### Release CPU microbenchmark

The microbenchmark records elapsed time for one complete pumped iteration. It
includes controller updates and all framework work performed by
`pumpBenchmark`, but does not divide that time between notification, variant
merge, Prop resolution, widget build, layout, and paint.

Decision-grade release comparisons select one implementation/scenario per
fresh process. Multi-case runs remain useful for smoke and stress work, but
later cases can inherit heap/GC phase from earlier cases. The harness keeps one
root mounted, enters benchmark policy once, uses one monotonic clock, and gives
manual frames exclusive ownership of the binding.

The release suite includes both isolation S0-S2 and idiomatic S0I-S1I. Four
separate Mix-only diagnostics stay outside the primary comparison:

- the variant probe measures complete widget rebuilds with 0, 1, 4, and 12
  active variants; and
- the resolution-stage probe uses synchronous batches to time a harness
  control, variant merge, property-source resolution, spec construction,
  premerged spec resolution, and full `Style.build` for inactive-only, static,
  and all-active versions of realistic styles;
- the retained-result heap probe uses an external VM-service process and GC'd
  before/after live-heap snapshots while retaining every returned result; and
- the exploratory post-build probe compares wrapper/widget paths, but its
  pumped-frame deltas are not valid stage attribution.

The stage cases are measured independently. Their shares locate work inside
style computation, but they do not allocate the primary grid's complete
widget/layout/paint duration among stages.

The retained-result probe is deliberately narrower than an allocation
profiler. In this VM, `getAllocationProfile` enumerates the live heap and reset
only changes its timestamp; it does not expose allocation throughput.
Consequently the probe reports `retained_heap_delta` and explicitly excludes
transient intermediates. The profiler runs in a separate OS process so its own
`vm_service` classes cannot pollute the target isolate group.

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

### Release/AOT cadence benchmark

Flutter Driver refuses non-web release mode. To measure the same warmed S2
transition cadence with the shipping AOT compiler, the integration target can
instead be built as a release macOS app and launched directly. In release mode
the target installs one `TimingsCallback`, records build/raster/total-span
arrays, writes JSON to `BENCHMARK_OUTPUT_PATH`, and exits. It does not claim GC
or cache metrics because `watchPerformance` is unavailable in this mode.

Use frozen baseline/changed binaries for repeated A/B work. The measurement is
frame-level and intentionally complements rather than replaces the tight-loop
CPU primary: sub-frame changes may be below cadence noise, while missed-frame
or tail regressions remain visible.

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
| Memory | Which result classes remain reachable? | GC'd retained bytes/instances by class; transient allocation unmeasured |

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
- Across 10 alternating-order release processes, the five-declared-variant
  style spends roughly 63-64% of `Style.build` time in active-variant merge and
  30-33% in generated spec/property resolution. The static profile averages
  5.44 µs per full build; the all-active profile averages 20.30 µs.
- GC'd retained-result snapshots show that full `Style.build` and premerged
  spec resolution return the same-size final object graph: about 13 objects /
  664 B static and 16 objects / 760 B all-active per retained result. Variant
  merge intermediates do not survive in the returned `StyleSpec` graph.
- Generated spec construction alone measures about 11-12 ns in the resolution
  probe. Property-source resolution is the material generated stage. A fast
  path limited to one ordinary `ValueSource` reduces static property resolution
  by 28.2% and the complete static `Style.build` by 12.4% without changing
  token, `MixSource`, nested `Mix`, or multi-source dispatch.

## Inconclusive post-build probe

Separately pumped direct-renderer, null-animation, `StyleSpecBuilder`, and full
`StyleBuilder` cases changed ordering between forward and reverse processes.
The full path even appeared faster than the direct path in one process, which
is not a defensible wrapper-cost result. Attempts to repeat raw macOS app
launches also exposed app-activation stalls, while many case repetitions in one
process reproduced Flutter live-binding frame-pair errors.

Keep these observations as a measurement-method finding: `pumpBenchmark` is
appropriate for complete workload comparisons, but its live-frame scheduling
floor is too large for subtracting these small wrapper layers. The next probe
should use diagnostic timeline spans or invocation/allocation counters inside a
single shared frame.

## Live frame-policy finding

Flutter's official `pumpBenchmark` contract requires
`LiveTestWidgetsFlutterBindingFramePolicy.benchmark`, which directly drives
`handleBeginFrame` and `handleDrawFrame`. Flutter's pinned stock build/layout
microbenchmarks mount and settle once, switch to benchmark policy once, and
remain there for the measurement loop.

The original multi-case harness returned to live policy for every case. A
persistent root and one policy transition removed the dominant trigger but did
not eliminate the race: after many clean launches, a previously accepted macOS
vsync still overlapped a manual frame.

The accepted harness additionally detaches the engine's begin/draw callbacks
while `pumpBenchmark` owns the binding, then restores them with the original
policy. This prevents an already-queued vsync from splitting the manual pair.
It passed 30 independent stress processes and two separate 200-case A/B
matrices with zero pairing errors. The earlier `endOfFrame` drain was removed.

Fresh-process selectors address a separate issue discovered afterward: even a
structurally clean multi-case process can transfer heap/GC phase into later
cases. Use one selected case per process for small A/B deltas.

## Observed avoidable work

Before QW1, `StyleBuilder` checked for an existing state scope with
`WidgetStateProvider.of(context)` without an aspect. That lookup established a
dependency on the whole provider. In the idiomatic `Pressable` path, a hover
change caused one style resolution even for:

- a state-free style; and
- a pressed-only style.

Idiomatic contracts now cover this provider arrangement and require zero
resolutions for both cases.

## Quick-win experiment queue

This queue records each hypothesis and its current disposition. Experiments
change one variable at a time and compare paired runs.

### QW1: Non-listening state-scope presence lookup — accepted

Replace the dependency-forming provider-presence check with a non-listening
ancestor lookup while keeping aspect-specific dependencies inside widget-state
variants.

Evidence and remaining proof:

- add idiomatic state-free and pressed-only hover contracts;
- require zero resolutions/build/layout/paint for irrelevant hover;
- matched controlled-hover S1I is complete; S3 profile repetition remains; and
- confirm relevant hover/press/focus states still update.

Result: both new contracts failed with one resolution before the change and
pass with zero after it. Relevant hover/press tests remain green. S1I
wall-clock timing changed distribution shape and is treated as inconclusive;
the accepted claim is eliminated work.

### QW2: Null-animation lightweight path — accepted

`StyleSpecBuilder` still creates `StyleAnimationBuilder` so animation config can
be added or removed without losing lifecycle state. A null animation now skips
`NoAnimationDriver` and `AnimatedBuilder` allocation while configured animation
behavior remains unchanged.

Evidence and remaining proof:

- S0 release CPU delta;
- S2 isolation release/profile delta;
- lifecycle tests for adding and removing animation config; and
- allocation counts for drivers/controllers/spec wrappers remain.

### QW3: Stable linear variant partition — rejected as a speed win

Replace sorting used only to place widget-state variants last with a stable
linear partition. This is also part of the behavior discussed around PR #962.

The tested two-bucket/followed-by implementation regressed all non-empty counts
in 10 corrected pairs and was reverted. Stable order remains a correctness
issue associated with PR #962, whose implementation differs and must be
measured independently.

Evidence used:

- same-bucket ordering contracts;
- S0/S2 resolution microbenchmarks with 1, 4, and 12 variants; and
- corrected paired release samples for each declared count.

### QW4: Resolve only after relevant state changes — partially accepted

QW1 removed the known broad-provider cause. Field-level caching remains
deferred until context/token/directive invalidation can be represented safely.

Proof:

- state-by-state matrix: hover, press, selected, disabled, focus;
- state-free, single-state, and all-state styles; and
- resolver counts across 1, 24, 60, and 240 cards.

### QW5: Interaction-wrapper cost — partially resolved

Measure identical hover and press sequences through:

1. direct controller updates;
2. `MixInteractionDetector`;
3. `Pressable` without styled state; and
4. `Pressable` plus `Box` state variants.

This separates state ownership from style computation. Duplicate setter
attempts during press are lower priority because the controller suppresses
duplicate notifications, but the extra callbacks can be quantified here.

Current evidence: S2 produces two notifications and one resolution; idiomatic
press produces one resolution on pressed-down and one on pressed-up. Automatic
tracking is now installed only for hover/pressed styles, and controller
ownership is lazy. Retained result classes are measured; transient allocation
volume remains unmeasured.

### QW6: Remove the second active-style merge list — rejected

Fully fusing extraction, recursion, and merge reduced synchronous
`Style.build` dramatically and made static S0/S0I 15–22% faster. It also
regressed S2 in 10/10 fresh-process CPU pairs and two balanced real-cadence
profile pairs. A narrower single-active fast path retained the static win but
still regressed S2 in 10/10 CPU pairs. Both implementations were reverted.

This is the main methodological result of the session: a stage-local win is
insufficient when the complete targeted workload moves cost elsewhere. See
`FINDINGS.md` for the release, profile, raster, and total-span tables.

### QW7: Skip already-unnecessary variant sorting — rejected

Scan the active variants and skip the stable sort when non-widget variants are
already before widget-state variants. Focused ordering tests passed, but four
order-balanced release stage runs made the target variant-merge stage about
1.5% slower for static and 0.3% slower for all-active. The experiment was
reverted at the stage-screen gate; no primary S0/S2 claim was made.

### QW8: Share null-side variant lists — rejected at source review

Returning the existing list from `MixOps.mergeVariants` would avoid copies but
would also create a new observable alias between the source and merged styles.
Variant lists are public and mutable, and constructors currently retain
caller-owned lists. This candidate needs a separate immutability/ownership
design before it can qualify as a safe performance experiment.

### QW9: No-active-variant early return — rejected

When variants are declared but the filter selects none, current code sorts an
empty list, allocates the extraction list, and then returns the original style
without merging. Returning immediately after filtering preserves current result
identity and ordering semantics. Add an inactive-only stage profile first, then
screen this single branch against static and all-active controls.

Result: four order-balanced release runs measured 564.89 ns baseline versus
565.94 ns changed for the directly affected inactive-only merge stage (+0.18%).
The branch was reverted at the stage gate. A lower full-build aggregate was not
promoted because the target stage itself did not improve.

### QW10: Single ordinary value resolution — accepted

When a `Prop` contains exactly one ordinary `ValueSource` whose value is not
itself `Mix<V>`, resolution no longer creates/scans the accumulation list. It
applies directives and returns directly. More general single-source versions
were rejected because profile-mode cadence regressed even though release CPU
improved. The narrow branch passed semantic tests, the intended stage screen,
the 200-case release CPU matrix, two balanced profile pairs, and a 40-process
release/AOT cadence campaign. See F8/R8 in `FINDINGS.md` for exact results.

## Experiment rules

- Keep primary and diagnostic result files separately labeled.
- Do not infer allocation volume from GC event counts alone.
- For small deltas, run Flutter and Mix controls as separate fresh processes,
  rotate case order, alternate revision-first order, and retain every paired
  delta.
- Do not attribute a total-span outlier to Mix unless its build/raster/vsync
  phases and transition boundary identify the source.
- Promote a quick win only when its contract tests pass and repeated primary
  runs improve the intended scenario without moving cost elsewhere.

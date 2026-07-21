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
  control, variant collection/sort/extraction/merge, context-builder
  extraction, ordinary-style extraction with exact, raw-prefiltered, cached,
  and no-StyleVariation inspection, property-source resolution, spec
  construction, decoration field resolution, border merge/normal/uniform-side
  resolution, premerged spec resolution, and full `Style.build` for
  inactive-only, static, and all-active versions of realistic styles;
- the retained-result heap probe uses an external VM-service process and GC'd
  before/after live-heap snapshots while retaining every returned result; and
- the exploratory post-build probe compares wrapper/widget paths, but its
  pumped-frame deltas are not valid stage attribution.

The stage cases are measured independently. Their shares locate work inside
style computation, but they do not allocate the primary grid's complete
widget/layout/paint duration among stages.

The field-level property probes separately time a null-property control,
padding, constraints, decoration, transform, and modifier resolution. Nullable
results are valid: the harness uses a unique untouched sentinel to distinguish
"operation did not run" from "operation ran and returned null."

The retained-result probe is deliberately narrower than an allocation
profiler. In this VM, `getAllocationProfile` enumerates the live heap and reset
only changes its timestamp; it does not expose allocation throughput.
Consequently the probe reports `retained_heap_delta` and explicitly excludes
transient intermediates. The profiler runs in a separate OS process so its own
`vm_service` classes cannot pollute the target isolate group.

### Combined accepted checkpoint estimate

The bounded checkpoint comparison freezes the clean pre-optimization and
current accepted sources, then launches one selected S0 or S2 case per release
process. Each of three pairs contains baseline/current Flutter and Mix
processes. Scenario, implementation, and revision order alternate; a two-second
lifecycle gap separates processes. Binary hashes, result markers, metadata,
duration, and positive samples remain strict validity checks.

The quick campaign completed 24/24 valid processes. Matched Flutter adjustment
estimated S0 at -11.56% aggregate / -11.94% median-paired with 3/3 wins. S2 was
-1.41% / -1.79% with 2/3 wins. Aggregate Flutter movement was -0.60% for S0 and
+0.17% for S2. Two individual S2 Flutter pairs crossed +/-2%, so the S2 result
is noisy rather than a decision-grade speed claim.

At the user's request, Conductor stayed open. Its known processes were excluded
from the between-case CPU abort check, and its verified WebContent renderer was
suspended only during the timing window. The runner recorded rather than
aborted for brief `mdworker` (20.3%) and `sysmond` (59.0%) bursts. This host
policy is acceptable for a basic local percentage estimate with matched
controls, but not for a release threshold or a small-delta promotion decision.
Raw results, process logs, host events, manifest, and analysis are under
`.context/benchmark-results/combined-accepted-quick-v8/`.

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

### QW11: Collect active variants with a manual loop — rejected

Replacing `where(...).toList()` with an explicit loop improved the directly
changed merge stage in four forward/reverse release pairs: median process
averages moved -14.17% inactive, -4.53% static, and -2.75% all-active. The
candidate preserved predicate count, priority, recursion, and merge semantics
in focused tests.

Ten fresh-process release/AOT pairs then separated the local win from the full
pipeline result. S0 improved in 8/10 pairs with a -1.91% median paired change,
but state-heavy S2 improved in only 4/10: its median paired change was +0.37%
and its trimmed-mean regression was +0.67%. The candidate was reverted at the
primary gate and did not proceed to profile or cadence testing. Raw evidence is
under `.context/benchmark-results/manual-variant-collection-v1/` and
`.context/benchmark-results/manual-variant-collection-primary-v1/`.

### QW12: Split and attribute variant-merge sub-stages

The release diagnostic now keeps official `variant_merge` and
`full_style_build` controls while separately measuring active collection,
priority sort, faithful extraction, pre-extracted merge, and a diagnostic-only
merge with variant metadata stripped. Two balanced runs attribute roughly 78%
of static merge and 90% of all-active merge to extraction/generic dispatch.
Sorting, final merge, and variant-metadata copying are each small in comparison.

Guarding the generic StyleVariation check when the named set is empty was then
screened as a bounded hypothesis. Forward all-active improved, but reverse and
both static merge measurements regressed, so it was reverted before primary
testing. Evidence is in `.context/benchmark-results/variant-substage-faithful-v1/`
and `.context/benchmark-results/empty-named-variation-guard-stage-v1/`.

### QW13: Remove the extraction IIFE — rejected

Direct switch cases and record-list appends preserved the entire two-phase
algorithm and passed 45 focused tests. Forward all-active extraction/merge
improved 4.5%/5.0%, but reverse extraction/merge moved +0.9%/+0.25%. Because the
directly changed stage was order-sensitive, the change was reverted without a
primary campaign. Raw evidence is under
`.context/benchmark-results/extraction-no-iife-stage-v1/`.

### QW14: Combine the generic StyleVariation test and cast — rejected

A typed pattern binding preserved accepted generic types and behavior while
removing the separate `is`/`as` pair. The result was again order-sensitive:
forward all-active extraction/merge improved 3.6%/3.8%, while reverse moved
+2.6%/+0.29% and static controls regressed. It was reverted before primary
testing. Evidence is under
`.context/benchmark-results/variation-pattern-binding-stage-v1/`.

### QW15: Preclassify StyleVariation values — rejected

Framework-created `VariantStyle` values were given cached StyleVariation
classification while the public const constructor retained runtime fallback
behavior. The prototype preserved equality/hash behavior and passed 89 focused
tests. It did not pass the balanced stage screen: forward all-active full build
improved 2.41%, but reverse all-active full build regressed 1.63%; inactive-only
full build regressed 4.92% forward and 6.43% reverse. Static also regressed in
the forward run. The metadata and alternate construction path were reverted
without a primary campaign. Evidence is under
`.context/benchmark-results/preclassified-style-variation-stage-v1/`.

### QW16: Specialize the empty-named-set extraction loop — rejected

A whole-call branch removed the per-active-variant generic StyleVariation check
when the named set was empty. A characterization test confirms that contextual
StyleVariation objects still merge as ordinary styles without invoking their
`styleBuilder`; all 88 focused tests passed. Official merge improved locally in
both orders for inactive-only and all-active profiles. Complete all-active
`Style.build` nevertheless regressed in both orders (+2.84% and +0.50%), while
static official merge was mixed. The duplicated hot path was reverted before a
primary campaign. Evidence is under
`.context/benchmark-results/empty-named-specialized-path-stage-v1/`.

### QW17: Split extraction by active input class

The release diagnostic now times preselected `ContextVariantBuilder` entries,
ordinary entries with the production StyleVariation inspection, and a
counterfactual ordinary path without that inspection. Forward/reverse absolute
times differ, but the composition is stable: builder execution is 21–23% of
faithful extraction, while ordinary extraction with the generic interface
check is 76–77%. Four ordinary styles take 8.399–16.369 µs with the check and
only 0.086–0.090 µs without it. This locates cost; it does not supersede the
production A/B failures in QW12–QW16. Evidence is under
`.context/benchmark-results/extraction-composition-v1/`.

### QW18: Avoid or cache the StyleVariation interface test — rejected

Three further diagnostic shapes failed before production promotion:

- a raw StyleVariation prefilter was +0.81% forward and -0.27% reverse versus
  the exact generic check;
- a temporary non-generic marker prefilter was -0.62% forward and flat
  (-0.006%) reverse; and
- a warmed `Expando<bool>` classification cache was +0.27% and +0.29% slower.

All remain around 8–16 µs for four ordinary styles, while the no-check control
is 88–93 ns. The AOT cost is the interface-test path itself; adding another
interface or lookup does not avoid it. The marker API was reverted, and no
production extraction or cache change was promoted. Evidence is under
`.context/benchmark-results/raw-variation-prefilter-composition-v1/`,
`.context/benchmark-results/marker-variation-prefilter-composition-v1/`, and
`.context/benchmark-results/expando-variation-classification-v1/`.

### QW19: Attribute generated fields and bypass one-item modifier ordering — rejected

Forward/reverse field-family runs completed all 66 expected records. Balanced
averages put decoration at 1.211 µs of 1.361 µs static property resolution and
3.599 µs of 6.544 µs all-active resolution. The all-active one-item opacity
modifier costs another 2.258 µs; padding and transform are comparatively small.

A test-first one-item ordering guard then reduced modifier resolution by
98.5–98.6%, all-active property resolution by 37–38%, and isolated full
`Style.build` by 8–12% in both stage orders. The matched 80-process primary
campaign rejected it: adjusted S0 was a small/inconsistent -0.77% (6/10), and
S2 regressed +1.24% aggregate with only 3/10 improved pairs. S2 does not execute
the changed branch, so this is another AOT code-shape failure rather than proof
that less ordering work is intrinsically slower. The production/test hunk was
reverted. Evidence is under
`.context/benchmark-results/property-field-attribution-v2/`,
`.context/benchmark-results/modifier-single-fastpath-v1/`, and
`.context/benchmark-results/modifier-single-fastpath-primary-v1/`.

### QW20: Resolve a shared uniform border side once — accepted

The decoration protocol grew to 34 stages and completed valid forward/reverse
runs for all three profiles. Border resolution accounted for 85–86% of the
all-active merged-decoration stage. The realistic `borderAll` inputs produced
one equal `Prop<BorderSide>` on all four fields, but generated `BorderMix`
resolution resolved that property four times.

A same-binary counterfactual reduced an already merged all-active border from
1.60–1.68 µs to 0.825–0.857 µs by resolving one side and using
`Border.fromBorderSide`. Test-first production work additionally proved that a
context token on a shared uniform side was invoked four times on the baseline;
the optimized path invokes it once and guarantees the declared border remains
uniform. Non-uniform borders keep the original per-side resolution order.

The first production shape redundantly evaluated structural equality twice
and was rejected by its static stage regression. The corrected implementation
evaluates uniformity once. Balanced candidate deltas were -22.4% for static
merged-border resolution, -47.6% for all-active merged-border resolution,
-30.1% for all-active decoration resolution, -23.8% for all-active property
resolution, and -12.9% for all-active premerged spec resolution.

Two 80-process primary campaigns were run after matched Flutter adjustment.
Their candidate executables had byte-identical `__text` and disassembly, yet
their ten-pair S2 aggregates had opposite signs (-0.67% and +0.58%). Pooling
the 20 pairs establishes the supported conclusion: S0 improved 1.25%
aggregate / 1.30% median paired / 1.11% trimmed mean with 13/20 improved
pairs; S2 was neutral at -0.05% / -0.48% / -0.07% with 12/20 improved pairs.
The `BorderMix` candidate is retained for its static win; S2 is only a
non-regression result. Directional borders remain a separate hypothesis
because this workload did not execute them. Evidence is under
`.context/benchmark-results/decoration-substage-v1/`,
`.context/benchmark-results/border-counterfactual-v1/`, and
`.context/benchmark-results/uniform-border-primary-v{1,2}/`.

### QW21: Isolate a single-active helper from the multi-active hot body — rejected

The previous single-active fast path improved static S0/S0I by roughly 20% but
regressed S2 in 10/10 pairs. This experiment kept the legacy multi-active
extraction/merge body unchanged and called a separate `vm:never-inline` helper
only when exactly one variant was active. It tested whether the earlier S2
movement came from inlining/code-shape coupling rather than the single-active
algorithm itself.

To shorten stage iteration without changing the default protocol, the
resolution executable now supports `PROFILE_FILTER` and `STAGE_FILTER`.
Empty filters still select all profiles and all 34 stages. A targeted build can
select `static,all_active` and `variant_merge,full_style_build`, producing four
validated records instead of 102.

A fresh three-pair forward/reverse screen reproduced the static reduction:
variant merge improved 68.64% and full build 50.59%, both 6/6. Complete
all-active build improved 0.51% overall and in both order aggregates, although
the isolated all-active merge stage regressed 0.32% with only 1/6 faster
comparisons.

The 80-process primary gate then improved adjusted S0 by 19.59% in 10/10
pairs, but adjusted S2 regressed 1.10% aggregate, 1.32% median-paired, and
1.05% trimmed mean with only 2/10 improvements. The helper was reverted under
the state-heavy stop rule without profile or cadence work. The protocol
filters remain. Valid evidence is under
`.context/benchmark-results/variant-single-isolated-stable-host-v1/` and
`.context/benchmark-{builds,results}/variant-single-isolated-primary-v1/`;
the earlier paused dataset remains excluded.

### Directional-border workload axis

The release microbenchmark and resolution-stage diagnostic can now exercise
the real `BorderDirectionalMix` path without relabeling a physical-border
workload. `--border=physical|directional` selects the release fixture, while
`BORDER_GEOMETRY=physical|directional` selects the compile-time stage fixture;
both default to `physical` so historical commands retain their meaning.

The directional Mix style family uses `BorderDirectionalMix.all` in base,
hovered, and selected sources. Its matched Flutter control uses an explicit
uniform `BorderDirectional` with the same color, width, style, and stroke
alignment. Geometry appears in case-selection metadata and in every primary
result, and the stage output records it in metadata. Fixture tests resolve all
three states and assert that neither implementation falls back to a physical
`Border`.

The bounded directional stage screen selects static and all-active profiles
plus the unchanged border-merge control, direct merged-border resolver,
decoration/property containment, premerged-spec resolution, and full style
build. Its valid frozen screen completed three matched pairs per order with no
exclusions. The candidate improved direct merged-border resolution by 21.89%
static and 47.89% all-active, both 6/6, but regressed static premerged-spec
resolution by 3.79% in 0/6 wins. It therefore failed before the primary gate;
the generated production resolver was restored exactly. Complete evidence is
under `.context/benchmark-results/border-directional-stage-v5/`.

### Rejected same-frame timing recorder

The R21 experiment temporarily added a compile-time `MIX_BENCHMARK_TIMINGS`
recorder to the real `StyleBuilder`/`StyleSpecBuilder` path and a per-iteration
collector to the benchmark renderer. It timed these non-overlapping bodies in
one pumped frame:

- inherited-style lookup/merge;
- `Style.build` resolution;
- the user renderer callback;
- provider/modifier widget assembly;
- matched Flutter `BoxSpec` mapping;
- shared renderer construction;
- layout; and
- paint.

Tests proved synchronous tick delivery, balanced nested/exception state,
zero-filled aligned samples, no default events, and the scenario-specific
relationships: S0 builds 36 cards; S2 skips outer inherited-style assembly and
resolves/builds one target card. Two release apps were built from source
manifest `8a08e50e4101b6c9e593461e4fa91feee63fa8e9c009e3c60ba3cc1853f428cf`,
one with timing disabled and one enabled.

The 24-process disabled/enabled campaign was structurally valid but failed the
observer gate:

| Scenario | Adjusted aggregate overhead | Paired median | Timing-order subsets | Slower pairs |
| --- | ---: | ---: | --- | ---: |
| S0 | +14.20% | +15.15% | +13.71% / +15.15% | 3/3 |
| S2 | +16.92% | +16.63% | +16.44% / +17.15% | 3/3 |

The preregistered ceiling was 5% for both aggregate and median, with stable
timing-order subsets. Consequently, the recorder cannot prove stage shares or
name a production target. Its apparent rankings and residuals are preserved
only as rejected-method diagnostics under
`.context/benchmark-results/in-frame-attribution-v1/`. All recorder, collector,
render-probe, result-schema, and timing-contract source was removed. The
normal release benchmark has no `MIX_BENCHMARK_TIMINGS` option.

Any future same-frame attempt must first demonstrate <=5% disabled/enabled
movement. Prefer framework/profile timeline data or one stage per frozen
binary so nested event collection cannot perturb a 36-card S0 iteration this
heavily. Do not combine R21's stage durations with uninstrumented totals.

## Experiment rules

- Keep primary and diagnostic result files separately labeled.
- Do not infer allocation volume from GC event counts alone.
- For small deltas, run Flutter and Mix controls as separate fresh processes,
  rotate case order, alternate revision-first order, and retain every paired
  delta.
- Before every fresh-process run, verify that no earlier workspace benchmark
  app or `flutter run` wrapper remains; explicitly terminate the runner after
  the result marker is written.
- Do not attribute a total-span outlier to Mix unless its build/raster/vsync
  phases and transition boundary identify the source.
- Promote a quick win only when its contract tests pass and repeated primary
  runs improve the intended scenario without moving cost elsewhere.

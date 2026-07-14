# Rendering-pipeline investigation findings

- Date: 2026-07-13
- Flutter: 3.41.7 (`cc0734ac71`)
- Dart: 3.11.5
- Host: macOS 26.5.2, 1600×1200 physical view, 120 Hz
- Branch: `chore/benchmarking`
- Status: accepted baseline established in draft PR #976; validated follow-up
  opened as draft PR #977; uniform-border follow-up validated locally

## Executive answer

The investigation found four low-risk sources of avoidable work in the normal
Mix pipeline and implemented fixes for them:

1. provider-presence checks no longer subscribe to every widget-state aspect;
2. null-animation styles no longer allocate a no-animation driver and
   `AnimatedBuilder` subtree;
3. styles with no declared variants return before filter/sort/list work; and
4. automatic pointer tracking and controller ownership are now lazy and only
   installed for hover/pressed styles.

Counter contracts confirm that irrelevant state changes now perform zero Mix
resolutions, while relevant state changes retain the expected rebuild and paint
behavior. The earlier combined workload A/B moved static Mix iterations by
roughly 20–22 µs, but that multi-case timing is retained as directional
characterization because this session later proved that heap/GC phase can leak
between cases in one process. The eliminated-work and lifecycle claims are
test-backed; a fresh origin-main versus final timing rerun is required before
turning that older combined number into a regression threshold.

The main remaining static cost is style computation plus widget construction.
With the accepted production state, fresh-process S0 averages 504.18 µs for Mix
and 216.59 µs for Flutter, a 287.60 µs gap. That is about 3.45% of an 8.33 ms
120 Hz frame budget, not a missed-frame claim. A synchronous stage probe
attributes about two thirds of realistic `Style.build` CPU to active-variant
evaluation/merge and about one third to generated property/spec resolution.

Removing the second active-style merge list looked like a large quick win in a
synchronous probe and in static grids. It was nevertheless rejected: the full
fusion regressed S2 state transitions in 10/10 release pairs and two balanced
real-cadence profile pairs. A narrower one-active-variant fast path retained
the static gain but still moved S2 in the wrong direction in 10/10 pairs. Both
experiments are documented below and are not present in the final source.

The follow-up phase has now added an external-process retained-heap diagnostic
and screened one further variant hypothesis. Retaining every operation result
shows that a complete `Style.build` has the same final object graph as resolving
an already merged style; merge intermediates do not survive into the returned
`StyleSpec`. Skipping `List.sort` when variant order was already suitable did
not make the variant stage faster and was rejected before a primary workload
campaign.

The generated-resolution split found a safe follow-up win. Most generated
properties contain one ordinary `ValueSource`, but `Prop.resolveProp` still
created a temporary values list, scanned it for `Mix`, and then returned its
last element. A narrow fast path now returns that direct value after applying
directives. Token sources, explicit `MixSource` values, direct values that
themselves implement `Mix`, and all multi-source properties retain the original
algorithm. In 10 fresh-process pairs, S0/S0I improved 9.88%/9.23% after Flutter
adjustment, lifecycle controls were neutral, and S2 improved 8.60% in 10/10
pairs. Profile and release-cadence gates found no regression for the narrow
version.

The latest field-level continuation found a second generated-resolution win.
Uniform `BorderMix` values stored the same side property four times, and the
generated resolver independently resolved all four references. `BorderMix`
now resolves that shared property once and constructs a uniform Flutter
`Border`; non-uniform borders retain the original per-side path. Besides
removing repeated work, this preserves uniformity when a context-token resolver
is consulted. Two matched 80-process campaigns pooled to a 1.25% adjusted S0
improvement. Their individual S2 signs disagreed despite byte-identical
executable text; the pooled S2 result is neutral (-0.05%), not a speed claim.

## Final measurement protocol

The release CPU protocol now uses:

- release/AOT mode only;
- 100 warm-up iterations and one measured second per case;
- one implementation/scenario per fresh process for decision-grade A/B work;
- 10 adjacent baseline/optimized pairs;
- alternating baseline-first/optimized-first order;
- rotating scenario order across pairs;
- a persistent mounted root when a process contains multiple cases;
- one monotonically increasing synthetic frame clock per process; and
- exclusive manual-frame ownership: benchmark frame policy is entered once and
  engine begin/draw callbacks are detached until manual pumping ends.

The callback guard is necessary because benchmark policy suppresses new
framework frame requests but cannot cancel a vsync already accepted by the
engine. A queued macOS activation frame can otherwise split a manual
`handleBeginFrame`/`handleDrawFrame` pair.

Validation completed:

- 30/30 independent release stress processes, 300/300 complete cases;
- 200/200 full-fusion fresh-process A/B cases;
- 200/200 single-active fresh-process A/B cases; and
- zero frame-pairing, test, or structural-output failures in those logs.

Valid local raw data (gitignored):

- `.context/benchmark-results/frame-isolated-stress/run-*.json`;
- `.context/benchmark-results/main-fused-isolated-v1/paired-*.json`;
- `.context/benchmark-results/single-active-v1/paired-*.json`;
- `.context/benchmark-results/s2-profile-fused/profile-p*.json`;
- `.context/benchmark-results/resolution-stage-v3/run-*.json`;
- `.context/benchmark-results/resolution-stage-fused/paired-*.json`;
- `.context/benchmark-results/pr976-reference-v1/*.json`;
- `.context/benchmark-results/pr976-retained-gc-v1/{forward,reverse}-01.json`;
  and
- `.context/benchmark-results/sort-skip-stage-screen-v1/*.json`;
- `.context/benchmark-results/prop-single-value-stage-v1/*.json`;
- `.context/benchmark-results/prop-single-value-primary-v1/*.json`;
- `.context/benchmark-results/prop-single-value-profile-v1/*.json`; and
- `.context/benchmark-results/prop-single-value-release-cadence-v1/*.json`.

### Invalidated protocols

The initial release harness restarted timestamps and switched frame policy per
case. Later revisions fixed timestamp monotonicity and mounted one root, but a
rare queued engine frame still reproduced after many clean launches. Those
datasets are not decision-grade.

A structurally clean 20-process multi-case fusion run then exposed a second
problem: later no-op cases had large p90 shifts in both Mix and Flutter even
though the source change was Mix-only. Running every case in a fresh process
removed the bimodality and made S1/S1I controls neutral. Multi-case timing is
therefore useful for smoke/stress work but not for small per-scenario A/B
deltas.

The following local directories are superseded or incomplete: `baseline`,
`qw2`, `variant-before`, `variant-after`, partial `variant-fixed-*`,
`main-fused`, `main-fused-v2`, `main-fused-v3`, and `main-fused-v4`.

The post-build wrapper subtraction probe is also invalid for attribution.
Forward/reverse ordering produced impossible hierarchies in which a full
`StyleBuilder` appeared faster than a direct renderer. It remains explicitly
exploratory; none of its deltas support a production claim.

The allocation directories `pr976-allocation-v1` and `pr976-retained-v1` are
also superseded. `getAllocationProfile` reports a live-heap census in this VM;
resetting it does not turn `instancesAccumulated` into allocation throughput.
The first directory also allowed profiler implementation classes to share the
target isolate group, and the second did not collect both endpoints after GC.
Neither supports a per-operation allocation claim.

## Current accepted pipeline cost

These are fresh-process values from the baseline side of the final full-fusion
experiment. They characterize the accepted production implementation. They do
not compare origin-main with this worktree.

| Scenario | Flutter average | Mix average | Mix − Flutter | Budget share of gap |
| --- | ---: | ---: | ---: | ---: |
| S0 static isolation | 216.59 µs | 504.18 µs | +287.60 µs | 3.45% |
| S0I static idiomatic | 315.87 µs | 658.55 µs | +342.68 µs | 4.11% |
| S1 irrelevant hover | 136.65 µs | 137.57 µs | +0.92 µs | 0.01% |
| S1I irrelevant idiomatic hover | 136.33 µs | 137.64 µs | +1.31 µs | 0.02% |
| S2 pressed + selected | 154.21 µs | 146.93 µs | −7.28 µs | n/a |

S2 here is an artificial maximum-load CPU loop. The profile track, not this
tight loop, is the source for real-cadence build/raster/missed-frame evidence.

The earlier accepted-change A/B used the superseded multi-case protocol and is
kept only as directional characterization:

| Scenario | Mix baseline | Mix accepted changes | Direct delta | Flutter-adjusted delta |
| --- | ---: | ---: | ---: | ---: |
| S0 | 475.75 µs | 456.01 µs | −19.74 µs | −22.59 µs |
| S0I | 624.78 µs | 602.47 µs | −22.31 µs | −29.68 µs |

A newer 30-process reference run against the exact code in PR #976 completed
three fresh processes per implementation/scenario without errors:

| Scenario | Flutter average | Mix average | Mix − Flutter |
| --- | ---: | ---: | ---: |
| S0 | 213.81 µs | 474.87 µs | +261.06 µs |
| S0I | 318.73 µs | 631.40 µs | +312.67 µs |
| S1 | 135.41 µs | 137.17 µs | +1.77 µs |
| S1I | 134.63 µs | 137.96 µs | +3.32 µs |
| S2 | 151.47 µs | 147.58 µs | −3.89 µs |

This is current-baseline characterization, not an optimization verdict: three
runs are enough to reconcile the source/binary baseline but not the required
10 adjacent A/B pairs.

## Where style-computation time comes from

The synchronous diagnostic uses the realistic card style with five declared
variants. It measures independent tight loops inside one mounted Material
context.

| Profile | Active / declared | Variant merge | Premerged resolve | Full `Style.build` | Merge share | Resolve share |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Static | 1 / 5 | 3.43 µs | 1.80 µs | 5.44 µs | 63.1% | 33.0% |
| All active | 5 / 5 | 12.95 µs | 6.11 µs | 20.30 µs | 63.9% | 30.1% |

The variant stage includes predicate evaluation, widget-state reads, sorting,
recursive active-style processing, and style merges. Premerged resolution
includes generated `Prop`/token/Mix/directive resolution, modifier resolution,
and `BoxSpec`/`StyleSpec` construction. These values do not include
`StyleAnimationBuilder`, concrete widgets, layout, paint, or raster.

A later split measured property-source resolution separately from construction.
Construction alone is about 11-12 ns and did not move across candidates; the
generated-resolution cost is overwhelmingly property resolution. For the final
narrow fast path:

| Profile | Property baseline | Fast path | Delta | Full build delta |
| --- | ---: | ---: | ---: | ---: |
| Inactive only | 301.39 ns | 197.59 ns | -34.44% | -11.03% |
| Static | 1.808 µs | 1.298 µs | -28.22% | -12.35% |
| All active | 6.117 µs | 5.891 µs | -3.70% | -3.46% |

## Confirmed findings

### F1: Provider presence caused irrelevant resolutions

`StyleBuilder` used `WidgetStateProvider.of(context) != null` only to ask
whether a scope existed. A null `InheritedModel` aspect subscribes to every
aspect, so idiomatic hover changes resolved state-free and pressed-only styles.
The new exact, non-listening lookup makes both resolution counts zero while
declared state variants still subscribe through `hasStateOf`.

### F2: Null-animation styles paid for an unused driver

The null path no longer constructs `NoAnimationDriver`, its controller/value,
or an `AnimatedBuilder`. Configured curve, spring, phase, and keyframe paths are
unchanged. Tests cover adding/removing animation configuration and interrupted
transitions.

### F3: Empty declared variants have a safe fast path

`mergeActiveVariants` now returns immediately when `$variants` is null or
empty. The corrected zero-variant diagnostic improved by about 2.05 µs average,
1.9 µs median, and 3.0 µs p90 across 10 pairs. This is also exercised
recursively by active fragments without nested variants.

### F4: Automatic interaction ownership did dead work

`StyleBuilder` no longer mixes in an unused ticker provider, eagerly allocates
an internal controller, allocates a state set for capability checks, or wraps
selected-only styles in a detector that cannot produce selected state.
Controller handoff, inherited pointer styles, hover/press behavior, and
selected-only behavior have focused lifecycle/tree tests.

### F5: S2 does not resolve twice

S2 performs two controller notifications (`pressed` and `selected`) but Flutter
coalesces them into one Mix resolution and one concrete renderer build in the
pumped frame. Idiomatic press likewise resolves exactly once per true state
transition. Duplicate style computation was not the S2 cost source.

### F6: Variant merge is the largest measured style-computation stage

For this five-variant card, variant work is roughly two thirds of
`Style.build`; generated resolution is roughly one third. This identifies the
optimization target but does not authorize an implementation that trades
static speed for state-transition regressions.

### F7: Merge intermediates are transient, not retained output

The allocation diagnostic runs its VM-service client in a separate OS process,
forces GC before both snapshots, and retains every measured result. It therefore
measures objects reachable from returned results, not transient allocation
throughput. Forward and reverse stage orders produced the following per-result
live-heap deltas for 5,000 operations:

| Profile | Stage | Retained objects/op | Retained bytes/op |
| --- | --- | ---: | ---: |
| Static | Variant merge | 12.00 | 599.90 B |
| Static | Premerged resolve | 13.00 | 663.88 B |
| Static | Full build | 13.00 | 663.88 B |
| All active | Variant merge | 18.00 | 823.85 B |
| All active | Premerged resolve | 16.00 | 759.86 B |
| All active | Full build | 16.00 | 759.86 B |

The exact equality between premerged resolve and full build is the important
result: the returned static graph contains about one `BoxSpec` and one
`StyleSpec` per operation, while merge-created styles/lists/props do not add to
the final graph. The retained merge result itself contains about one
`BoxStyler` and two `Prop` objects in the static case, or four `Prop` objects
when all variants are active. AOT class-allocation tracing is unavailable in
this VM, so no transient allocation count is claimed.

### F8: Ordinary single-value properties can bypass accumulation work

The accepted path applies only when a property has exactly one `ValueSource`
and that value is not itself `Mix<V>`. It avoids the temporary values list and
`Mix` scan, then applies the same directives. Every source type with additional
semantics falls through to the unchanged implementation.

| Scenario | Mix baseline | Fast path | Adjusted delta | Adjusted change | Faster pairs |
| --- | ---: | ---: | ---: | ---: | ---: |
| S0 | 470.77 µs | 423.50 µs | -46.52 µs | -9.88% | 9/10 |
| S0I | 618.82 µs | 556.30 µs | -57.10 µs | -9.23% | 9/10 |
| S1 | 134.50 µs | 133.69 µs | -0.07 µs | -0.05% | 6/10 |
| S1I | 134.15 µs | 133.85 µs | +0.21 µs | +0.16% | 5/10 |
| S2 | 141.78 µs | 128.72 µs | -12.19 µs | -8.60% | 10/10 |

Two balanced profile pairs both improved adjusted build and total-span time:
-0.374 ms build, -0.144 ms raster, and -710.01 µs total span on average. All
eight processes had zero 120 Hz misses, six new-generation GC events, and zero
old-generation events. A separate 10-pair release/AOT cadence run was neutral
at frame scale (-0.006 ms build, +0.069 ms raster, +3.70 µs total span) and the
changed Mix process group had zero misses over roughly 2,400 frames. This is
consistent with a sub-frame CPU improvement rather than a raster claim.

### F9: Active-style extraction and generic dispatch dominate variant merge

The resolution diagnostic now measures variant collection, priority sorting,
faithful active-style extraction, and pre-extracted merging independently. Two
forward/reverse release runs agree on the shape:

| Profile | Collection | Sort | Extraction | Pre-extracted merge | Official variant merge |
| --- | ---: | ---: | ---: | ---: | ---: |
| Static | 0.603 µs | 0.025 µs | 2.508 µs | 0.104 µs | 3.230 µs |
| All active | 0.666 µs | 0.052 µs | 11.195 µs | 0.481 µs | 12.474 µs |

Extraction includes the generic `StyleVariation<S>` check, context-builder
dispatch, tuple construction, and list append used by production. It accounts
for about 78% of static merge and 90% of all-active merge in these independent
tight loops. The stages are not additive attribution, but their order-balanced
scale clearly rules out priority sorting and the final style merge as primary
cost centers.

A counterfactual pre-extracted merge with variant metadata removed was flat:
0.110 versus 0.104 µs static and 0.472 versus 0.481 µs all-active. Repeated
`MixOps.mergeVariants` metadata copying is therefore not the dominant cost in
this profile. Removing public metadata remains semantically unsupported.

### F10: Generic variation inspection—not ContextVariantBuilder—is most extraction cost

The extraction diagnostic now separates its two active input classes and adds
a counterfactual ordinary-style probe without the generic StyleVariation
inspection. Absolute values changed substantially with case order, but the
composition was stable:

| Order | Faithful extraction | Context builder | Ordinary + variation check | Ordinary without check |
| --- | ---: | ---: | ---: | ---: |
| Forward | 21.435 µs | 4.574 µs | 16.369 µs | 0.090 µs |
| Reverse | 10.902 µs | 2.486 µs | 8.399 µs | 0.086 µs |

The card has one active `ContextVariantBuilder` that performs
`Theme.of(context)` and four ordinary active state styles. In both orders, the
builder contributes about 21–23% of faithful extraction and the ordinary path
with its generic `StyleVariation<BoxSpec>` check contributes about 76–77%.
Removing only that diagnostic check reduces four-style extraction to 86–90 ns.
The faithful total is approximately the sum of the two independently timed
input classes.

This identifies the expensive operation more precisely, but it is not a
production-speed claim. R10–R14 show that changing or bypassing the check in
production perturbs AOT code shape: local merge can improve while complete
`Style.build` or S2 regresses. R15–R17 show that raw/marker prefilters and an
external identity cache do not make the isolated interface test cheaper. Any
future representation change must therefore
pass the same fresh-process full-workload gates rather than extrapolating the
8–16 µs isolated counterfactual. Raw evidence is under
`.context/benchmark-results/extraction-composition-v1/`.

### F11: Release runners must be reaped between processes in this agent environment

The benchmark app writes its result and exits, but the Conductor unified-exec
sessions used in this investigation left some completed `flutter run` wrapper
processes sleeping. They consumed no measurable CPU but retained tens of
megabytes each, and enough accumulated to weaken memory/process isolation for
later small-delta work. All workspace-specific resolution-stage wrappers and
apps were terminated when the session paused.

Large within-process attribution ratios and conservative rejected candidates
remain useful, but future decision-grade campaigns must verify a clean process
table before each run and explicitly reap the runner afterward. No property
field result was accepted: the first attempt stopped at its new nullable
control and wrote no file, and the post-fix smoke was intentionally interrupted
when the user paused the session.

### F12: Decoration and modifier resolution dominate the remaining property stage

The field-family diagnostic completed in both forward and reverse order with
66 valid results per process (22 stages across three profiles). Balanced
process-average timings locate the remaining generated resolution cost:

| Profile | Whole property resolution | Decoration | Modifier | Padding | Transform |
| --- | ---: | ---: | ---: | ---: | ---: |
| Inactive only | 0.207 µs | 0.093 µs | 0.005 µs | 0.005 µs | 0.005 µs |
| Static | 1.361 µs | 1.211 µs | 0.005 µs | 0.119 µs | 0.020 µs |
| All active | 6.544 µs | 3.599 µs | 2.258 µs | 0.119 µs | 0.069 µs |

The null-property control is about 1.39 ns. Independent stages are not
algebraically additive, but their composition is stable enough for
attribution: decoration is about 89% of static property resolution and 55% of
all-active resolution; one active opacity modifier contributes about 35% of
the all-active property stage. Constraints dominate only the synthetic
inactive profile (about 0.106 µs). Spec construction is 12–15 ns and is not a
material remaining cost. Raw evidence is under
`.context/benchmark-results/property-field-attribution-v2/`.

### F13: Uniform border sides were resolved four times — fixed

The decoration split expanded the synchronous protocol to 34 stages across
three profiles. Forward/reverse results consistently located most all-active
decoration resolution in the border:

- a complete merged decoration resolved in 2.59–2.63 µs;
- its border alone took 2.21–2.24 µs (about 85–86%);
- merging the border sources took only about 0.36–0.38 µs; and
- resolving the already merged `BorderMix` took 1.60–1.68 µs.

The realistic card uses uniform `borderAll` sources. `BorderMix.isUniform`
confirmed that all four fields held the same `Prop<BorderSide>`, but generated
resolution still called `MixOps.resolve` separately for bottom, left, right,
and top. A counterfactual resolving that property once reduced the all-active
border substage to 0.825–0.857 µs. A test using a context token then exposed a
semantic consequence of the old path: the same resolver was invoked four
times and could make a declared uniform border non-uniform.

The production implementation now uses a manually maintained `resolve` method
for `BorderMix` and leaves non-uniform resolution unchanged. An initial version
checked structural equality twice and failed the static stage gate; removing
that duplicate check produced the expected balanced result:

| Profile/stage | Baseline | Candidate | Balanced delta |
| --- | ---: | ---: | ---: |
| Static merged border | 0.358 µs | 0.278 µs | -22.4% |
| Static decoration | 0.792 µs | 0.708 µs | -10.6% |
| All-active merged border | 1.639 µs | 0.859 µs | -47.6% |
| All-active decoration | 2.516 µs | 1.759 µs | -30.1% |
| All-active property resolution | 6.789 µs | 5.171 µs | -23.8% |
| All-active premerged spec | 5.964 µs | 5.198 µs | -12.9% |

The primary gate was repeated twice with frozen binaries, ten adjacent pairs
per scenario and campaign, separate Flutter controls, alternating
revision/scenario order, and three measured seconds per process (160 processes
total). The two candidate builds had byte-identical executable text and
normalized disassembly. Their individual S2 aggregate signs disagreed
(-0.67% then +0.58%), demonstrating that either ten-pair S2 estimate was below
the run-to-run noise floor. Pooling all 20 pairs gives:

| Scenario | Aggregate adjusted | Median paired | Trimmed mean | Improved pairs |
| --- | ---: | ---: | ---: | ---: |
| S0 static | -1.25% | -1.30% | -1.11% | 13/20 |
| S2 pressed + selected | -0.05% | -0.48% | -0.07% | 12/20 |

The candidate is retained for the repeatable static improvement; S2 is a
non-regression control, not an improvement claim. The scope is intentionally
limited to `BorderMix`; `BorderDirectionalMix` has the same generated shape
but was not exercised by this workload and remains a separately gated
follow-up. Raw evidence is under
`.context/benchmark-results/decoration-substage-v1/`,
`.context/benchmark-results/border-counterfactual-v1/`, and
`.context/benchmark-results/uniform-border-primary-v{1,2}/`.

## Rejected performance experiments

### R1: Fully fused active-style extraction and merge

The fused loop removed the second `(Style, isVariation)` list. Its synchronous
stage result was large and repeatable:

| Profile | Stage | Baseline | Fused | Delta | Faster pairs |
| --- | --- | ---: | ---: | ---: | ---: |
| Static | Variant merge | 3.88 µs | 1.04 µs | −2.84 µs | 10/10 |
| Static | Full build | 5.85 µs | 2.87 µs | −2.99 µs | 10/10 |
| All active | Variant merge | 14.70 µs | 1.51 µs | −13.19 µs | 10/10 |
| All active | Full build | 22.18 µs | 7.72 µs | −14.46 µs | 10/10 |

Fresh-process complete workloads showed the tradeoff:

| Scenario | Mix baseline | Fused | Mix delta | Adjusted delta | Faster pairs |
| --- | ---: | ---: | ---: | ---: | ---: |
| S0 | 504.18 µs | 395.59 µs | −108.59 µs | −108.53 µs | 10/10 |
| S0I | 658.55 µs | 555.63 µs | −102.92 µs | −104.40 µs | 10/10 |
| S1 | 137.57 µs | 138.18 µs | +0.61 µs | +0.05 µs | 4/10 |
| S1I | 137.64 µs | 138.98 µs | +1.34 µs | +0.72 µs | 3/10 |
| S2 | 146.93 µs | 158.50 µs | +11.57 µs | +11.98 µs | 0/10 |

Two balanced, fresh-process S2 profile pairs confirmed the negative movement:

| Metric | Flutter control delta | Mix delta | Adjusted Mix delta |
| --- | ---: | ---: | ---: |
| Average build | +0.0085 ms | +0.0885 ms | +0.0800 ms |
| Average raster | +0.0225 ms | +0.2085 ms | +0.1860 ms |
| Average total span | +21.67 µs | +302.07 µs | +280.40 µs |

Both revisions recorded zero 120 Hz budget misses and the same 12 aggregate
new-generation GC events; neither recorded old-generation GC. The experiment
was reverted despite its static and synchronous wins.

### R2: Single-active-variant fast path

This version used the direct path only for zero/one active variants and retained
the original two-phase path for multiple active variants.

| Scenario | Mix baseline | Fast path | Mix delta | Adjusted delta | Faster pairs |
| --- | ---: | ---: | ---: | ---: | ---: |
| S0 | 495.00 µs | 392.58 µs | −102.42 µs | −101.12 µs | 10/10 |
| S0I | 644.91 µs | 549.18 µs | −95.74 µs | −100.50 µs | 10/10 |
| S1 | 137.64 µs | 137.68 µs | +0.04 µs | −0.23 µs | 6/10 |
| S1I | 137.09 µs | 137.14 µs | +0.05 µs | −0.01 µs | 5/10 |
| S2 | 146.97 µs | 149.99 µs | +3.02 µs | +3.34 µs | 0/10 |

The stop condition was a consistent targeted-workload regression, so this
version was also reverted.

### R3: Stable linear variant partition as a speed win

The tested two-bucket implementation regressed every non-empty diagnostic
count: +57.84 µs at one declared variant, +74.85 µs at four, and +10.78 µs at
12, each 10/10 pairs slower. Stable ordering remains a correctness concern, but
that implementation is not a performance optimization.

### R4: Independently pumped wrapper subtraction

Frame scheduling and application activation dominated direct/animation/
`StyleSpecBuilder`/`StyleBuilder` comparisons. No wrapper delta from that probe
is valid. A future split needs spans or counters inside one frame, not
subtraction of separately pumped widget cases.

### R5: Skip sorting when variants are already bucket-ordered

This experiment preserved the existing stable sort whenever a widget-state
variant preceded a non-widget variant, but skipped it when all non-widget
variants already came first. Correctness tests covered interleaved priority and
same-bucket order, and all focused tests passed. Four order-balanced stage runs
showed no target-stage win:

| Profile | Baseline variant merge | Sort-skip | Delta |
| --- | ---: | ---: | ---: |
| Static | 3.318 µs | 3.367 µs | +1.5% |
| All active | 13.012 µs | 13.057 µs | +0.3% |

Because the intended variant stage was flat-to-slower, the stop rule applied:
the change was reverted without spending a 10-pair S0/S2 campaign on unrelated
full-build noise.

### R6: Share a variant list when the other merge side is null

`MixOps.mergeVariants` currently copies the non-null list when the other side
is null. Sharing that list would remove repeated copies while merging active
fragments, but it was rejected at source review without a production
experiment. `$variants` is a public mutable `List`, generated style constructors
retain caller-owned lists, and merge currently creates a distinct list even for
a null-side merge. Other code and the pipeline guide describe fluent operations
as producing new style values. Removing the copy would therefore introduce a
new alias between source and merged styles unless the broader API first makes
variant-list ownership immutable. That semantic expansion is not justified by
an unmeasured speed hypothesis.

### R7: Return immediately when no declared variant is active

This candidate preserved current result identity and added only an early return
after filtering. An inactive-only diagnostic profile with four declared widget
states made the intended merge-stage result measurable. Across four
order-balanced release runs, the target was flat-to-slower:

| Profile | Stage | Baseline | Early return | Delta |
| --- | --- | ---: | ---: | ---: |
| Inactive only | Variant merge | 564.89 ns | 565.94 ns | +0.18% |
| Inactive only | Full build | 923.69 ns | 906.00 ns | −1.92% |
| Static control | Variant merge | 3.349 µs | 3.365 µs | +0.47% |
| All-active control | Variant merge | 12.793 µs | 12.723 µs | −0.55% |

The full-build delta is not attributable when the directly changed stage does
not improve. The production branch was reverted and no primary campaign was
run. The inactive-only diagnostic and identity contract remain to make this
case explicit in future work.

### R8: Generalized single-source property fast path

The first version dispatched all single sources directly. A focused test caught
an initial semantic error: `Prop.value<Object>` may contain a value that itself
implements `Mix<Object>`, which the baseline resolves. The corrected version
preserved direct/token `Mix` and nested `Style` behavior and produced strong
release CPU results, but profile cadence regressed in 3/4 pairs by +0.175 ms
adjusted build and +212.36 µs adjusted total span. Moving the unchanged
multi-source algorithm to a helper reduced but did not remove the profile-mode
regression (+0.130 ms build and +249.61 µs span in 2/2 pairs). Its release/AOT
cadence averages were neutral, but changed Mix recorded four isolated 120 Hz
misses while the other groups recorded none in that campaign. Both generalized
forms were rejected. Restricting the branch to ordinary `ValueSource` values
removed the complex dispatch from the hot path and passed every gate in F8.

### R9: Replace lazy active-variant filtering with a manual loop

This candidate replaced only `variants.where(predicate).toList()` with an
explicit `for` loop. Sorting, style extraction, recursive resolution, and merge
order were unchanged. A characterization test confirmed that every context
predicate is still evaluated exactly once; 45 focused variant and
`StyleVariation` tests passed.

Four forward/reverse release stage pairs showed a genuine local improvement.
Because the first forward baseline was an extreme cold/order outlier, the table
uses the median process average across all four pairs:

| Profile | Stage | Baseline | Manual loop | Change |
| --- | --- | ---: | ---: | ---: |
| Inactive only | Variant merge | 560.95 ns | 481.46 ns | -14.17% |
| Static | Variant merge | 3.222 µs | 3.076 µs | -4.53% |
| All active | Variant merge | 12.272 µs | 11.935 µs | -2.75% |

The complete fresh-process AOT workload did not preserve that result safely:

| Scenario | Baseline process median | Manual-loop process median | Median paired change | Faster pairs |
| --- | ---: | ---: | ---: | ---: |
| S0 | 418.88 µs | 411.64 µs | -1.91% | 8/10 |
| S2 | 128.19 µs | 130.04 µs | +0.37% | 4/10 |

The trimmed-mean S2 change was also a regression (+0.67%). S2 is the relevant
state-heavy workload, so the candidate failed the primary stop condition and
was reverted before profile or release-cadence promotion. This is further
evidence that removing a short-lived iterator/closure cost can change AOT code
shape without reducing end-to-end state-transition cost.

### R10: Skip StyleVariation inspection for an empty named-variant set

The branch is logically unreachable when `namedVariants` is empty, so a guard
was tested around the generic `StyleVariation<S>` check. All 46 focused tests
passed, including nonempty StyleVariation behavior. The forward run improved
all-active extraction/merge by 2.4%/2.1%, but the matched reverse run regressed
them by 2.5%/1.7%. Static merge regressed in both directions, by 2.2% and 2.1%.
The candidate was reverted at the stage gate without a primary S0/S2 campaign.

### R11: Remove the per-variant extraction IIFE

This refactor replaced only the immediately invoked closure in the
ContextVariant/NamedVariant extraction branch with a switch statement and
direct list appends. The two-phase record list, StyleVariation checks, builder
dispatch, recursion, priority, and merge order were unchanged; all 45 focused
tests passed.

The forward release run improved all-active extraction 4.5%, official variant
merge 5.0%, and full build 3.6%. The matched reverse run did not reproduce the
target-stage gain: all-active extraction regressed 0.9% and variant merge
regressed 0.25%; static full build also regressed 0.6%. The candidate was
therefore order-sensitive and was reverted before primary S0/S2 testing.

### R12: Bind StyleVariation with a typed pattern

This semantics-equivalent refactor replaced the separate generic `is` check
and `as` cast with one `StyleVariation<S>` pattern binding. All 45 focused tests
and analysis passed. Forward all-active extraction/merge improved 3.6%/3.8%,
but static extraction/merge regressed 1.6%/0.8%. Reverse then regressed
all-active extraction 2.6%, merge 0.29%, and full build 2.9%; static merge and
full build also regressed. The change was reverted at the stage gate.

### R13: Cache StyleVariation classification on VariantStyle

This experiment moved the generic `StyleVariation<S>` classification from the
hot extraction loop to fluent `VariantStyle` construction and merge. The public
`const VariantStyle` constructor retained a runtime fallback for source
compatibility, while framework-created variants used an internal preclassified
constructor. The cached field was excluded from equality and hash semantics.
All 89 focused variant, identity, nesting, and `StyleVariation` tests passed.

The matched forward/reverse release runs did not produce a workload-safe gain:

| Order | Profile | Extraction | Official merge | Full build |
| --- | --- | ---: | ---: | ---: |
| Forward | Inactive only | -0.85% | +7.83% | +4.92% |
| Forward | Static | +1.80% | +2.82% | +1.30% |
| Forward | All active | -3.08% | -2.82% | -2.41% |
| Reverse | Inactive only | -4.02% | +4.73% | +6.43% |
| Reverse | Static | -1.87% | -0.65% | -0.50% |
| Reverse | All active | -0.37% | -0.72% | +1.63% |

The forward all-active improvement collapsed in reverse order, while the
inactive-only full path regressed in both runs and static regressed throughout
the forward run. Per-instance classification metadata therefore trades AOT
code/object shape between profiles rather than removing stable end-to-end
work. The candidate was reverted before a primary S0/S2 campaign. Raw evidence
is under `.context/benchmark-results/preclassified-style-variation-stage-v1/`.

### R14: Split the empty-named-set extraction path

Most widget builds pass an empty named-variant set. This experiment branched
once per recursive merge call and used a dedicated extraction loop that treats
active contextual `StyleVariation` values as ordinary styles, avoiding the
generic type check for every active variant. A new characterization test pins
the subtle existing contract: in this case `styleBuilder` is not invoked, but
the variation object's ordinary style fields still merge. All 88 focused
identity, nesting, priority, and `StyleVariation` tests passed.

Official variant merge improved for inactive-only in both orders (-1.09% and
-1.77%) and for all-active in both orders (-3.08% and -0.44%). That local
reduction did not survive the complete style computation:

| Order | Profile | Official merge | Full build |
| --- | --- | ---: | ---: |
| Forward | Inactive only | -1.09% | -2.03% |
| Forward | Static | +0.45% | +0.25% |
| Forward | All active | -3.08% | +2.84% |
| Reverse | Inactive only | -1.77% | +0.04% |
| Reverse | Static | -1.62% | -1.82% |
| Reverse | All active | -0.44% | +0.50% |

All-active full `Style.build` regressed in both orders, and static official
merge was not consistently non-regressive. The duplicated extraction path
therefore moved AOT code shape/cost into the complete build despite removing
work locally. It was reverted before primary S0/S2 testing. Raw evidence is
under `.context/benchmark-results/empty-named-specialized-path-stage-v1/`.

### R15: Raw StyleVariation prefilter

A raw `value is StyleVariation` check was placed before the exact
`StyleVariation<BoxSpec>` check so ordinary styles could theoretically avoid
reified generic matching while actual variations retained the exact semantic
guard. In a same-binary diagnostic, four ordinary styles took 8.715 µs with the
prefilter versus 8.645 µs directly in forward order (+0.81%), and 16.080 versus
16.123 µs in reverse (-0.27%). The raw check therefore uses effectively the
same runtime interface machinery and was rejected before production work.

### R16: Non-generic StyleVariation marker prefilter

A field-free, non-generic marker superinterface was temporarily added to
`StyleVariation<S>`. This preserved `VariantStyle` constructors, object layout,
runtime types, equality, and external transitive implementations. It still did
not make the ordinary false path cheaper: marker-prefilter extraction was
8.433 versus 8.486 µs direct in forward order and 8.529 versus 8.530 µs in
reverse. The marker API and diagnostic stage were reverted.

### R17: Expando-cached StyleVariation classification

A benchmark-local `Expando<bool>` cached the exact generic classification by
style identity. Warm-up populated all entries, so the timed stage measured the
best-case steady-state lookup rather than first-use classification. It was
slightly slower in both orders: 8.527 versus 8.504 µs (+0.27%) and 8.443 versus
8.418 µs (+0.29%). No production cache was attempted. The diagnostic remains
available to prevent revisiting this cache shape without new evidence.

### R18: Return directly when only one widget modifier needs ordering

Ordering cannot change a one-element list, so this candidate returned that
list directly instead of constructing the full default type order and scanning
it. A test-first performance contract failed against the baseline and passed
with the one-line guard; the existing default/custom ordering and rendering
tests also passed.

The directly affected release stages improved strongly in both orders:

| Order | Modifier resolution | Property resolution | Premerged resolve | Full build |
| --- | ---: | ---: | ---: | ---: |
| Forward | 2.324→0.034 µs (-98.5%) | 6.702→4.201 µs (-37.3%) | 6.491→4.216 µs (-35.0%) | 18.679→17.157 µs (-8.2%) |
| Reverse | 2.192→0.030 µs (-98.6%) | 6.385→3.959 µs (-38.0%) | 6.004→3.847 µs (-35.9%) | 19.786→17.453 µs (-11.8%) |

The complete 80-process release campaign did not preserve a workload-safe
result after matched Flutter adjustment. S0 improved only 6/10 pairs
(aggregate -0.77%, median paired -1.11%). S2, which does not activate the
disabled opacity modifier and therefore serves as a code-shape control,
improved only 3/10 and regressed +1.24% aggregate, +0.82% median paired, and
+0.98% trimmed mean. The production guard and its no-allocation contract test
were reverted under the state-heavy stop rule. This is a useful local
attribution result, not a shippable optimization. Raw evidence is under
`.context/benchmark-results/modifier-single-fastpath-v1/` and
`.context/benchmark-results/modifier-single-fastpath-primary-v1/`.

## Remaining opportunities

The next useful work should be bounded and independently attributable:

- preserve the established multi-active behavior while avoiding repeated
  generic extraction dispatch through a structural design that does not add
  per-instance metadata to every `VariantStyle` or duplicate the hot loop;
- validate the equivalent uniform fast path for `BorderDirectionalMix` with a
  workload that actually exercises directional borders; do not infer it from
  the accepted `BorderMix` result;
- continue below the now-reduced decoration stage with border radius and box
  shadow only if a primary workload can make their roughly 0.13/0.19 µs costs
  material; modifier ordering already has a strong isolated fast path that
  failed the whole-pipeline state gate;
- find a supported way to measure transient AOT allocations, or use a narrowly
  attributable source change plus release timing rather than mislabeling
  retained heap as allocation throughput;
- investigate a cache only after defining invalidation keys for context,
  tokens, directives, inherited/named variants, widget states, modifiers, and
  animation metadata; and
- repeat profile work on a physical mobile device before making raster,
  energy, or missed-frame claims beyond this macOS host.

Adjacent correctness items remain separate: listening inherited-style lookup,
stable equal-priority variant ordering, and storing/notifying
`WidgetState.scrolledUnder`.

## Verification

Completed for the retained uniform-border candidate:

- the 46-test border suite, including the new one-resolution context-token
  contract;
- all 29 rendering-pipeline app tests and Flutter analysis;
- repository code generation, with only the expected `BorderMix.resolve`
  generated diff;
- the complete repository Flutter and Dart CI scripts;
- all repository Dart analyzer jobs; and
- all fatal DCM analysis jobs with no issues.

All repository commands used the pinned FVM Dart 3.11.5 SDK. The locally
cached Melos launcher emits stale `Invalid SDK hash` diagnostics, but the
individual jobs and top-level generation/CI/analysis commands all completed
with successful exit codes.

Completed for the accepted baseline and final single-value candidate:

- 97 focused variant/`StyleVariation`/context-builder tests;
- all 26 rendering-pipeline app tests;
- rendering-pipeline Flutter analysis; and
- all release/profile output structure and error-log checks described above;
- final release-mode smoke runs of the primary selector, variant diagnostic,
  and post-build probe, each with complete output and no frame-pairing error;
- repository code generation (`gen:build`), with no unexpected generated diff;
- the full Mix Flutter suite;
- all 304 generator tests and 37 linter tests; and
- repository Dart and DCM analysis with no issues.

The configured `ci` wrapper prompts for a package in a non-TTY shell, so its
two constituent scripts were run directly with `--no-select`. The configured
`analyze` wrapper re-enters the workspace once per package and is noisy, but
all Dart/DCM jobs and the final wrapper completed successfully.

The final candidate also passed 88 focused Prop/token/nested-style tests in its
isolated worktree. Repository generation completed without an unexpected
tracked diff; all six Dart analyzer jobs and four fatal DCM jobs completed with
no issues. The aggregate `ci` wrapper still prompts for a package in this
non-TTY shell, so its exact `test:flutter` and `test:dart` constituents were run
directly with `--no-select` under the pinned FVM SDK.

The code-only follow-up is commit `942fd7c04` on
`refactor/prop-single-value-resolution`, draft PR #977. It is stacked on PR
#976 so its GitHub diff contains only `prop.dart` and `prop_test.dart`.

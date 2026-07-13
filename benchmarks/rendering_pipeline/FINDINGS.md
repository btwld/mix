# Rendering-pipeline investigation findings

- Date: 2026-07-13
- Flutter: 3.41.7 (`cc0734ac71`)
- Dart: 3.11.5
- Host: macOS 26.5.2, 1600×1200 physical view, 120 Hz
- Branch: `chore/benchmarking`
- Status: accepted baseline established in draft PR #976; validated follow-up
  opened as draft PR #977

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

## Remaining opportunities

The next useful work should be bounded and independently attributable:

- preserve the established multi-active behavior while avoiding repeated
  filtering/sorting through precomputed variant metadata or another design;
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

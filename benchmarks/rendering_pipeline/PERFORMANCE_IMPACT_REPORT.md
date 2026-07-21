# Mix Rendering Performance: Cost, State Changes, and Practical Impact

- Report date: 2026-07-20
- Mix line under test: accepted pipeline changes from draft PR #976 plus the
  single-value property optimization from draft PR #977 and the locally
  accepted uniform physical-border resolver
- Flutter: 3.41.7 (`cc0734ac71`)
- Dart: 3.11.5
- Host: macOS 26.5.2, Apple silicon, 120 Hz
- Primary optimization benchmark: release/AOT, fresh process per
  implementation/scenario, 100 warm-ups, 10 adjacent baseline/optimized pairs
- Combined checkpoint estimate: release/AOT, three matched fresh-process pairs
  each for S0 and S2
- Web companion: <https://mix-rendering-performance.leo510228.chatgpt.site>

## Executive verdict

Mix still has a measurable CPU premium when a large static subtree rebuilds,
but the current evidence does **not** show a frame-rate problem on the tested
host.

- The latest current-accepted static Mix grid iteration takes **400.97 µs**,
  versus **203.55 µs** for the matched direct-Flutter implementation. The ratio
  is 1.97×, but the absolute difference is only **197.42 µs**, or **2.37% of one
  120 Hz frame budget**.
- The idiomatic static path, including matched interaction wrappers, takes
  **556.30 µs** in Mix versus **298.72 µs** in Flutter. The **257.58 µs** gap is
  **3.09% of a 120 Hz frame budget**.
- Irrelevant state changes are effectively equal to Flutter and now trigger
  **zero Mix resolutions**.
- The pressed-plus-selected state transition is **13.53% faster than the
  matched Flutter control** in the primary CPU benchmark.
- The final optimization made Mix about **9–10% faster** in the static cases
  and **8.60% faster** in the relevant-state case after adjustment for the
  contemporaneous Flutter control.
- Real-cadence validation did not find a regression. Optimized Mix recorded
  zero 120 Hz misses over roughly 2,400 release-cadence frames. The release
  cadence averages were neutral at frame scale.
- The later uniform physical-border resolver added a smaller **1.25% pooled S0
  improvement** with neutral S2. The analogous directional resolver was
  rejected because its static containing spec stage regressed **3.79% in 6/6
  comparisons**, despite a much faster local border stage.
- Directly comparing the clean pre-optimization source with the complete
  current accepted source estimates a net **11.56% adjusted S0 improvement**
  in 3/3 pairs. S2 was **1.41% faster adjusted** in 2/3 pairs, which is too
  small and noisy to promote as a strong speed claim.
- A same-frame stage-timing follow-up was rejected because the recorder added
  **14.20% adjusted S0 overhead** and **16.92% adjusted S2 overhead**, above
  its 5% validity ceiling. It produced no new optimization claim, and all
  timing hooks were removed.

The latest S0 absolute values and combined percentages come from the bounded
baseline-to-current run. The S0I and detailed five-scenario values below come
from the final single-value campaign; the physical-border result is a separately
validated incremental change. These separate experiments are not added
together to manufacture a combined percentage.

The practical conclusion is therefore:

> Mix's remaining static overhead is real and worth continuing to reduce, but
> it is currently a sub-frame CPU tax rather than evidence of visible jank.

The risk rises on slower mobile hardware, in already budget-constrained frames,
or when many styled nodes resolve together. Physical-device validation is
still required before making broad mobile, energy, or raster claims.

## Net baseline-to-current release estimate

The direct comparison freezes clean pre-optimization commit `2140e609d` and
current accepted commit `38511e842`. It runs separate baseline/current Flutter
and Mix processes, three adjacent pairs per scenario, alternating order, three
measured seconds, and matched Flutter normalization.

| Scenario | Baseline Mix | Current Mix | Raw Mix | Flutter control | Adjusted aggregate | Paired median | Wins |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| S0 | 456.14 µs | 400.97 µs | -12.09% | -0.60% | **-11.56%** | **-11.94%** | 3/3 |
| S2 | 128.68 µs | 127.07 µs | -1.25% | +0.17% | -1.41% | -1.79% | 2/3 |

All 24 release processes passed marker, metadata, binary, duration, and sample
validation. Aggregate Flutter controls stayed within 0.60%, but two individual
S2 control pairs moved slightly beyond +/-2%. The host logged brief `mdworker`
and `sysmond` CPU bursts while Conductor remained open. The table is therefore
a practical local estimate: the 11-12% S0 signal is consistent, while the
roughly 1-2% S2 movement should be treated as neutral-to-slightly-better rather
than a release claim. Evidence is under
`.context/benchmark-results/combined-accepted-quick-v8/`.

## Rejected in-frame attribution follow-up

The final continuation asked whether the remaining Mix/Flutter gap could be
split among style resolution, widget assembly, shared rendering, layout, and
paint inside the same release frame. This avoids the earlier invalid method of
subtracting independently pumped widget trees, but any inserted timer can
still perturb the workload it observes.

Two frozen release apps used the same instrumented source: one compiled the
timing flag out and one enabled it. Three adjacent S0/S2 pairs, separate
Flutter and Mix controls, alternating timing-first/scenario/implementation
order, fresh processes, and lifecycle gaps produced 24/24 valid results with
zero exclusions.

| Scenario | Raw Flutter movement | Raw Mix movement | Flutter-adjusted observer overhead | Paired median | Slower pairs |
| --- | ---: | ---: | ---: | ---: | ---: |
| S0 | +0.00% | +14.20% | **+14.20%** | **+15.15%** | 3/3 |
| S2 | -15.08% | -0.72% | **+16.92%** | **+16.63%** | 3/3 |

Both results fail the preregistered <=5% aggregate-and-median gate. Timing-
order subsets agreed, so reversing order does not rescue the method. Although
the enabled payload ranked style resolution first for Mix, those shares are
not valid estimates of the uninstrumented pipeline. No production target was
selected, no optimization was attempted, and the repository source was
restored to checkpoint `4269d387a`. Raw data and the invalid-method summary
are under `.context/benchmark-results/in-frame-attribution-v1/`.

## What “Flutter versus Mix” means here

The comparison deliberately excludes style-declaration construction from the
timed loop.

### Both sides hoist stable work

- Mix constructs `_baseStyle`, `_pressedStyle`, `_allStatesStyle`, and animated
  variants as top-level `final` values. `BoxStyler()` chains are not recreated
  during measured builds.
- Flutter hoists constant colors, shadows, padding, border-radius values, data,
  and child widgets.
- Both implementations reuse the same cached card content, grid,
  `SharedCardRenderer`, and `RepaintBoundary` placement.
- Diagnostic counters are disabled in timed runs.

### The timed difference

The isolation track intentionally narrows the comparison to two different ways
of producing the same resolved `BoxSpec`:

```text
Direct Flutter
  current state booleans
  -> direct color/border/scale branches
  -> BoxDecoration + BoxSpec
  -> shared renderer

Mix
  existing BoxStyler
  -> inherited/state scope handling
  -> active variant evaluation and merge
  -> Prop/token/Mix/directive resolution
  -> BoxSpec + StyleSpec
  -> shared renderer
```

This is apples-to-apples for measuring the cost of Mix's general-purpose style
pipeline. It is not API-symmetric: the Flutter control is a hand-written lower
bound with direct boolean branches and no generic token, variant, directive, or
property machinery. That difference is the abstraction cost the benchmark is
trying to expose.

The Flutter control also constructs a `BoxSpec` so both sides use the same
renderer. Ordinary handwritten Flutter could place values directly on a
`Container`; conversely, either implementation could add an application-level
cache. No such manual cache is applied to either side.

## Workload and scenario definitions

The fixture is a deterministic 60-card `GridView.builder` in a 1200×800 logical
viewport. Approximately 24 cards are fully visible and a fifth row is partially
visible. Each card has the same cached icon/title/subtitle/badge content,
padding, border, radius, and shadow. There is no network or image decoding.

| Scenario | What changes | Why it exists |
| --- | --- | --- |
| S0 | Rebuild the static grid through the isolation path | Measures broad static rebuild cost with rendering held constant |
| S0I | Rebuild through idiomatic interaction wrappers | Includes normal gesture/mouse/focus/semantics ownership |
| S1 | Toggle irrelevant hover on state-free and pressed-only cards | Negative control for unnecessary state subscriptions |
| S1I | Repeat irrelevant hover through idiomatic providers | Verifies provider/wrapper behavior under normal ownership |
| S2 | Toggle pressed and selected on one all-state card | Measures a relevant multi-state transition |

The release CPU timer surrounds the state update or screen rebuild and the
manually pumped Flutter frame. It therefore includes framework work performed
by that pump: style resolution, widget build, layout, and paint. It is not an
engine-raster-completion timer. Separate profile/release-cadence tracks provide
frame build, raster, total-span, and missed-budget evidence.

## Before, after, and direct Flutter

The final campaign ran two matched Flutter controls: one beside the Mix
baseline and one beside optimized Mix. This matters because the validated
optimization result subtracts Flutter's contemporaneous movement rather than
assuming the host is perfectly stationary.

| Scenario | Baseline Flutter | Mix before | Changed Flutter | Optimized Mix | Flutter-adjusted Mix change |
| --- | ---: | ---: | ---: | ---: | ---: |
| S0 | 206.14 µs | 470.77 µs | 205.40 µs | 423.50 µs | **−9.88%** |
| S0I | 304.14 µs | 618.82 µs | 298.72 µs | 556.30 µs | **−9.23%** |
| S1 | 133.84 µs | 134.50 µs | 133.09 µs | 133.69 µs | −0.05% — neutral |
| S1I | 133.83 µs | 134.15 µs | 133.33 µs | 133.85 µs | +0.16% — neutral |
| S2 | 149.73 µs | 141.78 µs | 148.85 µs | 128.72 µs | **−8.60%** |

The optimized-Mix versus changed-Flutter comparison is:

| Scenario | Changed Flutter | Optimized Mix | Mix − Flutter | Relative result | Gap as 120 Hz budget |
| --- | ---: | ---: | ---: | ---: | ---: |
| S0 | 205.40 µs | 423.50 µs | +218.10 µs | Mix takes 2.06× the time | +2.62% |
| S0I | 298.72 µs | 556.30 µs | +257.58 µs | Mix takes 1.86× the time | +3.09% |
| S1 | 133.09 µs | 133.69 µs | +0.60 µs | Mix is 0.45% slower | +0.007% |
| S1I | 133.33 µs | 133.85 µs | +0.52 µs | Mix is 0.39% slower | +0.006% |
| S2 | 148.85 µs | 128.72 µs | −20.14 µs | Mix is 13.53% faster | −0.24% |

Lower is faster. Frame-budget percentages are context, not a claim that the
isolated microbenchmark consumes an entire production frame in the same way.

## Where the remaining Mix time goes

### 1. Variant evaluation and merge is the largest measured style stage

A synchronous diagnostic isolates `Style.build` for a realistic card style
with five declared variants.

| Profile | Active / declared variants | Variant work | Premerged resolution | Full `Style.build` | Variant share | Resolution share |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Static | 1 / 5 | 3.43 µs | 1.80 µs | 5.44 µs | 63.1% | 33.0% |
| All active | 5 / 5 | 12.95 µs | 6.11 µs | 20.30 µs | 63.9% | 30.1% |

“Variant work” includes:

1. evaluating context and widget-state predicates;
2. reading the relevant widget states;
3. collecting active fragments;
4. enforcing variant priority/order;
5. recursively processing active fragments; and
6. merging those fragments into the base style.

This stage grows sharply as more declared variants become active. It remains
the clearest optimization target, but the rejected experiments show that its
current two-phase behavior cannot be replaced casually.

### 2. Property-source resolution is the meaningful generated cost

The generated-resolution split measured property resolution separately from
spec construction:

| Profile | Property resolution before | Optimized | Change | Complete `Style.build` change |
| --- | ---: | ---: | ---: | ---: |
| Inactive-only | 301.39 ns | 197.59 ns | **−34.44%** | −11.03% |
| Static | 1.808 µs | 1.298 µs | **−28.22%** | −12.35% |
| All active | 6.117 µs | 5.891 µs | **−3.70%** | −3.46% |

Generated `BoxSpec` construction itself is only about **11–12 ns**. The
material work is resolving `Prop` sources, including direct values, tokens,
nested `Mix` values, directives, and multiple merged sources.

The final fast path helps the common case where a property contains exactly one
ordinary direct `ValueSource`. It skips creation/scanning of a temporary values
list and then applies the same directives. Token sources, explicit `MixSource`
values, values that themselves implement `Mix`, nested styles, and multi-source
properties keep the original algorithm.

The diminishing all-active gain is expected: a small single-value shortcut is
a smaller fraction of the work when many merged sources and variants are
active.

### 3. Widget and framework work explains the rest of the end-to-end gap

The synchronous stage probe stops before animation wrappers, concrete widget
construction, Flutter element reconciliation, layout, paint, and raster. The
full S0/S0I timer includes several of these later stages. Therefore the
`Style.build` stage figures must not be subtracted mechanically from the full
iteration result.

An attempted wrapper-subtraction probe was invalidated because independently
pumped frames were dominated by scheduling and app-activation noise. The
later same-frame recorder was also invalidated because it added 14-17%
Flutter-adjusted observer overhead. The remaining post-resolution wrapper cost
is therefore not cleanly attributable. A replacement needs materially cheaper
framework/profile spans or one stage per binary and must pass a <=5% disabled/
enabled observer gate before its shares are interpreted.

### 4. Retained result size is known; transient allocation volume is not

After forced GC, retained results show the same final object-graph size for a
full build and a premerged resolve:

| Profile | Retained result graph |
| --- | ---: |
| Static | about 13 objects / 664 B per result |
| All active | about 16 objects / 760 B per result |

This means merge intermediates do not survive in the returned `StyleSpec`.
They may still be transient allocations, but the VM facility used here exposes
a live-heap census rather than allocation throughput. The report therefore
does not claim a transient allocation count or attribute the gap to GC.

## What happens during state changes

### Irrelevant state change: no style work

Before the provider-presence fix, checking whether a widget-state provider
existed subscribed `StyleBuilder` to every state aspect. Hover could therefore
resolve styles that declared no hover behavior.

Now the scope-presence lookup is non-listening, while actual variants subscribe
only to their relevant state aspects. The S1/S1I contract is:

```text
hover controller changes
  -> no relevant style dependency
  -> 0 Mix resolutions
  -> 0 renderer builds
  -> 0 layouts
  -> 0 paints
```

The remaining ~133 µs in S1/S1I is primarily the live benchmark pump/control
floor, which is why Mix and Flutter are almost identical there.

### Relevant pressed + selected change: notifications are coalesced

S2 intentionally performs two controller updates:

```text
pressed update  ─┐
                 ├─ same pumped frame -> 1 Mix resolution -> 1 renderer build
selected update ─┘
```

There are two controller notifications, but Flutter coalesces the dependent
widget invalidations before the pumped frame. Mix does **not** resolve the
style twice. Duplicate resolution is not the S2 bottleneck.

The primary CPU result is favorable: optimized Mix takes 128.72 µs versus
148.85 µs for the matched Flutter mapper. This should not be generalized into
“all Mix state changes are faster”; it is the result for this exact equivalent
pressed-plus-selected card transition.

### Pointer movement: two affected cards can legitimately resolve

Moving a pointer from one hover-aware card to another changes two controllers:
the old card exits hover and the new card enters hover. One resolution per
affected card is expected. This is not duplicate work on one card.

### Press transitions and animation ticks are intentional work

- An idiomatic press produces one resolution when pressed becomes true and one
  when it becomes false.
- `Pressable` and `MixInteractionDetector` may both attempt to write pressed
  state, but `WidgetStatesController.update` suppresses an identical second
  write.
- Once an animation starts, later interpolation-tick builds are intentional.
  They are not repeated state notifications or repeated target-style
  resolution.

## Improvements already accepted

| Change | Work removed | User-visible consequence |
| --- | --- | --- |
| Non-listening provider-presence lookup | Broad state subscription | Irrelevant hover now produces zero Mix resolution/build/layout/paint |
| Lightweight null-animation path | No-animation driver and `AnimatedBuilder` subtree | Static styles avoid animation infrastructure |
| Empty-variant early return | Filter/sort/list work for styles with no variants | Zero-variant style build improved by roughly 2 µs in its diagnostic |
| Lazy interaction ownership | Unused controller, state set, ticker/provider, and detector work | Only hover/pressed styles install automatic pointer tracking |
| Single ordinary value fast path | Temporary list creation and `Mix` scan for one direct value | Static primary workloads improved about 9–10%; S2 improved 8.60% |
| Shared uniform physical border side | Three duplicate side-property resolutions | Pooled S0 improved 1.25%; S2 was neutral |

These changes are narrow because Mix supports tokens, nested mergeable values,
directives, inheritance, context variants, widget-state variants, modifiers,
and animation. A fast path is valid only when it preserves all fallback
semantics.

## Why the obvious larger optimization was rejected

Variant merge accounts for roughly two thirds of `Style.build`, so fusing
active-style collection and merge looked compelling.

The fully fused implementation made the synchronous stage dramatically faster
and improved static grids by approximately 100 µs. It nevertheless made S2
slower in **10/10** release pairs and regressed adjusted real-cadence build,
raster, and total-span averages. A narrower one-active-variant path retained
the static gain but still regressed S2 in **10/10** pairs.

Both were reverted. This is important: optimizing the largest local stage did
not optimize the workload that matters during interaction. The next variant
change must preserve the established multi-active behavior and pass both
static and transition gates.

Other rejected ideas include:

- a stable two-bucket partition, which was slower;
- skipping sort when already ordered, which was flat-to-slower;
- returning early when declared variants were all inactive, whose changed
  stage did not improve;
- sharing a mutable variant list, rejected because it changes ownership and
  aliasing semantics; and
- a generalized single-source property shortcut, rejected after profile-mode
  regressions even though its release CPU result looked good;
- a one-modifier ordering shortcut, whose local stage improved about 98.5% but
  whose complete S2 workload regressed 1.24%;
- a never-inline isolated single-active helper, whose S0 improved 19.59% while
  S2 regressed 1.10%; and
- the uniform directional-border resolver, whose direct stage improved
  21.89-47.89% while static premerged-spec resolution regressed 3.79%.

## Is the remaining slowness feasible?

### For typical UI work on the tested host: yes

At 120 Hz, a frame has about 8.33 ms. The optimized static isolation path uses
423.50 µs in the benchmark—about **5.08%** of that budget in total. The direct
Flutter control uses 205.40 µs, so Mix's incremental premium is **2.62%** of the
budget. The idiomatic premium is **3.09%**.

These costs leave substantial headroom in isolation, and the real-cadence
campaign did not expose a missed-frame regression. The large “2×” static ratio
is mathematically correct but sounds more severe than the absolute cost: it is
2× a small number.

### Where it could become material

The gap deserves attention when any of these are true:

- a frame is already close to its build/layout budget;
- a dense surface causes many Mix styles to resolve together;
- many variants are simultaneously active;
- an inherited theme/token/context change invalidates a wide subtree;
- the application targets slower mobile hardware; or
- energy and thermal behavior matter over sustained interaction.

The macOS benchmark cannot prove those environments safe. It only establishes
that, on this host and workload, the cost is small enough not to create a frame
failure by itself.

### Optimization feasibility

Further improvement is feasible, but the remaining work is less likely to be a
one-line shortcut:

1. **A structural variation-representation boundary** is the highest-value
   target, provided it removes repeated generic inspection while preserving
   ordering and the existing multi-active algorithm. Per-instance cached
   metadata and duplicated/single-active loops have already failed.
2. **Lower-overhead post-resolution attribution** is needed to measure widget
   and framework wrapper cost. R4 subtraction and R21's multi-stage recorder
   are both rejected; use framework/profile spans or one stage per binary and
   prove <=5% observer movement first.
3. **Transient AOT allocation measurement** would distinguish CPU branching
   from allocation/GC pressure without misusing retained-heap counters.
4. **Resolution caching** could be powerful, but only after defining safe keys
   for context, tokens, directives, inherited/named variants, widget states,
   modifiers, and animation metadata.
5. **Physical-device profile campaigns** are required before prioritizing
   raster, energy, or low-end-mobile work.

The recommended posture is to keep the current narrow property optimization,
avoid the rejected variant rewrites, and continue with bounded experiments that
must pass both static and S2 transition gates.

## Confidence and limits

### Strong evidence

- release/AOT-only primary CPU measurements;
- fresh process per implementation/scenario;
- 10 adjacent baseline/optimized pairs with alternating order;
- Flutter controls on both sides of the source change;
- strict invocation/build/layout/paint contract tests;
- stage-specific synchronous diagnostics;
- profile and release-cadence regression gates; and
- full package tests, generation, analysis, and focused semantic tests.

### Deliberate limits

- one macOS host, not a representative mobile-device matrix;
- synthetic repeated actions, not a production application trace;
- no supported transient AOT allocation count;
- no valid isolated attribution for the post-resolution wrapper layers;
- frame-budget percentages are contextual comparisons, not additive
  guarantees; and
- S2 is an artificial maximum-frequency loop, so real cadence—not the tight
  loop—is the source for frame/raster conclusions.

## Source map

- `FINDINGS.md` contains the accepted/rejected experiments and raw summaries.
- `INSTRUMENTATION.md` defines what each counter and benchmark can prove.
- `README.md` defines scenarios, fixture fairness, and benchmark commands.
- `guides/mix-styling-rendering-pipeline.md` maps runtime stages to source.
- `lib/scenarios/mix_card.dart` contains hoisted Mix styles.
- `lib/scenarios/flutter_card.dart` contains the direct Flutter state mapper.
- `lib/scenarios/card_grid.dart` contains the shared renderer and cached child
  setup.
- `.context/benchmark-results/prop-single-value-*` contains the gitignored raw
  result files for the final candidate.

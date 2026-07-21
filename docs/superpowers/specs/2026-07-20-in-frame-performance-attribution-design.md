# In-Frame Rendering Attribution Design

Date: 2026-07-20
Status: Completed — attribution method rejected and source restored
Branch checkpoint: `4269d387abd4fc468f195b6b6750add67a307e07`

## Purpose

Measure where the current accepted Mix pipeline spends CPU after style
resolution without repeating the invalid independently pumped subtraction
probe. The experiment must observe the real release/AOT widget path inside the
same pumped frame, quantify its own observer overhead, and identify the next
evidence-backed optimization target. It does not itself promote a production
optimization.

## Decision Context

The current evidence ranks a structural variation-representation boundary as
the largest possible source optimization. Source inspection shows that it is
not a safe bounded experiment:

- public `VariantStyle` is a `const` wrapper that accepts any `Style<S>`;
- existing behavior dynamically recognizes values implementing
  `StyleVariation<S>`;
- a non-breaking cached classification repeats rejected experiment R13; and
- removing the fallback requires a public representation and migration design.

The next experiment therefore uses the approved fallback: in-frame
post-resolution attribution. This is materially different from R4 because all
stages are observed during one framework-owned frame rather than inferred by
subtracting separately pumped widget trees.

## Goals

1. Measure the real accepted Mix path in release/AOT mode.
2. Attribute synchronous style, wrapper, renderer, layout, and paint work
   within the same S0 or S2 pumped iteration.
3. Retain matched Flutter measurements for shared renderer/layout/paint work.
4. Quantify timing-instrumentation overhead against the same source with timing
   disabled.
5. Produce a bounded three-pair local percentage and stage-share estimate,
   not a CI threshold.
6. Leave normal Mix builds behaviorally and structurally unchanged when the
   compile-time timing flag is false.

## Non-Goals

- Changing `VariantStyle`, `StyleVariation`, or production style algorithms.
- Reopening rejected single-active, modifier, or directional-border shapes.
- Claiming transient allocation, raster-thread, mobile, or energy attribution.
- Treating the uninstrumented residual as one specific framework stage.
- Running a long primary, profile, cadence, or GitHub Actions campaign.
- Committing, pushing, or changing a pull request as part of this goal.

## Chosen Architecture

### Compile-time gate

Add a non-exported internal timing utility in the Mix package. Every production
call site is guarded by:

```text
MIX_BENCHMARK_TIMINGS=true
```

The guard is a compile-time boolean. Ordinary builds use the false default, so
the timing branches, recorder, and callbacks are eligible for tree shaking.
The benchmark imports the internal utility explicitly; it does not add a
public Mix API.

### Timing recorder

The recorder exposes a synchronous event sink and a small stage enum. It uses
monotonic `Stopwatch` ticks and reports elapsed ticks plus the stopwatch
frequency. No file I/O, JSON encoding, logging, timeline events, or diagnostic
counters run inside measured iterations.

The benchmark installs the sink immediately before an iteration and removes it
immediately afterward. Events are accumulated by iteration and stage. A
missing sink is a no-op even in a timing-enabled binary. Recorder state must be
balanced at the end of every iteration; nested or unfinished events invalidate
the result.

### Non-overlapping observed stages

The first implementation records only independently executed bodies so stage
totals can be summed without double counting:

| Stage | Location | Meaning |
| --- | --- | --- |
| Mix inherited-style assembly | `StyleBuilder` | Lookup and optional merge before the inner builder |
| Mix style resolution | `StyleBuilder` inner builder | `Style.build(context)` through resolved `StyleSpec` |
| Mix renderer callback | `StyleSpecBuilder` | User builder invocation that creates `SharedCardRenderer` |
| Mix provider/modifier assembly | `StyleSpecBuilder` | `StyleSpecProvider` and optional modifier widget construction after the callback |
| Flutter spec mapping | benchmark Flutter card | Direct state-to-`BoxSpec` mapping |
| Shared renderer build | benchmark renderer | `SharedCardRenderer.build` for either implementation |
| Layout | benchmark render probe | Timed `performLayout` for the measured cards |
| Paint | benchmark render probe | Timed `paint` for the measured cards |

`StyleAnimationBuilder` state/update/dispatch, element reconciliation,
scheduler work, and uninstrumented framework work remain in the residual. The
report must not relabel that residual as animation or reconciliation cost.
Timed runs activate the render probe through the timing collector, independently
of `PipelineCounters`; ordinary performance runs continue to install neither.

### Data flow

Each measured iteration has one monotonically increasing iteration ID:

```text
begin iteration
  trigger S0 rebuild or S2 state change
  pump one benchmark frame
  Mix/Flutter and shared pipeline stages report elapsed ticks
end iteration
validate counts and store total-frame plus per-stage samples
```

The result adds a diagnostic section beside the existing total pump samples.
For every stage it records invocation count, total elapsed microseconds, and a
per-iteration microsecond array. Existing result fields and default runs remain
unchanged when timing is disabled.

## Workload and Controls

Use the existing 60-card isolation fixture and existing S0/S2 actions. Style
declarations, children, viewport, warmups, frame guard, and case selectors stay
unchanged.

Build two frozen release apps from byte-identical source:

- timing disabled: observer-overhead baseline;
- timing enabled: stage-attribution candidate.

Each app supports separate Flutter/Mix and S0/S2 runtime selectors. Three
adjacent pairs per scenario produce 24 fresh processes total: disabled/enabled
Flutter and Mix for S0 and S2. Alternate scenario, implementation, and
timing-first order. Use three measured seconds and two-second lifecycle gaps.
Keep Conductor running; its verified renderer may use the existing reversible
suspension procedure during each timing window.

## Validity and Analysis

Every process must pass existing binary hash, signature, metadata, selector,
result-marker, duration, positive-sample, and stale-process checks. Timing-
enabled results additionally require:

- at least one timing event for every stage expected for the selected
  implementation;
- balanced begin/end iteration state;
- nonnegative elapsed values;
- stage sample arrays aligned with total iteration samples;
- expected S0/S2 resolution and renderer invocation relationships; and
- no event recorded outside an active measured iteration.

Report:

- disabled-versus-enabled raw Flutter and Mix aggregates;
- Flutter-adjusted instrumentation overhead;
- aggregate, median-paired, and win counts for overhead;
- average and median microseconds per stage;
- stage share of total pumped iteration time;
- instrumented-stage sum; and
- the explicitly unlabeled residual.

With three pairs, 20% trimming removes no observations and adds no information,
so it is reported only for consistency with the existing analyzer.

## Evidence Gates

### Gate 1: contracts and default behavior

- Existing Mix and benchmark tests remain green without the timing define.
- A timing-enabled widget contract proves expected stage presence, iteration
  alignment, and S0/S2 invocation relationships.
- Analysis and fatal DCM pass for touched files.
- A normal release build contains no enabled timing metadata and preserves the
  accepted production hashes outside the explicitly instrumented builder
  files.

### Gate 2: observer overhead

The attribution is usable only when disabled-versus-enabled total-pump movement
is directionally stable and no more than 5% after Flutter adjustment for both
S0 and S2 aggregate and median views. A larger, contradictory, or
order-dependent movement invalidates percentage shares; retain only contracts
that remain generally useful and document the failed method.

### Gate 3: attribution conclusion

A stage may be recommended as the next optimization target only when:

- it is present in every valid timing-enabled process;
- its average and median rank agree;
- its ordering is consistent in at least two of three pairs per scenario; and
- it is material relative to both total pump time and recorder overhead.

Otherwise the result is limited to ruling out measured stages or identifying
that the unattributed residual dominates.

## Testing Strategy

- Unit-test recorder state, stage accounting, and missing-sink behavior.
- Widget-test timing-enabled S0 and S2 event/count contracts.
- Run the complete rendering-pipeline test package.
- Run focused Mix builder/animation tests affected by instrumentation.
- Analyze both packages and run fatal DCM for touched Mix files.
- Format touched Dart files and run `git diff --check`.
- Build a default release/AOT smoke app and a timing-enabled release/AOT smoke
  app before freezing campaign binaries.

## Failure Handling and Rollback

Malformed timing state fails the selected benchmark process before its result
is promoted from pending to valid. Partial campaigns remain separately marked
invalid and never enter an aggregate.

If the recorder changes default behavior, cannot be tree-shaken, exceeds the
overhead gate, or produces inconsistent counts, remove the Mix instrumentation
and restore the exact checkpoint source. Retain only benchmark-local contracts
that are independently useful. No production optimization is accepted by this
experiment.

## Documentation and Handoff

Update `FINDINGS.md`, `INSTRUMENTATION.md`,
`PERFORMANCE_IMPACT_REPORT.md`, `README.md`, the implementation plan, and
`.context/rendering-pipeline-session.md` with source/binary hashes, commands,
raw paths, invalid attempts, exact stage/overhead statistics, limitations, and
the next recommendation. At handoff, verify no benchmark process remains and
that Conductor is running. Do not commit, push, modify a PR, or create a CI
workflow without a new explicit request.

## Completion Conditions

1. The structural-boundary deferral is documented with its compatibility
   reason.
2. Frozen disabled/enabled release binaries are source-identical except for
   the compile-time flag and embedded metadata.
3. A valid bounded campaign either supports a defensible in-frame attribution
   or explicitly rejects the instrumentation method.
4. No speculative production optimization remains.
5. Tests, code-generation consistency, analysis, DCM, formatting, and diff
   checks pass at the scope dictated by the verdict; generation must produce
   zero changes because this design modifies no generated input.
6. Findings, instrumentation, impact report, README, plan, design, and session
   handoff agree with the source and raw evidence.
7. No benchmark process remains, Conductor remains running, and the worktree is
   uncommitted and unpushed.

## Final Verdict

The design was implemented and exercised, but Gate 2 failed. All 24 required
release processes were valid with zero exclusions. Flutter-adjusted timing
overhead was +14.20% aggregate / +15.15% median for S0 and +16.92% / +16.63%
for S2, with enabled timing slower in 3/3 pairs for both scenarios. Both
timing-order subsets agreed. These values exceed the 5% ceiling, so no stage
share or optimization target is accepted.

The Mix recorder, benchmark collector, render hooks, timing schema, and their
tests were removed. Tracked production and benchmark source is exactly back at
checkpoint `4269d387a`. The rejected instrumented source manifest, frozen
binaries, raw evidence, scripts, hashes, and summary are preserved under the
versioned `.context` paths specified above.

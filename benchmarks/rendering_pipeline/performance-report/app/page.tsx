import type { CSSProperties } from "react";

type BarStyle = CSSProperties & { "--bar-size": string };
type SegmentStyle = CSSProperties & { "--segment-size": string };

const scenarios = [
  {
    id: "S0",
    name: "Static rebuild",
    note: "Isolation track",
    flutter: "205.40",
    before: "470.77",
    optimized: "423.50",
    flutterBar: "31.6%",
    beforeBar: "72.4%",
    optimizedBar: "65.2%",
    gain: "9.88% faster",
    comparison: "2.06× Flutter time",
    tone: "watch",
  },
  {
    id: "S0I",
    name: "Static + wrappers",
    note: "Idiomatic track",
    flutter: "298.72",
    before: "618.82",
    optimized: "556.30",
    flutterBar: "46.0%",
    beforeBar: "95.2%",
    optimizedBar: "85.6%",
    gain: "9.23% faster",
    comparison: "1.86× Flutter time",
    tone: "watch",
  },
  {
    id: "S1",
    name: "Irrelevant hover",
    note: "Isolation control",
    flutter: "133.09",
    before: "134.50",
    optimized: "133.69",
    flutterBar: "20.5%",
    beforeBar: "20.7%",
    optimizedBar: "20.6%",
    gain: "Neutral",
    comparison: "+0.45% vs Flutter",
    tone: "good",
  },
  {
    id: "S1I",
    name: "Irrelevant + providers",
    note: "Idiomatic control",
    flutter: "133.33",
    before: "134.15",
    optimized: "133.85",
    flutterBar: "20.5%",
    beforeBar: "20.6%",
    optimizedBar: "20.6%",
    gain: "Neutral",
    comparison: "+0.39% vs Flutter",
    tone: "good",
  },
  {
    id: "S2",
    name: "Pressed + selected",
    note: "Relevant state",
    flutter: "148.85",
    before: "141.78",
    optimized: "128.72",
    flutterBar: "22.9%",
    beforeBar: "21.8%",
    optimizedBar: "19.8%",
    gain: "8.60% faster",
    comparison: "13.53% faster than Flutter",
    tone: "good",
  },
] as const;

const acceptedChanges = [
  {
    number: "01",
    title: "Stop broad state subscriptions",
    body: "Provider-presence checks no longer subscribe to every widget-state aspect. Irrelevant hover now produces zero resolution, build, layout, or paint work.",
  },
  {
    number: "02",
    title: "Skip unused animation machinery",
    body: "Styles with no animation avoid the no-animation driver and AnimatedBuilder subtree while configured animation behavior remains unchanged.",
  },
  {
    number: "03",
    title: "Return early for no variants",
    body: "Styles without declared variants bypass filtering, sorting, and list work. The focused zero-variant diagnostic improved by roughly two microseconds.",
  },
  {
    number: "04",
    title: "Own interaction state lazily",
    body: "Automatic controller and pointer tracking are installed only when hover or pressed behavior actually requires them.",
  },
  {
    number: "05",
    title: "Resolve one ordinary value directly",
    body: "The common single-ValueSource path avoids a temporary list and Mix scan. Complex values and multi-source properties retain the original semantics.",
  },
] as const;

const rejectedChanges = [
  {
    title: "Fully fused variant merge",
    staticResult: "≈100 µs static win",
    reason: "S2 became 11.98 µs slower after control adjustment and regressed in 10/10 pairs.",
  },
  {
    title: "Single-active fast path",
    staticResult: "≈100 µs static win",
    reason: "S2 still regressed in 10/10 pairs, so the narrower form was also reverted.",
  },
  {
    title: "Skip an already-ordered sort",
    staticResult: "No target-stage win",
    reason: "Variant merge was 0.3–1.5% slower; the experiment stopped before a larger campaign.",
  },
  {
    title: "General single-source dispatch",
    staticResult: "Strong release CPU result",
    reason: "Profile cadence regressed until the branch was narrowed to ordinary direct values only.",
  },
] as const;

function MetricBar({
  label,
  value,
  size,
  kind,
}: {
  label: string;
  value: string;
  size: string;
  kind: "flutter" | "before" | "optimized";
}) {
  return (
    <div className="metric-bar-row">
      <span className="metric-bar-label">{label}</span>
      <div className="metric-bar-track" aria-hidden="true">
        <span
          className={`metric-bar-fill metric-bar-fill--${kind}`}
          style={{ "--bar-size": size } as BarStyle}
        />
      </div>
      <span className="metric-bar-value">{value} µs</span>
    </div>
  );
}

function StageBar({
  label,
  variant,
  resolution,
  residual,
  total,
}: {
  label: string;
  variant: string;
  resolution: string;
  residual: string;
  total: string;
}) {
  return (
    <div className="stage-row">
      <div className="stage-label">
        <strong>{label}</strong>
        <span>{total} full Style.build</span>
      </div>
      <div
        className="stage-track"
        role="img"
        aria-label={`${label}: ${variant} variant work, ${resolution} property and spec resolution, ${residual} remaining work`}
      >
        <span
          className="stage-segment stage-segment--variant"
          style={{ "--segment-size": variant } as SegmentStyle}
        >
          <span>{variant}</span>
        </span>
        <span
          className="stage-segment stage-segment--resolve"
          style={{ "--segment-size": resolution } as SegmentStyle}
        >
          <span>{resolution}</span>
        </span>
        <span
          className="stage-segment stage-segment--rest"
          style={{ "--segment-size": residual } as SegmentStyle}
        />
      </div>
    </div>
  );
}

export default function Home() {
  return (
    <main>
      <header className="site-header">
        <a className="wordmark" href="#top" aria-label="Mix performance report home">
          <span className="wordmark-mark" aria-hidden="true">M</span>
          <span>Mix / Performance review</span>
        </a>
        <nav aria-label="Report sections">
          <a href="#comparison">Comparison</a>
          <a href="#pipeline">Cost map</a>
          <a href="#state">State changes</a>
          <a href="#decision">Decision</a>
        </nav>
      </header>

      <section className="hero" id="top">
        <div className="hero-copy">
          <p className="eyebrow">Rendering pipeline investigation · 13 July 2026</p>
          <h1>
            The static overhead is real.
            <span>The frame impact is small.</span>
          </h1>
          <p className="hero-lede">
            Mix still spends more CPU than direct Flutter when a broad static subtree
            rebuilds. After optimization, that premium is 218 microseconds in the
            isolation case—2.62% of one 120 Hz frame budget on the tested Mac.
          </p>
          <div className="verdict-row">
            <span className="verdict-badge"><i /> Feasible on the tested host</span>
            <span>Release/AOT · 10 paired runs · fresh process per case</span>
          </div>
        </div>

        <aside className="hero-scorecard" aria-label="Headline benchmark results">
          <div className="scorecard-topline">
            <span>Practical verdict</span>
            <span className="confidence">High confidence</span>
          </div>
          <div className="hero-number">
            <strong>218.10</strong>
            <span>µs static premium</span>
          </div>
          <div className="budget-rail" aria-label="Static premium uses 2.62 percent of a 120 hertz frame budget">
            <span className="budget-used" />
          </div>
          <div className="budget-labels">
            <span>2.62% used</span>
            <span>8.33 ms at 120 Hz</span>
          </div>
          <div className="scorecard-grid">
            <div><strong>9.88%</strong><span>static Mix gain</span></div>
            <div><strong>0</strong><span>optimized Mix misses*</span></div>
            <div><strong>13.53%</strong><span>S2 faster than Flutter</span></div>
          </div>
          <p className="fine-print">* Roughly 2,400 frames in the release-cadence campaign.</p>
        </aside>
      </section>

      <section className="report-section frame-context" aria-labelledby="ratio-title">
        <div className="section-heading compact-heading">
          <p className="section-index">01 / Read the number correctly</p>
          <h2 id="ratio-title">A large ratio over a small baseline</h2>
        </div>
        <div className="context-grid">
          <article className="context-card context-card--ratio">
            <span className="context-kicker">Relative</span>
            <strong>2.06×</strong>
            <h3>Optimized Mix vs direct Flutter</h3>
            <p>The static isolation ratio is conspicuous because Flutter’s control is only 205.40 µs.</p>
          </article>
          <article className="context-card context-card--absolute">
            <span className="context-kicker">Absolute</span>
            <strong>0.218 ms</strong>
            <h3>Incremental CPU premium</h3>
            <p>This is the more useful planning number: 2.62% of a 120 Hz frame, or 1.31% at 60 Hz.</p>
          </article>
          <article className="context-card context-card--cadence">
            <span className="context-kicker">Observed cadence</span>
            <strong>Neutral</strong>
            <h3>No frame-scale regression</h3>
            <p>Release cadence averaged −0.006 ms build, +0.069 ms raster, and +3.70 µs total span.</p>
          </article>
        </div>
      </section>

      <section className="report-section" id="comparison" aria-labelledby="comparison-title">
        <div className="section-heading">
          <div>
            <p className="section-index">02 / Before and after</p>
            <h2 id="comparison-title">Flutter, Mix, optimized Mix</h2>
          </div>
          <p>
            Average release/AOT CPU time. Lower is faster. The validated gain is
            adjusted using a contemporaneous Flutter control on both sides.
          </p>
        </div>

        <div className="legend" aria-label="Chart legend">
          <span><i className="legend-flutter" /> Changed Flutter</span>
          <span><i className="legend-before" /> Mix before</span>
          <span><i className="legend-optimized" /> Optimized Mix</span>
        </div>

        <div className="scenario-list">
          {scenarios.map((scenario) => (
            <article className="scenario-card" key={scenario.id}>
              <div className="scenario-copy">
                <span className="scenario-id">{scenario.id}</span>
                <div>
                  <h3>{scenario.name}</h3>
                  <p>{scenario.note}</p>
                </div>
              </div>
              <div className="scenario-bars">
                <MetricBar label="Flutter" value={scenario.flutter} size={scenario.flutterBar} kind="flutter" />
                <MetricBar label="Before" value={scenario.before} size={scenario.beforeBar} kind="before" />
                <MetricBar label="Optimized" value={scenario.optimized} size={scenario.optimizedBar} kind="optimized" />
              </div>
              <div className={`scenario-result scenario-result--${scenario.tone}`}>
                <strong>{scenario.gain}</strong>
                <span>{scenario.comparison}</span>
              </div>
            </article>
          ))}
        </div>
        <p className="chart-note">Scale maximum: 650 µs. “Before” is the PR #976 baseline; “optimized” adds the narrow ordinary-value fast path.</p>
      </section>

      <section className="report-section pipeline-section" id="pipeline" aria-labelledby="pipeline-title">
        <div className="section-heading section-heading--light">
          <div>
            <p className="section-index">03 / Cost map</p>
            <h2 id="pipeline-title">Where Mix spends its style-computation time</h2>
          </div>
          <p>
            A synchronous diagnostic isolates the unresolved-style pipeline before
            animation wrappers, concrete widgets, layout, paint, and raster.
          </p>
        </div>

        <div className="pipeline-layout">
          <div className="pipeline-bars">
            <StageBar label="Static profile · 1 of 5 active" variant="63.1%" resolution="33.0%" residual="3.9%" total="5.44 µs" />
            <StageBar label="All-active profile · 5 of 5" variant="63.9%" resolution="30.1%" residual="6.0%" total="20.30 µs" />
            <div className="stage-legend">
              <span><i className="stage-key stage-key--variant" /> Variant evaluation + merge</span>
              <span><i className="stage-key stage-key--resolve" /> Property + spec resolution</span>
              <span><i className="stage-key stage-key--rest" /> Residual</span>
            </div>
          </div>

          <aside className="pipeline-callout">
            <span className="callout-label">Largest remaining target</span>
            <strong>≈ 64%</strong>
            <h3>Variant evaluation and merge</h3>
            <p>
              Predicate evaluation, widget-state reads, active-fragment collection,
              priority ordering, recursive processing, and style merges dominate both profiles.
            </p>
          </aside>
        </div>

        <div className="resolution-grid">
          <article>
            <span>Static property resolution</span>
            <div><del>1.808 µs</del><strong>1.298 µs</strong></div>
            <p>28.22% faster with the narrow single-value path.</p>
          </article>
          <article>
            <span>All-active property resolution</span>
            <div><del>6.117 µs</del><strong>5.891 µs</strong></div>
            <p>3.70% faster; multi-source work dominates here.</p>
          </article>
          <article>
            <span>Generated spec construction</span>
            <div><strong>11–12 ns</strong></div>
            <p>Construction is negligible; resolving property sources is the cost.</p>
          </article>
        </div>
      </section>

      <section className="report-section" id="state" aria-labelledby="state-title">
        <div className="section-heading">
          <div>
            <p className="section-index">04 / State behavior</p>
            <h2 id="state-title">What actually fires when state changes</h2>
          </div>
          <p>
            Counter contracts separate controller notifications from Mix resolution,
            renderer builds, layout, and paint.
          </p>
        </div>

        <div className="state-grid">
          <article className="state-card state-card--quiet">
            <div className="state-card-heading">
              <span className="state-symbol">Ø</span>
              <div><span>Irrelevant hover</span><h3>No downstream style work</h3></div>
            </div>
            <ol className="state-flow">
              <li><span>01</span>Controller value changes</li>
              <li><span>02</span>No matching aspect dependency</li>
              <li className="state-flow-result"><span>03</span><strong>0 resolutions · 0 builds · 0 layouts · 0 paints</strong></li>
            </ol>
          </article>

          <article className="state-card state-card--active">
            <div className="state-card-heading">
              <span className="state-symbol">2→1</span>
              <div><span>Pressed + selected</span><h3>Two notifications, one resolution</h3></div>
            </div>
            <div className="coalesce-diagram" role="img" aria-label="Pressed and selected notifications are coalesced into one Mix resolution and one renderer build">
              <div><span>Pressed</span><span>Selected</span></div>
              <i aria-hidden="true" />
              <div><strong>1 Mix resolution</strong><strong>1 renderer build</strong></div>
            </div>
            <p>Flutter coalesces both invalidations before the pumped frame. The style is not resolved twice.</p>
          </article>

          <article className="state-card state-card--expected">
            <div className="state-card-heading">
              <span className="state-symbol">↔</span>
              <div><span>Pointer movement</span><h3>Two cards can resolve legitimately</h3></div>
            </div>
            <p>Hover exit affects the old card; hover enter affects the new card. One resolution per affected hover-aware card is expected.</p>
            <div className="mini-equation"><span>old card − hover</span><b>+</b><span>new card + hover</span></div>
          </article>

          <article className="state-card state-card--expected">
            <div className="state-card-heading">
              <span className="state-symbol">◌</span>
              <div><span>Animation</span><h3>Interpolation ticks are intentional</h3></div>
            </div>
            <p>The target style resolves for a true state transition. Later animation-tick builds interpolate that target; they are not duplicate controller events.</p>
            <div className="tick-line" aria-hidden="true"><i /><i /><i /><i /><i /></div>
          </article>
        </div>
      </section>

      <section className="report-section accepted-section" aria-labelledby="accepted-title">
        <div className="section-heading">
          <div>
            <p className="section-index">05 / Work removed</p>
            <h2 id="accepted-title">Five bounded improvements survived validation</h2>
          </div>
          <p>Each change removes work without broadening cache or merge semantics.</p>
        </div>
        <div className="accepted-list">
          {acceptedChanges.map((change) => (
            <article key={change.number}>
              <span>{change.number}</span>
              <div><h3>{change.title}</h3><p>{change.body}</p></div>
            </article>
          ))}
        </div>
      </section>

      <section className="report-section rejected-section" aria-labelledby="rejected-title">
        <div className="section-heading">
          <div>
            <p className="section-index">06 / Guardrails</p>
            <h2 id="rejected-title">Fast locally does not mean fast interactively</h2>
          </div>
          <p>The largest apparent wins were reverted when relevant-state or profile gates moved backward.</p>
        </div>
        <div className="rejected-table" role="table" aria-label="Rejected optimization experiments">
          <div className="rejected-row rejected-row--head" role="row">
            <span role="columnheader">Experiment</span><span role="columnheader">What looked good</span><span role="columnheader">Why it stopped</span>
          </div>
          {rejectedChanges.map((change) => (
            <div className="rejected-row" role="row" key={change.title}>
              <strong role="cell">{change.title}</strong><span role="cell">{change.staticResult}</span><p role="cell">{change.reason}</p>
            </div>
          ))}
        </div>
      </section>

      <section className="report-section decision-section" id="decision" aria-labelledby="decision-title">
        <div className="decision-banner">
          <p className="section-index">07 / Recommendation</p>
          <h2 id="decision-title">Keep the optimization. Keep investigating. Do not call it a frame problem.</h2>
          <p>
            The remaining static premium is measurable but feasible on the tested host.
            Further work should target variant metadata or a rigorously keyed cache—and must
            pass both broad static and relevant-state gates.
          </p>
        </div>

        <div className="decision-grid">
          <article>
            <span className="decision-status decision-status--yes">Do now</span>
            <h3>Ship the narrow property fast path</h3>
            <p>It improves every target workload, preserves complex-source semantics, and passes profile/cadence gates.</p>
          </article>
          <article>
            <span className="decision-status decision-status--next">Explore next</span>
            <h3>Precompute safe variant metadata</h3>
            <p>Variant work remains approximately two thirds of Style.build, but multi-active ordering must stay intact.</p>
          </article>
          <article>
            <span className="decision-status decision-status--prove">Prove first</span>
            <h3>Profile physical mobile devices</h3>
            <p>The current Mac evidence cannot establish low-end CPU, raster, energy, or thermal behavior.</p>
          </article>
        </div>

        <div className="risk-matrix">
          <div className="risk-copy">
            <h3>When the premium becomes worth worrying about</h3>
            <p>The current gap is most likely to matter when several multipliers occur together.</p>
          </div>
          <ul>
            <li>Already-tight build/layout budget</li>
            <li>Dense subtree invalidation</li>
            <li>Many simultaneously active variants</li>
            <li>Wide theme/token/context change</li>
            <li>Slower mobile CPU</li>
            <li>Sustained energy-sensitive interaction</li>
          </ul>
        </div>
      </section>

      <section className="method-section" aria-labelledby="method-title">
        <div>
          <p className="section-index">Evidence notes</p>
          <h2 id="method-title">What this report can—and cannot—claim</h2>
        </div>
        <div className="method-columns">
          <div>
            <h3>Strong evidence</h3>
            <ul>
              <li>Release/AOT primary timings</li>
              <li>Fresh process per case</li>
              <li>10 adjacent A/B pairs</li>
              <li>Flutter control on both sides</li>
              <li>Strict pipeline counter contracts</li>
              <li>Profile and release-cadence gates</li>
            </ul>
          </div>
          <div>
            <h3>Deliberate limits</h3>
            <ul>
              <li>One 120 Hz macOS host</li>
              <li>Synthetic card-grid workload</li>
              <li>No transient AOT allocation count</li>
              <li>No valid wrapper-only timing split</li>
              <li>No broad mobile or energy claim</li>
              <li>Budget shares are context, not guarantees</li>
            </ul>
          </div>
        </div>
      </section>

      <footer>
        <div>
          <strong>Mix rendering-pipeline report</strong>
          <span>Flutter 3.41.7 · Dart 3.11.5 · Mix 2.1.0</span>
        </div>
        <p>Source of truth: PERFORMANCE_IMPACT_REPORT.md, FINDINGS.md, INSTRUMENTATION.md, and the raw prop-single-value benchmark campaign.</p>
      </footer>
    </main>
  );
}

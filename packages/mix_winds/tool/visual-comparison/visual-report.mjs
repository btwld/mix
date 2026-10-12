import fs from 'node:fs';
import path from 'node:path';

export const EXPECTED_WIDTHS = Object.freeze([480, 768, 1024]);

const METRIC_LABELS = Object.freeze({
  diffPercent: 'Tolerant',
  strictDiffPercent: 'Strict',
  exactDiffPercent: 'Exact',
});

const REQUIRED_FILES = Object.freeze([
  ['tailwind', 'Tailwind capture'],
  ['flutter', 'Flutter capture'],
  ['pixelmatchDiff', 'Tolerant diff'],
  ['strictPixelmatchDiff', 'Strict diff'],
  ['absoluteDiff', 'Absolute diff'],
  ['blink', 'Blink diff'],
]);

export function evaluateAcceptance(summary, contract) {
  const metric = contract?.metric;
  if (!Object.hasOwn(METRIC_LABELS, metric)) {
    throw new TypeError(`Unknown visual acceptance metric: ${metric}`);
  }

  const maximumByWidth = contract.maximumByWidth ?? {};
  const expectedWidths = Object.keys(maximumByWidth)
    .map(Number)
    .sort((left, right) => left - right);
  const resultsByWidth = new Map(
    (summary.results ?? []).map((result) => [result.width, result]),
  );
  const checks = expectedWidths.map((width) => {
    const result = resultsByWidth.get(width);
    const value = result?.[metric];
    const maximum = maximumByWidth[width];
    const present = result != null && Number.isFinite(value);
    return {
      width,
      metric,
      value: present ? value : null,
      maximum,
      passed: present && value <= maximum,
    };
  });
  const captureComplete =
    summary.captureComplete === true &&
    expectedWidths.length === EXPECTED_WIDTHS.length &&
    EXPECTED_WIDTHS.every((width) => resultsByWidth.has(width));

  return {
    metric,
    metricLabel: METRIC_LABELS[metric],
    maximumByWidth,
    captureComplete,
    passed: captureComplete && checks.every((check) => check.passed),
    checks,
  };
}

export function discoverVisualSummaries(outputRoot) {
  if (!fs.existsSync(outputRoot)) return [];

  const summaryPaths = [];
  walk(outputRoot, (filePath) => {
    if (path.basename(filePath) === 'summary.json') summaryPaths.push(filePath);
  });

  return summaryPaths
    .sort((left, right) => left.localeCompare(right))
    .map((summaryPath) => {
      const summary = JSON.parse(fs.readFileSync(summaryPath, 'utf8'));
      return {
        summaryPath,
        relativeSummaryPath: toPosix(path.relative(outputRoot, summaryPath)),
        summary,
      };
    })
    .filter((record) => Array.isArray(record.summary.results))
    .sort(compareSummaryRecords);
}

export function buildReportModel(
  outputRoot,
  records = discoverVisualSummaries(outputRoot),
) {
  const captures = records.map((record) => buildCapture(outputRoot, record));
  const cards = captures.flatMap((capture) => capture.cards);

  return {
    captures,
    cards,
    summaryCount: captures.length,
    captureCount: cards.length,
    failedCaptureCount: cards.filter((card) => !card.passed).length,
    missingAssetCount: captures.reduce(
      (total, capture) => total + capture.missingAssets.length,
      0,
    ),
    suites: [...new Set(captures.map((capture) => capture.suite))].sort(),
  };
}

export function renderVisualReport(model) {
  const cards = model.cards.map(renderCard).join('\n');
  const suiteOptions = model.suites
    .map((suite) => `<option value="${escapeHtml(suite)}">${escapeHtml(titleCase(suite))}</option>`)
    .join('');

  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Mix × Tailwind visual parity</title>
  <style>
    :root {
      color-scheme: light;
      --paper: #f3f6fa;
      --surface: #ffffff;
      --ink: #172033;
      --muted: #61708a;
      --rule: #d5deea;
      --signal: #376ff6;
      --pass: #087f6b;
      --pass-soft: #dff4ee;
      --fail: #c83e4d;
      --fail-soft: #fbe8eb;
      --shadow: 0 18px 55px rgba(30, 48, 80, 0.11);
    }
    * { box-sizing: border-box; }
    html { background: var(--paper); }
    body {
      margin: 0;
      color: var(--ink);
      background:
        linear-gradient(rgba(55, 111, 246, 0.035) 1px, transparent 1px),
        linear-gradient(90deg, rgba(55, 111, 246, 0.035) 1px, transparent 1px),
        var(--paper);
      background-size: 24px 24px;
      font-family: "Avenir Next", Avenir, system-ui, sans-serif;
    }
    a { color: inherit; }
    button, select { font: inherit; }
    .shell { width: min(1560px, calc(100% - 40px)); margin: 0 auto; padding: 42px 0 72px; }
    .masthead {
      display: grid;
      grid-template-columns: minmax(0, 1fr) auto;
      gap: 28px;
      align-items: end;
      padding: 0 0 26px;
      border-bottom: 2px solid var(--ink);
    }
    .eyebrow, .data-label {
      margin: 0;
      color: var(--muted);
      font: 700 11px/1.2 "SFMono-Regular", Consolas, monospace;
      letter-spacing: 0.12em;
      text-transform: uppercase;
    }
    h1 {
      max-width: 850px;
      margin: 8px 0 0;
      font-family: "Avenir Next Condensed", "Arial Narrow", sans-serif;
      font-size: clamp(42px, 6vw, 78px);
      font-stretch: condensed;
      font-weight: 700;
      letter-spacing: -0.045em;
      line-height: 0.92;
    }
    .lede { max-width: 700px; margin: 18px 0 0; color: var(--muted); font-size: 16px; line-height: 1.55; }
    .scoreboard { display: grid; grid-template-columns: repeat(3, minmax(88px, 1fr)); border: 1px solid var(--rule); background: var(--surface); box-shadow: var(--shadow); }
    .score { min-width: 112px; padding: 16px 18px; border-left: 1px solid var(--rule); }
    .score:first-child { border-left: 0; }
    .score strong { display: block; margin-top: 7px; font: 650 28px/1 "SFMono-Regular", Consolas, monospace; }
    .score.fail strong { color: var(--fail); }
    .controls {
      position: sticky;
      top: 0;
      z-index: 5;
      display: grid;
      grid-template-columns: repeat(3, minmax(150px, 220px)) 1fr;
      gap: 12px;
      align-items: end;
      margin: 24px 0 30px;
      padding: 14px;
      border: 1px solid var(--rule);
      background: rgba(243, 246, 250, 0.94);
      backdrop-filter: blur(14px);
    }
    .control label { display: block; margin-bottom: 6px; }
    select {
      width: 100%;
      min-height: 42px;
      padding: 8px 34px 8px 11px;
      color: var(--ink);
      border: 1px solid #aebbd0;
      border-radius: 4px;
      background: var(--surface);
    }
    select:focus-visible, a:focus-visible { outline: 3px solid rgba(55, 111, 246, 0.38); outline-offset: 2px; }
    .visible-count { align-self: center; justify-self: end; color: var(--muted); font: 600 12px/1.4 "SFMono-Regular", Consolas, monospace; }
    .grid { display: grid; gap: 24px; }
    .capture {
      overflow: hidden;
      border: 1px solid var(--rule);
      border-top: 4px solid var(--pass);
      border-radius: 5px;
      background: var(--surface);
      box-shadow: var(--shadow);
    }
    .capture[data-status="fail"] { border-top-color: var(--fail); }
    .capture[hidden] { display: none; }
    .capture-head { display: grid; grid-template-columns: 1fr auto; gap: 18px; align-items: start; padding: 18px 20px; border-bottom: 1px solid var(--rule); }
    .capture-title { margin: 4px 0 0; font-family: "Avenir Next Condensed", "Arial Narrow", sans-serif; font-size: 28px; line-height: 1; }
    .capture-meta { display: flex; flex-wrap: wrap; gap: 8px 16px; margin-top: 9px; color: var(--muted); font-size: 13px; }
    .status { display: inline-flex; align-items: center; gap: 7px; padding: 7px 10px; border-radius: 99px; color: var(--pass); background: var(--pass-soft); font: 700 11px/1 "SFMono-Regular", Consolas, monospace; text-transform: uppercase; }
    .status::before { content: ""; width: 7px; height: 7px; border-radius: 50%; background: currentColor; }
    [data-status="fail"] .status { color: var(--fail); background: var(--fail-soft); }
    .ruler { display: grid; grid-template-columns: repeat(12, 1fr); height: 10px; border-bottom: 1px solid var(--rule); background: repeating-linear-gradient(90deg, var(--rule) 0 1px, transparent 1px 8.333%); }
    .pair { position: relative; display: grid; grid-template-columns: 1fr 1fr; gap: 1px; background: var(--ink); }
    .pair::after { content: "TW  /  FL"; position: absolute; top: 10px; left: 50%; z-index: 2; transform: translateX(-50%); padding: 4px 8px; color: #fff; background: var(--ink); font: 700 9px/1 "SFMono-Regular", Consolas, monospace; letter-spacing: 0.12em; }
    .frame { min-width: 0; background: #e8edf4; }
    .frame-label { display: flex; justify-content: space-between; padding: 8px 12px; color: var(--muted); background: var(--surface); font: 700 10px/1.2 "SFMono-Regular", Consolas, monospace; letter-spacing: 0.08em; text-transform: uppercase; }
    .frame img { display: block; width: 100%; height: auto; background: #fff; }
    .missing { display: grid; min-height: 220px; place-items: center; padding: 28px; color: var(--fail); background: repeating-linear-gradient(135deg, #fff 0 12px, var(--fail-soft) 12px 24px); font: 700 12px/1.5 "SFMono-Regular", Consolas, monospace; text-align: center; }
    .evidence { display: grid; grid-template-columns: minmax(0, 1fr) auto; gap: 18px; align-items: center; padding: 16px 20px 18px; }
    .metrics { display: flex; flex-wrap: wrap; gap: 10px; }
    .metric { min-width: 106px; padding: 10px 12px; border-left: 2px solid var(--rule); }
    .metric.enforced { border-left-color: var(--signal); background: #edf3ff; }
    .metric strong { display: block; margin-top: 5px; font: 700 17px/1 "SFMono-Regular", Consolas, monospace; }
    .metric small { color: var(--muted); font: 600 10px/1.2 "SFMono-Regular", Consolas, monospace; text-transform: uppercase; }
    .artifacts { display: flex; flex-wrap: wrap; justify-content: flex-end; gap: 7px; }
    .artifact { padding: 7px 9px; border: 1px solid var(--rule); border-radius: 3px; color: #314464; font: 650 11px/1 "SFMono-Regular", Consolas, monospace; text-decoration: none; }
    .artifact:hover { border-color: var(--signal); color: var(--signal); }
    .artifact.missing { min-height: auto; color: var(--fail); background: var(--fail-soft); }
    .empty { display: none; padding: 70px 24px; border: 1px dashed #9cabc2; color: var(--muted); text-align: center; }
    .empty[data-visible="true"] { display: block; }
    @media (max-width: 880px) {
      .shell { width: min(100% - 24px, 1560px); padding-top: 24px; }
      .masthead { grid-template-columns: 1fr; }
      .scoreboard { width: 100%; }
      .controls { grid-template-columns: 1fr 1fr; }
      .visible-count { justify-self: start; }
      .pair { grid-template-columns: 1fr; }
      .pair::after { content: "TW  ↓  FL"; top: 50%; }
      .evidence { grid-template-columns: 1fr; }
      .artifacts { justify-content: flex-start; }
    }
    @media (max-width: 520px) {
      .scoreboard { grid-template-columns: 1fr; }
      .score { border-top: 1px solid var(--rule); border-left: 0; }
      .score:first-child { border-top: 0; }
      .controls { position: static; grid-template-columns: 1fr; }
      .capture-head { grid-template-columns: 1fr; }
    }
    @media (prefers-reduced-motion: reduce) { *, *::before, *::after { scroll-behavior: auto !important; } }
  </style>
</head>
<body>
  <main class="shell">
    <header class="masthead">
      <div>
        <p class="eyebrow">Mix renderer laboratory · Tailwind CSS 4.3.1</p>
        <h1>Visual parity light table</h1>
        <p class="lede">Every viewport is judged by its configured acceptance metric. Use the contact sheets to inspect geometry, palette, typography, and state without leaving this file.</p>
      </div>
      <div class="scoreboard" aria-label="Report totals">
        <div class="score"><span class="data-label">Summaries</span><strong>${model.summaryCount}</strong></div>
        <div class="score"><span class="data-label">Captures</span><strong>${model.captureCount}</strong></div>
        <div class="score ${model.failedCaptureCount > 0 ? 'fail' : ''}"><span class="data-label">Failures</span><strong>${model.failedCaptureCount}</strong></div>
      </div>
    </header>

    <section class="controls" aria-label="Report filters">
      <div class="control"><label class="data-label" for="viewport-filter">Viewport</label><select id="viewport-filter"><option value="all">All widths</option>${EXPECTED_WIDTHS.map((width) => `<option value="${width}">${width}px</option>`).join('')}</select></div>
      <div class="control"><label class="data-label" for="suite-filter">Suite</label><select id="suite-filter"><option value="all">All suites</option>${suiteOptions}</select></div>
      <div class="control"><label class="data-label" for="status-filter">Result</label><select id="status-filter"><option value="all">Pass and fail</option><option value="fail">Failures only</option><option value="pass">Passes only</option></select></div>
      <output class="visible-count" id="visible-count" aria-live="polite"></output>
    </section>

    <section class="grid" id="capture-grid">${cards}</section>
    <div class="empty" id="empty-state">No captures match these filters.</div>
  </main>
  <script>
    const controls = [...document.querySelectorAll('select')];
    const cards = [...document.querySelectorAll('.capture')];
    const count = document.querySelector('#visible-count');
    const empty = document.querySelector('#empty-state');
    function applyFilters() {
      const viewport = document.querySelector('#viewport-filter').value;
      const suite = document.querySelector('#suite-filter').value;
      const status = document.querySelector('#status-filter').value;
      let visible = 0;
      for (const card of cards) {
        const show = (viewport === 'all' || card.dataset.width === viewport) &&
          (suite === 'all' || card.dataset.suite === suite) &&
          (status === 'all' || card.dataset.status === status);
        card.hidden = !show;
        visible += Number(show);
      }
      count.textContent = visible + ' of ' + cards.length + ' captures shown';
      empty.dataset.visible = String(visible === 0);
    }
    for (const control of controls) control.addEventListener('change', applyFilters);
    applyFilters();
  </script>
</body>
</html>
`;
}

export function writeVisualReport(outputRoot) {
  fs.mkdirSync(outputRoot, { recursive: true });
  const model = buildReportModel(outputRoot);
  const outputPath = path.join(outputRoot, 'index.html');
  fs.writeFileSync(outputPath, renderVisualReport(model));
  return { outputPath, model };
}

export function escapeHtml(value) {
  return String(value)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');
}

function buildCapture(outputRoot, record) {
  const { summary, summaryPath, relativeSummaryPath } = record;
  const summaryDir = path.dirname(summaryPath);
  const suite = summary.suite ?? (summary.caseId != null
    ? 'complex'
    : ['dashboard', 'card-alert', 'flowbite-card'].includes(summary.example)
      ? 'legacy'
      : 'diagnostic');
  const acceptance = summary.acceptance ?? {
    metric: null,
    metricLabel: 'Unconfigured',
    captureComplete: false,
    passed: false,
    checks: [],
  };
  const checksByWidth = new Map(
    (acceptance.checks ?? []).map((check) => [check.width, check]),
  );
  const missingAssets = [];
  const cards = [...(summary.results ?? [])]
    .sort((left, right) => left.width - right.width)
    .map((result) => {
      const assets = Object.fromEntries(
        REQUIRED_FILES.map(([key, label]) => {
          const relative = result.files?.[key];
          const absolute = relative == null ? null : path.resolve(summaryDir, relative);
          const exists = absolute != null && fs.existsSync(absolute);
          if (!exists) {
            missingAssets.push({ width: result.width, key, label, relative });
          }
          return [
            key,
            {
              label,
              exists,
              href: exists
                ? encodeReportPath(toPosix(path.relative(outputRoot, absolute)))
                : null,
            },
          ];
        }),
      );
      const check = checksByWidth.get(result.width) ?? null;
      const hasAllAssets = Object.values(assets).every((asset) => asset.exists);
      const passed =
        summary.captureComplete === true && check?.passed === true && hasAllAssets;
      return {
        id: `${summary.example ?? 'capture'}-${result.width}`,
        title: summary.title ?? (summary.caseId == null
          ? summary.example ?? relativeSummaryPath
          : `Complex case ${summary.caseId}`),
        example: summary.example ?? relativeSummaryPath,
        caseId: summary.caseId,
        captureState: summary.captureState ?? 'static',
        suite,
        width: result.width,
        passed,
        result,
        check,
        acceptance,
        assets,
      };
    });

  return {
    summaryPath,
    relativeSummaryPath,
    suite,
    acceptance,
    missingAssets,
    passed:
      acceptance.passed === true &&
      summary.captureComplete === true &&
      missingAssets.length === 0,
    cards,
  };
}

function renderCard(card) {
  const status = card.passed ? 'pass' : 'fail';
  const metric = card.acceptance.metric;
  const check = card.check;
  const requirement = check == null
    ? 'No acceptance check'
    : `${card.acceptance.metricLabel} ≤ ${formatPercent(check.maximum)}`;
  const frame = (key, title) => {
    const asset = card.assets[key];
    return `<figure class="frame"><figcaption class="frame-label"><span>${escapeHtml(title)}</span><span>${card.width}px</span></figcaption>${asset.exists ? `<img src="${escapeHtml(asset.href)}" alt="${escapeHtml(`${title} capture for ${card.title} at ${card.width}px`)}">` : `<div class="missing">${escapeHtml(asset.label)} is missing</div>`}</figure>`;
  };
  const artifact = (key, label) => {
    const asset = card.assets[key];
    return asset.exists
      ? `<a class="artifact" href="${escapeHtml(asset.href)}">${escapeHtml(label)}</a>`
      : `<span class="artifact missing">Missing ${escapeHtml(label)}</span>`;
  };
  const metricBlock = (key, label) => `<div class="metric ${metric === key ? 'enforced' : ''}"><small>${escapeHtml(label)}</small><strong>${formatPercent(card.result[key])}</strong></div>`;

  return `<article class="capture" data-suite="${escapeHtml(card.suite)}" data-width="${card.width}" data-status="${status}">
    <header class="capture-head">
      <div><p class="eyebrow">${escapeHtml(card.suite)} suite · ${escapeHtml(card.captureState)}</p><h2 class="capture-title">${escapeHtml(card.title)}</h2><div class="capture-meta"><span>${card.width}px viewport</span><span>${escapeHtml(requirement)}</span></div></div>
      <span class="status">${status}</span>
    </header>
    <div class="ruler" aria-hidden="true"></div>
    <div class="pair">${frame('tailwind', 'Tailwind reference')}${frame('flutter', 'Flutter render')}</div>
    <footer class="evidence">
      <div class="metrics">${metricBlock('diffPercent', 'Tolerant')}${metricBlock('strictDiffPercent', 'Strict')}${metricBlock('exactDiffPercent', 'Exact')}</div>
      <nav class="artifacts" aria-label="Diff artifacts">${artifact('strictPixelmatchDiff', 'Strict')}${artifact('absoluteDiff', 'Absolute')}${artifact('pixelmatchDiff', 'Pixelmatch')}${artifact('blink', 'Blink')}</nav>
    </footer>
  </article>`;
}

function compareSummaryRecords(left, right) {
  return summarySortKey(left).localeCompare(summarySortKey(right), undefined, {
    numeric: true,
  });
}

function summarySortKey(record) {
  const { summary } = record;
  if (summary.caseId != null) return `1-complex-${summary.caseId}`;
  const legacyOrder = ['dashboard', 'card-alert', 'flowbite-card'];
  const legacyIndex = legacyOrder.indexOf(summary.example);
  if (legacyIndex >= 0) return `0-legacy-${legacyIndex}`;
  if (summary.suite === 'advanced') return `2-advanced-${summary.example}`;
  return `3-${record.relativeSummaryPath}`;
}

function walk(directory, visit) {
  for (const entry of fs.readdirSync(directory, { withFileTypes: true }).sort((left, right) => left.name.localeCompare(right.name))) {
    const entryPath = path.join(directory, entry.name);
    if (entry.isDirectory()) walk(entryPath, visit);
    if (entry.isFile()) visit(entryPath);
  }
}

function encodeReportPath(value) {
  return value.split('/').map(encodeURIComponent).join('/');
}

function toPosix(value) {
  return value.split(path.sep).join('/');
}

function formatPercent(value) {
  return Number.isFinite(value) ? `${Number(value).toFixed(4)}%` : '—';
}

function titleCase(value) {
  return value.replaceAll('-', ' ').replace(/\b\w/g, (letter) => letter.toUpperCase());
}

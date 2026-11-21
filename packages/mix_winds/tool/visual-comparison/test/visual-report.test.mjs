import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';
import { pathToFileURL } from 'node:url';
import { chromium } from 'playwright';

import {
  buildReportModel,
  discoverVisualSummaries,
  evaluateAcceptance,
  renderVisualReport,
  writeVisualReport,
} from '../visual-report.mjs';

const widths = [480, 768, 1024];
const png = Buffer.from(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
  'base64',
);
const gif = Buffer.from(
  'R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==',
  'base64',
);

test('acceptance uses the selected metric and fails incomplete captures', () => {
  const complete = summary({
    values: {
      480: [0.8, 0.4, 0],
      768: [0.9, 0.5, 0],
      1024: [1, 0.6, 0],
    },
  });
  const strictContract = contract('strictDiffPercent', 0.6);

  const passing = evaluateAcceptance(complete, strictContract);
  assert.equal(passing.passed, true);
  assert.deepEqual(
    passing.checks.map((check) => check.passed),
    [true, true, true],
  );

  const failing = evaluateAcceptance(complete, contract('diffPercent', 0.9));
  assert.equal(failing.passed, false);
  assert.equal(failing.checks.at(-1).passed, false);

  const incomplete = evaluateAcceptance(
    { ...complete, captureComplete: false, results: complete.results.slice(0, 2) },
    strictContract,
  );
  assert.equal(incomplete.captureComplete, false);
  assert.equal(incomplete.passed, false);
  assert.equal(incomplete.checks.at(-1).value, null);
});

test('summary discovery and report rendering are deterministic', (t) => {
  const root = temporaryDirectory(t);
  writeSummary(root, 'z-other', summary({ example: 'z-other' }));
  writeSummary(root, 'complex-parity/case-02', summary({ example: 'complex-02', caseId: '02' }));
  writeSummary(root, 'card-alert', summary({ example: 'card-alert' }));
  writeSummary(root, 'complex-parity/case-01', summary({ example: 'complex-01', caseId: '01' }));
  writeSummary(root, 'dashboard', summary({ example: 'dashboard' }));

  const records = discoverVisualSummaries(root);
  assert.deepEqual(
    records.map((record) => record.summary.example),
    ['dashboard', 'card-alert', 'complex-01', 'complex-02', 'z-other'],
  );

  const model = buildReportModel(root, records);
  assert.equal(renderVisualReport(model), renderVisualReport(model));
});

test('report escapes summary-controlled text', () => {
  const record = {
    summaryPath: '/tmp/visual-report/summary.json',
    relativeSummaryPath: 'unsafe/summary.json',
    summary: summary({ example: '<script>alert("unsafe")</script>' }),
  };
  const html = renderVisualReport(buildReportModel('/tmp/visual-report', [record]));

  assert.doesNotMatch(html, /<script>alert\("unsafe"\)<\/script>/);
  assert.match(html, /&lt;script&gt;alert\(&quot;unsafe&quot;\)&lt;\/script&gt;/);
});

test('report honors explicit suite and title metadata', () => {
  const record = {
    summaryPath: '/tmp/visual-report/summary.json',
    relativeSummaryPath: 'advanced-parity/launch-command/summary.json',
    summary: summary({
      example: 'advanced-launch-command',
      suite: 'advanced',
      title: 'Launch command',
    }),
  };
  const model = buildReportModel('/tmp/visual-report', [record]);

  assert.equal(model.captures[0].suite, 'advanced');
  assert.equal(model.cards[0].title, 'Launch command');
  assert.match(renderVisualReport(model), /advanced suite/);
  assert.match(renderVisualReport(model), /Launch command/);
});

test('missing artifacts make an otherwise accepted capture fail visibly', (t) => {
  const root = temporaryDirectory(t);
  const fixture = acceptedSummary();
  writeSummary(root, 'dashboard', fixture);

  const model = buildReportModel(root);
  assert.equal(model.missingAssetCount, widths.length * 6);
  assert.equal(model.failedCaptureCount, widths.length);
  assert.equal(model.captures[0].passed, false);
  assert.match(renderVisualReport(model), /Tailwind capture is missing/);
});

test('generated file report opens cleanly and filters captures', async (t) => {
  const root = temporaryDirectory(t);
  const fixture = acceptedSummary();
  const captureDir = path.join(root, 'dashboard');
  fs.mkdirSync(path.join(captureDir, 'diff'), { recursive: true });
  for (const width of widths) writeAssets(captureDir, width);
  writeSummary(root, 'dashboard', fixture);

  const { outputPath } = writeVisualReport(root);
  const browser = await chromium.launch();
  t.after(() => browser.close());
  const page = await browser.newPage();
  const errors = [];
  page.on('console', (message) => {
    if (message.type() === 'error') errors.push(message.text());
  });
  page.on('pageerror', (error) => errors.push(error.message));
  page.on('requestfailed', (request) => errors.push(request.url()));

  await page.goto(pathToFileURL(outputPath).href);
  await page.waitForLoadState('load');
  assert.equal(await page.title(), 'Mix × Tailwind visual parity');
  assert.equal(await page.locator('.capture').count(), 3);
  assert.equal(await page.locator('.capture:not([hidden])').count(), 3);

  await page.locator('#viewport-filter').selectOption('480');
  assert.equal(await page.locator('.capture:not([hidden])').count(), 1);
  assert.match(await page.locator('#visible-count').textContent(), /^1 of 3/);
  assert.deepEqual(errors, []);
});

function acceptedSummary() {
  const value = summary();
  value.acceptance = evaluateAcceptance(value, contract('diffPercent', 1));
  return value;
}

function summary({
  example = 'dashboard',
  caseId = null,
  suite = null,
  title = null,
  values = {
    480: [0.2, 0.3, 0.4],
    768: [0.2, 0.3, 0.4],
    1024: [0.2, 0.3, 0.4],
  },
} = {}) {
  return {
    generatedAt: '2026-08-04T12:00:00.000Z',
    example,
    caseId,
    suite,
    title,
    captureState: 'static',
    captureComplete: true,
    results: widths.map((width) => ({
      width,
      diffPercent: values[width][0],
      strictDiffPercent: values[width][1],
      exactDiffPercent: values[width][2],
      files: {
        tailwind: `tailwind-${width}.png`,
        flutter: `flutter-${width}.png`,
        pixelmatchDiff: `diff/diff-${width}.png`,
        strictPixelmatchDiff: `diff/strictdiff-${width}.png`,
        absoluteDiff: `diff/absdiff-${width}.png`,
        blink: `diff/blink-${width}.gif`,
      },
    })),
  };
}

function contract(metric, maximum) {
  return {
    metric,
    maximumByWidth: Object.fromEntries(widths.map((width) => [width, maximum])),
  };
}

function writeSummary(root, relativeDirectory, value) {
  const directory = path.join(root, relativeDirectory);
  fs.mkdirSync(directory, { recursive: true });
  fs.writeFileSync(
    path.join(directory, 'summary.json'),
    `${JSON.stringify(value, null, 2)}\n`,
  );
}

function writeAssets(directory, width) {
  fs.writeFileSync(path.join(directory, `tailwind-${width}.png`), png);
  fs.writeFileSync(path.join(directory, `flutter-${width}.png`), png);
  fs.writeFileSync(path.join(directory, 'diff', `diff-${width}.png`), png);
  fs.writeFileSync(path.join(directory, 'diff', `strictdiff-${width}.png`), png);
  fs.writeFileSync(path.join(directory, 'diff', `absdiff-${width}.png`), png);
  fs.writeFileSync(path.join(directory, 'diff', `blink-${width}.gif`), gif);
}

function temporaryDirectory(t) {
  const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'mix-tw-report-'));
  t.after(() => fs.rmSync(directory, { recursive: true, force: true }));
  return directory;
}

#!/usr/bin/env node
import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';
import { computeShowcaseSourceFingerprint } from './showcase-provenance.mjs';
import { writeVisualReport } from './visual-report.mjs';

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const packageRoot = path.resolve(scriptDir, '../..');
const outputRoot = path.join(packageRoot, 'visual-comparison', 'advanced-parity');
const examples = [
  ['launch-command', 'Launch command'],
  ['signal-analytics', 'Signal analytics'],
  ['incident-room', 'Incident room'],
  ['release-timeline', 'Release timeline'],
  ['capacity-map', 'Capacity map'],
];
const forwardedArgs = process.argv
  .slice(2)
  .filter((argument) => !argument.startsWith('--example='));
const summaries = [];
const failures = [];
const sourceFingerprint = computeShowcaseSourceFingerprint();

for (const [slug, title] of examples) {
  console.log(`\n${'='.repeat(72)}`);
  console.log(`Advanced parity: ${title}`);
  console.log(`${'='.repeat(72)}\n`);

  const result = spawnSync(
    process.execPath,
    [
      path.join(scriptDir, 'run-visual-comparison.mjs'),
      `--example=advanced-${slug}`,
      ...forwardedArgs,
    ],
    { stdio: 'inherit' },
  );

  if (result.error || result.status !== 0) {
    failures.push({
      slug,
      exitCode: result.status,
      error: result.error?.message ?? null,
    });
  }

  const summaryPath = path.join(outputRoot, slug, 'summary.json');
  if (!fs.existsSync(summaryPath)) {
    failures.push({ slug, exitCode: null, error: 'summary.json missing' });
    continue;
  }

  const summary = JSON.parse(fs.readFileSync(summaryPath, 'utf8'));
  const average = (metric) => {
    const values = summary.results.map((entry) => entry[metric]);
    return values.reduce((sum, value) => sum + value, 0) / values.length;
  };
  summaries.push({
    slug,
    title,
    captureComplete: summary.captureComplete,
    acceptance: summary.acceptance,
    results: summary.results,
    averageDiffPercent: average('diffPercent'),
    averageStrictDiffPercent: average('strictDiffPercent'),
    averageExactDiffPercent: average('exactDiffPercent'),
  });
}

await fs.promises.mkdir(outputRoot, { recursive: true });
const aggregatePath = path.join(outputRoot, 'summary.json');
const finalSourceFingerprint = computeShowcaseSourceFingerprint();
if (finalSourceFingerprint !== sourceFingerprint) {
  failures.push({
    slug: null,
    exitCode: null,
    error: 'Showcase sources changed while advanced parity was running.',
  });
}
const aggregate = {
  generatedAt: new Date().toISOString(),
  sourceFingerprint,
  tailwindVersion: '4.3.1',
  widths: [480, 768, 1024],
  expectedExampleCount: examples.length,
  completedExampleCount: summaries.filter((summary) => summary.captureComplete)
    .length,
  failures,
  passed:
    failures.length === 0 &&
    summaries.length === examples.length &&
    summaries.every((summary) => summary.acceptance?.passed === true),
  examples: summaries,
};
fs.writeFileSync(aggregatePath, `${JSON.stringify(aggregate, null, 2)}\n`);

console.log('\n=== Advanced Visual Comparison Summary ===\n');
console.table(
  summaries.map((summary) => ({
    example: summary.title,
    complete: summary.captureComplete,
    'tolerant avg %': summary.averageDiffPercent.toFixed(4),
    'strict avg %': summary.averageStrictDiffPercent.toFixed(4),
    'exact avg %': summary.averageExactDiffPercent.toFixed(4),
  })),
);
console.log(`\nAggregate JSON summary: ${aggregatePath}`);

try {
  const report = writeVisualReport(path.join(packageRoot, 'visual-comparison'));
  console.log(`Visual report: ${report.outputPath}`);
} catch (error) {
  failures.push({ slug: null, exitCode: null, error: error.message });
  console.error(`Could not generate visual report: ${error.message}`);
}

if (failures.length > 0 || summaries.length !== examples.length) {
  console.error(`Advanced comparison failed for ${failures.length} capture(s).`);
  process.exitCode = 1;
}

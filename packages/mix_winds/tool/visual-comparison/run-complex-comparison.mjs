#!/usr/bin/env node
import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';
import { writeVisualReport } from './visual-report.mjs';

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const packageRoot = path.resolve(scriptDir, '../..');
const outputRoot = path.join(
  packageRoot,
  'visual-comparison',
  'complex-parity',
);
const caseIds = Array.from({ length: 10 }, (_, index) =>
  String(index + 1).padStart(2, '0'),
);
const forwardedArgs = process.argv
  .slice(2)
  .filter((argument) => !argument.startsWith('--example='));
const summaries = [];
const failures = [];

for (const caseId of caseIds) {
  console.log(`\n${'='.repeat(72)}`);
  console.log(`Complex parity case ${caseId}`);
  console.log(`${'='.repeat(72)}\n`);

  const result = spawnSync(
    process.execPath,
    [
      path.join(scriptDir, 'run-visual-comparison.mjs'),
      `--example=complex-${caseId}`,
      ...forwardedArgs,
    ],
    { stdio: 'inherit' },
  );

  if (result.error || result.status !== 0) {
    failures.push({
      caseId,
      exitCode: result.status,
      error: result.error?.message ?? null,
    });
  }

  const summaryPath = path.join(
    outputRoot,
    `case-${caseId}`,
    'summary.json',
  );
  if (!fs.existsSync(summaryPath)) {
    failures.push({ caseId, exitCode: null, error: 'summary.json missing' });
    continue;
  }

  const summary = JSON.parse(fs.readFileSync(summaryPath, 'utf8'));
  const diffPercents = summary.results.map((entry) => entry.diffPercent);
  const strictDiffPercents = summary.results.map(
    (entry) => entry.strictDiffPercent,
  );
  const exactDiffPercents = summary.results.map(
    (entry) => entry.exactDiffPercent,
  );
  summaries.push({
    caseId,
    captureState: summary.captureState,
    captureComplete: summary.captureComplete,
    acceptance: summary.acceptance,
    results: summary.results,
    averageDiffPercent:
      diffPercents.reduce((sum, value) => sum + value, 0) /
      diffPercents.length,
    maximumDiffPercent: Math.max(...diffPercents),
    averageStrictDiffPercent:
      strictDiffPercents.reduce((sum, value) => sum + value, 0) /
      strictDiffPercents.length,
    maximumStrictDiffPercent: Math.max(...strictDiffPercents),
    averageExactDiffPercent:
      exactDiffPercents.reduce((sum, value) => sum + value, 0) /
      exactDiffPercents.length,
    maximumExactDiffPercent: Math.max(...exactDiffPercents),
  });
}

await fs.promises.mkdir(outputRoot, { recursive: true });
const aggregatePath = path.join(outputRoot, 'summary.json');
const aggregate = {
  generatedAt: new Date().toISOString(),
  tailwindVersion: '4.3.1',
  widths: [480, 768, 1024],
  expectedCaseCount: caseIds.length,
  completedCaseCount: summaries.filter((summary) => summary.captureComplete)
    .length,
  failures,
  passed:
    failures.length === 0 &&
    summaries.length === caseIds.length &&
    summaries.every((summary) => summary.acceptance?.passed === true),
  cases: summaries,
};
fs.writeFileSync(aggregatePath, `${JSON.stringify(aggregate, null, 2)}\n`);

console.log('\n=== Complex Visual Comparison Summary ===\n');
console.table(
  summaries.map((summary) => ({
    case: summary.caseId,
    state: summary.captureState,
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
  failures.push({ caseId: null, exitCode: null, error: error.message });
  console.error(`Could not generate visual report: ${error.message}`);
}

if (failures.length > 0 || summaries.length !== caseIds.length) {
  console.error(`Complex comparison failed for ${failures.length} capture(s).`);
  process.exitCode = 1;
}

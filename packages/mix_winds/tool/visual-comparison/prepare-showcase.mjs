#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

import { computeShowcaseSourceFingerprint } from './showcase-provenance.mjs';

const scriptPath = fileURLToPath(import.meta.url);
const scriptDir = path.dirname(scriptPath);
const packageRoot = path.resolve(scriptDir, '../..');
const exampleRoot = path.join(packageRoot, 'example');
const webRoot = path.join(exampleRoot, 'web');
const generatedRoot = path.join(webRoot, 'generated');
const comparisonRoot = path.join(
  packageRoot,
  'visual-comparison',
  'advanced-parity',
);
const manifestPath = path.join(webRoot, 'showcase-manifest.json');
const aggregatePath = path.join(comparisonRoot, 'summary.json');
const compilerPath = path.join(
  scriptDir,
  'node_modules',
  '@tailwindcss',
  'browser',
  'dist',
  'index.global.js',
);

const REQUIRED_ARTIFACTS = [
  'tailwind',
  'flutter',
  'pixelmatchDiff',
  'strictPixelmatchDiff',
  'absoluteDiff',
  'blink',
];
const REQUIRED_WIDTHS = [480, 768, 1024];

export function prepareShowcase({
  outputRoot = generatedRoot,
  visualRoot = comparisonRoot,
  manifestFile = manifestPath,
  aggregateFile = aggregatePath,
  tailwindCompiler = compilerPath,
  sourceFingerprint = computeShowcaseSourceFingerprint(),
} = {}) {
  const manifest = readJson(manifestFile, 'showcase manifest');
  const aggregate = readJson(aggregateFile, 'advanced parity summary');
  const examples = validateEvidence({
    aggregate,
    manifest,
    sourceFingerprint,
    visualRoot,
  });

  if (!fs.existsSync(tailwindCompiler)) {
    throw new Error(
      `Tailwind browser compiler is missing: ${tailwindCompiler}\nRun npm install in ${scriptDir}.`,
    );
  }

  const copyPlan = buildCopyPlan(examples, visualRoot, outputRoot);
  for (const item of copyPlan) {
    if (!fs.existsSync(item.source)) {
      throw new Error(`Required showcase artifact is missing: ${item.source}`);
    }
  }

  fs.rmSync(outputRoot, { recursive: true, force: true });
  fs.mkdirSync(outputRoot, { recursive: true });
  copyFile(tailwindCompiler, path.join(outputRoot, 'tailwindcss-browser.js'));
  for (const item of copyPlan) copyFile(item.source, item.destination);

  const parityData = {
    schemaVersion: 1,
    generatedAt: aggregate.generatedAt,
    sourceFingerprint: aggregate.sourceFingerprint,
    tailwindVersion: aggregate.tailwindVersion,
    widths: aggregate.widths,
    passed: aggregate.passed,
    examples: examples.map(({ manifestExample, summary }) => ({
      id: manifestExample.id,
      slug: manifestExample.slug,
      title: manifestExample.title,
      captureComplete: summary.captureComplete,
      acceptance: summary.acceptance,
      averageDiffPercent: summary.averageDiffPercent,
      averageStrictDiffPercent: summary.averageStrictDiffPercent,
      averageExactDiffPercent: summary.averageExactDiffPercent,
      results: summary.results.map((result) => ({
        ...result,
        files: Object.fromEntries(
          Object.entries(result.files).map(([key, relativeFile]) => [
            key,
            toPosix(
              path.join('generated', 'parity', manifestExample.slug, relativeFile),
            ),
          ]),
        ),
      })),
    })),
  };
  const parityDataPath = path.join(outputRoot, 'parity-data.json');
  fs.writeFileSync(parityDataPath, `${JSON.stringify(parityData, null, 2)}\n`);

  return {
    artifactCount: copyPlan.length,
    exampleCount: examples.length,
    outputRoot,
    parityDataPath,
  };
}

function validateEvidence({
  aggregate,
  manifest,
  sourceFingerprint,
  visualRoot,
}) {
  if (!Array.isArray(manifest.examples) || manifest.examples.length !== 5) {
    throw new Error('The public showcase must declare exactly five examples.');
  }
  if (aggregate.passed !== true || aggregate.failures?.length > 0) {
    throw new Error('Advanced visual parity has not passed; refusing to publish stale evidence.');
  }
  if (aggregate.completedExampleCount !== manifest.examples.length) {
    throw new Error('Advanced parity evidence is incomplete for the showcase manifest.');
  }
  if (aggregate.sourceFingerprint !== sourceFingerprint) {
    throw new Error(
      'Advanced parity evidence has a different source fingerprint. Run npm run compare:advanced again.',
    );
  }
  if (!hasCanonicalWidths(aggregate.widths)) {
    throw new Error(
      'Advanced parity evidence must contain 480, 768, and 1024 exactly once.',
    );
  }

  const summaryBySlug = new Map(
    (aggregate.examples ?? []).map((summary) => [summary.slug, summary]),
  );
  return manifest.examples.map((manifestExample) => {
    const summary = summaryBySlug.get(manifestExample.slug);
    if (!summary) {
      throw new Error(`No parity summary exists for ${manifestExample.slug}.`);
    }
    if (summary.captureComplete !== true || summary.acceptance?.passed !== true) {
      throw new Error(`Parity evidence did not pass for ${manifestExample.slug}.`);
    }
    if (
      !Array.isArray(summary.results) ||
      !hasCanonicalWidths(summary.results.map((result) => result.width))
    ) {
      throw new Error(
        `${manifestExample.slug} must contain 480, 768, and 1024 exactly once.`,
      );
    }

    const individualSummary = path.join(
      visualRoot,
      manifestExample.slug,
      'summary.json',
    );
    if (!fs.existsSync(individualSummary)) {
      throw new Error(`Individual summary is missing: ${individualSummary}`);
    }
    return { manifestExample, summary };
  });
}

function hasCanonicalWidths(values) {
  if (!Array.isArray(values) || values.length !== REQUIRED_WIDTHS.length) {
    return false;
  }

  const uniqueWidths = new Set(values);
  return (
    uniqueWidths.size === REQUIRED_WIDTHS.length &&
    REQUIRED_WIDTHS.every((width) => uniqueWidths.has(width))
  );
}

function buildCopyPlan(examples, visualRoot, outputRoot) {
  const plan = [];
  for (const { manifestExample, summary } of examples) {
    for (const result of summary.results) {
      for (const artifact of REQUIRED_ARTIFACTS) {
        const relativeFile = result.files?.[artifact];
        if (!relativeFile) {
          throw new Error(
            `${manifestExample.slug} at ${result.width}px is missing ${artifact}.`,
          );
        }
        plan.push({
          destination: path.join(
            outputRoot,
            'parity',
            manifestExample.slug,
            relativeFile,
          ),
          source: path.join(visualRoot, manifestExample.slug, relativeFile),
        });
      }
    }
  }
  return plan;
}

function readJson(filePath, label) {
  if (!fs.existsSync(filePath)) throw new Error(`Missing ${label}: ${filePath}`);
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function copyFile(source, destination) {
  fs.mkdirSync(path.dirname(destination), { recursive: true });
  fs.copyFileSync(source, destination);
}

function toPosix(filePath) {
  return filePath.split(path.sep).join('/');
}

if (process.argv[1] && path.resolve(process.argv[1]) === scriptPath) {
  try {
    const result = prepareShowcase();
    console.log(
      `Prepared ${result.exampleCount} examples and ${result.artifactCount} parity artifacts in ${result.outputRoot}.`,
    );
  } catch (error) {
    console.error(error.message);
    process.exitCode = 1;
  }
}

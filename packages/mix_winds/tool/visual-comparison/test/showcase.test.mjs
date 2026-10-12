import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';
import { fileURLToPath } from 'node:url';

import {
  extractShowcaseRegion,
  highlightDartSource,
  presentationTailwindSource,
} from '../../../example/web/showcase-source.js';
import { prepareShowcase } from '../prepare-showcase.mjs';
import { computeShowcaseSourceFingerprint } from '../showcase-provenance.mjs';

const testDir = path.dirname(fileURLToPath(import.meta.url));
const mixWindsRoot = path.resolve(testDir, '../../..');
const exampleWebRoot = path.join(mixWindsRoot, 'example', 'web');
const widths = [480, 768, 1024];
const artifacts = [
  ['tailwind', (width) => `tailwind-${width}.png`],
  ['flutter', (width) => `flutter-${width}.png`],
  ['pixelmatchDiff', (width) => `diff/diff-${width}.png`],
  ['strictPixelmatchDiff', (width) => `diff/strictdiff-${width}.png`],
  ['absoluteDiff', (width) => `diff/absdiff-${width}.png`],
  ['blink', (width) => `diff/blink-${width}.gif`],
];
const showcaseFunctionNames = new Set([
  'button',
  'div',
  'h1',
  'h2',
  'h3',
  'p',
  'span',
]);

test('all manifest entries map to the real HTML and Dart source regions', () => {
  const manifest = readJson(path.join(exampleWebRoot, 'showcase-manifest.json'));
  const html = fs.readFileSync(
    path.join(mixWindsRoot, 'example', 'real_tailwind', 'advanced-examples.html'),
    'utf8',
  );
  const dart = fs.readFileSync(
    path.join(mixWindsRoot, 'example', 'lib', 'advanced_parity_preview.dart'),
    'utf8',
  );

  assert.equal(manifest.examples.length, 5);
  for (const example of manifest.examples) {
    const htmlRegion = extractShowcaseRegion(html, example.slug);
    const dartRegion = extractShowcaseRegion(dart, example.slug);
    assert.match(htmlRegion, new RegExp(`data-example="${example.id}"`));
    assert.ok(htmlRegion.includes(example.signatureUtility));
    assert.ok(dartRegion.includes(example.signatureUtility));
    assert.doesNotMatch(presentationTailwindSource(htmlRegion), /data-parity-class/);
    assert.match(dartRegion, /^final _[a-zA-Z]+ = div\(/);
    assert.doesNotMatch(dartRegion, /\bclass\s+/);
    assert.doesNotMatch(dartRegion, /\bclassNames\s*:/);
    assert.doesNotMatch(dartRegion, /\b(?:Button|Div|H[1-6]|P|Span)\(/);
    const highlightedDart = highlightDartSource(
      dartRegion,
      example.signatureUtility,
    );
    assert.equal(highlightedText(highlightedDart), dartRegion);
    assert.equal(
      highlightedDart.split('<mark class="utility-match">').length - 1,
      1,
    );
    for (const match of dartRegion.matchAll(/\b([a-z][A-Za-z0-9]*)\(/g)) {
      assert.ok(
        showcaseFunctionNames.has(match[1]),
        `${example.slug} hides showcase markup behind ${match[1]}`,
      );
    }
  }
});

test('showcase keeps live render and exact source in one comparison flow', () => {
  const html = fs.readFileSync(path.join(exampleWebRoot, 'index.html'), 'utf8');
  const script = fs.readFileSync(path.join(exampleWebRoot, 'showcase.js'), 'utf8');
  const previewIndex = html.indexOf('id="panel-preview"');
  const sourceIndex = html.indexOf('id="panel-source"');
  const parityIndex = html.indexOf('id="panel-parity"');

  assert.ok(previewIndex >= 0, 'The live render comparison is missing.');
  assert.ok(sourceIndex > previewIndex, 'Source must follow the rendered pair.');
  assert.ok(parityIndex > sourceIndex, 'Parity evidence must follow the source pair.');
  assert.equal(html.split('id="source-utility"').length - 1, 1);
  assert.match(html, /<details id="panel-parity"/);
  assert.doesNotMatch(html, /role="tab(?:list|panel)?"/);
  assert.doesNotMatch(html, /id="hero-utility"/);
  assert.doesNotMatch(script, /VALID_VIEWS|mountedViews|data-view/);
  assert.match(script, /url\.searchParams\.delete\('view'\)/);
});

test('Dart highlighting classifies syntax without changing source text', () => {
  const source = [
    '/* outer /* nested */ comment */',
    '@override',
    'final Widget card = div(',
    "  'flex p-4',",
    "  [span(r'''raw $value''', 'Count: 42')],",
    "  semanticsLabel: 'Card <primary>',",
    ');',
    'const int count = 0x2A;',
  ].join('\n');
  const highlighted = highlightDartSource(source, 'flex p-4');

  assert.match(highlighted, /class="syntax-comment"/);
  assert.match(highlighted, /class="syntax-annotation">@override/);
  assert.match(highlighted, /class="syntax-keyword">final/);
  assert.match(highlighted, /class="syntax-type">Widget/);
  assert.match(highlighted, /class="syntax-function">div/);
  assert.match(highlighted, /class="syntax-named-parameter">semanticsLabel/);
  assert.match(highlighted, /class="syntax-number">0x2A/);
  assert.match(highlighted, /<mark class="utility-match">flex p-4<\/mark>/);
  assert.doesNotMatch(highlighted, /<primary>/);
  assert.equal(highlightedText(highlighted), source);
});

test('showcase preparation publishes only complete passing evidence', (t) => {
  const fixture = createPreparationFixture(t);
  const result = prepareShowcase(fixture.options);
  const published = readJson(result.parityDataPath);

  assert.equal(result.artifactCount, 90);
  assert.equal(published.sourceFingerprint, fixture.options.sourceFingerprint);
  assert.equal(published.examples.length, 5);
  assert.equal(published.examples[0].results.length, 3);
  assert.equal(
    published.examples[0].results[0].files.tailwind,
    'generated/parity/launch-command/tailwind-480.png',
  );
  assert.ok(
    fs.existsSync(
      path.join(fixture.options.outputRoot, 'tailwindcss-browser.js'),
    ),
  );
});

test('showcase preparation refuses failed parity evidence before replacing output', (t) => {
  const root = temporaryDirectory(t);
  const outputRoot = path.join(root, 'generated');
  const aggregateFile = path.join(root, 'aggregate.json');
  fs.mkdirSync(outputRoot);
  fs.writeFileSync(path.join(outputRoot, 'sentinel'), 'preserve me');
  fs.writeFileSync(
    aggregateFile,
    JSON.stringify({ passed: false, failures: [{ slug: 'launch-command' }] }),
  );

  assert.throws(
    () =>
      prepareShowcase({
        aggregateFile,
        manifestFile: path.join(exampleWebRoot, 'showcase-manifest.json'),
        outputRoot,
        tailwindCompiler: path.join(root, 'missing.js'),
        visualRoot: path.join(root, 'visual'),
      }),
    /has not passed/,
  );
  assert.equal(fs.readFileSync(path.join(outputRoot, 'sentinel'), 'utf8'), 'preserve me');
});

test(
  'showcase preparation refuses evidence from a different source fingerprint',
  (t) => {
    const fixture = createPreparationFixture(t, {
      sourceFingerprint: 'captured-source',
    });

    assert.throws(
      () =>
        prepareShowcase({
          ...fixture.options,
          sourceFingerprint: 'current-source',
        }),
      /source fingerprint/i,
    );
  },
);

test(
  'showcase preparation requires each canonical capture width exactly once',
  (t) => {
    const fixture = createPreparationFixture(t);
    fixture.aggregate.examples[0].results[2].width = 768;
    fs.writeFileSync(
      fixture.options.aggregateFile,
      JSON.stringify(fixture.aggregate),
    );

    assert.throws(
      () => prepareShowcase(fixture.options),
      /480, 768, and 1024/i,
    );
  },
);

test('source fingerprint includes ignored dependency overrides', (t) => {
  const root = temporaryDirectory(t);
  execFileSync('git', ['init', '--quiet'], { cwd: root });
  fs.writeFileSync(path.join(root, '.gitignore'), 'pubspec_overrides.yaml\n');
  fs.writeFileSync(path.join(root, 'tracked.txt'), 'tracked source');
  fs.writeFileSync(path.join(root, 'pubspec_overrides.yaml'), 'mix: local-a\n');
  execFileSync('git', ['add', '.gitignore', 'tracked.txt'], { cwd: root });

  const options = {
    additionalFiles: ['pubspec_overrides.yaml'],
    sourcePaths: ['tracked.txt'],
    workspaceRoot: root,
  };
  const before = computeShowcaseSourceFingerprint(options);
  fs.writeFileSync(path.join(root, 'pubspec_overrides.yaml'), 'mix: local-b\n');
  const after = computeShowcaseSourceFingerprint(options);

  assert.notEqual(after, before);
});

function createPreparationFixture(
  t,
  { sourceFingerprint = 'current-source' } = {},
) {
  const root = temporaryDirectory(t);
  const visualRoot = path.join(root, 'visual');
  const outputRoot = path.join(root, 'generated');
  const manifestFile = path.join(root, 'manifest.json');
  const aggregateFile = path.join(root, 'aggregate.json');
  const tailwindCompiler = path.join(root, 'tailwind.js');
  const manifest = readJson(path.join(exampleWebRoot, 'showcase-manifest.json'));
  const examples = manifest.examples.map((example) =>
    createEvidence(visualRoot, example.slug, example.title),
  );
  const aggregate = {
    generatedAt: '2026-08-04T00:00:00.000Z',
    tailwindVersion: '4.3.1',
    sourceFingerprint,
    widths,
    completedExampleCount: 5,
    failures: [],
    passed: true,
    examples,
  };

  fs.writeFileSync(manifestFile, JSON.stringify(manifest));
  fs.writeFileSync(aggregateFile, JSON.stringify(aggregate));
  fs.writeFileSync(tailwindCompiler, '/* compiler */');

  return {
    aggregate,
    options: {
      aggregateFile,
      manifestFile,
      outputRoot,
      sourceFingerprint,
      tailwindCompiler,
      visualRoot,
    },
  };
}

function createEvidence(visualRoot, slug, title) {
  const directory = path.join(visualRoot, slug);
  const results = widths.map((width) => {
    const files = Object.fromEntries(
      artifacts.map(([key, getFile]) => [key, getFile(width)]),
    );
    for (const relativeFile of Object.values(files)) {
      const filePath = path.join(directory, relativeFile);
      fs.mkdirSync(path.dirname(filePath), { recursive: true });
      fs.writeFileSync(filePath, 'artifact');
    }
    return {
      width,
      dimensions: {
        tailwind: { width, height: 400 },
        flutter: { width, height: 400 },
      },
      diffPercent: 1,
      strictDiffPercent: 2,
      exactDiffPercent: 3,
      files,
    };
  });
  const summary = {
    slug,
    title,
    captureComplete: true,
    acceptance: {
      passed: true,
      maximumByWidth: Object.fromEntries(widths.map((width) => [width, 5])),
    },
    results,
    averageDiffPercent: 1,
    averageStrictDiffPercent: 2,
    averageExactDiffPercent: 3,
  };
  fs.mkdirSync(directory, { recursive: true });
  fs.writeFileSync(path.join(directory, 'summary.json'), JSON.stringify(summary));
  return summary;
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function highlightedText(value) {
  return value
    .replace(/<[^>]+>/g, '')
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&quot;', '"')
    .replaceAll('&#39;', "'")
    .replaceAll('&amp;', '&');
}

function temporaryDirectory(t) {
  const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'mix-tw-showcase-'));
  t.after(() => fs.rmSync(directory, { recursive: true, force: true }));
  return directory;
}

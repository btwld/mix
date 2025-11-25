#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import pixelmatch from 'pixelmatch';
import { PNG } from 'pngjs';

const __dirname = path.dirname(new URL(import.meta.url).pathname);
const goldensDir = path.resolve(__dirname, '..', '..', 'packages', 'mix_tailwinds', 'example', 'test', 'goldens', 'exploration');

function readPng(filePath) {
  return PNG.sync.read(fs.readFileSync(filePath));
}

const tailwindPath = path.join(goldensDir, 'tailwind-text-reference.png');
if (!fs.existsSync(tailwindPath)) {
  console.error('Missing Tailwind reference:', tailwindPath);
  process.exit(1);
}

const tailwindPng = readPng(tailwindPath);

// List of experiments to compare
const experiments = [
  { file: 'exp-a-flutter-default.png', label: 'A: Flutter default (no height)' },
  { file: 'exp-b1-tw-proportional.png', label: 'B1: TW heights + proportional' },
  { file: 'exp-b2-tw-even.png', label: 'B2: TW heights + even' },
  { file: 'exp-c1-even-no-first.png', label: 'C1: Even + no first ascent' },
  { file: 'exp-c2-even-no-last.png', label: 'C2: Even + no last descent' },
  { file: 'exp-c3-even-no-both.png', label: 'C3: Even + no first/last' },
  { file: 'exp-d1-90pct-height.png', label: 'D1: 90% of TW height' },
  { file: 'exp-d2-80pct-height.png', label: 'D2: 80% of TW height' },
  { file: 'exp-e-tight-even.png', label: 'E: Height 1.0 + even' },
  { file: 'mix-tailwinds-current.png', label: 'Current mix_tailwinds' },
];

const results = [];

for (const exp of experiments) {
  const expPath = path.join(goldensDir, exp.file);
  if (!fs.existsSync(expPath)) {
    console.error(`Missing: ${exp.file}`);
    continue;
  }

  const expPng = readPng(expPath);

  // Crop to the smaller dimensions
  const width = Math.min(tailwindPng.width, expPng.width);
  const height = Math.min(tailwindPng.height, expPng.height);

  // Create cropped versions
  const croppedTailwind = new PNG({ width, height });
  const croppedExp = new PNG({ width, height });
  const bytesPerRow = width * 4;

  for (let row = 0; row < height; row++) {
    tailwindPng.data.copy(
      croppedTailwind.data,
      row * bytesPerRow,
      row * tailwindPng.width * 4,
      row * tailwindPng.width * 4 + bytesPerRow,
    );
    expPng.data.copy(
      croppedExp.data,
      row * bytesPerRow,
      row * expPng.width * 4,
      row * expPng.width * 4 + bytesPerRow,
    );
  }

  const diff = new PNG({ width, height });
  const mismatched = pixelmatch(
    croppedTailwind.data,
    croppedExp.data,
    diff.data,
    width,
    height,
    { threshold: 0.1 },
  );

  const totalPixels = width * height;
  const delta = (mismatched / totalPixels) * 100;

  results.push({
    label: exp.label,
    mismatched,
    totalPixels,
    delta,
  });
}

// Sort by delta ascending (best matches first)
results.sort((a, b) => a.delta - b.delta);

console.log('\n=== Text Rendering Exploration Results ===\n');
console.log('Comparing each experiment against Tailwind CSS reference:\n');

console.table(
  results.map((r, i) => ({
    rank: i + 1,
    experiment: r.label,
    'diff px': r.mismatched,
    'diff %': `${r.delta.toFixed(2)}%`,
  })),
);

console.log('\nBest approach:', results[0]?.label || 'N/A');
console.log('Worst approach:', results[results.length - 1]?.label || 'N/A');

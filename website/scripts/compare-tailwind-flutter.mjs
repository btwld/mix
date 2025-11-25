#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import pixelmatch from 'pixelmatch';
import { PNG } from 'pngjs';

const __dirname = path.dirname(new URL(import.meta.url).pathname);
const websiteRoot = path.resolve(__dirname, '..');
const screenshotDir = path.join(websiteRoot, 'screenshots', 'tailwind-plan-card');
const flutterGoldensDir = path.resolve(
  websiteRoot,
  '..',
  'packages',
  'mix_tailwinds',
  'example',
  'test',
  'goldens',
);
const diffDir = path.join(screenshotDir, 'diff');
await fs.promises.mkdir(diffDir, { recursive: true });

const widths = [480, 768, 1024];

function readPng(filePath) {
  return PNG.sync.read(fs.readFileSync(filePath));
}

function writePng(filePath, png) {
  fs.writeFileSync(filePath, PNG.sync.write(png));
}

const results = [];

for (const width of widths) {
  const tailwindPath = path.join(
    screenshotDir,
    `tailwind-plan-card-${width}.png`,
  );
  const flutterPath = path.join(
    flutterGoldensDir,
    `flutter-plan-card-${width}.png`,
  );

  if (!fs.existsSync(tailwindPath)) {
    console.error(`Missing Tailwind screenshot: ${tailwindPath}`);
    process.exitCode = 1;
    continue;
  }
  if (!fs.existsSync(flutterPath)) {
    console.error(`Missing Flutter golden: ${flutterPath}`);
    process.exitCode = 1;
    continue;
  }

  const tailwindPng = readPng(tailwindPath);
  const flutterPng = readPng(flutterPath);

  if (tailwindPng.width !== flutterPng.width) {
    console.error(
      `Width mismatch at ${width}px: Tailwind=${tailwindPng.width}, Flutter=${flutterPng.width}`,
    );
    process.exitCode = 1;
    continue;
  }

  const targetHeight = Math.min(tailwindPng.height, flutterPng.height);
  const flutterCropped = new PNG({
    width: flutterPng.width,
    height: targetHeight,
  });
  const bytesPerRow = flutterPng.width * 4;
  for (let row = 0; row < targetHeight; row += 1) {
    flutterPng.data.copy(
      flutterCropped.data,
      row * bytesPerRow,
      row * bytesPerRow,
      row * bytesPerRow + bytesPerRow,
    );
  }

  const tailwindCropped = new PNG({
    width: tailwindPng.width,
    height: targetHeight,
  });
  for (let row = 0; row < targetHeight; row += 1) {
    tailwindPng.data.copy(
      tailwindCropped.data,
      row * bytesPerRow,
      row * bytesPerRow,
      row * bytesPerRow + bytesPerRow,
    );
  }

  const diff = new PNG({
    width: tailwindCropped.width,
    height: tailwindCropped.height,
  });

  const mismatched = pixelmatch(
    tailwindCropped.data,
    flutterCropped.data,
    diff.data,
    tailwindCropped.width,
    tailwindCropped.height,
    { threshold: 0.1 },
  );

  const diffPath = path.join(diffDir, `diff-${width}.png`);
  writePng(diffPath, diff);

  const totalPixels = tailwindCropped.width * tailwindCropped.height;
  const delta = (mismatched / totalPixels) * 100;
  results.push({
    width,
    mismatched,
    totalPixels,
    delta,
    diffPath,
  });
}

console.table(
  results.map((r) => ({
    width: `${r.width}px`,
    'diff px': r.mismatched,
    'diff %': `${r.delta.toFixed(2)}%`,
    'diff file': path.relative(websiteRoot, r.diffPath),
  })),
);

if (results.some((r) => r.mismatched > 0)) {
  console.log('\nDifferences detected. Inspect the diff PNGs listed above.');
}

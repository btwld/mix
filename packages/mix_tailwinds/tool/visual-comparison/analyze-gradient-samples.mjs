#!/usr/bin/env node
/**
 * Gradient sample analyzer for Flutter vs Tailwind screenshots.
 *
 * Usage examples:
 *   node analyze-gradient-samples.mjs --example=card-alert --width=480
 *   node analyze-gradient-samples.mjs --tailwind=../../visual-comparison/card-alert/tailwind-480.png --flutter=../../visual-comparison/card-alert/flutter-480.png
 *   node analyze-gradient-samples.mjs --example=card-alert --width=480 --y-band=0.72:0.98 --x-count=7 --y-count=4
 */
import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';
import { PNG } from 'pngjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const packageRoot = path.resolve(__dirname, '../..');

const args = parseArgs(process.argv.slice(2));
const example = args.example ?? 'card-alert';
const width = Number(args.width ?? 480);
const patchRadius = Math.max(0, Number(args.patch ?? 2));
const xCount = Math.max(2, Number(args['x-count'] ?? 5));
const yCount = Math.max(2, Number(args['y-count'] ?? 3));

const yBandByExample = {
  'card-alert': '0.72:0.98',
  dashboard: '0.72:0.96',
};

const yBand = parseBand(args['y-band'] ?? yBandByExample[example] ?? '0.7:0.95');
const xBand = parseBand(args['x-band'] ?? '0.08:0.92');

const tailwindPath =
  args.tailwind ??
  path.join(packageRoot, 'visual-comparison', example, `tailwind-${width}.png`);
const flutterPath =
  args.flutter ??
  path.join(packageRoot, 'visual-comparison', example, `flutter-${width}.png`);

assertFileExists(tailwindPath, '--tailwind');
assertFileExists(flutterPath, '--flutter');

const tailwind = PNG.sync.read(fs.readFileSync(tailwindPath));
const flutter = PNG.sync.read(fs.readFileSync(flutterPath));

const sampleWidth = Math.min(tailwind.width, flutter.width);
const sampleHeight = Math.min(tailwind.height, flutter.height);

const points = buildGridPoints(xBand, yBand, xCount, yCount);
const rows = points.map((point, index) => {
  const x = clamp(Math.round(point.x * (sampleWidth - 1)), 0, sampleWidth - 1);
  const y = clamp(Math.round(point.y * (sampleHeight - 1)), 0, sampleHeight - 1);
  const tailwindColor = averagePatch(tailwind, x, y, patchRadius);
  const flutterColor = averagePatch(flutter, x, y, patchRadius);
  const delta = deltaRgb(tailwindColor, flutterColor);
  return {
    point: index + 1,
    x,
    y,
    tailwind: toHex(tailwindColor),
    flutter: toHex(flutterColor),
    delta: Number(delta.toFixed(2)),
    tailwindLum: Number(luminance(tailwindColor).toFixed(4)),
    flutterLum: Number(luminance(flutterColor).toFixed(4)),
  };
});

const deltas = rows.map((row) => row.delta);
const tailwindLums = rows.map((row) => row.tailwindLum);
const flutterLums = rows.map((row) => row.flutterLum);
const summary = {
  points: rows.length,
  meanDelta: round2(mean(deltas)),
  medianDelta: round2(median(deltas)),
  maxDelta: round2(Math.max(...deltas)),
  luminanceCorrelation: round4(correlation(tailwindLums, flutterLums)),
  tailwindRange: round4(Math.max(...tailwindLums) - Math.min(...tailwindLums)),
  flutterRange: round4(Math.max(...flutterLums) - Math.min(...flutterLums)),
};

console.log('Gradient sample analysis\n');
console.log(`Tailwind: ${tailwindPath}`);
console.log(`Flutter : ${flutterPath}`);
console.log(`Dimensions compared: ${sampleWidth}x${sampleHeight}`);
console.log(
  `Sampling grid: x=${xCount}, y=${yCount}, x-band=${fmtBand(xBand)}, y-band=${fmtBand(
    yBand,
  )}, patch=${patchRadius}`,
);
console.log('');
console.table(rows);
console.log('Summary:', summary);
console.log('Diagnosis:', diagnose(summary));

if (args.output) {
  const outputPath = path.resolve(args.output);
  const payload = {
    tailwindPath,
    flutterPath,
    dimensions: { width: sampleWidth, height: sampleHeight },
    grid: { xCount, yCount, xBand, yBand, patchRadius },
    rows,
    summary,
    diagnosis: diagnose(summary),
    generatedAt: new Date().toISOString(),
  };
  fs.writeFileSync(outputPath, `${JSON.stringify(payload, null, 2)}\n`);
  console.log(`Wrote report: ${outputPath}`);
}

function parseArgs(argv) {
  const parsed = {};
  for (const token of argv) {
    if (!token.startsWith('--')) continue;
    const [rawKey, rawValue] = token.slice(2).split('=');
    parsed[rawKey] = rawValue ?? 'true';
  }
  return parsed;
}

function parseBand(value) {
  const [rawStart, rawEnd] = value.split(':');
  const start = Number(rawStart);
  const end = Number(rawEnd);
  if (!Number.isFinite(start) || !Number.isFinite(end)) {
    throw new Error(`Invalid band: "${value}". Expected "start:end".`);
  }
  return {
    start: clamp(start, 0, 1),
    end: clamp(end, 0, 1),
  };
}

function fmtBand(band) {
  return `${band.start.toFixed(2)}:${band.end.toFixed(2)}`;
}

function buildGridPoints(xBandInput, yBandInput, xGrid, yGrid) {
  const xBandSafe = normalizeBand(xBandInput);
  const yBandSafe = normalizeBand(yBandInput);
  const points = [];
  for (let yi = 0; yi < yGrid; yi++) {
    const yT = yGrid === 1 ? 0 : yi / (yGrid - 1);
    const y = lerp(yBandSafe.start, yBandSafe.end, yT);
    for (let xi = 0; xi < xGrid; xi++) {
      const xT = xGrid === 1 ? 0 : xi / (xGrid - 1);
      const x = lerp(xBandSafe.start, xBandSafe.end, xT);
      points.push({ x, y });
    }
  }
  return points;
}

function normalizeBand(band) {
  return band.start <= band.end
    ? band
    : {
        start: band.end,
        end: band.start,
      };
}

function averagePatch(png, centerX, centerY, radius) {
  let r = 0;
  let g = 0;
  let b = 0;
  let count = 0;
  for (let dy = -radius; dy <= radius; dy++) {
    for (let dx = -radius; dx <= radius; dx++) {
      const x = clamp(centerX + dx, 0, png.width - 1);
      const y = clamp(centerY + dy, 0, png.height - 1);
      const idx = (png.width * y + x) * 4;
      r += png.data[idx];
      g += png.data[idx + 1];
      b += png.data[idx + 2];
      count++;
    }
  }
  return {
    r: Math.round(r / count),
    g: Math.round(g / count),
    b: Math.round(b / count),
  };
}

function deltaRgb(a, b) {
  return Math.sqrt(
    (a.r - b.r) * (a.r - b.r) +
      (a.g - b.g) * (a.g - b.g) +
      (a.b - b.b) * (a.b - b.b),
  );
}

function toHex(color) {
  return `#${byteHex(color.r)}${byteHex(color.g)}${byteHex(color.b)}`;
}

function byteHex(value) {
  return Math.max(0, Math.min(255, value)).toString(16).padStart(2, '0');
}

function luminance(color) {
  // Relative luminance on sRGB components.
  const r = color.r / 255;
  const g = color.g / 255;
  const b = color.b / 255;
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

function mean(values) {
  if (values.length === 0) return 0;
  return values.reduce((sum, value) => sum + value, 0) / values.length;
}

function median(values) {
  if (values.length === 0) return 0;
  const sorted = [...values].sort((a, b) => a - b);
  const mid = Math.floor(sorted.length / 2);
  if (sorted.length % 2 === 0) {
    return (sorted[mid - 1] + sorted[mid]) / 2;
  }
  return sorted[mid];
}

function correlation(a, b) {
  if (a.length !== b.length || a.length < 2) return 0;
  const meanA = mean(a);
  const meanB = mean(b);
  let numerator = 0;
  let denomA = 0;
  let denomB = 0;
  for (let i = 0; i < a.length; i++) {
    const da = a[i] - meanA;
    const db = b[i] - meanB;
    numerator += da * db;
    denomA += da * da;
    denomB += db * db;
  }
  if (denomA === 0 || denomB === 0) return 0;
  return numerator / Math.sqrt(denomA * denomB);
}

function diagnose(summaryInput) {
  const { meanDelta, maxDelta, luminanceCorrelation, flutterRange, tailwindRange } =
    summaryInput;
  const rangeGap = Math.abs(flutterRange - tailwindRange);

  if (meanDelta > 30 || maxDelta > 60 || luminanceCorrelation < 0.5) {
    return 'obvious mismatch: likely gradient geometry/direction issue';
  }
  if (meanDelta > 15 || rangeGap > 0.12) {
    return 'moderate mismatch: likely blend/transform/renderer differences';
  }
  return 'close match: residual differences are minor';
}

function assertFileExists(filePath, flag) {
  if (!fs.existsSync(filePath)) {
    throw new Error(`Missing file for ${flag}: ${filePath}`);
  }
}

function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}

function lerp(a, b, t) {
  return a + (b - a) * t;
}

function round2(value) {
  return Number(value.toFixed(2));
}

function round4(value) {
  return Number(value.toFixed(4));
}

#!/usr/bin/env node
/**
 * Automated visual comparison: Flutter vs Tailwind CSS
 *
 * Usage:
 *   cd packages/mix_winds/tool/visual-comparison
 *   npm ci       # first time, or whenever package-lock.json changes
 *   npm run compare
 *   npm run compare -- --example=card-alert
 *   npm run compare -- --example=flowbite-card
 *
 * Prerequisites:
 *   - Flutter web server running: flutter run -d web-server --web-port=8089 --profile
 *   - Or pass custom URL via --flutter-url
 */
import { chromium } from 'playwright';
import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';
import GIFEncoder from 'gif-encoder-2';
import pixelmatch from 'pixelmatch';
import { PNG } from 'pngjs';
import { evaluateAcceptance, writeVisualReport } from './visual-report.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const packageRoot = path.resolve(__dirname, '../..'); // packages/mix_winds
const baseScreenshotDir = path.join(packageRoot, 'visual-comparison');

const WIDTHS = [480, 768, 1024];
const FLUTTER_PORT = 8089;
const DEFAULT_GRADIENT_STRATEGY = 'css-angle-rect';

const maximumAtEveryWidth = (maximum) =>
  Object.fromEntries(WIDTHS.map((width) => [width, maximum]));

const COMPLEX_ACCEPTANCE = {
  '01': { metric: 'strictDiffPercent', maximum: 1 },
  '02': { metric: 'strictDiffPercent', maximum: 1 },
  '03': { metric: 'exactDiffPercent', maximum: 0 },
  '04': { metric: 'diffPercent', maximum: 5 },
  '05': { metric: 'diffPercent', maximum: 1 },
  '06': { metric: 'strictDiffPercent', maximum: 3 },
  '07': { metric: 'strictDiffPercent', maximum: 1 },
  '08': { metric: 'strictDiffPercent', maximum: 1 },
  '09': { metric: 'strictDiffPercent', maximum: 1 },
  '10': { metric: 'strictDiffPercent', maximum: 1 },
};

const COMPLEX_CASE_IDS = Array.from({ length: 10 }, (_, index) =>
  String(index + 1).padStart(2, '0'),
);
const COMPLEX_CASES = Object.fromEntries(
  COMPLEX_CASE_IDS.map((caseId) => {
    const fullCanvasCases = new Set(['02', '07', '08']);
    const hoverCases = new Set(['09', '10']);
    return [
      `complex-${caseId}`,
      {
        htmlFile: 'example/real_tailwind/complex-parity.html',
        selector: fullCanvasCases.has(caseId)
          ? '#capture'
          : `[data-case="${caseId}"]`,
        margin: fullCanvasCases.has(caseId) ? 0 : 16,
        outputSubdir: `complex-parity/case-${caseId}`,
        tailwindQuery: `case=${caseId}`,
        flutterExample: 'complex-parity',
        flutterQuery: `case=${caseId}`,
        colorScheme: caseId === '09' ? 'dark' : 'light',
        hoverSelector: hoverCases.has(caseId)
          ? '[data-case]:not([hidden]) [data-subject]'
          : null,
        hoverWaitMs: caseId === '10' ? 500 : 100,
        tailwindWaitMs: 500,
        caseId,
        captureState: caseId === '09'
          ? 'dark-hovered'
          : caseId === '10'
            ? 'hovered-after-transition'
            : 'static',
        acceptance: {
          metric: COMPLEX_ACCEPTANCE[caseId].metric,
          maximumByWidth: maximumAtEveryWidth(
            COMPLEX_ACCEPTANCE[caseId].maximum,
          ),
        },
      },
    ];
  }),
);

const ADVANCED_EXAMPLES = Object.fromEntries(
  [
    ['01', 'launch-command', 'Launch command'],
    ['02', 'signal-analytics', 'Signal analytics'],
    ['03', 'incident-room', 'Incident room'],
    ['04', 'release-timeline', 'Release timeline'],
    ['05', 'capacity-map', 'Capacity map'],
  ].map(([exampleId, slug, title]) => [
    `advanced-${slug}`,
    {
      htmlFile: 'example/real_tailwind/advanced-examples.html',
      selector: `[data-example="${exampleId}"]`,
      margin: 16,
      outputSubdir: `advanced-parity/${slug}`,
      tailwindQuery: `example=${exampleId}`,
      tailwindWaitMs: 500,
      flutterExample: 'advanced-parity',
      flutterQuery: `sample=${exampleId}`,
      suite: 'advanced',
      title,
      acceptance: {
        metric: 'diffPercent',
        maximumByWidth: maximumAtEveryWidth(5),
      },
    },
  ]),
);

// Example configurations
const EXAMPLES = {
  dashboard: {
    htmlFile: 'example/real_tailwind/index.html',
    selector: 'main',
    margin: 16,
    acceptance: {
      metric: 'diffPercent',
      maximumByWidth: { 480: 1.45, 768: 1.4, 1024: 1.15 },
    },
  },
  'card-alert': {
    htmlFile: 'example/real_tailwind/card-alert.html',
    selector: 'body > div > div',
    margin: 16,
    acceptance: {
      metric: 'diffPercent',
      maximumByWidth: { 480: 5.11, 768: 4.19, 1024: 3.62 },
    },
  },
  'flowbite-card': {
    htmlFile: 'example/real_tailwind/flowbite-card.html',
    selector: 'body > div',
    margin: 16,
    acceptance: {
      metric: 'diffPercent',
      maximumByWidth: { 480: 1.68, 768: 1.68, 1024: 1.68 },
    },
  },
  'gradient-debug': {
    htmlFile: 'example/real_tailwind/gradient-debug.html',
    selector: 'main',
    margin: 16,
    acceptance: {
      metric: 'diffPercent',
      maximumByWidth: maximumAtEveryWidth(5),
    },
  },
  ...ADVANCED_EXAMPLES,
  ...COMPLEX_CASES,
};

async function main() {
  // Parse args
  const flutterUrl =
    process.argv.find((a) => a.startsWith('--flutter-url='))?.split('=')[1] ||
    `http://localhost:${FLUTTER_PORT}`;

  const gradientStrategy =
    process.argv.find((a) => a.startsWith('--gradient-strategy='))?.split('=')[1] ||
    DEFAULT_GRADIENT_STRATEGY;

  const exampleArg =
    process.argv.find((a) => a.startsWith('--example='))?.split('=')[1] ||
    'dashboard';

  const exampleConfig = EXAMPLES[exampleArg];
  if (!exampleConfig) {
    console.error(`Unknown example: ${exampleArg}`);
    console.error(`Available examples: ${Object.keys(EXAMPLES).join(', ')}`);
    process.exitCode = 1;
    return;
  }

  const tailwindPath = path.resolve(packageRoot, exampleConfig.htmlFile);
  const elementSelector = exampleConfig.selector;
  const captureMargin = exampleConfig.margin ?? 0;
  const clipByWidth = new Map();
  const hoverPointByWidth = new Map();

  // Create example-specific directories.
  // Keep non-default gradient strategy outputs separate for A/B comparisons.
  const configuredSubdir = exampleConfig.outputSubdir ?? exampleArg;
  const screenshotSubdir =
    gradientStrategy === DEFAULT_GRADIENT_STRATEGY
      ? configuredSubdir
      : `${configuredSubdir}-${gradientStrategy}`;
  const screenshotDir = path.join(baseScreenshotDir, screenshotSubdir);
  const diffDir = path.join(screenshotDir, 'diff');
  await fs.promises.mkdir(diffDir, { recursive: true });
  await clearPreviousCaptureArtifacts(screenshotDir, diffDir);

  console.log('Automated Visual Comparison: Flutter vs Tailwind CSS\n');
  console.log(`Example: ${exampleArg}`);
  console.log(`Gradient strategy: ${gradientStrategy}`);
  console.log(`Flutter URL: ${flutterUrl}`);
  console.log(`Tailwind HTML: ${tailwindPath}`);
  console.log(`Selector: ${elementSelector}`);
  console.log(`Output: ${screenshotDir}\n`);

  // Launch browser
  const browser = await chromium.launch();
  const context = await browser.newContext({
    colorScheme: exampleConfig.colorScheme ?? 'light',
  });
  const page = await context.newPage();

  console.log('Capturing screenshots...\n');

  // Capture Tailwind screenshots
  for (const width of WIDTHS) {
    const viewport = { width, height: 1200 };
    await page.setViewportSize(viewport);
    await page.mouse.move(viewport.width - 1, viewport.height - 1);
    const tailwindQuery = exampleConfig.tailwindQuery
      ? `?${exampleConfig.tailwindQuery}`
      : '';
    await page.goto(`file://${tailwindPath}${tailwindQuery}`);
    await page.waitForLoadState('networkidle');
    await waitForFonts(page);
    if (exampleConfig.tailwindWaitMs) {
      await page.waitForTimeout(exampleConfig.tailwindWaitMs);
    }
    if (exampleConfig.hoverSelector) {
      const hoverTarget = await page.$(exampleConfig.hoverSelector);
      const hoverBox = await hoverTarget?.boundingBox();
      if (!hoverBox) {
        console.error(
          `  ERROR: Could not read hover target ${exampleConfig.hoverSelector} for ${width}px`,
        );
        continue;
      }
      const hoverPoint = {
        x: hoverBox.x + hoverBox.width / 2,
        y: hoverBox.y + hoverBox.height / 2,
      };
      hoverPointByWidth.set(width, hoverPoint);
      await page.mouse.move(hoverPoint.x, hoverPoint.y);
      await page.waitForTimeout(exampleConfig.hoverWaitMs ?? 100);
    }
    const element = await page.$(elementSelector);
    if (!element) {
      console.error(`  ERROR: Could not find <${elementSelector}> element for ${width}px`);
      continue;
    }
    const box = await element.boundingBox();
    if (!box) {
      console.error(`  ERROR: Could not read bounds for <${elementSelector}> at ${width}px`);
      continue;
    }
    const clip = expandClipBox(box, viewport, captureMargin);
    clipByWidth.set(width, clip);
    await page.screenshot({
      path: path.join(screenshotDir, `tailwind-${width}.png`),
      clip,
    });
    console.log(`  tailwind-${width}.png`);
  }

  // Capture Flutter screenshots
  for (const width of WIDTHS) {
    const viewport = { width, height: 1200 };
    await page.setViewportSize(viewport);
    try {
      await page.mouse.move(viewport.width - 1, viewport.height - 1);
      const flutterParams = new URLSearchParams({
        screenshot: 'true',
        width: String(width),
        example: exampleConfig.flutterExample ?? exampleArg,
        gradient: gradientStrategy,
      });
      if (exampleConfig.flutterQuery) {
        for (const [key, value] of new URLSearchParams(
          exampleConfig.flutterQuery,
        )) {
          flutterParams.set(key, value);
        }
      }
      await page.goto(
        `${flutterUrl}/?${flutterParams}`,
        { timeout: 30000 },
      );
      // Wait for Flutter to fully render (flt-glass-pane indicates Flutter is ready)
      // Use state: 'attached' since the element may be transparent/hidden
      await page.waitForSelector('flt-glass-pane', { timeout: 10000, state: 'attached' });
      await page.waitForLoadState('networkidle');
      await waitForFonts(page);
      // Additional delay for Flutter to finish painting
      await page.waitForTimeout(1000);
      const hoverPoint = hoverPointByWidth.get(width);
      if (hoverPoint) {
        await page.mouse.move(hoverPoint.x, hoverPoint.y);
        await page.waitForTimeout(exampleConfig.hoverWaitMs ?? 100);
      }
      const clip = clipByWidth.get(width) ?? fullViewportClip(viewport);
      await page.screenshot({
        path: path.join(screenshotDir, `flutter-${width}.png`),
        clip,
      });
      console.log(`  flutter-${width}.png`);
    } catch (error) {
      console.error(
        `  ERROR: Could not capture Flutter at ${width}px - is the server running?`,
      );
      console.error(`  ${error.message}`);
    }
  }

  await browser.close();

  // Generate diffs
  console.log('\nGenerating diff images...\n');
  const results = [];

  for (const width of WIDTHS) {
    const tailwindFile = path.join(screenshotDir, `tailwind-${width}.png`);
    const flutterFile = path.join(screenshotDir, `flutter-${width}.png`);

    if (!fs.existsSync(tailwindFile)) {
      console.error(`  Missing: tailwind-${width}.png`);
      continue;
    }
    if (!fs.existsSync(flutterFile)) {
      console.error(`  Missing: flutter-${width}.png`);
      continue;
    }

    const tailwindPng = PNG.sync.read(fs.readFileSync(tailwindFile));
    const flutterPng = PNG.sync.read(fs.readFileSync(flutterFile));

    const targetWidth = Math.min(tailwindPng.width, flutterPng.width);
    const targetHeight = Math.min(tailwindPng.height, flutterPng.height);

    if (tailwindPng.width !== flutterPng.width) {
      console.warn(
        `  Width mismatch at ${width}px: Tailwind=${tailwindPng.width}, Flutter=${flutterPng.width}. Using ${targetWidth}px.`,
      );
    }

    const tailwindCropped = cropToSize(tailwindPng, targetWidth, targetHeight);
    const flutterCropped = cropToSize(flutterPng, targetWidth, targetHeight);

    const diff = new PNG({ width: targetWidth, height: targetHeight });
    const mismatched = pixelmatch(
      tailwindCropped.data,
      flutterCropped.data,
      diff.data,
      targetWidth,
      targetHeight,
      { threshold: 0.1 },
    );

    const strictDiff = new PNG({ width: targetWidth, height: targetHeight });
    const strictMismatched = pixelmatch(
      tailwindCropped.data,
      flutterCropped.data,
      strictDiff.data,
      targetWidth,
      targetHeight,
      { threshold: 0.01 },
    );
    const exactDifference = measureExactRgbaDifference(
      tailwindCropped,
      flutterCropped,
    );

    const diffPath = path.join(diffDir, `diff-${width}.png`);
    fs.writeFileSync(diffPath, PNG.sync.write(diff));

    const strictDiffPath = path.join(diffDir, `strictdiff-${width}.png`);
    fs.writeFileSync(strictDiffPath, PNG.sync.write(strictDiff));

    const absoluteDiff = createAmplifiedAbsoluteDiff(
      tailwindCropped,
      flutterCropped,
      targetWidth,
      targetHeight,
    );
    const absoluteDiffPath = path.join(diffDir, `absdiff-${width}.png`);
    fs.writeFileSync(absoluteDiffPath, PNG.sync.write(absoluteDiff));

    const blinkPath = path.join(diffDir, `blink-${width}.gif`);
    writeBlinkGif(
      [tailwindCropped, flutterCropped],
      targetWidth,
      targetHeight,
      blinkPath,
    );

    const totalPixels = targetWidth * targetHeight;
    const delta = (mismatched / totalPixels) * 100;
    const strictDelta = (strictMismatched / totalPixels) * 100;
    const exactDelta = (exactDifference.mismatchedPixels / totalPixels) * 100;
    results.push({
      width,
      dimensions: {
        tailwind: { width: tailwindPng.width, height: tailwindPng.height },
        flutter: { width: flutterPng.width, height: flutterPng.height },
        compared: { width: targetWidth, height: targetHeight },
      },
      mismatched,
      strictMismatched,
      exactMismatched: exactDifference.mismatchedPixels,
      meanAbsoluteRgbaDelta: exactDifference.meanAbsoluteChannelDelta,
      maximumRgbaChannelDelta: exactDifference.maximumChannelDelta,
      totalPixels,
      delta,
      strictDelta,
      exactDelta,
      files: {
        tailwind: path.relative(screenshotDir, tailwindFile),
        flutter: path.relative(screenshotDir, flutterFile),
        pixelmatchDiff: path.relative(screenshotDir, diffPath),
        strictPixelmatchDiff: path.relative(screenshotDir, strictDiffPath),
        absoluteDiff: path.relative(screenshotDir, absoluteDiffPath),
        blink: path.relative(screenshotDir, blinkPath),
      },
    });
    console.log(
      `  diff-${width}.png (${delta.toFixed(2)}% tolerant, ` +
        `${strictDelta.toFixed(2)}% strict, ${exactDelta.toFixed(2)}% exact)`,
    );
  }

  const summaryPath = path.join(screenshotDir, 'summary.json');
  const summary = {
    generatedAt: new Date().toISOString(),
    example: exampleArg,
    caseId: exampleConfig.caseId ?? null,
    suite: exampleConfig.suite ?? null,
    title: exampleConfig.title ?? null,
    captureState: exampleConfig.captureState ?? 'static',
    tailwindVersion: exampleConfig.caseId ? '4.3.1' : null,
    gradientStrategy,
    flutterUrl,
    tailwindHtml: tailwindPath,
    selector: elementSelector,
    captureComplete: results.length === WIDTHS.length,
    results: results.map((r) => ({
      width: r.width,
      dimensions: r.dimensions,
      mismatchedPixels: r.mismatched,
      strictMismatchedPixels: r.strictMismatched,
      exactMismatchedPixels: r.exactMismatched,
      totalPixels: r.totalPixels,
      diffPercent: Number(r.delta.toFixed(4)),
      strictDiffPercent: Number(r.strictDelta.toFixed(4)),
      exactDiffPercent: Number(r.exactDelta.toFixed(4)),
      meanAbsoluteRgbaDelta: Number(r.meanAbsoluteRgbaDelta.toFixed(6)),
      maximumRgbaChannelDelta: r.maximumRgbaChannelDelta,
      files: r.files,
    })),
  };
  summary.acceptance = evaluateAcceptance(summary, exampleConfig.acceptance);
  fs.writeFileSync(summaryPath, `${JSON.stringify(summary, null, 2)}\n`);

  if (results.length !== WIDTHS.length) {
    console.error(
      `\nIncomplete capture: expected ${WIDTHS.length} widths, produced ${results.length}.`,
    );
    process.exitCode = 1;
  }

  // Output report
  console.log('\n=== Visual Comparison Results ===\n');
  console.table(
    results.map((r) => ({
      width: `${r.width}px`,
      'tolerant %': `${r.delta.toFixed(2)}%`,
      'strict %': `${r.strictDelta.toFixed(2)}%`,
      'exact %': `${r.exactDelta.toFixed(2)}%`,
      'mean RGBA Δ': r.meanAbsoluteRgbaDelta.toFixed(3),
    })),
  );

  console.log(
    `\nAcceptance: ${summary.acceptance.metricLabel} at configured per-width maxima — ` +
      `${summary.acceptance.passed ? 'PASS' : 'FAIL'}`,
  );
  console.table(
    summary.acceptance.checks.map((check) => ({
      width: `${check.width}px`,
      metric: summary.acceptance.metricLabel,
      actual: check.value == null ? 'missing' : `${check.value.toFixed(4)}%`,
      maximum: `${check.maximum.toFixed(4)}%`,
      result: check.passed ? 'pass' : 'FAIL',
    })),
  );
  if (!summary.acceptance.passed) process.exitCode = 1;

  console.log(`\nScreenshots saved to: ${screenshotDir}`);
  console.log(`Diff images saved to: ${diffDir}\n`);
  console.log(`JSON summary saved to: ${summaryPath}\n`);
}

async function clearPreviousCaptureArtifacts(screenshotDir, diffDir) {
  const files = [path.join(screenshotDir, 'summary.json')];
  for (const width of WIDTHS) {
    files.push(
      path.join(screenshotDir, `tailwind-${width}.png`),
      path.join(screenshotDir, `flutter-${width}.png`),
      path.join(diffDir, `diff-${width}.png`),
      path.join(diffDir, `strictdiff-${width}.png`),
      path.join(diffDir, `absdiff-${width}.png`),
      path.join(diffDir, `blink-${width}.gif`),
    );
  }
  await Promise.all(files.map((file) => fs.promises.rm(file, { force: true })));
}

function cropToSize(png, targetWidth, targetHeight) {
  const cropped = new PNG({ width: targetWidth, height: targetHeight });
  for (let y = 0; y < targetHeight; y++) {
    for (let x = 0; x < targetWidth; x++) {
      const srcIdx = (png.width * y + x) << 2;
      const dstIdx = (targetWidth * y + x) << 2;
      cropped.data[dstIdx] = png.data[srcIdx];
      cropped.data[dstIdx + 1] = png.data[srcIdx + 1];
      cropped.data[dstIdx + 2] = png.data[srcIdx + 2];
      cropped.data[dstIdx + 3] = png.data[srcIdx + 3];
    }
  }
  return cropped;
}

function measureExactRgbaDifference(tailwindPng, flutterPng) {
  let mismatchedPixels = 0;
  let absoluteChannelDelta = 0;
  let maximumChannelDelta = 0;

  for (let index = 0; index < tailwindPng.data.length; index += 4) {
    let pixelDiffers = false;
    for (let channel = 0; channel < 4; channel++) {
      const delta = Math.abs(
        tailwindPng.data[index + channel] - flutterPng.data[index + channel],
      );
      absoluteChannelDelta += delta;
      maximumChannelDelta = Math.max(maximumChannelDelta, delta);
      pixelDiffers ||= delta !== 0;
    }
    if (pixelDiffers) mismatchedPixels++;
  }

  return {
    mismatchedPixels,
    meanAbsoluteChannelDelta:
      absoluteChannelDelta / tailwindPng.data.length,
    maximumChannelDelta,
  };
}

async function waitForFonts(page) {
  await page.evaluate(async () => {
    if (document.fonts) {
      await document.fonts.ready;
    }
  });
}

function fullViewportClip(viewport) {
  return { x: 0, y: 0, width: viewport.width, height: viewport.height };
}

function createAmplifiedAbsoluteDiff(tailwindPng, flutterPng, width, height) {
  const amplified = new PNG({ width, height });
  const gain = 4;

  for (let i = 0; i < width * height; i++) {
    const idx = i << 2;
    amplified.data[idx] = clampByte(
      Math.abs(tailwindPng.data[idx] - flutterPng.data[idx]) * gain,
    );
    amplified.data[idx + 1] = clampByte(
      Math.abs(tailwindPng.data[idx + 1] - flutterPng.data[idx + 1]) * gain,
    );
    amplified.data[idx + 2] = clampByte(
      Math.abs(tailwindPng.data[idx + 2] - flutterPng.data[idx + 2]) * gain,
    );
    amplified.data[idx + 3] = 255;
  }

  return amplified;
}

function writeBlinkGif(frames, width, height, outputPath) {
  const encoder = new GIFEncoder(width, height, 'neuquant', false, frames.length);
  encoder.start();
  encoder.setRepeat(0);
  encoder.setDelay(650);
  encoder.setQuality(10);

  for (const frame of frames) {
    encoder.addFrame(frame.data);
  }

  encoder.finish();
  fs.writeFileSync(outputPath, encoder.out.getData());
}

function clampByte(value) {
  return Math.max(0, Math.min(255, Math.round(value)));
}

function expandClipBox(box, viewport, margin) {
  const x = Math.max(0, Math.floor(box.x - margin));
  const y = Math.max(0, Math.floor(box.y - margin));
  const right = Math.min(viewport.width, Math.ceil(box.x + box.width + margin));
  const bottom = Math.min(viewport.height, Math.ceil(box.y + box.height + margin));
  return {
    x,
    y,
    width: Math.max(1, right - x),
    height: Math.max(1, bottom - y),
  };
}

try {
  await main();
} catch (error) {
  console.error('Error:', error.message);
  process.exitCode = 1;
} finally {
  try {
    const report = writeVisualReport(baseScreenshotDir);
    console.log(`Visual report: ${report.outputPath}`);
  } catch (error) {
    console.error('Could not generate visual report:', error.message);
    process.exitCode = 1;
  }
}

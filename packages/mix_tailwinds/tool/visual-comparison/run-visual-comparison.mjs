#!/usr/bin/env node
/**
 * Automated visual comparison: Flutter vs Tailwind CSS
 *
 * Usage:
 *   cd packages/mix_tailwinds/tool/visual-comparison
 *   npm install  # first time only
 *   npm run compare
 *   npm run compare -- --example=card-alert
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
import pixelmatch from 'pixelmatch';
import { PNG } from 'pngjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const packageRoot = path.resolve(__dirname, '../..'); // packages/mix_tailwinds
const baseScreenshotDir = path.join(packageRoot, 'visual-comparison');

const WIDTHS = [480, 768, 1024];
const FLUTTER_PORT = 8089;

// Example configurations
const EXAMPLES = {
  dashboard: {
    htmlFile: 'example/real_tailwind/index.html',
    selector: 'main', // Element to screenshot in Tailwind HTML
  },
  'card-alert': {
    htmlFile: 'example/real_tailwind/card-alert.html',
    selector: 'body', // Full body with gradient background
  },
};

async function main() {
  // Parse args
  const flutterUrl =
    process.argv.find((a) => a.startsWith('--flutter-url='))?.split('=')[1] ||
    `http://localhost:${FLUTTER_PORT}`;

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

  // Create example-specific directories
  const screenshotDir = path.join(baseScreenshotDir, exampleArg);
  const diffDir = path.join(screenshotDir, 'diff');
  await fs.promises.mkdir(diffDir, { recursive: true });

  console.log('Automated Visual Comparison: Flutter vs Tailwind CSS\n');
  console.log(`Example: ${exampleArg}`);
  console.log(`Flutter URL: ${flutterUrl}`);
  console.log(`Tailwind HTML: ${tailwindPath}`);
  console.log(`Selector: ${elementSelector}`);
  console.log(`Output: ${screenshotDir}\n`);

  // Launch browser
  const browser = await chromium.launch();
  const context = await browser.newContext();
  const page = await context.newPage();

  console.log('Capturing screenshots...\n');

  // Capture Tailwind screenshots
  for (const width of WIDTHS) {
    await page.setViewportSize({ width, height: 1200 });
    await page.goto(`file://${tailwindPath}`);
    await page.waitForLoadState('networkidle');
    // For body selector, use page screenshot to match Flutter's approach
    if (elementSelector === 'body') {
      await page.screenshot({
        path: path.join(screenshotDir, `tailwind-${width}.png`),
        fullPage: false,
      });
      console.log(`  tailwind-${width}.png`);
    } else {
      const element = await page.$(elementSelector);
      if (element) {
        await element.screenshot({
          path: path.join(screenshotDir, `tailwind-${width}.png`),
        });
        console.log(`  tailwind-${width}.png`);
      } else {
        console.error(`  ERROR: Could not find <${elementSelector}> element for ${width}px`);
      }
    }
  }

  // Capture Flutter screenshots
  for (const width of WIDTHS) {
    await page.setViewportSize({ width, height: 1200 });
    try {
      await page.goto(`${flutterUrl}/?screenshot=true&width=${width}&example=${exampleArg}`, {
        timeout: 30000,
      });
      // Wait for Flutter to fully render (flt-glass-pane indicates Flutter is ready)
      // Use state: 'attached' since the element may be transparent/hidden
      await page.waitForSelector('flt-glass-pane', { timeout: 10000, state: 'attached' });
      await page.waitForLoadState('networkidle');
      // Additional delay for Flutter to finish painting
      await page.waitForTimeout(1000);
      await page.screenshot({
        path: path.join(screenshotDir, `flutter-${width}.png`),
        fullPage: false,
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

    const diffPath = path.join(diffDir, `diff-${width}.png`);
    fs.writeFileSync(diffPath, PNG.sync.write(diff));

    const totalPixels = targetWidth * targetHeight;
    const delta = (mismatched / totalPixels) * 100;
    results.push({ width, mismatched, totalPixels, delta, diffPath });
    console.log(`  diff-${width}.png (${delta.toFixed(2)}% diff)`);
  }

  // Output report
  console.log('\n=== Visual Comparison Results ===\n');
  console.table(
    results.map((r) => ({
      width: `${r.width}px`,
      'diff pixels': r.mismatched.toLocaleString(),
      'diff %': `${r.delta.toFixed(2)}%`,
    })),
  );

  // Summary
  const avgDiff =
    results.reduce((sum, r) => sum + r.delta, 0) / results.length || 0;

  if (results.some((r) => r.delta > 15)) {
    console.log(
      '\nHigh diff detected! Check for structural issues in the diff images.',
    );
    process.exitCode = 1;
  } else if (results.some((r) => r.delta > 5)) {
    console.log(
      '\nModerate diff detected (likely font rendering differences).',
    );
  } else if (avgDiff < 3) {
    console.log('\nExcellent parity! Remaining diff is likely platform-specific font rendering.');
  } else {
    console.log('\nGood parity.');
  }

  console.log(`\nScreenshots saved to: ${screenshotDir}`);
  console.log(`Diff images saved to: ${diffDir}\n`);
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

main().catch((error) => {
  console.error('Error:', error.message);
  process.exitCode = 1;
});

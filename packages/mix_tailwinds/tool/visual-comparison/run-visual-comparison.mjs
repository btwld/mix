#!/usr/bin/env node
/**
 * Automated visual comparison: Flutter vs Tailwind CSS
 *
 * Usage:
 *   cd packages/mix_tailwinds/tool/visual-comparison
 *   npm install
 *   npm run doctor
 *   npm run compare -- --example=dashboard
 *   npm run compare -- --example=card-alert
 *
 * This workflow is CLI-only. The local script shells out to the global
 * `playwright` CLI for screenshot capture.
 *
 * Machine setup:
 *   npm install -g playwright@1.56.0
 *   playwright install chromium
 */
import { spawn } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath, pathToFileURL } from 'node:url';
import pixelmatch from 'pixelmatch';
import { PNG } from 'pngjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const toolRoot = __dirname;
const packageRoot = path.resolve(toolRoot, '../..');
const exampleRoot = path.join(packageRoot, 'example');
const baseScreenshotDir = path.join(packageRoot, 'visual-comparison');
const requiredPlaywrightVersionPath = path.join(
  toolRoot,
  'required-playwright-version.txt',
);

const WIDTHS = [480, 768, 1024];
const FLUTTER_PORT = 8089;
const DEFAULT_FLUTTER_URL = `http://127.0.0.1:${FLUTTER_PORT}`;
const CAPTURE_VIEWPORT_HEIGHT = 1400;
const FLUTTER_START_TIMEOUT_MS = 120000;
const LOCAL_SERVER_SHUTDOWN_TIMEOUT_MS = 10000;
const SIDE_BY_SIDE_GUTTER = 24;
const DEFAULT_GRADIENT_STRATEGY = 'css-angle-rect';

const EXAMPLES = {
  dashboard: {
    flutterWaitMs: 15000,
    highDiffThreshold: 12,
    htmlFile: 'example/real_tailwind/dashboard.html',
    moderateDiffThreshold: 6,
    readySelector: 'html[data-tailwind-ready="true"]',
    tailwindWaitMs: 900,
  },
  'card-alert': {
    flutterWaitMs: 15000,
    highDiffThreshold: 16,
    htmlFile: 'example/real_tailwind/card-alert.html',
    moderateDiffThreshold: 7,
    readySelector: 'html[data-tailwind-ready="true"]',
    tailwindWaitMs: 900,
    viewportHeight: 320,
  },
  'gradient-debug': {
    flutterWaitMs: 15000,
    highDiffThreshold: 12,
    htmlFile: 'example/real_tailwind/gradient-debug.html',
    moderateDiffThreshold: 5,
    readySelector: 'html[data-tailwind-ready="true"]',
    tailwindWaitMs: 900,
  },
};

let activeFlutterServer = null;

async function main() {
  const options = parseArgs(process.argv.slice(2));
  if (options.help) {
    printHelp();
    return;
  }

  const requiredPlaywrightVersion = readRequiredPlaywrightVersion();
  const exampleConfig = EXAMPLES[options.example];
  if (!exampleConfig) {
    console.error(`Unknown example: ${options.example}`);
    console.error(`Available examples: ${Object.keys(EXAMPLES).join(', ')}`);
    process.exitCode = 1;
    return;
  }

  installSignalHandlers();

  console.log('Visual Comparison Preflight\n');

  const playwrightInfo = await validatePlaywright(requiredPlaywrightVersion);
  const needsLocalFlutter = options.doctor || !options.flutterUrl;
  const flutterInfo = needsLocalFlutter ? await validateFlutterCommand() : null;
  if (needsLocalFlutter) {
    validateExampleWebTarget();
  } else {
    console.log(`  OK  Reusing provided Flutter URL ${options.flutterUrl}`);
  }
  const flutterServer = await ensureFlutterSurface({
    flutterInfo,
    flutterUrl: options.flutterUrl,
  });
  activeFlutterServer = flutterServer.managed ? flutterServer : null;

  if (options.doctor) {
    console.log('\nDoctor checks passed.\n');
    await cleanupActiveFlutterServer();
    return;
  }

  const screenshotSubdir =
    options.gradientStrategy === DEFAULT_GRADIENT_STRATEGY
      ? options.example
      : `${options.example}-${options.gradientStrategy}`;
  const screenshotDir = path.join(baseScreenshotDir, screenshotSubdir);
  const diffDir = path.join(screenshotDir, 'diff');
  await fs.promises.mkdir(diffDir, { recursive: true });

  try {
    console.log('\nAutomated Visual Comparison: Flutter vs Tailwind CSS\n');
    console.log(`Global Playwright CLI: ${playwrightInfo.commandPath}`);
    console.log(`Global Playwright version: ${playwrightInfo.version}`);
    console.log(`Chromium cache: ${playwrightInfo.chromiumInstallPath}`);
    if (flutterInfo) {
      console.log(`Flutter command: ${flutterInfo.displayCommand}`);
    } else {
      console.log('Flutter command: external server via --flutter-url');
    }
    console.log(`Example: ${options.example}`);
    console.log(`Gradient strategy: ${options.gradientStrategy}`);
    console.log(`Flutter URL: ${flutterServer.url}`);
    console.log(
      `Tailwind HTML: ${path.resolve(packageRoot, exampleConfig.htmlFile)}`,
    );
    console.log(`Output: ${screenshotDir}\n`);

    console.log('Capturing screenshots...\n');
    await captureTailwindScreenshots({
      exampleConfig,
      screenshotDir,
    });
    await captureFlutterScreenshots({
      example: options.example,
      exampleConfig,
      flutterUrl: flutterServer.url,
      gradientStrategy: options.gradientStrategy,
      screenshotDir,
    });

    const results = generateComparisonArtifacts({ diffDir, screenshotDir });

    printSummary(results, exampleConfig);
    console.log(`\nScreenshots saved to: ${screenshotDir}`);
    console.log(`Diff images saved to: ${diffDir}\n`);
  } finally {
    await cleanupActiveFlutterServer();
  }
}

function parseArgs(argv) {
  const options = {
    doctor: false,
    example: 'dashboard',
    flutterUrl: null,
    gradientStrategy: DEFAULT_GRADIENT_STRATEGY,
    help: false,
  };

  for (const arg of argv) {
    if (arg === '--doctor') {
      options.doctor = true;
      continue;
    }

    if (arg === '--help' || arg === '-h') {
      options.help = true;
      continue;
    }

    if (arg.startsWith('--example=')) {
      options.example = arg.split('=')[1] || options.example;
      continue;
    }

    if (arg.startsWith('--flutter-url=')) {
      options.flutterUrl = arg.split('=')[1] || null;
      continue;
    }

    if (arg.startsWith('--gradient-strategy=')) {
      options.gradientStrategy =
        arg.split('=')[1] || DEFAULT_GRADIENT_STRATEGY;
      continue;
    }
  }

  return options;
}

function printHelp() {
  console.log(`Usage:
  npm run doctor
  npm run compare -- --example=dashboard
  npm run compare -- --example=card-alert
  npm run compare -- --example=gradient-debug

Options:
  --doctor                         Run preflight validation only.
  --example=<name>                 Example to compare.
  --flutter-url=<url>              Reuse an existing Flutter web server instead of auto-managing localhost:${FLUTTER_PORT}.
  --gradient-strategy=<strategy>   TwConfig gradient strategy (default: ${DEFAULT_GRADIENT_STRATEGY}).
  --help                           Show this help message.

Machine setup:
  npm install -g playwright@${readRequiredPlaywrightVersion()}
  playwright install chromium`);
}

function readRequiredPlaywrightVersion() {
  return fs.readFileSync(requiredPlaywrightVersionPath, 'utf8').trim();
}

async function validatePlaywright(requiredVersion) {
  const commandPath = await resolveCommandPath('playwright');
  if (!commandPath) {
    throw new Error(
      `Global Playwright CLI is not installed.\nRun:\n  npm install -g playwright@${requiredVersion}\n  playwright install chromium`,
    );
  }

  const versionResult = await runCommand('playwright', ['--version']);
  const versionMatch = versionResult.stdout.match(/Version\s+([^\s]+)/);
  const version = versionMatch?.[1];
  if (!version) {
    throw new Error('Unable to determine the global Playwright CLI version.');
  }

  if (version !== requiredVersion) {
    throw new Error(
      `Expected global Playwright CLI ${requiredVersion}, found ${version}.\nRun:\n  npm install -g playwright@${requiredVersion}\n  playwright install chromium`,
    );
  }

  const dryRun = await runCommand('playwright', [
    'install',
    'chromium',
    '--dry-run',
  ]);
  const chromiumInstallPath = extractChromiumInstallPath(dryRun.stdout);
  if (!chromiumInstallPath) {
    throw new Error(
      'Unable to determine the Chromium install location for the global Playwright CLI.',
    );
  }

  if (!fs.existsSync(chromiumInstallPath)) {
    throw new Error(
      `Chromium is not installed for Playwright ${requiredVersion}.\nRun:\n  playwright install chromium`,
    );
  }

  console.log(`  OK  Playwright CLI ${version}`);
  console.log(`      ${commandPath}`);
  console.log(`  OK  Chromium cache ${chromiumInstallPath}`);

  return { chromiumInstallPath, commandPath, version };
}

function extractChromiumInstallPath(output) {
  const lines = output.split(/\r?\n/);
  let inChromiumSection = false;

  for (const line of lines) {
    const trimmed = line.trim();
    if (trimmed.startsWith('browser: chromium ')) {
      inChromiumSection = true;
      continue;
    }

    if (inChromiumSection && trimmed.startsWith('browser: ')) {
      break;
    }

    if (inChromiumSection && trimmed.startsWith('Install location:')) {
      return trimmed.replace('Install location:', '').trim();
    }
  }

  return null;
}

async function validateFlutterCommand() {
  const fvmPath = await resolveCommandPath('fvm');
  if (fvmPath) {
    const info = {
      argsPrefix: ['flutter'],
      command: 'fvm',
      displayCommand: 'fvm flutter',
    };
    try {
      await runFlutterCommand(info, ['--version']);
      console.log('  OK  Flutter via fvm flutter');
      return info;
    } catch (error) {
      console.warn(
        `  WARN fvm flutter is not usable here, falling back to flutter.\n      ${error.message.split('\n')[0]}`,
      );
    }
  }

  const flutterPath = await resolveCommandPath('flutter');
  if (!flutterPath) {
    throw new Error('Flutter is not installed or is not on PATH.');
  }

  const info = {
    argsPrefix: [],
    command: 'flutter',
    displayCommand: 'flutter',
  };
  await runFlutterCommand(info, ['--version']);
  console.log('  OK  Flutter via flutter');
  return info;
}

function validateExampleWebTarget() {
  const webIndex = path.join(exampleRoot, 'web', 'index.html');
  if (!fs.existsSync(webIndex)) {
    throw new Error(
      `Missing checked-in web target: ${webIndex}\nCommit packages/mix_tailwinds/example/web/ before running visual comparison.`,
    );
  }

  console.log(`  OK  Example web target ${webIndex}`);
}

async function ensureFlutterSurface({ flutterInfo, flutterUrl }) {
  if (flutterUrl) {
    const reachable = await waitForUrl(flutterUrl, 5000);
    if (!reachable) {
      throw new Error(
        `Flutter URL is not reachable: ${flutterUrl}\nStart the example app yourself or omit --flutter-url to let the tool manage localhost:${FLUTTER_PORT}.`,
      );
    }

    console.log(`  OK  Reusing Flutter server at ${flutterUrl}`);
    return { managed: false, url: flutterUrl };
  }

  const reachable = await waitForUrl(DEFAULT_FLUTTER_URL, 1500);
  if (reachable) {
    console.log(`  OK  Reusing Flutter server at ${DEFAULT_FLUTTER_URL}`);
    return { managed: false, url: DEFAULT_FLUTTER_URL };
  }

  console.log(`  ... Starting Flutter web server on ${DEFAULT_FLUTTER_URL}`);
  const managedServer = await startFlutterServer(flutterInfo);
  console.log(`  OK  Flutter server ready at ${managedServer.url}`);
  return managedServer;
}

async function startFlutterServer(flutterInfo) {
  const args = [
    ...flutterInfo.argsPrefix,
    'run',
    '-d',
    'web-server',
    '--web-port',
    String(FLUTTER_PORT),
    '--profile',
  ];

  const child = spawn(flutterInfo.command, args, {
    cwd: exampleRoot,
    env: process.env,
    stdio: ['ignore', 'pipe', 'pipe'],
  });

  const recentOutput = [];
  const rememberOutput = (chunk) => {
    const text = chunk.toString();
    if (recentOutput.length > 80) {
      recentOutput.shift();
    }
    recentOutput.push(text);
  };

  child.stdout.on('data', rememberOutput);
  child.stderr.on('data', rememberOutput);

  const exitPromise = new Promise((resolve) => {
    child.once('exit', (code, signal) => {
      resolve({ code, signal });
    });
  });

  const ready = await Promise.race([
    waitForUrl(DEFAULT_FLUTTER_URL, FLUTTER_START_TIMEOUT_MS),
    exitPromise.then(({ code, signal }) => {
      const recent = recentOutput.join('');
      throw new Error(
        `Flutter web server exited before it became ready (code=${code}, signal=${signal ?? 'none'}).\n${recent}`.trim(),
      );
    }),
  ]);

  if (!ready) {
    child.kill('SIGINT');
    const recent = recentOutput.join('');
    throw new Error(
      `Flutter web server did not become ready within ${FLUTTER_START_TIMEOUT_MS}ms.\n${recent}`.trim(),
    );
  }

  return {
    child,
    managed: true,
    url: DEFAULT_FLUTTER_URL,
  };
}

async function cleanupActiveFlutterServer() {
  if (!activeFlutterServer?.managed) {
    activeFlutterServer = null;
    return;
  }

  const server = activeFlutterServer;
  activeFlutterServer = null;
  await stopFlutterServer(server);
}

async function stopFlutterServer(server) {
  if (!server?.managed || server.child.killed) {
    return;
  }

  server.child.kill('SIGINT');

  const exited = await waitForProcessExit(
    server.child,
    LOCAL_SERVER_SHUTDOWN_TIMEOUT_MS,
  );
  if (exited) {
    return;
  }

  server.child.kill('SIGTERM');
  const terminated = await waitForProcessExit(server.child, 3000);
  if (!terminated) {
    server.child.kill('SIGKILL');
    await waitForProcessExit(server.child, 2000);
  }
}

function installSignalHandlers() {
  for (const signal of ['SIGINT', 'SIGTERM']) {
    process.on(signal, async () => {
      try {
        await cleanupActiveFlutterServer();
      } finally {
        process.exit(1);
      }
    });
  }
}

async function waitForProcessExit(child, timeoutMs) {
  return await new Promise((resolve) => {
    const timer = setTimeout(() => resolve(false), timeoutMs);
    child.once('exit', () => {
      clearTimeout(timer);
      resolve(true);
    });
  });
}

async function captureTailwindScreenshots({ exampleConfig, screenshotDir }) {
  const tailwindUrl = pathToFileURL(
    path.resolve(packageRoot, exampleConfig.htmlFile),
  ).href;

  for (const width of WIDTHS) {
    const outputPath = path.join(screenshotDir, `tailwind-${width}.png`);
    await captureScreenshot({
      outputPath,
      readySelector: exampleConfig.readySelector,
      url: tailwindUrl,
      viewportHeight: exampleConfig.viewportHeight,
      viewportWidth: width,
      waitMs: exampleConfig.tailwindWaitMs,
    });
    console.log(`  tailwind-${width}.png`);
  }
}

async function captureFlutterScreenshots({
  example,
  exampleConfig,
  flutterUrl,
  gradientStrategy,
  screenshotDir,
}) {
  for (const width of WIDTHS) {
    const url = new URL(flutterUrl);
    url.searchParams.set('screenshot', 'true');
    url.searchParams.set('width', String(width));
    url.searchParams.set('example', example);
    url.searchParams.set('gradient', gradientStrategy);

    const outputPath = path.join(screenshotDir, `flutter-${width}.png`);
    await captureScreenshot({
      outputPath,
      readySelector: null,
      url: url.toString(),
      viewportHeight: exampleConfig.viewportHeight,
      viewportWidth: width,
      waitMs: exampleConfig.flutterWaitMs,
    });
    console.log(`  flutter-${width}.png`);
  }
}

async function captureScreenshot({
  outputPath,
  readySelector,
  url,
  viewportHeight,
  viewportWidth,
  waitMs,
}) {
  const args = [
    'screenshot',
    '--browser=chromium',
    '--block-service-workers',
    '--color-scheme=light',
    '--full-page',
    '--lang=en-US',
    '--timeout=60000',
    `--viewport-size=${viewportWidth},${viewportHeight ?? CAPTURE_VIEWPORT_HEIGHT}`,
    `--wait-for-timeout=${waitMs}`,
    url,
    outputPath,
  ];

  if (readySelector) {
    args.splice(args.length - 3, 0, `--wait-for-selector=${readySelector}`);
  }

  await runCommand('playwright', args);
}

function generateComparisonArtifacts({ diffDir, screenshotDir }) {
  console.log('\nGenerating comparison artifacts...\n');
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

    if (
      tailwindPng.width !== flutterPng.width ||
      tailwindPng.height !== flutterPng.height
    ) {
      console.warn(
        `  Cropping ${width}px pair to ${targetWidth}x${targetHeight} for diff/side-by-side output.`,
      );
    }

    const tailwindCropped = cropToSize(tailwindPng, targetWidth, targetHeight);
    const flutterCropped = cropToSize(flutterPng, targetWidth, targetHeight);

    const sideBySide = createSideBySidePng(tailwindCropped, flutterCropped);
    const sideBySidePath = path.join(
      screenshotDir,
      `side-by-side-${width}.png`,
    );
    fs.writeFileSync(sideBySidePath, PNG.sync.write(sideBySide));

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
    results.push({
      delta,
      mismatched,
      totalPixels,
      width,
    });

    console.log(`  side-by-side-${width}.png`);
    console.log(`  diff-${width}.png (${delta.toFixed(2)}% diff)`);
  }

  if (!results.length) {
    throw new Error('No comparison artifacts were generated.');
  }

  return results;
}

function printSummary(results, exampleConfig) {
  console.log('\n=== Visual Comparison Results ===\n');
  console.table(
    results.map((result) => ({
      width: `${result.width}px`,
      'diff pixels': result.mismatched.toLocaleString(),
      'diff %': `${result.delta.toFixed(2)}%`,
    })),
  );

  const avgDiff =
    results.reduce((sum, result) => sum + result.delta, 0) / results.length;
  const moderateDiffThreshold = exampleConfig.moderateDiffThreshold ?? 5;
  const highDiffThreshold = exampleConfig.highDiffThreshold ?? 15;

  if (results.some((result) => result.delta > highDiffThreshold)) {
    console.log(
      `\nHigh diff detected (>${highDiffThreshold}%). Check the side-by-side and diff images for structural parity issues.`,
    );
    process.exitCode = 1;
    return;
  }

  if (results.some((result) => result.delta > moderateDiffThreshold)) {
    console.log(
      `\nModerate diff detected (>${moderateDiffThreshold}%, likely a mix of platform font rendering and layout drift).`,
    );
    return;
  }

  if (avgDiff < 3) {
    console.log(
      '\nExcellent parity. Remaining diff is likely platform-specific font or shadow rendering.',
    );
    return;
  }

  console.log('\nGood parity.');
}

async function resolveCommandPath(command) {
  const result = await runCommand('which', [command], { allowFailure: true });
  if (result.code !== 0) {
    return null;
  }

  return result.stdout.trim() || null;
}

async function runFlutterCommand(flutterInfo, args, options = {}) {
  return await runCommand(
    flutterInfo.command,
    [...flutterInfo.argsPrefix, ...args],
    options,
  );
}

async function runCommand(command, args, options = {}) {
  const {
    allowFailure = false,
    cwd = packageRoot,
    env = process.env,
  } = options;

  return await new Promise((resolve, reject) => {
    const child = spawn(command, args, {
      cwd,
      env,
      stdio: ['ignore', 'pipe', 'pipe'],
    });

    let stdout = '';
    let stderr = '';

    child.stdout.on('data', (chunk) => {
      stdout += chunk.toString();
    });
    child.stderr.on('data', (chunk) => {
      stderr += chunk.toString();
    });
    child.on('error', reject);
    child.on('close', (code) => {
      const result = { code, stderr, stdout };
      if (code === 0 || allowFailure) {
        resolve(result);
        return;
      }

      reject(
        new Error(
          [
            `Command failed: ${command} ${args.join(' ')}`.trim(),
            stdout.trim(),
            stderr.trim(),
          ]
            .filter(Boolean)
            .join('\n'),
        ),
      );
    });
  });
}

async function waitForUrl(url, timeoutMs) {
  const deadline = Date.now() + timeoutMs;

  while (Date.now() < deadline) {
    try {
      const response = await fetch(url, {
        method: 'GET',
        signal: AbortSignal.timeout(1000),
      });
      if (response.ok) {
        return true;
      }
    } catch {
      // Keep polling until the timeout expires.
    }

    await sleep(500);
  }

  return false;
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
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

function createSideBySidePng(leftPng, rightPng) {
  const background = { alpha: 255, blue: 252, green: 250, red: 248 };
  const width = leftPng.width + SIDE_BY_SIDE_GUTTER + rightPng.width;
  const height = Math.max(leftPng.height, rightPng.height);
  const composite = new PNG({ width, height });

  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      const idx = (width * y + x) << 2;
      composite.data[idx] = background.red;
      composite.data[idx + 1] = background.green;
      composite.data[idx + 2] = background.blue;
      composite.data[idx + 3] = background.alpha;
    }
  }

  blitPng(leftPng, composite, 0, 0);
  blitPng(rightPng, composite, leftPng.width + SIDE_BY_SIDE_GUTTER, 0);

  return composite;
}

function blitPng(source, target, dx, dy) {
  for (let y = 0; y < source.height; y++) {
    for (let x = 0; x < source.width; x++) {
      const srcIdx = (source.width * y + x) << 2;
      const destIdx = (target.width * (y + dy) + (x + dx)) << 2;
      target.data[destIdx] = source.data[srcIdx];
      target.data[destIdx + 1] = source.data[srcIdx + 1];
      target.data[destIdx + 2] = source.data[srcIdx + 2];
      target.data[destIdx + 3] = source.data[srcIdx + 3];
    }
  }
}

main().catch((error) => {
  console.error('Error:', error.message);
  cleanupActiveFlutterServer().catch(() => {});
  process.exitCode = 1;
});

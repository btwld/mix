#!/usr/bin/env node
import assert from 'node:assert/strict';
import fs from 'node:fs';
import http from 'node:http';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

import playwright from 'playwright';

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const packageRoot = path.resolve(scriptDir, '../..');
const workspaceRoot = path.resolve(scriptDir, '../../../..');
const buildRoot = path.join(packageRoot, 'example', 'build', 'web');
const evidenceRoot = path.join(workspaceRoot, '.context', 'showcase-qa');
const parityDataPath = path.join(buildRoot, 'generated', 'parity-data.json');

if (!fs.existsSync(path.join(buildRoot, 'index.html'))) {
  throw new Error('The showcase release build is missing. Run npm run showcase:build first.');
}

const parityData = JSON.parse(fs.readFileSync(parityDataPath, 'utf8'));
const signalMetrics = expectedMetricStrings(parityData, '02', 1024);

fs.mkdirSync(evidenceRoot, { recursive: true });
const server = await startStaticServer(buildRoot);
const address = server.address();
const baseUrl = `http://127.0.0.1:${address.port}`;
const browser = await playwright.chromium.launch({ headless: true });

try {
  const desktop = await verifyDesktop(browser, baseUrl);
  const mobile = await verifyMobile(browser, baseUrl);
  const fullPage = await verifyFullPageCapture(browser, baseUrl);
  console.log(JSON.stringify({ desktop, fullPage, mobile }, null, 2));
} finally {
  await browser.close();
  await new Promise((resolve, reject) =>
    server.close((error) => (error ? reject(error) : resolve())),
  );
}

async function verifyDesktop(browserInstance, baseUrlValue) {
  const context = await browserInstance.newContext({
    deviceScaleFactor: 1,
    permissions: ['clipboard-read', 'clipboard-write'],
    viewport: { width: 1440, height: 1000 },
  });
  const page = await context.newPage();
  const diagnostics = collectDiagnostics(page);

  await page.goto(
    `${baseUrlValue}/?example=launch-command&view=source&width=768&layout=all`,
    { waitUntil: 'networkidle' },
  );
  await waitForStatus(page, '1 view mounted');
  const reference = page.frameLocator('#tailwind-preview');
  await reference.locator('html[data-ready="true"]').waitFor({ timeout: 20_000 });

  assert.equal(await page.locator('.example-nav-button').count(), 5);
  assert.equal(await page.locator('#flutter-preview flt-glass-pane').count(), 1);
  assert.equal(await reference.locator('[data-example="01"]').count(), 1);
  assert.equal(new URL(page.url()).searchParams.has('layout'), false);
  assert.equal(new URL(page.url()).searchParams.has('view'), false);
  assert.equal(await page.locator('[role="tab"]').count(), 0);
  assert.equal(await page.locator('#panel-preview').isVisible(), true);
  assert.equal(await page.locator('#panel-source').isVisible(), true);
  assert.equal(await page.locator('.code-card').count(), 2);

  await page.locator('[data-example-id="02"]').click();
  await waitForStatus(page, '1 view mounted');
  await reference.locator('[data-example="02"]').waitFor({ timeout: 20_000 });
  const htmlSource = await page.locator('#tailwind-source').textContent();
  const dartSource = await page.locator('#flutter-source').textContent();
  assert.match(htmlSource, /WEEKLY SIGNAL \/ ACQUISITION/);
  assert.match(dartSource, /final _signalAnalytics = div\(/);
  assert.doesNotMatch(dartSource, /class _/);
  assert.doesNotMatch(htmlSource, /data-parity-class/);
  assert.equal(await page.locator('#tailwind-source mark.utility-match').count(), 1);
  assert.equal(await page.locator('#flutter-source mark.utility-match').count(), 1);
  assert.ok(await page.locator('#flutter-source .syntax-keyword').count());
  assert.ok(await page.locator('#flutter-source .syntax-function').count());
  assert.ok(await page.locator('#flutter-source .syntax-string').count());
  assert.ok(await page.locator('#flutter-source .syntax-operator').count());

  await page.getByRole('button', { name: 'Copy HTML' }).click();
  await page.waitForFunction(
    () => document.querySelector('#copy-status')?.textContent === 'HTML copied',
  );
  assert.equal(await page.locator('#copy-status').textContent(), 'HTML copied');

  await page.locator('#panel-parity > summary').click();
  assert.equal(await page.locator('#panel-parity').getAttribute('open'), '');
  await page.locator('[data-parity-width="1024"]').click();
  await page.locator('.parity-frame img').first().waitFor({ state: 'visible' });
  await page.waitForFunction(() =>
    [...document.querySelectorAll('.parity-frame img')].every(
      (image) => image.complete && image.naturalWidth > 0,
    ),
  );
  assert.equal(await page.locator('.parity-frame img').count(), 2);
  assert.equal(await page.locator('.parity-artifacts a').count(), 3);
  assert.equal(await page.locator('.parity-intro h3').textContent(), 'Parity contract passed');
  assert.deepEqual(
    await page.locator('.metric-grid strong').allTextContents(),
    signalMetrics,
  );

  await waitForStatus(page, '1 view mounted');
  assert.equal(await page.locator('#flutter-preview flt-glass-pane').count(), 1);
  assert.equal(await page.locator('#panel-source').isVisible(), true);
  assert.equal(await page.locator('[data-layout]').count(), 0);
  await page.locator('#panel-parity > summary').click();

  await page.addStyleTag({
    content: '.skip-link,.copy-status{display:none!important}',
  });
  const workbenchTop = await page.evaluate(() => {
    document.documentElement.style.scrollBehavior = 'auto';
    const workspace = document.querySelector('#showcase-workspace');
    const top = Math.max(0, workspace.getBoundingClientRect().top + window.scrollY - 76);
    window.scrollTo(0, top);
    return top;
  });
  await page.waitForFunction(
    (top) => Math.abs(window.scrollY - top) < 2,
    workbenchTop,
  );
  await page.screenshot({
    path: path.join(evidenceRoot, 'verified-desktop-workbench.png'),
  });

  await page.addStyleTag({
    content: '.site-header{position:static!important}',
  });
  await page.evaluate(() => {
    document.activeElement?.blur();
    window.scrollTo({ top: 0, behavior: 'auto' });
  });

  await page.screenshot({
    fullPage: true,
    path: path.join(evidenceRoot, 'verified-desktop-comparison.png'),
  });
  assertNoDiagnostics(diagnostics, 'desktop showcase');
  const result = {
    examples: 5,
    selectedFlutterMounts: 1,
    parityViewport: 1024,
    screenshot: path.join(evidenceRoot, 'verified-desktop-comparison.png'),
    workbenchScreenshot: path.join(evidenceRoot, 'verified-desktop-workbench.png'),
    sourceComparisonVisibleWithRender: true,
  };
  await context.close();
  return result;
}

function expectedMetricStrings(data, exampleId, width) {
  const example = data.examples.find((entry) => entry.id === exampleId);
  assert.ok(example, `Missing parity data for example ${exampleId}`);

  const result = example.results.find((entry) => entry.width === width);
  assert.ok(result, `Missing parity data for example ${exampleId} at ${width}px`);

  return ['diffPercent', 'strictDiffPercent', 'exactDiffPercent'].map(
    (key) => `${Number(result[key]).toFixed(2)}%`,
  );
}

async function verifyMobile(browserInstance, baseUrlValue) {
  const context = await browserInstance.newContext({
    deviceScaleFactor: 1,
    viewport: { width: 390, height: 844 },
  });
  const page = await context.newPage();
  const diagnostics = collectDiagnostics(page);

  await page.goto(`${baseUrlValue}/`, { waitUntil: 'networkidle' });
  await waitForStatus(page, '1 view mounted');
  await page.locator('#mobile-example-select').selectOption('05');
  await waitForStatus(page, '1 view mounted');
  await page
    .frameLocator('#tailwind-preview')
    .locator('[data-example="05"]')
    .waitFor({ timeout: 20_000 });

  assert.equal(await page.locator('#example-title').textContent(), 'Capacity map');
  assert.equal(await page.locator('.site-header').isVisible(), true);
  assert.equal(await page.locator('.mobile-example-picker').isVisible(), true);
  assert.equal(await page.locator('.example-strip').isVisible(), false);
  assert.equal(await page.locator('#panel-preview').isVisible(), true);
  assert.equal(await page.locator('#panel-source').isVisible(), true);
  assert.equal(await page.locator('#flutter-preview flt-glass-pane').count(), 1);
  assert.equal(await page.locator('.code-card').count(), 2);
  assert.equal(
    await page.evaluate(
      () => document.documentElement.scrollWidth - document.documentElement.clientWidth,
    ),
    0,
  );
  await page.addStyleTag({
    content:
      '.site-header{position:static!important}.skip-link,.copy-status{display:none!important}',
  });
  await page.evaluate(() => {
    document.documentElement.style.scrollBehavior = 'auto';
    window.scrollTo(0, 0);
  });
  await page.screenshot({
    fullPage: true,
    path: path.join(evidenceRoot, 'verified-mobile-source.png'),
  });
  assertNoDiagnostics(diagnostics, 'mobile showcase');
  const result = {
    horizontalOverflow: 0,
    liveRenderAndSourceVisible: true,
    selectedExample: 'Capacity map',
    screenshot: path.join(evidenceRoot, 'verified-mobile-source.png'),
  };
  await context.close();
  return result;
}

async function verifyFullPageCapture(browserInstance, baseUrlValue) {
  const context = await browserInstance.newContext({
    deviceScaleFactor: 1,
    viewport: { width: 480, height: 1200 },
  });
  const page = await context.newPage();
  const diagnostics = collectDiagnostics(page);
  await page.goto(
    `${baseUrlValue}/?screenshot=true&example=advanced-parity&sample=01&width=480`,
    { waitUntil: 'networkidle' },
  );
  await page
    .locator('flt-glass-pane')
    .waitFor({ state: 'attached', timeout: 30_000 });
  assert.equal(await page.locator('.showcase-shell').isVisible(), false);
  assert.equal(await page.locator('flt-glass-pane').count(), 1);
  assertNoDiagnostics(diagnostics, 'full-page Flutter capture');
  await context.close();
  return { implicitFlutterView: 1, showcaseShellHidden: true };
}

function collectDiagnostics(page) {
  const errors = [];
  const failedRequests = [];
  page.on('console', (message) => {
    if (message.type() === 'error') errors.push(message.text());
  });
  page.on('pageerror', (error) => errors.push(error.message));
  page.on('requestfailed', (request) => {
    failedRequests.push(`${request.failure()?.errorText}: ${request.url()}`);
  });
  return { errors, failedRequests };
}

function assertNoDiagnostics(diagnostics, label) {
  assert.deepEqual(diagnostics.errors, [], `${label} emitted console/page errors`);
  assert.deepEqual(
    diagnostics.failedRequests,
    [],
    `${label} emitted failed network requests`,
  );
}

async function waitForStatus(page, expected) {
  await page.waitForFunction(
    (value) => document.querySelector('#flutter-status')?.textContent.includes(value),
    expected,
    { timeout: 30_000 },
  );
}

async function startStaticServer(root) {
  const server = http.createServer((request, response) => {
    try {
      const requestUrl = new URL(request.url, 'http://127.0.0.1');
      const relativePath = decodeURIComponent(requestUrl.pathname).replace(/^\/+/, '');
      const requestedPath = path.resolve(root, relativePath || 'index.html');
      if (requestedPath !== root && !requestedPath.startsWith(`${root}${path.sep}`)) {
        response.writeHead(403).end('Forbidden');
        return;
      }
      const filePath = fs.statSync(requestedPath).isDirectory()
        ? path.join(requestedPath, 'index.html')
        : requestedPath;
      response.writeHead(200, { 'content-type': mimeType(filePath) });
      fs.createReadStream(filePath).pipe(response);
    } catch {
      response.writeHead(404).end('Not found');
    }
  });
  await new Promise((resolve, reject) => {
    server.once('error', reject);
    server.listen(0, '127.0.0.1', resolve);
  });
  return server;
}

function mimeType(filePath) {
  return (
    {
      '.css': 'text/css; charset=utf-8',
      '.gif': 'image/gif',
      '.html': 'text/html; charset=utf-8',
      '.js': 'text/javascript; charset=utf-8',
      '.json': 'application/json; charset=utf-8',
      '.otf': 'font/otf',
      '.png': 'image/png',
      '.svg': 'image/svg+xml',
      '.ttf': 'font/ttf',
      '.wasm': 'application/wasm',
      '.woff2': 'font/woff2',
    }[path.extname(filePath)] ?? 'application/octet-stream'
  );
}

#!/usr/bin/env node
import path from 'node:path';
import fs from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import { spawn } from 'node:child_process';
import process from 'node:process';
import { chromium } from 'playwright';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const websiteRoot = path.resolve(__dirname, '..');
const outputDir = path.join(websiteRoot, 'screenshots', 'tailwind-plan-card');
const route = '/examples/tailwind-plan-card';
const port = process.env.TAILWIND_SCREENSHOT_PORT ?? '4319';
const baseUrl = `http://127.0.0.1:${port}`;
const widths = [480, 768, 1024];

const log = (...args) => console.log('[screenshots]', ...args);

async function waitForServer(url, timeoutMs = 60000) {
  const start = Date.now();
  while (Date.now() - start < timeoutMs) {
    try {
      const res = await fetch(url, { method: 'GET' });
      if (res.ok) {
        return;
      }
    } catch (err) {
      // Server not ready yet; swallow.
    }
    await new Promise((resolve) => setTimeout(resolve, 500));
  }
  throw new Error(`Timed out waiting for ${url}`);
}

async function main() {
  await fs.mkdir(outputDir, { recursive: true });

  log('starting Next.js dev server on port', port);
  const server = spawn('yarn', ['dev'], {
    cwd: websiteRoot,
    env: { ...process.env, PORT: port },
    stdio: 'inherit',
  });

  let serverExited = false;
  server.on('exit', (code, signal) => {
    serverExited = true;
    log(`Next.js dev server exited (code=${code}, signal=${signal})`);
  });

  try {
    await waitForServer(`${baseUrl}${route}`);
    log('dev server ready');

    const browser = await chromium.launch();
    const page = await browser.newPage();

    for (const width of widths) {
      log('capturing width', width);
      await page.setViewportSize({ width, height: 1200 });
      await page.goto(`${baseUrl}${route}`, { waitUntil: 'networkidle' });

      const slider = page.locator('input[type="range"]').first();
      if (await slider.count()) {
        await slider.fill(String(width));
      }

      await page.waitForTimeout(500);
      let target = page.locator('main').first();
      if (!(await target.count())) {
        target = page.locator('body');
      }
      const outPath = path.join(outputDir, `tailwind-plan-card-${width}.png`);
      await target.screenshot({ path: outPath, animations: 'disabled' });
      log('saved', outPath);
    }

    await browser.close();
  } finally {
    if (!serverExited) {
      server.kill('SIGTERM');
    }
  }
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});

import { test, expect } from '@playwright/test';
import * as fs from 'fs';
import { isDartPadAvailable } from './helpers/dartpad';

const TEST_PAGE = '/documentation/test/demo-test';
const demosExist = fs.existsSync('./public/demos/index.html');

test.describe('Visual Regression - DartPad @slow', () => {
  test.beforeEach(async ({ page, request }) => {
    const dartpadAvailable = await isDartPadAvailable(request);
    test.skip(!dartpadAvailable, 'dartpad.dev is unavailable');

    await page.goto(TEST_PAGE);
  });

  test('DartPadEmbed light theme screenshot', async ({ page }) => {
    const wrapper = page.getByTestId('test-dartpad-inline');
    await wrapper.scrollIntoViewIfNeeded();

    // Wait for iframe to load
    const embed = wrapper.locator('[data-testid="dartpad-embed"]');
    await expect(embed).toHaveAttribute('data-status', 'ready', { timeout: 60000 });

    // Stabilization wait for layout
    await page.waitForTimeout(500);

    await expect(wrapper).toHaveScreenshot('dartpad-light.png');
  });

  test('DartPadEmbed dark theme screenshot', async ({ page }) => {
    const wrapper = page.getByTestId('test-dartpad-dark');
    await wrapper.scrollIntoViewIfNeeded();

    // Wait for iframe to load
    const embed = wrapper.locator('[data-testid="dartpad-embed"]');
    await expect(embed).toHaveAttribute('data-status', 'ready', { timeout: 60000 });

    // Stabilization wait for layout
    await page.waitForTimeout(500);

    await expect(wrapper).toHaveScreenshot('dartpad-dark.png');
  });

  test('Demo component DartPad mode screenshot', async ({ page }) => {
    const wrapper = page.getByTestId('test-demo-dartpad');
    await wrapper.scrollIntoViewIfNeeded();

    // Wait for DartPad to load
    const embed = wrapper.locator('[data-testid="dartpad-embed"]');
    await expect(embed).toHaveAttribute('data-status', 'ready', { timeout: 60000 });

    // Extended wait for DartPad content to fully render
    await page.waitForTimeout(3000);

    await expect(wrapper).toHaveScreenshot('demo-dartpad.png');
  });
});

test.describe('Visual Regression - Flutter', () => {
  test.skip(!demosExist, 'Flutter demos not built. Run: bash examples/scripts/build_web_demos.sh');

  test.beforeEach(async ({ page }) => {
    await page.goto(TEST_PAGE);
  });

  test.skip('FlutterEmbed element mode screenshot', async ({ page }) => {
    // SKIP RATIONALE: Flutter element embedding requires WebGL/CanvasKit which
    // has known issues in headless Chromium. See flutter-embed.spec.ts for details.
    // Iframe mode visual testing (below) provides equivalent coverage.
    const wrapper = page.getByTestId('test-flutter-element');
    await wrapper.scrollIntoViewIfNeeded();

    // Wait for Flutter to load
    const embed = wrapper.locator('[data-testid="flutter-embed"]');
    await expect(embed).toHaveAttribute('data-status', 'ready', { timeout: 60000 });

    // Stabilization wait for Flutter rendering
    await page.waitForTimeout(1000);

    await expect(wrapper).toHaveScreenshot('flutter-element.png');
  });

  test('FlutterEmbed iframe mode screenshot', async ({ page }) => {
    const wrapper = page.getByTestId('test-flutter-iframe');
    await wrapper.scrollIntoViewIfNeeded();

    // Wait for iframe element to be present
    const iframe = wrapper.locator('[data-testid="flutter-iframe"]');
    await expect(iframe).toBeVisible();

    // Extended wait for Flutter app to fully initialize and render inside iframe
    // Flutter apps with canvaskit take 15-20+ seconds to bootstrap in headless Chrome
    await page.waitForTimeout(20000);

    await expect(wrapper).toHaveScreenshot('flutter-iframe.png');
  });

  test.skip('Demo component Flutter mode screenshot', async ({ page }) => {
    // SKIP RATIONALE: Same as FlutterEmbed element mode - WebGL/CanvasKit issues
    // in headless Chromium. Demo component with flutterSrc uses element embedding internally.
    const wrapper = page.getByTestId('test-demo-flutter');
    await wrapper.scrollIntoViewIfNeeded();

    // Wait for Flutter to load
    const embed = wrapper.locator('[data-testid="flutter-embed"]');
    await expect(embed).toHaveAttribute('data-status', 'ready', { timeout: 60000 });

    // Stabilization wait for Flutter rendering
    await page.waitForTimeout(1000);

    await expect(wrapper).toHaveScreenshot('demo-flutter.png');
  });
});

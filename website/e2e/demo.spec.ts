import { test, expect } from '@playwright/test';
import * as fs from 'fs';
import { scrollIntoViewAndWait } from './helpers/scroll-and-wait';

const TEST_PAGE = '/documentation/test/demo-test';
const demosExist = fs.existsSync('./public/demos/index.html');

test.describe('Demo Component', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(TEST_PAGE);
  });

  test('selects DartPad mode when code provided', async ({ page }) => {
    const wrapper = page.getByTestId('test-demo-dartpad');
    await scrollIntoViewAndWait(wrapper);

    const demo = wrapper.locator('[data-testid="demo"]');
    await expect(demo).toHaveAttribute('data-demo-type', 'dartpad');
  });

  test('shows DartPad badge for code mode', async ({ page }) => {
    const wrapper = page.getByTestId('test-demo-dartpad');
    await scrollIntoViewAndWait(wrapper);

    const badge = wrapper.locator('[data-testid="demo-badge"]');
    await expect(badge).toHaveText('DartPad');
  });

  test('shows tab buttons for DartPad mode', async ({ page }) => {
    const wrapper = page.getByTestId('test-demo-dartpad');
    await scrollIntoViewAndWait(wrapper);

    await expect(wrapper.locator('[data-testid="demo-tab-preview"]')).toBeVisible();
    await expect(wrapper.locator('[data-testid="demo-tab-code"]')).toBeVisible();
    await expect(wrapper.locator('[data-testid="demo-tab-both"]')).toBeVisible();
  });

  test('tab switching works', async ({ page }) => {
    const wrapper = page.getByTestId('test-demo-dartpad');
    await scrollIntoViewAndWait(wrapper);

    // Verify initial state has split=50 (preview mode)
    const iframe = wrapper.locator('[data-testid="dartpad-iframe"]');
    await expect(iframe).toHaveAttribute('src', /split=0/);

    // Click code tab
    const codeTab = wrapper.locator('[data-testid="demo-tab-code"]');
    await codeTab.click();

    // Wait for iframe src to update
    await page.waitForTimeout(100);

    // Verify the iframe src has split=100 for code-only view
    await expect(iframe).toHaveAttribute('src', /split=100/);
  });
});

test.describe('Demo Component (Flutter mode)', () => {
  test.skip(!demosExist, 'Flutter demos not built. Run: bash examples/scripts/build_web_demos.sh');

  test.beforeEach(async ({ page }) => {
    await page.goto(TEST_PAGE);
  });

  test('selects Flutter mode when flutterSrc provided', async ({ page }) => {
    const wrapper = page.getByTestId('test-demo-flutter');
    await scrollIntoViewAndWait(wrapper);

    const demo = wrapper.locator('[data-testid="demo"]');
    await expect(demo).toHaveAttribute('data-demo-type', 'flutter');
  });

  test('shows Flutter Web badge for flutter mode', async ({ page }) => {
    const wrapper = page.getByTestId('test-demo-flutter');
    await scrollIntoViewAndWait(wrapper);

    const badge = wrapper.locator('[data-testid="demo-badge"]');
    await expect(badge).toHaveText('Flutter Web');
  });

  test('does not show tabs for Flutter mode', async ({ page }) => {
    const wrapper = page.getByTestId('test-demo-flutter');
    await scrollIntoViewAndWait(wrapper);

    await expect(wrapper.locator('[data-testid="demo-tab-preview"]')).not.toBeVisible();
  });
});

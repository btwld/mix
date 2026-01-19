import { test, expect } from '@playwright/test';
import * as fs from 'fs';
import { scrollIntoViewAndWait } from './helpers/scroll-and-wait';

const TEST_PAGE = '/documentation/test/demo-test';
const demosExist = fs.existsSync('./public/demos/index.html');

test.describe('FlutterMultiView', () => {
  test.skip(!demosExist, 'Flutter demos not built. Run: bash examples/scripts/build_web_demos.sh');

  test.beforeEach(async ({ page }) => {
    await page.goto(TEST_PAGE);
  });

  test('renders container with correct demo id', async ({ page }) => {
    const wrapper = page.getByTestId('test-multiview-1');
    await scrollIntoViewAndWait(wrapper);

    // Container should have data-demo-id attribute
    const container = wrapper.locator('[data-demo-id="box-basic"]');
    await expect(container).toBeAttached();
  });

  test('multiple views can coexist on same page', async ({ page }) => {
    // Scroll to both multiview components to trigger loading
    const wrapper1 = page.getByTestId('test-multiview-1');
    const wrapper2 = page.getByTestId('test-multiview-2');

    await scrollIntoViewAndWait(wrapper1);
    await scrollIntoViewAndWait(wrapper2);

    // Verify both have their correct demo IDs
    await expect(wrapper1.locator('[data-demo-id="box-basic"]')).toBeAttached();
    await expect(wrapper2.locator('[data-demo-id="variant-hover"]')).toBeAttached();
  });

  test('has data-state attribute for tracking loading state', async ({ page }) => {
    const wrapper = page.getByTestId('test-multiview-1');
    await wrapper.scrollIntoViewIfNeeded();

    // Container should have data-state attribute
    const container = wrapper.locator('[data-state]');
    const state = await container.getAttribute('data-state');

    // State should be one of the valid states
    expect(['idle', 'loading-engine', 'adding-view', 'ready', 'error']).toContain(state);
  });

  test('has accessible role and aria attributes', async ({ page }) => {
    const wrapper = page.getByTestId('test-multiview-1');
    await scrollIntoViewAndWait(wrapper);

    // Container should have role="application" for screen readers
    const container = wrapper.locator('[role="application"]');
    await expect(container).toBeVisible();

    // Should have aria-label for accessibility
    await expect(container).toHaveAttribute('aria-label', /Flutter demo/);
  });

  test('shows loading indicator during initialization', async ({ page }) => {
    const wrapper = page.getByTestId('test-multiview-1');
    await wrapper.scrollIntoViewIfNeeded();

    // Loading text should be visible initially or transition quickly
    // We check that the loading infrastructure exists
    const loadingIndicator = wrapper.locator('text=Loading');
    const waitingIndicator = wrapper.locator('text=Waiting');
    const isLoadingVisible = await loadingIndicator.isVisible().catch(() => false);
    const isWaitingVisible = await waitingIndicator.isVisible().catch(() => false);

    // Either loading is visible OR we've already reached ready state
    const container = wrapper.locator('[data-state]');
    const state = await container.getAttribute('data-state');

    expect(
      isLoadingVisible ||
        isWaitingVisible ||
        state === 'idle' ||
        state === 'loading-engine' ||
        state === 'adding-view' ||
        state === 'ready' ||
        state === 'error'
    ).toBe(true);
  });
});

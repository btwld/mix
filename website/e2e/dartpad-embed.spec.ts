import { test, expect } from '@playwright/test';
import { scrollIntoViewAndWait, waitForStatus } from './helpers/scroll-and-wait';

const TEST_PAGE = '/documentation/test/demo-test';

test.describe('DartPadEmbed @slow', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(TEST_PAGE);
  });

  test('renders container with correct data-testid', async ({ page }) => {
    const wrapper = page.getByTestId('test-dartpad-inline');
    await scrollIntoViewAndWait(wrapper);

    const embed = wrapper.locator('[data-testid="dartpad-embed"]');
    await expect(embed).toBeVisible();
  });

  test('iframe loads successfully', async ({ page }) => {
    const wrapper = page.getByTestId('test-dartpad-inline');
    await scrollIntoViewAndWait(wrapper);

    const iframe = wrapper.locator('[data-testid="dartpad-iframe"]');
    await expect(iframe).toBeVisible();
    await expect(iframe).toHaveAttribute('src', /dartpad\.dev/);
  });

  test('status changes to ready after load', async ({ page }) => {
    const wrapper = page.getByTestId('test-dartpad-inline');
    const embed = wrapper.locator('[data-testid="dartpad-embed"]');

    await waitForStatus(embed, 'ready', 60000);
  });

  test('light theme applies correctly', async ({ page }) => {
    const wrapper = page.getByTestId('test-dartpad-inline');
    await scrollIntoViewAndWait(wrapper);

    const iframe = wrapper.locator('[data-testid="dartpad-iframe"]');
    await expect(iframe).toHaveAttribute('src', /theme=light/);
  });

  test('dark theme applies correctly', async ({ page }) => {
    const wrapper = page.getByTestId('test-dartpad-dark');
    await scrollIntoViewAndWait(wrapper);

    const iframe = wrapper.locator('[data-testid="dartpad-iframe"]');
    await expect(iframe).toHaveAttribute('src', /theme=dark/);
  });
});

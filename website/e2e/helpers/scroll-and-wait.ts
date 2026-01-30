import { Locator, expect } from '@playwright/test';

export async function scrollIntoViewAndWait(locator: Locator, timeout = 30000) {
  await locator.scrollIntoViewIfNeeded();
  await locator.waitFor({ state: 'visible', timeout });
}

export async function waitForStatus(
  locator: Locator,
  status: 'loading' | 'ready' | 'error',
  timeout = 45000
) {
  await scrollIntoViewAndWait(locator);
  await expect(locator).toHaveAttribute('data-status', status, { timeout });
}

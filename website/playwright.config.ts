import { defineConfig, devices } from '@playwright/test';

const isCI = !!process.env.CI;

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: isCI,
  retries: isCI ? 2 : 0,
  workers: isCI ? 1 : undefined,
  reporter: isCI ? 'github' : 'html',
  timeout: 60000,

  use: {
    baseURL: 'http://localhost:3002',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],

  webServer: {
    command: isCI ? 'yarn build && yarn start' : 'yarn dev',
    url: 'http://localhost:3002',
    reuseExistingServer: !isCI,
    timeout: 120000,
  },

  expect: {
    toHaveScreenshot: {
      maxDiffPixelRatio: 0.01,
      animations: 'disabled',
    },
  },
});

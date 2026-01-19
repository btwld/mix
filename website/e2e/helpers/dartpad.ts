import { APIRequestContext } from '@playwright/test';

export async function isDartPadAvailable(request: APIRequestContext): Promise<boolean> {
  try {
    const response = await request.get('https://dartpad.dev', { timeout: 10000 });
    return response.ok();
  } catch {
    return false;
  }
}

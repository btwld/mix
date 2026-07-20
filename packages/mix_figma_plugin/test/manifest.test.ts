import { describe, expect, it } from 'vitest';

import manifest from '../manifest.json';

describe('plugin manifest', () => {
  it('has a Figma plugin id so private plugin data is available', () => {
    expect(manifest.id).toMatch(/^\d+$/);
  });

  it('allows only the local development bridge', () => {
    expect(manifest.networkAccess).toEqual({
      allowedDomains: ['none'],
      devAllowedDomains: ['http://localhost:8787'],
    });
  });
});

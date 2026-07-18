import { describe, expect, it, vi } from 'vitest';

import { DevBridgeClient } from '../src/bridge/dev_bridge_client';
import type {
  ComponentSetWritePayload,
  FigmaSelectionDocument,
  PullTokensPayload,
  PushTokensPayload,
} from '../src/types';

const emptyTokens: PullTokensPayload = {
  variables: { version: 1, collections: [], variables: [] },
  styles: { version: 1, textStyles: [], effectStyles: [], paintStyles: [] },
};

const emptyPushTokens: PushTokensPayload = {
  variables: { version: 1, collections: [], variables: [] },
  styles: { version: 1, textStyles: [], effectStyles: [] },
};

const emptySelection: FigmaSelectionDocument = {
  version: 1,
  pageId: 'page:1',
  pageName: 'Page 1',
  selection: [],
  diagnostics: [],
};

const componentPayload: ComponentSetWritePayload = {
  version: 1,
  ref: 'button',
  name: 'Button',
  variants: [],
};

describe('DevBridgeClient', () => {
  it('uses the bridge endpoint contract and JSON request bodies', async () => {
    const fetch = vi.fn(async (input: RequestInfo | URL, _init?: RequestInit) => {
      const url = String(input);
      const payload = url.endsWith('/push/tokens')
        ? emptyPushTokens
        : url.endsWith('/push/components/button%2Fprimary')
          ? componentPayload
          : url.endsWith('/health')
            ? { status: 'ok' }
            : { accepted: true };
      return new Response(JSON.stringify(payload), {
        headers: { 'content-type': 'application/json' },
      });
    });
    const client = new DevBridgeClient('http://localhost:8787/', fetch);

    await expect(client.health()).resolves.toEqual({ status: 'ok' });
    await expect(client.pullTokens(emptyTokens)).resolves.toEqual({ accepted: true });
    await expect(client.pushTokens()).resolves.toEqual(emptyPushTokens);
    await expect(client.pullNodes({ nodes: emptySelection })).resolves.toEqual({ accepted: true });
    await expect(client.pushComponent('button/primary')).resolves.toEqual(componentPayload);

    expect(fetch.mock.calls.map(([input, init]) => [String(input), init?.method])).toEqual([
      ['http://localhost:8787/health', 'GET'],
      ['http://localhost:8787/pull/tokens', 'POST'],
      ['http://localhost:8787/push/tokens', 'GET'],
      ['http://localhost:8787/pull/nodes', 'POST'],
      ['http://localhost:8787/push/components/button%2Fprimary', 'GET'],
    ]);
    expect(fetch.mock.calls[1]?.[1]).toMatchObject({
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify(emptyTokens),
    });
    expect(fetch.mock.calls[3]?.[1]).toMatchObject({ body: JSON.stringify({ nodes: emptySelection }) });
  });

  it('reports endpoint and response body when the bridge rejects a request', async () => {
    const fetch = vi.fn(async () => new Response('bridge unavailable', { status: 503 }));
    const client = new DevBridgeClient('http://localhost:8787', fetch);

    await expect(client.health()).rejects.toThrow(
      'Mix bridge GET /health failed with 503: bridge unavailable',
    );
  });
});

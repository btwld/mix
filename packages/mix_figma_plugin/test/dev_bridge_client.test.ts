import { describe, expect, it, vi } from 'vitest';

import { DevBridgeClient } from '../src/bridge/dev_bridge_client';
import type {
  FigmaTokenWriteResult,
  PullTokensPayload,
  PushTokensPayload,
  SyncApplyResponse,
  SyncPlanResponse,
  SyncVerificationReport,
} from '../src/types';

const emptyTokens: PullTokensPayload = {
  variables: { version: 1, collections: [], variables: [] },
  styles: { version: 1, textStyles: [], effectStyles: [], paintStyles: [] },
};

const emptyPushTokens: PushTokensPayload = {
  variables: { version: 1, collections: [], variables: [] },
  styles: { version: 1, textStyles: [], effectStyles: [] },
};

const tokenWriteResult: FigmaTokenWriteResult = {
  variables: {
    collections: { 'Mix Tokens': 'collection:1' },
    modes: { 'Mix Tokens': { 'mode:light': 'mode:1' } },
    variables: { 'colors/color.brand': 'variable:1' },
  },
  styles: {
    textStyles: { 'textStyles/type.body': 'style:text' },
    effectStyles: {},
    paintStyles: {},
  },
};

const tokenPlan: SyncPlanResponse = {
  plan: {
    schema: 'mix_figma/sync-plan/v1',
    version: 1,
    id: 'plan:1',
    direction: 'mixToFigma',
    resource: 'tokens',
    sourceFingerprint: 'source',
    desiredFingerprint: 'desired',
    summary: {
      create: 0,
      update: 0,
      rename: 0,
      delete: 0,
      unchanged: 0,
      skip: 0,
      errors: 0,
      warnings: 0,
    },
    operations: [],
    diagnostics: [],
  },
  payload: emptyPushTokens,
};

const tokenApply: SyncApplyResponse = {
  status: 'approved',
  plan: tokenPlan.plan,
  payload: emptyPushTokens,
  allowDeletes: false,
  appliedOperations: [],
};

const tokenReport: SyncVerificationReport = {
  schema: 'mix_figma/sync-report/v1',
  version: 1,
  planId: 'plan:1',
  direction: 'mixToFigma',
  resource: 'tokens',
  status: 'verified',
  remainingMutations: 0,
  pendingDeletes: 0,
  diagnostics: [],
};

describe('DevBridgeClient', () => {
  it('uses the bridge endpoint contract and JSON request bodies', async () => {
    const fetch = vi.fn(async (input: RequestInfo | URL, _init?: RequestInit) => {
      const url = String(input);
      const payload = url.endsWith('/sync/plan')
          ? tokenPlan
          : url.endsWith('/sync/apply')
            ? tokenApply
            : url.endsWith('/sync/verify')
              ? tokenReport
        : url.endsWith('/health')
            ? { status: 'ok' }
            : { accepted: true };
      return new Response(JSON.stringify(payload), {
        headers: { 'content-type': 'application/json' },
      });
    });
    const client = new DevBridgeClient('http://localhost:8787/', fetch);
    client.setAuthToken('session-token');

    await expect(client.health()).resolves.toEqual({ status: 'ok' });
    await expect(client.planSync({
      version: 1,
      direction: 'mixToFigma',
      resource: 'tokens',
      current: emptyTokens,
    })).resolves.toEqual(tokenPlan);
    await expect(client.applySync({
      planId: 'plan:1',
      allowDeletes: false,
      current: emptyTokens,
    })).resolves.toEqual(tokenApply);
    await expect(client.verifySync({
      planId: 'plan:1',
      current: emptyTokens,
      writeResult: tokenWriteResult,
    })).resolves.toEqual(tokenReport);

    expect(fetch.mock.calls.map(([input, init]) => [String(input), init?.method])).toEqual([
      ['http://localhost:8787/health', 'GET'],
      ['http://localhost:8787/sync/plan', 'POST'],
      ['http://localhost:8787/sync/apply', 'POST'],
      ['http://localhost:8787/sync/verify', 'POST'],
    ]);
    expect(fetch.mock.calls[1]?.[1]).toMatchObject({
      headers: {
        authorization: 'Bearer session-token',
        'content-type': 'application/json',
      },
      body: JSON.stringify({
        version: 1,
        direction: 'mixToFigma',
        resource: 'tokens',
        current: emptyTokens,
      }),
    });
    expect(fetch.mock.calls[0]?.[1]).toMatchObject({
      headers: { authorization: 'Bearer session-token' },
    });
  });

  it('reports endpoint and response body when the bridge rejects a request', async () => {
    const fetch = vi.fn(async () => new Response('bridge unavailable', { status: 503 }));
    const client = new DevBridgeClient('http://localhost:8787', fetch);

    await expect(client.health()).rejects.toThrow(
      'Mix bridge GET /health failed with 503: bridge unavailable',
    );
  });

  it('returns a structured failed verification report from HTTP 422', async () => {
    const failed = { ...tokenReport, status: 'failed' as const, remainingMutations: 1 };
    const fetch = vi.fn(async () =>
      new Response(JSON.stringify(failed), {
        status: 422,
        headers: { 'content-type': 'application/json' },
      }),
    );
    const client = new DevBridgeClient('http://localhost:8787', fetch);

    await expect(client.verifySync({ planId: 'plan:1' })).resolves.toEqual(failed);
  });
});

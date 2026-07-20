import { afterEach, describe, expect, it, vi } from 'vitest';

import type {
  PullNodesPayload,
  SyncApplyResponse,
  SyncPlanResponse,
  SyncVerificationReport,
} from '../src/types';

interface MockElement {
  checked: boolean;
  dataset: Record<string, string>;
  disabled: boolean;
  hidden: boolean;
  listeners: Map<string, () => void>;
  textContent: string;
  value: string;
  addEventListener(type: string, listener: () => void): void;
  click(): void;
}

function element(value = ''): MockElement {
  const listeners = new Map<string, () => void>();
  return {
    checked: false,
    dataset: {},
    disabled: false,
    hidden: false,
    listeners,
    textContent: '',
    value,
    addEventListener(type, listener) {
      listeners.set(type, listener);
    },
    click() {
      listeners.get('click')?.();
    },
  };
}

const selection: PullNodesPayload = {
  nodes: {
    version: 1,
    pageId: 'page:1',
    pageName: 'Page',
    selection: [],
    diagnostics: [],
  },
  variables: { version: 1, collections: [], variables: [] },
};

const planResponse: SyncPlanResponse = {
  plan: {
    schema: 'mix_figma/sync-plan/v1',
    version: 1,
    id: 'selection-plan-1234567890',
    direction: 'figmaToMix',
    resource: 'selection',
    sourceFingerprint: 'source',
    desiredFingerprint: 'desired',
    summary: {
      create: 1,
      update: 0,
      rename: 0,
      delete: 0,
      unchanged: 0,
      skip: 0,
      errors: 0,
      warnings: 0,
    },
    operations: [
      {
        action: 'create',
        kind: 'styleFile',
        ref: 'card',
        name: 'Card',
        path: '/styles/card.style.json',
        destructive: false,
        changes: ['styleFile'],
        diagnostics: [],
      },
    ],
    diagnostics: [],
  },
};

const applyResponse: SyncApplyResponse = {
  status: 'applied',
  plan: planResponse.plan,
  appliedOperations: planResponse.plan.operations,
};

const report: SyncVerificationReport = {
  schema: 'mix_figma/sync-report/v1',
  version: 1,
  planId: planResponse.plan.id,
  direction: 'figmaToMix',
  resource: 'selection',
  status: 'verifiedWithRetainedItems',
  remainingMutations: 0,
  pendingDeletes: 0,
  diagnostics: [
    {
      code: 'unmanaged_resource_preserved',
      severity: 'info',
      path: '/styles/style:user',
      message: 'Unowned Figma resource was preserved.',
    },
  ],
};

describe('plugin UI', () => {
  afterEach(() => {
    vi.unstubAllGlobals();
    vi.resetModules();
  });

  it('guides a selection through Analyze, Preview, Apply, and Verify', async () => {
    const workflow = element('selection-pull');
    const bridgeToken = element('session-token');
    const componentField = element();
    const componentInput = element();
    const analyze = element();
    const apply = element();
    apply.disabled = true;
    const verify = element();
    verify.disabled = true;
    const deleteControl = element();
    deleteControl.hidden = true;
    const allowDeletes = element();
    const preview = element();
    const status = element();
    const health = element();
    const stages = {
      analyze: element(),
      preview: element(),
      apply: element(),
      verify: element(),
    };
    const selectors = new Map<string, MockElement>([
      ['#bridge-token', bridgeToken],
      ['#workflow', workflow],
      ['#component-field', componentField],
      ['#component-id', componentInput],
      ['#analyze', analyze],
      ['#apply', apply],
      ['#verify', verify],
      ['#deletion-control', deleteControl],
      ['#allow-deletes', allowDeletes],
      ['#preview', preview],
      ['#status', status],
      ['#health', health],
      ['[data-stage="analyze"]', stages.analyze],
      ['[data-stage="preview"]', stages.preview],
      ['[data-stage="apply"]', stages.apply],
      ['[data-stage="verify"]', stages.verify],
    ]);
    const document = {
      querySelector: vi.fn((selector: string) => selectors.get(selector) ?? null),
    };
    let messageListener: ((event: MessageEvent<unknown>) => void) | undefined;
    const window = {
      addEventListener: vi.fn(
        (type: string, listener: (event: MessageEvent<unknown>) => void) => {
          if (type === 'message') messageListener = listener;
        },
      ),
    };
    const sandboxMessages: unknown[] = [];
    const parent = {
      postMessage: vi.fn((envelope: unknown) => {
        const message = (
          envelope as { pluginMessage: { type: string; requestId: string } }
        ).pluginMessage;
        sandboxMessages.push(message);
        if (message.type !== 'read-selection') return;
        messageListener?.({
          data: {
            pluginMessage: {
              type: 'operation-result',
              requestId: message.requestId,
              payload: selection,
            },
          },
        } as MessageEvent<unknown>);
      }),
    };
    const fetch = vi.fn(async (request: RequestInfo | URL) => {
      const url = String(request);
      const payload = url.endsWith('/sync/plan')
        ? planResponse
        : url.endsWith('/sync/apply')
          ? applyResponse
          : report;
      return new Response(JSON.stringify(payload), {
        headers: { 'content-type': 'application/json' },
      });
    });

    vi.stubGlobal('document', document);
    vi.stubGlobal('window', window);
    vi.stubGlobal('parent', parent);
    vi.stubGlobal('fetch', fetch);

    await import('../src/ui/main');
    analyze.click();

    await vi.waitFor(() => {
      expect(apply.disabled).toBe(false);
    });
    expect(preview.textContent).toContain('PLAN selection-pl');
    expect(preview.textContent).toContain('+ styleFile');
    expect(stages.preview.dataset.state).toBe('active');

    apply.click();
    await vi.waitFor(() => {
      expect(verify.disabled).toBe(false);
    });
    expect(stages.verify.dataset.state).toBe('active');

    verify.click();
    await vi.waitFor(() => {
      expect(status.textContent).toContain(
        'Verified with retained items: 1 unmanaged resource.',
      );
    });
    expect(stages.verify.dataset.state).toBe('done');
    expect(
      sandboxMessages.filter(
        (message) => (message as { type: string }).type.startsWith('write-'),
      ),
    ).toEqual([]);
    expect(fetch.mock.calls.map(([request]) => String(request))).toEqual([
      'http://localhost:8787/sync/plan',
      'http://localhost:8787/sync/apply',
      'http://localhost:8787/sync/verify',
    ]);
  });
});

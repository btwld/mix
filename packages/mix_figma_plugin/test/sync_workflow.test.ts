import { describe, expect, it, vi } from 'vitest';

import { SyncWorkflowSession } from '../src/ui/sync_workflow';
import type {
  FigmaTokenWriteResult,
  PullTokensPayload,
  PushTokensPayload,
  SyncApplyResponse,
  SyncPlanResponse,
  SyncVerificationReport,
  UiToSandboxMessage,
} from '../src/types';

const currentTokens: PullTokensPayload = {
  variables: { version: 1, collections: [], variables: [] },
  styles: {
    version: 1,
    textStyles: [],
    effectStyles: [],
    paintStyles: [],
  },
};

const desiredTokens: PushTokensPayload = {
  variables: { version: 1, collections: [], variables: [] },
  styles: { version: 1, textStyles: [], effectStyles: [] },
};

const operation = {
  action: 'create' as const,
  kind: 'collection',
  ref: 'Mix Tokens',
  name: 'Mix Tokens',
  path: '/variables/collections/Mix Tokens',
  destructive: false,
  changes: ['collection'],
  diagnostics: [],
};

const planResponse: SyncPlanResponse = {
  plan: {
    schema: 'mix_figma/sync-plan/v1',
    version: 1,
    id: 'plan:tokens',
    direction: 'mixToFigma',
    resource: 'tokens',
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
    operations: [operation],
    diagnostics: [],
  },
  payload: desiredTokens,
};

const applyResponse: SyncApplyResponse = {
  status: 'approved',
  plan: planResponse.plan,
  payload: desiredTokens,
  allowDeletes: false,
  appliedOperations: [operation],
};

const writeResult: FigmaTokenWriteResult = {
  variables: { collections: {}, modes: {}, variables: {} },
  styles: { textStyles: {}, effectStyles: {}, paintStyles: {} },
};

const report: SyncVerificationReport = {
  schema: 'mix_figma/sync-report/v1',
  version: 1,
  planId: 'plan:tokens',
  direction: 'mixToFigma',
  resource: 'tokens',
  status: 'verified',
  remainingMutations: 0,
  pendingDeletes: 0,
  diagnostics: [],
};

describe('SyncWorkflowSession', () => {
  it('executes token push as Analyze, Apply, then explicit read-back Verify', async () => {
    const bridge = {
      planSync: vi.fn(async () => planResponse),
      applySync: vi.fn(async () => applyResponse),
      verifySync: vi.fn(async () => report),
    };
    const messages: UiToSandboxMessage[] = [];
    let readCount = 0;
    const sandbox = vi.fn(async (message: UiToSandboxMessage) => {
      messages.push(message);
      if (message.type === 'read-tokens') {
        readCount += 1;
        return currentTokens;
      }
      if (message.type === 'write-tokens') return writeResult;
      throw new Error(`Unexpected ${message.type}`);
    });
    const session = new SyncWorkflowSession(bridge, sandbox);

    await session.analyze('tokens-push');
    expect(session.state.phase).toBe('analyzed');
    expect(bridge.planSync).toHaveBeenCalledWith({
      version: 1,
      direction: 'mixToFigma',
      resource: 'tokens',
      current: currentTokens,
    });

    await session.apply(false);
    expect(session.state.phase).toBe('applied');
    expect(messages[2]).toMatchObject({
      type: 'write-tokens',
      payload: desiredTokens,
      operations: [operation],
    });
    expect(readCount).toBe(2);

    await session.verify();
    expect(readCount).toBe(3);
    expect(bridge.verifySync).toHaveBeenCalledWith({
      planId: 'plan:tokens',
      current: currentTokens,
      writeResult,
    });
    expect(session.state).toMatchObject({ phase: 'verified', report });
  });

  it('re-reads Figma immediately before Apply so the bridge can reject stale plans', async () => {
    const changedTokens: PullTokensPayload = {
      ...currentTokens,
      variables: {
        version: 1,
        collections: [
          {
            id: 'VariableCollection:changed',
            key: 'changed',
            name: 'Changed',
            defaultModeId: 'mode:changed',
            modes: [{ modeId: 'mode:changed', name: 'Changed' }],
            remote: false,
            hiddenFromPublishing: false,
            variableIds: [],
            pluginData: {},
          },
        ],
        variables: [],
      },
    };
    const bridge = {
      planSync: vi.fn(async () => planResponse),
      applySync: vi.fn(async () => applyResponse),
      verifySync: vi.fn(async () => report),
    };
    let readCount = 0;
    const sandbox = vi.fn(async (message: UiToSandboxMessage) => {
      if (message.type === 'read-tokens') {
        readCount += 1;
        return readCount === 1 ? currentTokens : changedTokens;
      }
      if (message.type === 'write-tokens') return writeResult;
      throw new Error(`Unexpected ${message.type}`);
    });
    const session = new SyncWorkflowSession(bridge, sandbox);

    await session.analyze('tokens-push');
    await session.apply(false);

    expect(bridge.applySync).toHaveBeenCalledWith({
      planId: planResponse.plan.id,
      allowDeletes: false,
      current: changedTokens,
    });
  });

  it('does not mutate Figma when the bridge rejects a stale plan', async () => {
    const bridge = {
      planSync: vi.fn(async () => planResponse),
      applySync: vi.fn(async () => {
        throw new Error('HTTP 409: stale plan; analyze again');
      }),
      verifySync: vi.fn(async () => report),
    };
    const sandbox = vi.fn(async (message: UiToSandboxMessage) => {
      if (message.type === 'read-tokens') return currentTokens;
      throw new Error(`Unexpected ${message.type}`);
    });
    const session = new SyncWorkflowSession(bridge, sandbox);

    await session.analyze('tokens-push');
    await expect(session.apply(false)).rejects.toThrow('HTTP 409');

    expect(
      sandbox.mock.calls.filter(
        ([message]) => (message as UiToSandboxMessage).type === 'write-tokens',
      ),
    ).toHaveLength(0);
    expect(session.state.phase).toBe('analyzed');
    expect(bridge.verifySync).not.toHaveBeenCalled();
  });

  it('rejects operations that were not present in Preview before writing Figma', async () => {
    const unpreviewedDelete = {
      ...operation,
      action: 'delete' as const,
      ref: 'colors/legacy',
      sourceId: 'Variable:legacy',
      name: 'Legacy',
      destructive: true,
      changes: ['delete'],
    };
    const bridge = {
      planSync: vi.fn(async () => planResponse),
      applySync: vi.fn(async () => ({
        ...applyResponse,
        appliedOperations: [operation, unpreviewedDelete],
      })),
      verifySync: vi.fn(async () => report),
    };
    const sandbox = vi.fn(async (message: UiToSandboxMessage) => {
      if (message.type === 'read-tokens') return currentTokens;
      if (message.type === 'write-tokens') return writeResult;
      throw new Error(`Unexpected ${message.type}`);
    });
    const session = new SyncWorkflowSession(bridge, sandbox);

    await session.analyze('tokens-push');
    await expect(session.apply(false)).rejects.toThrow(
      'does not match the analyzed Preview',
    );

    expect(
      sandbox.mock.calls.filter(
        ([message]) => (message as UiToSandboxMessage).type === 'write-tokens',
      ),
    ).toHaveLength(0);
  });

  it('imports a selection without issuing a Figma mutation', async () => {
    const selection = {
      nodes: {
        version: 1 as const,
        pageId: 'page:1',
        pageName: 'Page',
        selection: [],
        diagnostics: [],
      },
      variables: currentTokens.variables,
    };
    const selectionPlan: SyncPlanResponse = {
      plan: {
        ...planResponse.plan,
        id: 'plan:selection',
        direction: 'figmaToMix',
        resource: 'selection',
      },
    };
    const selectionApply: SyncApplyResponse = {
      status: 'applied',
      plan: selectionPlan.plan,
      appliedOperations: selectionPlan.plan.operations,
    };
    const selectionReport: SyncVerificationReport = {
      ...report,
      planId: 'plan:selection',
      direction: 'figmaToMix',
      resource: 'selection',
    };
    const bridge = {
      planSync: vi.fn(async () => selectionPlan),
      applySync: vi.fn(async () => selectionApply),
      verifySync: vi.fn(async () => selectionReport),
    };
    const sandbox = vi.fn(async () => selection);
    const session = new SyncWorkflowSession(bridge, sandbox);

    await session.analyze('selection-pull');
    await session.apply(false);
    await session.verify();

    expect(sandbox).toHaveBeenCalledTimes(2);
    expect(sandbox).toHaveBeenNthCalledWith(
      1,
      expect.objectContaining({ type: 'read-selection' }),
    );
    expect(sandbox).toHaveBeenNthCalledWith(
      2,
      expect.objectContaining({ type: 'read-selection' }),
    );
    expect(bridge.verifySync).toHaveBeenCalledWith({
      planId: 'plan:selection',
    });
  });
});

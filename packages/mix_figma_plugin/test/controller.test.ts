import { describe, expect, it, vi } from 'vitest';

import { createPluginController } from '../src/controller';
import type { PushTokensPayload } from '../src/types';

const emptyPushTokens: PushTokensPayload = {
  variables: { version: 1, collections: [], variables: [] },
  styles: { version: 1, textStyles: [], effectStyles: [] },
};

describe('plugin controller', () => {
  it('routes sandbox requests and posts correlated results', async () => {
    const postMessage = vi.fn();
    const api = {
      currentPage: { id: 'page:1', name: 'Page', selection: [] },
      loadAllPagesAsync: async () => undefined,
      root: { findAllWithCriteria: () => [] },
      commitUndo: vi.fn(),
      triggerUndo: vi.fn(),
      variables: {
        getLocalVariableCollectionsAsync: async () => [],
        getLocalVariablesAsync: async () => [],
      },
      getLocalTextStylesAsync: async () => [],
      getLocalEffectStylesAsync: async () => [],
      getLocalPaintStylesAsync: async () => [],
      closePlugin: vi.fn(),
    } as unknown as PluginAPI;
    const controller = createPluginController(api, postMessage);

    await controller.handleMessage({ type: 'read-tokens', requestId: 'tokens' });
    await controller.handleMessage({ type: 'read-selection', requestId: 'selection' });
    await controller.handleMessage({
      type: 'read-component-set',
      requestId: 'component',
      componentRef: 'button',
    });
    await controller.handleMessage({ type: 'write-tokens', requestId: 'write', payload: emptyPushTokens });
    await controller.handleMessage({ type: 'close-plugin', requestId: 'close' });

    expect(postMessage).toHaveBeenCalledWith({
      type: 'operation-result',
      requestId: 'tokens',
      payload: {
        variables: { version: 1, collections: [], variables: [] },
        styles: { version: 1, textStyles: [], effectStyles: [], paintStyles: [] },
      },
    });
    expect(postMessage).toHaveBeenCalledWith({
      type: 'operation-result',
      requestId: 'selection',
      payload: {
        nodes: expect.objectContaining({ version: 1, selection: [] }),
        variables: { version: 1, collections: [], variables: [] },
      },
    });
    expect(postMessage).toHaveBeenCalledWith({
      type: 'operation-result',
      requestId: 'write',
      payload: {
        variables: { collections: {}, modes: {}, variables: {} },
        styles: { textStyles: {}, effectStyles: {}, paintStyles: {} },
      },
    });
    expect(postMessage).toHaveBeenCalledWith({
      type: 'operation-result',
      requestId: 'component',
      payload: { componentSet: null },
    });
    expect(api.closePlugin).toHaveBeenCalledOnce();
    expect(api.commitUndo).toHaveBeenCalledTimes(2);
    expect(api.triggerUndo).not.toHaveBeenCalled();
  });

  it('writes token resources sequentially inside one undo boundary', async () => {
    let releaseCollections: ((value: VariableCollection[]) => void) | undefined;
    const collections = new Promise<VariableCollection[]>((resolve) => {
      releaseCollections = resolve;
    });
    const getLocalTextStylesAsync = vi.fn(async () => []);
    const api = {
      commitUndo: vi.fn(),
      triggerUndo: vi.fn(),
      variables: {
        getLocalVariableCollectionsAsync: vi.fn(() => collections),
        getLocalVariablesAsync: async () => [],
      },
      getLocalTextStylesAsync,
      getLocalEffectStylesAsync: async () => [],
      getLocalPaintStylesAsync: async () => [],
    } as unknown as PluginAPI;
    const postMessage = vi.fn();
    const controller = createPluginController(api, postMessage);

    const operation = controller.handleMessage({
      type: 'write-tokens',
      requestId: 'write',
      payload: emptyPushTokens,
    });
    await vi.waitFor(() => {
      expect(api.variables.getLocalVariableCollectionsAsync).toHaveBeenCalledOnce();
    });
    expect(getLocalTextStylesAsync).not.toHaveBeenCalled();

    releaseCollections?.([]);
    await operation;

    expect(getLocalTextStylesAsync).toHaveBeenCalledOnce();
    expect(api.commitUndo).toHaveBeenCalledTimes(2);
    expect(api.triggerUndo).not.toHaveBeenCalled();
  });

  it('undoes the whole token write when a later resource fails', async () => {
    const api = {
      commitUndo: vi.fn(),
      triggerUndo: vi.fn(),
      variables: {
        getLocalVariableCollectionsAsync: async () => [],
        getLocalVariablesAsync: async () => [],
      },
      getLocalTextStylesAsync: async () => {
        throw new Error('style write failed');
      },
      getLocalEffectStylesAsync: async () => [],
      getLocalPaintStylesAsync: async () => [],
    } as unknown as PluginAPI;
    const postMessage = vi.fn();
    const controller = createPluginController(api, postMessage);

    await controller.handleMessage({
      type: 'write-tokens',
      requestId: 'write',
      payload: emptyPushTokens,
    });

    expect(api.commitUndo).toHaveBeenCalledOnce();
    expect(api.triggerUndo).toHaveBeenCalledOnce();
    expect(postMessage).toHaveBeenCalledWith({
      type: 'operation-error',
      requestId: 'write',
      error: 'style write failed',
    });
  });

  it('converts thrown values into correlated operation errors', async () => {
    const postMessage = vi.fn();
    const api = {
      variables: {
        getLocalVariableCollectionsAsync: async () => { throw new Error('denied'); },
        getLocalVariablesAsync: async () => [],
      },
      getLocalTextStylesAsync: async () => [],
      getLocalEffectStylesAsync: async () => [],
      getLocalPaintStylesAsync: async () => [],
    } as unknown as PluginAPI;
    const controller = createPluginController(api, postMessage);

    await controller.handleMessage({ type: 'read-tokens', requestId: 'failed' });

    expect(postMessage).toHaveBeenCalledWith({
      type: 'operation-error',
      requestId: 'failed',
      error: 'denied',
    });
  });
});

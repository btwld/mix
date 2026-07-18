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
      payload: expect.objectContaining({ version: 1, selection: [] }),
    });
    expect(postMessage).toHaveBeenCalledWith({
      type: 'operation-result',
      requestId: 'write',
      payload: {
        variables: { collections: {}, modes: {}, variables: {} },
        styles: { textStyles: {}, effectStyles: {}, paintStyles: {} },
      },
    });
    expect(api.closePlugin).toHaveBeenCalledOnce();
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

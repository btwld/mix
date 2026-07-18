import { describe, expect, it, vi } from 'vitest';

import { postToSandbox, sandboxMessageFromEvent } from '../src/ui/messages';

describe('UI message envelope', () => {
  it('posts UiToSandbox messages in Figma\'s pluginMessage envelope', () => {
    const target = { postMessage: vi.fn() };
    const message = { type: 'read-selection', requestId: 'request:1' } as const;

    postToSandbox(message, target);

    expect(target.postMessage).toHaveBeenCalledWith({ pluginMessage: message }, '*');
  });

  it('extracts only structurally valid SandboxToUi messages', () => {
    const result = { type: 'operation-result', requestId: 'request:1', payload: { ok: true } } as const;

    expect(sandboxMessageFromEvent({ data: { pluginMessage: result } } as MessageEvent<unknown>)).toEqual(result);
    expect(sandboxMessageFromEvent({ data: { pluginMessage: { type: 'unknown' } } } as MessageEvent<unknown>)).toBeUndefined();
    expect(sandboxMessageFromEvent({ data: null } as MessageEvent<unknown>)).toBeUndefined();
  });
});

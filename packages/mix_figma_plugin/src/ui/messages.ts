import type { SandboxToUiMessage, UiToSandboxMessage } from '../types';

export interface ParentMessageTarget {
  postMessage(message: unknown, targetOrigin: string): void;
}

export function postToSandbox(
  message: UiToSandboxMessage,
  target: ParentMessageTarget = parent,
): void {
  target.postMessage({ pluginMessage: message }, '*');
}

export function sandboxMessageFromEvent(event: MessageEvent<unknown>): SandboxToUiMessage | undefined {
  if (!isRecord(event.data)) return undefined;
  const message = event.data.pluginMessage;
  if (!isRecord(message) || typeof message.type !== 'string') return undefined;

  switch (message.type) {
    case 'plugin-ready':
      return { type: 'plugin-ready' };
    case 'operation-result':
      if (typeof message.requestId !== 'string' || !('payload' in message)) return undefined;
      return { type: 'operation-result', requestId: message.requestId, payload: message.payload };
    case 'operation-error':
      if (typeof message.requestId !== 'string' || typeof message.error !== 'string') return undefined;
      return { type: 'operation-error', requestId: message.requestId, error: message.error };
    default:
      return undefined;
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

import { DevBridgeClient } from '../bridge/dev_bridge_client';
import type {
  FigmaSelectionDocument,
  PullTokensPayload,
  SandboxToUiMessage,
  UiToSandboxMessage,
} from '../types';
import { postToSandbox, sandboxMessageFromEvent } from './messages';

const bridge = new DevBridgeClient();
const pending = new Map<string, (message: SandboxToUiMessage) => void>();

function request(message: UiToSandboxMessage): Promise<SandboxToUiMessage> {
  return new Promise((resolve) => {
    pending.set(message.requestId, resolve);
    postToSandbox(message);
  });
}

window.addEventListener('message', (event) => {
  const message = sandboxMessageFromEvent(event);
  if (message === undefined || !('requestId' in message)) return;
  pending.get(message.requestId)?.(message);
  pending.delete(message.requestId);
});

function requestId(): string {
  return `${Date.now()}-${Math.random().toString(36).slice(2)}`;
}

async function run(action: () => Promise<string>): Promise<void> {
  const status = document.querySelector<HTMLElement>('#status');
  if (status === null) return;
  status.textContent = 'Working…';
  try {
    status.textContent = await action();
  } catch (error) {
    status.textContent = error instanceof Error ? error.message : String(error);
  }
}

document.querySelector('#health')?.addEventListener('click', () => {
  void run(async () => `Bridge: ${(await bridge.health()).status}`);
});

document.querySelector('#pull-tokens')?.addEventListener('click', () => {
  void run(async () => {
    const response = await request({ type: 'read-tokens', requestId: requestId() });
    if (response.type === 'operation-error') throw new Error(response.error);
    if (response.type !== 'operation-result') throw new Error('Unexpected plugin response.');
    if (!isPullTokensPayload(response.payload)) throw new Error('Plugin returned an invalid token payload.');
    await bridge.pullTokens(response.payload);
    return 'Tokens pulled into Mix.';
  });
});

document.querySelector('#push-tokens')?.addEventListener('click', () => {
  void run(async () => {
    const payload = await bridge.pushTokens();
    const response = await request({ type: 'write-tokens', requestId: requestId(), payload });
    if (response.type === 'operation-error') throw new Error(response.error);
    return 'Tokens written to Figma.';
  });
});

document.querySelector('#pull-selection')?.addEventListener('click', () => {
  void run(async () => {
    const response = await request({ type: 'read-selection', requestId: requestId() });
    if (response.type === 'operation-error') throw new Error(response.error);
    if (response.type !== 'operation-result') throw new Error('Unexpected plugin response.');
    if (!isSelectionDocument(response.payload)) throw new Error('Plugin returned an invalid selection payload.');
    await bridge.pullNodes({ nodes: response.payload });
    return 'Selection pulled into Mix.';
  });
});

document.querySelector('#push-component')?.addEventListener('click', () => {
  void run(async () => {
    const input = document.querySelector<HTMLInputElement>('#component-id');
    const componentId = input?.value.trim() ?? '';
    if (componentId.length === 0) throw new Error('Enter a component id.');
    const payload = await bridge.pushComponent(componentId);
    const response = await request({ type: 'write-component-set', requestId: requestId(), payload });
    if (response.type === 'operation-error') throw new Error(response.error);
    return `Component ${componentId} written to Figma.`;
  });
});

function isPullTokensPayload(value: unknown): value is PullTokensPayload {
  return (
    isRecord(value) &&
    isVersionOne(value.variables) &&
    Array.isArray(value.variables.collections) &&
    Array.isArray(value.variables.variables) &&
    isVersionOne(value.styles) &&
    Array.isArray(value.styles.textStyles) &&
    Array.isArray(value.styles.effectStyles) &&
    Array.isArray(value.styles.paintStyles)
  );
}

function isSelectionDocument(value: unknown): value is FigmaSelectionDocument {
  return (
    isVersionOne(value) &&
    typeof value.pageId === 'string' &&
    typeof value.pageName === 'string' &&
    Array.isArray(value.selection) &&
    Array.isArray(value.diagnostics)
  );
}

function isVersionOne(value: unknown): value is Record<string, unknown> {
  return isRecord(value) && value.version === 1;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

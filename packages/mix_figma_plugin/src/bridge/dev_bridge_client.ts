import type {
  BridgeHealth,
  ComponentSetWritePayload,
  PullNodesPayload,
  PullTokensPayload,
  PushTokensPayload,
} from '../types';

export type BridgeFetch = (input: RequestInfo | URL, init?: RequestInit) => Promise<Response>;

export class DevBridgeClient {
  readonly #baseUrl: string;
  readonly #fetch: BridgeFetch;

  public constructor(
    baseUrl = 'http://localhost:8787',
    fetchImplementation: BridgeFetch = globalThis.fetch.bind(globalThis),
  ) {
    this.#baseUrl = baseUrl.replace(/\/+$/, '');
    this.#fetch = fetchImplementation;
  }

  public async health(): Promise<BridgeHealth> {
    const value = await this.#request('GET', '/health');
    if (!isRecord(value) || typeof value.status !== 'string') {
      throw new Error('Mix bridge GET /health returned an invalid health payload.');
    }
    return value as BridgeHealth;
  }

  public pullTokens(payload: PullTokensPayload): Promise<unknown> {
    return this.#request('POST', '/pull/tokens', payload);
  }

  public async pushTokens(): Promise<PushTokensPayload> {
    const value = await this.#request('GET', '/push/tokens');
    if (!isPushTokensPayload(value)) {
      throw new Error('Mix bridge GET /push/tokens returned an invalid token payload.');
    }
    return value;
  }

  public pullNodes(payload: PullNodesPayload): Promise<unknown> {
    return this.#request('POST', '/pull/nodes', payload);
  }

  public async pushComponent(componentId: string): Promise<ComponentSetWritePayload> {
    const path = `/push/components/${encodeURIComponent(componentId)}`;
    const value = await this.#request('GET', path);
    if (!isComponentSetWritePayload(value)) {
      throw new Error(`Mix bridge GET ${path} returned an invalid component payload.`);
    }
    return value;
  }

  async #request(method: 'GET' | 'POST', path: string, body?: unknown): Promise<unknown> {
    const init: RequestInit = { method };
    if (body !== undefined) {
      init.body = JSON.stringify(body);
      init.headers = { 'content-type': 'application/json' };
    }

    const response = await this.#fetch(`${this.#baseUrl}${path}`, init);
    if (!response.ok) {
      const responseBody = (await response.text()).trim();
      const suffix = responseBody.length === 0 ? '' : `: ${responseBody}`;
      throw new Error(`Mix bridge ${method} ${path} failed with ${response.status}${suffix}`);
    }
    if (response.status === 204) return undefined;

    const responseText = await response.text();
    if (responseText.trim().length === 0) return undefined;
    try {
      return JSON.parse(responseText) as unknown;
    } catch {
      throw new Error(`Mix bridge ${method} ${path} returned invalid JSON.`);
    }
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function isVersionOneDocument(value: unknown): value is Record<string, unknown> {
  return isRecord(value) && value.version === 1;
}

function isPushTokensPayload(value: unknown): value is PushTokensPayload {
  return (
    isRecord(value) &&
    isVersionOneDocument(value.variables) &&
    Array.isArray(value.variables.collections) &&
    Array.isArray(value.variables.variables) &&
    isVersionOneDocument(value.styles) &&
    Array.isArray(value.styles.textStyles) &&
    Array.isArray(value.styles.effectStyles)
  );
}

function isComponentSetWritePayload(value: unknown): value is ComponentSetWritePayload {
  return (
    isVersionOneDocument(value) &&
    typeof value.ref === 'string' &&
    typeof value.name === 'string' &&
    Array.isArray(value.variants)
  );
}

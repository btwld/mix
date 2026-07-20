import type {
  BridgeHealth,
  SyncApplyRequest,
  SyncApplyResponse,
  SyncPlanRequest,
  SyncPlanResponse,
  SyncVerificationReport,
  SyncVerifyRequest,
} from '../types';

export type BridgeFetch = (input: RequestInfo | URL, init?: RequestInit) => Promise<Response>;

export class DevBridgeClient {
  readonly #baseUrl: string;
  readonly #fetch: BridgeFetch;
  #authToken = '';

  public constructor(
    baseUrl = 'http://localhost:8787',
    fetchImplementation: BridgeFetch = globalThis.fetch.bind(globalThis),
  ) {
    this.#baseUrl = baseUrl.replace(/\/+$/, '');
    this.#fetch = fetchImplementation;
  }

  public setAuthToken(value: string): void {
    this.#authToken = value.trim();
  }

  public async health(): Promise<BridgeHealth> {
    const value = await this.#request('GET', '/health');
    if (!isRecord(value) || typeof value.status !== 'string') {
      throw new Error('Mix bridge GET /health returned an invalid health payload.');
    }
    return value as BridgeHealth;
  }

  public async planSync(request: SyncPlanRequest): Promise<SyncPlanResponse> {
    const value = await this.#request('POST', '/sync/plan', request);
    if (!isSyncPlanResponse(value)) {
      throw new Error('Mix bridge POST /sync/plan returned an invalid sync plan.');
    }
    return value;
  }

  public async applySync(request: SyncApplyRequest): Promise<SyncApplyResponse> {
    const value = await this.#request('POST', '/sync/apply', request);
    if (!isSyncApplyResponse(value)) {
      throw new Error('Mix bridge POST /sync/apply returned an invalid apply response.');
    }
    return value;
  }

  public async verifySync(request: SyncVerifyRequest): Promise<SyncVerificationReport> {
    const value = await this.#request('POST', '/sync/verify', request, [422]);
    if (!isSyncVerificationReport(value)) {
      throw new Error('Mix bridge POST /sync/verify returned an invalid verification report.');
    }
    return value;
  }

  async #request(
    method: 'GET' | 'POST',
    path: string,
    body?: unknown,
    acceptedErrorStatuses: readonly number[] = [],
  ): Promise<unknown> {
    const init: RequestInit = { method };
    const headers: Record<string, string> = {};
    if (this.#authToken.length > 0) {
      headers.authorization = `Bearer ${this.#authToken}`;
    }
    if (body !== undefined) {
      init.body = JSON.stringify(body);
      headers['content-type'] = 'application/json';
    }
    if (Object.keys(headers).length > 0) init.headers = headers;

    const response = await this.#fetch(`${this.#baseUrl}${path}`, init);
    if (!response.ok && !acceptedErrorStatuses.includes(response.status)) {
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

function isSyncPlanResponse(value: unknown): value is SyncPlanResponse {
  return isRecord(value) && isSyncPlan(value.plan);
}

function isSyncApplyResponse(value: unknown): value is SyncApplyResponse {
  return (
    isRecord(value) &&
    (value.status === 'applied' || value.status === 'approved') &&
    isSyncPlan(value.plan) &&
    Array.isArray(value.appliedOperations)
  );
}

function isSyncVerificationReport(value: unknown): value is SyncVerificationReport {
  return (
    isRecord(value) &&
    value.schema === 'mix_figma/sync-report/v1' &&
    value.version === 1 &&
    typeof value.planId === 'string' &&
    (value.status === 'failed' ||
      value.status === 'verified' ||
      value.status === 'verifiedWithRetainedItems') &&
    typeof value.remainingMutations === 'number' &&
    typeof value.pendingDeletes === 'number' &&
    Array.isArray(value.diagnostics)
  );
}

function isSyncPlan(value: unknown): boolean {
  return (
    isRecord(value) &&
    value.schema === 'mix_figma/sync-plan/v1' &&
    value.version === 1 &&
    typeof value.id === 'string' &&
    Array.isArray(value.operations) &&
    isRecord(value.summary) &&
    Array.isArray(value.diagnostics)
  );
}

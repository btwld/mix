import type {
  ComponentSetWritePayload,
  ComponentSetWriteResult,
  ComponentSyncSnapshot,
  FigmaTokenWriteResult,
  MixFigmaSyncPlan,
  PullNodesPayload,
  PullTokensPayload,
  PushTokensPayload,
  SyncApplyRequest,
  SyncApplyResponse,
  SyncPlanRequest,
  SyncPlanResponse,
  SyncVerificationReport,
  SyncVerifyRequest,
  UiToSandboxMessage,
} from '../types';

export type SyncWorkflowId =
  | 'component-push'
  | 'selection-pull'
  | 'tokens-pull'
  | 'tokens-push';

export type SyncWorkflowPhase = 'analyzed' | 'applied' | 'idle' | 'verified';

export interface SyncWorkflowState {
  readonly phase: SyncWorkflowPhase;
  readonly workflow?: SyncWorkflowId;
  readonly plan?: MixFigmaSyncPlan;
  readonly applyResponse?: SyncApplyResponse;
  readonly report?: SyncVerificationReport;
}

export interface SyncBridge {
  planSync(request: SyncPlanRequest): Promise<SyncPlanResponse>;
  applySync(request: SyncApplyRequest): Promise<SyncApplyResponse>;
  verifySync(request: SyncVerifyRequest): Promise<SyncVerificationReport>;
}

export type SandboxRequest = (message: UiToSandboxMessage) => Promise<unknown>;

interface PreparedSync {
  readonly workflow: SyncWorkflowId;
  readonly componentId?: string;
  readonly current: unknown;
  readonly response: SyncPlanResponse;
}

interface AppliedSync {
  readonly response: SyncApplyResponse;
  readonly writeResult?: FigmaTokenWriteResult | ComponentSetWriteResult;
}

export class SyncWorkflowSession {
  readonly #bridge: SyncBridge;
  readonly #sandbox: SandboxRequest;
  #requestSequence = 0;
  #prepared: PreparedSync | undefined;
  #applied: AppliedSync | undefined;
  #state: SyncWorkflowState = { phase: 'idle' };

  public constructor(bridge: SyncBridge, sandbox: SandboxRequest) {
    this.#bridge = bridge;
    this.#sandbox = sandbox;
  }

  public get state(): SyncWorkflowState {
    return this.#state;
  }

  public reset(): void {
    this.#prepared = undefined;
    this.#applied = undefined;
    this.#state = { phase: 'idle' };
  }

  public async analyze(
    workflow: SyncWorkflowId,
    componentId?: string,
  ): Promise<SyncPlanResponse> {
    const normalizedComponentId = componentId?.trim();
    if (workflow === 'component-push' && !normalizedComponentId) {
      throw new Error('Enter a component id before analyzing.');
    }
    const current = await this.#readCurrent(workflow, normalizedComponentId);
    const request = planRequest(workflow, current, normalizedComponentId);
    const response = await this.#bridge.planSync(request);
    this.#prepared = {
      workflow,
      current,
      response,
      ...(normalizedComponentId === undefined
        ? {}
        : { componentId: normalizedComponentId }),
    };
    this.#applied = undefined;
    this.#state = { phase: 'analyzed', workflow, plan: response.plan };

    return response;
  }

  public async apply(allowDeletes: boolean): Promise<SyncApplyResponse> {
    const prepared = this.#prepared;
    if (prepared === undefined) throw new Error('Analyze the workflow before applying it.');
    if (prepared.response.plan.summary.errors > 0) {
      throw new Error('Resolve plan errors before applying this workflow.');
    }
    const current = await this.#readCurrent(
      prepared.workflow,
      prepared.componentId,
    );
    const response = await this.#bridge.applySync({
      planId: prepared.response.plan.id,
      allowDeletes,
      current,
    });
    assertApplyMatchesPreview(prepared, response, allowDeletes);
    let writeResult: FigmaTokenWriteResult | ComponentSetWriteResult | undefined;
    if (prepared.workflow === 'tokens-push') {
      if (!isPushTokensPayload(response.payload)) {
        throw new Error('The bridge returned an invalid token write payload.');
      }
      const result = await this.#sandbox({
        type: 'write-tokens',
        requestId: this.#requestId(),
        payload: response.payload,
        operations: response.appliedOperations,
      });
      if (!isTokenWriteResult(result)) {
        throw new Error('Figma returned an invalid token write result.');
      }
      writeResult = result;
    } else if (prepared.workflow === 'component-push') {
      if (!isComponentSetWritePayload(response.payload)) {
        throw new Error('The bridge returned an invalid component payload.');
      }
      const result = await this.#sandbox({
        type: 'write-component-set',
        requestId: this.#requestId(),
        payload: response.payload,
        operations: response.appliedOperations,
      });
      if (!isComponentWriteResult(result)) {
        throw new Error('Figma returned an invalid component write result.');
      }
      writeResult = result;
    }
    this.#applied = {
      response,
      ...(writeResult === undefined ? {} : { writeResult }),
    };
    this.#state = {
      phase: 'applied',
      workflow: prepared.workflow,
      plan: prepared.response.plan,
      applyResponse: response,
    };

    return response;
  }

  public async verify(): Promise<SyncVerificationReport> {
    const prepared = this.#prepared;
    const applied = this.#applied;
    if (prepared === undefined || applied === undefined) {
      throw new Error('Apply the analyzed workflow before verifying it.');
    }
    const request: SyncVerifyRequest = isFigmaWrite(prepared.workflow)
      ? {
          planId: prepared.response.plan.id,
          current: await this.#readCurrent(
            prepared.workflow,
            prepared.componentId,
          ),
          writeResult: applied.writeResult,
        }
      : { planId: prepared.response.plan.id };
    const report = await this.#bridge.verifySync(request);
    this.#state = {
      phase: 'verified',
      workflow: prepared.workflow,
      plan: prepared.response.plan,
      applyResponse: applied.response,
      report,
    };

    return report;
  }

  async #readCurrent(
    workflow: SyncWorkflowId,
    componentId?: string,
  ): Promise<unknown> {
    if (workflow === 'tokens-pull' || workflow === 'tokens-push') {
      const value = await this.#sandbox({
        type: 'read-tokens',
        requestId: this.#requestId(),
      });
      if (!isPullTokensPayload(value)) {
        throw new Error('Figma returned an invalid token snapshot.');
      }
      return value;
    }
    if (workflow === 'selection-pull') {
      const value = await this.#sandbox({
        type: 'read-selection',
        requestId: this.#requestId(),
      });
      if (!isPullNodesPayload(value)) {
        throw new Error('Figma returned an invalid selection snapshot.');
      }
      return value;
    }
    if (!componentId) throw new Error('Enter a component id before analyzing.');
    const value = await this.#sandbox({
      type: 'read-component-set',
      requestId: this.#requestId(),
      componentRef: componentId,
    });
    if (!isComponentSyncSnapshot(value)) {
      throw new Error('Figma returned an invalid component-set snapshot.');
    }
    return value;
  }

  #requestId(): string {
    this.#requestSequence += 1;
    return `sync-${Date.now()}-${this.#requestSequence}`;
  }
}

function planRequest(
  workflow: SyncWorkflowId,
  current: unknown,
  componentId?: string,
): SyncPlanRequest {
  switch (workflow) {
    case 'tokens-pull':
      return { version: 1, direction: 'figmaToMix', resource: 'tokens', current };
    case 'tokens-push':
      return { version: 1, direction: 'mixToFigma', resource: 'tokens', current };
    case 'selection-pull':
      return { version: 1, direction: 'figmaToMix', resource: 'selection', current };
    case 'component-push':
      if (!componentId) throw new Error('Enter a component id before analyzing.');
      return {
        version: 1,
        direction: 'mixToFigma',
        resource: 'component',
        current,
        componentId,
      };
  }
}

function isFigmaWrite(workflow: SyncWorkflowId): boolean {
  return workflow === 'tokens-push' || workflow === 'component-push';
}

function assertApplyMatchesPreview(
  prepared: PreparedSync,
  response: SyncApplyResponse,
  allowDeletes: boolean,
): void {
  const expectedStatus = isFigmaWrite(prepared.workflow) ? 'approved' : 'applied';
  const expectedOperations = prepared.response.plan.operations.filter(
    (operation) => allowDeletes || !operation.destructive,
  );
  const matches =
    response.status === expectedStatus &&
    sameJson(response.plan, prepared.response.plan) &&
    sameJson(response.appliedOperations, expectedOperations) &&
    (response.allowDeletes === undefined || response.allowDeletes === allowDeletes) &&
    (!isFigmaWrite(prepared.workflow) ||
      (response.allowDeletes === allowDeletes &&
        sameJson(response.payload, prepared.response.payload)));
  if (!matches) {
    throw new Error(
      'The bridge Apply response does not match the analyzed Preview. Analyze again.',
    );
  }
}

function sameJson(left: unknown, right: unknown): boolean {
  return JSON.stringify(canonicalJson(left)) === JSON.stringify(canonicalJson(right));
}

function canonicalJson(value: unknown): unknown {
  if (Array.isArray(value)) return value.map(canonicalJson);
  if (!isRecord(value)) return value;
  return Object.fromEntries(
    Object.keys(value)
      .sort()
      .filter((key) => value[key] !== undefined)
      .map((key) => [key, canonicalJson(value[key])]),
  );
}

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

function isPullNodesPayload(value: unknown): value is PullNodesPayload {
  return (
    isRecord(value) &&
    isVersionOne(value.nodes) &&
    typeof value.nodes.pageId === 'string' &&
    Array.isArray(value.nodes.selection) &&
    Array.isArray(value.nodes.diagnostics) &&
    isVersionOne(value.variables)
  );
}

function isPushTokensPayload(value: unknown): value is PushTokensPayload {
  return (
    isRecord(value) &&
    isVersionOne(value.variables) &&
    Array.isArray(value.variables.collections) &&
    Array.isArray(value.variables.variables) &&
    isVersionOne(value.styles) &&
    Array.isArray(value.styles.textStyles) &&
    Array.isArray(value.styles.effectStyles)
  );
}

function isTokenWriteResult(value: unknown): value is FigmaTokenWriteResult {
  return (
    isRecord(value) &&
    isRecord(value.variables) &&
    isRecord(value.variables.collections) &&
    isRecord(value.variables.modes) &&
    isRecord(value.variables.variables) &&
    isRecord(value.styles) &&
    isRecord(value.styles.textStyles) &&
    isRecord(value.styles.effectStyles) &&
    isRecord(value.styles.paintStyles)
  );
}

function isComponentSetWritePayload(
  value: unknown,
): value is ComponentSetWritePayload {
  return (
    isVersionOne(value) &&
    typeof value.ref === 'string' &&
    typeof value.name === 'string' &&
    Array.isArray(value.variants)
  );
}

function isComponentWriteResult(value: unknown): value is ComponentSetWriteResult {
  return (
    isRecord(value) &&
    typeof value.componentSetId === 'string' &&
    isRecord(value.variants) &&
    Array.isArray(value.diagnostics)
  );
}

function isComponentSyncSnapshot(value: unknown): value is ComponentSyncSnapshot {
  if (!isRecord(value) || !('componentSet' in value)) return false;
  if (value.componentSet === null) return true;
  return (
    isRecord(value.componentSet) &&
    typeof value.componentSet.id === 'string' &&
    typeof value.componentSet.name === 'string' &&
    isRecord(value.componentSet.pluginData) &&
    Array.isArray(value.componentSet.variants)
  );
}

function isVersionOne(value: unknown): value is Record<string, unknown> {
  return isRecord(value) && value.version === 1;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

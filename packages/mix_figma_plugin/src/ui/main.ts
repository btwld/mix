import { DevBridgeClient } from '../bridge/dev_bridge_client';
import type {
  MixFigmaSyncOperation,
  SandboxToUiMessage,
  SyncVerificationReport,
  UiToSandboxMessage,
} from '../types';
import { postToSandbox, sandboxMessageFromEvent } from './messages';
import {
  SyncWorkflowSession,
  type SyncWorkflowId,
  type SyncWorkflowPhase,
} from './sync_workflow';

const bridge = new DevBridgeClient();
const pending = new Map<string, (message: SandboxToUiMessage) => void>();

function request(message: UiToSandboxMessage): Promise<unknown> {
  return new Promise((resolve, reject) => {
    pending.set(message.requestId, (response) => {
      if (response.type === 'operation-error') reject(new Error(response.error));
      else if (response.type === 'operation-result') resolve(response.payload);
      else reject(new Error('Figma returned an unexpected response.'));
    });
    postToSandbox(message);
  });
}

window.addEventListener('message', (event) => {
  const message = sandboxMessageFromEvent(event);
  if (message === undefined || !('requestId' in message)) return;
  pending.get(message.requestId)?.(message);
  pending.delete(message.requestId);
});

const session = new SyncWorkflowSession(bridge, request);
const bridgeToken = document.querySelector<HTMLInputElement>('#bridge-token');
const workflowSelect = document.querySelector<HTMLSelectElement>('#workflow');
const componentField = document.querySelector<HTMLElement>('#component-field');
const componentInput = document.querySelector<HTMLInputElement>('#component-id');
const analyzeButton = document.querySelector<HTMLButtonElement>('#analyze');
const applyButton = document.querySelector<HTMLButtonElement>('#apply');
const verifyButton = document.querySelector<HTMLButtonElement>('#verify');
const deleteControl = document.querySelector<HTMLElement>('#deletion-control');
const allowDeletes = document.querySelector<HTMLInputElement>('#allow-deletes');
const preview = document.querySelector<HTMLElement>('#preview');
const status = document.querySelector<HTMLElement>('#status');
const healthButton = document.querySelector<HTMLButtonElement>('#health');
let busy = false;

healthButton?.addEventListener('click', () => {
  void run('Checking bridge…', async () => {
    configureBridgeToken();
    const health = await bridge.health();
    return `Bridge ${health.status}. Ready to analyze.`;
  });
});

workflowSelect?.addEventListener('change', () => {
  session.reset();
  if (allowDeletes !== null) allowDeletes.checked = false;
  updateWorkflowFields();
  render();
});

analyzeButton?.addEventListener('click', () => {
  void run('Analyzing Figma and Mix…', async () => {
    configureBridgeToken();
    const workflow = selectedWorkflow();
    const response = await session.analyze(workflow, componentInput?.value);
    if (allowDeletes !== null) allowDeletes.checked = false;
    const mutations = mutationCount(response.plan.operations);
    return response.plan.summary.errors > 0
      ? `Analysis found ${response.plan.summary.errors} blocking error${plural(response.plan.summary.errors)}.`
      : `Preview ready: ${mutations} mutation${plural(mutations)}.`;
  });
});

applyButton?.addEventListener('click', () => {
  void run('Applying the approved plan…', async () => {
    configureBridgeToken();
    const response = await session.apply(allowDeletes?.checked === true);
    return response.status === 'approved'
      ? 'Applied in Figma. Read-back verification is required.'
      : 'Applied to Mix. Read-back verification is required.';
  });
});

verifyButton?.addEventListener('click', () => {
  void run('Reading back the result…', async () => {
    configureBridgeToken();
    const report = await session.verify();
    if (report.status === 'failed') {
      return `Verification failed: ${report.remainingMutations} mutation${plural(report.remainingMutations)} remain.`;
    }
    if (report.status === 'verifiedWithRetainedItems') {
      return retainedVerificationMessage(report);
    }
    return 'Verified. Figma and Mix match the approved plan.';
  });
});

async function run(workingMessage: string, action: () => Promise<string>): Promise<void> {
  busy = true;
  if (status !== null) {
    status.textContent = workingMessage;
    status.dataset.tone = 'working';
  }
  renderControls();
  try {
    const message = await action();
    if (status !== null) {
      status.textContent = message;
      status.dataset.tone = session.state.report?.status === 'failed' ? 'error' : 'neutral';
    }
  } catch (error) {
    if (status !== null) {
      status.textContent = error instanceof Error ? error.message : String(error);
      status.dataset.tone = 'error';
    }
  } finally {
    busy = false;
    render();
  }
}

function render(): void {
  renderControls();
  renderStages();
  renderPreview();
}

function renderControls(): void {
  const { phase, plan } = session.state;
  if (analyzeButton !== null) analyzeButton.disabled = busy;
  if (applyButton !== null) {
    applyButton.disabled = busy || phase !== 'analyzed' || (plan?.summary.errors ?? 0) > 0;
  }
  if (verifyButton !== null) verifyButton.disabled = busy || phase !== 'applied';
  const hasDeletes = (plan?.summary.delete ?? 0) > 0;
  if (deleteControl !== null) deleteControl.hidden = !hasDeletes;
  if (allowDeletes !== null) allowDeletes.disabled = busy || phase !== 'analyzed';
  if (workflowSelect !== null) workflowSelect.disabled = busy;
  if (componentInput !== null) componentInput.disabled = busy;
  if (bridgeToken !== null) bridgeToken.disabled = busy;
}

function configureBridgeToken(): void {
  const value = bridgeToken?.value.trim() ?? '';
  if (value.length === 0) {
    throw new Error('Paste the session token printed by the Mix Figma bridge.');
  }
  bridge.setAuthToken(value);
}

function renderStages(): void {
  const phase = session.state.phase;
  const order = stageStates(phase);
  for (const [stage, state] of Object.entries(order)) {
    const element = document.querySelector<HTMLElement>(`[data-stage="${stage}"]`);
    if (element !== null) element.dataset.state = state;
  }
  const verifyStage = document.querySelector<HTMLElement>('[data-stage="verify"]');
  if (verifyStage !== null && session.state.report?.status === 'failed') {
    verifyStage.dataset.state = 'error';
  }
}

function renderPreview(): void {
  if (preview === null) return;
  const { plan, report } = session.state;
  if (plan === undefined) {
    preview.textContent = [
      'No plan yet.',
      'Analyze reads both sides without changing either one.',
    ].join('\n');
    return;
  }
  const summary = plan.summary;
  const lines = [
    `PLAN ${plan.id.slice(0, 12)}  ${plan.direction} / ${plan.resource}`,
    `+${summary.create}  ~${summary.update + summary.rename}  −${summary.delete}  =${summary.unchanged}  ·${summary.skip}`,
    '',
    ...plan.operations.map(operationLine),
  ];
  const diagnostics = [
    ...plan.diagnostics,
    ...plan.operations.flatMap((operation) => operation.diagnostics),
  ];
  if (diagnostics.length > 0) {
    lines.push('', 'DIAGNOSTICS');
    lines.push(
      ...diagnostics.map(
        (diagnostic) =>
          `${diagnostic.severity.toUpperCase()} ${diagnostic.code} — ${diagnostic.message}`,
      ),
    );
  }
  if (report !== undefined) {
    lines.push(
      '',
      `VERIFY ${report.status.toUpperCase()}  remaining=${report.remainingMutations} retained=${retainedItemCount(report)}`,
    );
  }
  preview.textContent = lines.join('\n');
}

function updateWorkflowFields(): void {
  if (componentField !== null) {
    componentField.hidden = selectedWorkflow() !== 'component-push';
  }
}

function selectedWorkflow(): SyncWorkflowId {
  const value = workflowSelect?.value ?? 'tokens-pull';
  if (
    value === 'tokens-pull' ||
    value === 'tokens-push' ||
    value === 'selection-pull' ||
    value === 'component-push'
  ) {
    return value;
  }
  throw new Error('Choose a supported synchronization workflow.');
}

function mutationCount(operations: readonly MixFigmaSyncOperation[]): number {
  return operations.filter(
    (operation) => operation.action !== 'unchanged' && operation.action !== 'skip',
  ).length;
}

function operationLine(operation: MixFigmaSyncOperation): string {
  const marker = {
    create: '+',
    update: '~',
    rename: '→',
    delete: '−',
    unchanged: '=',
    skip: '·',
  }[operation.action];
  const source = operation.sourceId === undefined ? '' : `  [${operation.sourceId}]`;
  return `${marker} ${operation.kind.padEnd(16)} ${operation.name}${source}`;
}

function stageStates(
  phase: SyncWorkflowPhase,
): Readonly<Record<'analyze' | 'apply' | 'preview' | 'verify', string>> {
  switch (phase) {
    case 'idle':
      return { analyze: 'active', preview: 'pending', apply: 'pending', verify: 'pending' };
    case 'analyzed':
      return { analyze: 'done', preview: 'active', apply: 'pending', verify: 'pending' };
    case 'applied':
      return { analyze: 'done', preview: 'done', apply: 'done', verify: 'active' };
    case 'verified':
      return { analyze: 'done', preview: 'done', apply: 'done', verify: 'done' };
  }
}

function plural(value: number): string {
  return value === 1 ? '' : 's';
}

function retainedVerificationMessage(report: SyncVerificationReport): string {
  const parts: string[] = [];
  const unmanaged = unmanagedRetainedCount(report);
  if (unmanaged > 0) {
    parts.push(`${unmanaged} unmanaged resource${plural(unmanaged)}`);
  }
  if (report.pendingDeletes > 0) {
    parts.push(
      `${report.pendingDeletes} managed deletion${plural(report.pendingDeletes)}`,
    );
  }

  return parts.length === 0
    ? 'Verified with retained items.'
    : `Verified with retained items: ${parts.join(', ')}.`;
}

function retainedItemCount(report: SyncVerificationReport): number {
  return report.pendingDeletes + unmanagedRetainedCount(report);
}

function unmanagedRetainedCount(report: SyncVerificationReport): number {
  return report.diagnostics.filter(
    (diagnostic) => diagnostic.code === 'unmanaged_resource_preserved',
  ).length;
}

updateWorkflowFields();
render();

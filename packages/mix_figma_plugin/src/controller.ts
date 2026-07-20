import type { SandboxToUiMessage, UiToSandboxMessage } from './types';
import { readComponentSet } from './components/read_component_set';
import { writeComponentSet } from './components/write_component_set';
import { readSelection } from './nodes/read_selection';
import { readStyles } from './styles/read_styles';
import { writeStyles } from './styles/write_styles';
import { readVariables } from './variables/read_variables';
import { writeVariables } from './variables/write_variables';

export interface PluginController {
  handleMessage(message: UiToSandboxMessage): Promise<void>;
}

export type SandboxPostMessage = (message: SandboxToUiMessage) => void;

export function createPluginController(
  api: PluginAPI,
  postMessage: SandboxPostMessage,
): PluginController {
  return {
    async handleMessage(message) {
      try {
        switch (message.type) {
          case 'read-tokens': {
            const [variables, styles] = await Promise.all([readVariables(api), readStyles(api)]);
            postResult(postMessage, message.requestId, { variables, styles });
            return;
          }
          case 'read-selection': {
            const [nodes, variables] = await Promise.all([
              readSelection(api),
              readVariables(api),
            ]);
            postResult(postMessage, message.requestId, { nodes, variables });
            return;
          }
          case 'read-component-set':
            postResult(
              postMessage,
              message.requestId,
              await readComponentSet(api, message.componentRef),
            );
            return;
          case 'write-tokens': {
            const { variables, styles } = await inUndoTransaction(api, async () => {
              const options = message.operations === undefined ? {} : { operations: message.operations };
              const variables = await writeVariables(api, message.payload.variables, options);
              const styles = await writeStyles(api, message.payload.styles, options);
              return { variables, styles };
            });
            postResult(postMessage, message.requestId, { variables, styles });
            return;
          }
          case 'write-component-set':
            postResult(
              postMessage,
              message.requestId,
              await inUndoTransaction(api, () =>
                writeComponentSet(
                  api,
                  message.payload,
                  message.operations === undefined ? {} : { operations: message.operations },
                ),
              ),
            );
            return;
          case 'close-plugin':
            api.closePlugin();
            return;
        }
      } catch (error) {
        postMessage({
          type: 'operation-error',
          requestId: message.requestId,
          error: error instanceof Error ? error.message : String(error),
        });
      }
    },
  };
}

async function inUndoTransaction<T>(api: PluginAPI, action: () => Promise<T>): Promise<T> {
  api.commitUndo();
  try {
    const result = await action();
    api.commitUndo();
    return result;
  } catch (error) {
    api.triggerUndo();
    throw error;
  }
}

function postResult(postMessage: SandboxPostMessage, requestId: string, payload: unknown): void {
  postMessage({ type: 'operation-result', requestId, payload });
}

export function isUiToSandboxMessage(value: unknown): value is UiToSandboxMessage {
  if (!isRecord(value) || typeof value.type !== 'string' || typeof value.requestId !== 'string') return false;
  switch (value.type) {
    case 'read-tokens':
    case 'read-selection':
    case 'close-plugin':
      return true;
    case 'read-component-set':
      return typeof value.componentRef === 'string';
    case 'write-tokens':
    case 'write-component-set':
      return isRecord(value.payload);
    default:
      return false;
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

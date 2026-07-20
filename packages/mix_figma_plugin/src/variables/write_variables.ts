import { writePluginData } from '../plugin_data';
import {
  MIX_FIGMA_PLUGIN_DATA_KEYS,
  type FigmaVariableValue,
  type FigmaVariablesWritePayload,
  type FigmaVariablesWriteResult,
  type FigmaWriteOptions,
  type MixFigmaSyncOperation,
} from '../types';

export async function writeVariables(
  api: PluginAPI,
  payload: FigmaVariablesWritePayload,
  options: FigmaWriteOptions = {},
): Promise<FigmaVariablesWriteResult> {
  assertUniqueRefs('variable collection', payload.collections.map((collection) => collection.ref));
  assertUniqueRefs('variable', payload.variables.map((variable) => variable.ref));

  const [localCollections, localVariables] = await Promise.all([
    api.variables.getLocalVariableCollectionsAsync(),
    api.variables.getLocalVariablesAsync(),
  ]);
  const collectionObjects = new Map<string, VariableCollection>();
  const collectionIds: Record<string, string> = {};
  const modeIds: Record<string, Record<string, string>> = {};

  for (const collectionPayload of payload.collections) {
    if (collectionPayload.modes.length === 0) {
      throw new Error(`Variable collection "${collectionPayload.name}" must contain at least one mode.`);
    }

    const existingCollection = findCollection(localCollections, collectionPayload);
    const collection = existingCollection ??
      api.variables.createVariableCollection(collectionPayload.name);
    const collectionWasCreated = existingCollection === undefined;
    if (collection.remote) {
      throw new Error(`Cannot update remote variable collection "${collection.name}".`);
    }

    collection.name = collectionPayload.name;
    if (collectionPayload.hiddenFromPublishing !== undefined) {
      collection.hiddenFromPublishing = collectionPayload.hiddenFromPublishing;
    }
    writePluginData(collection, collectionPayload.pluginData, collectionPayload.identity);

    const resolvedModes: Record<string, string> = {};
    for (const [index, modePayload] of collectionPayload.modes.entries()) {
      const existingMode = collectionWasCreated
        ? undefined
        : modePayload.sourceId === undefined
          ? collection.modes.find((mode) => mode.name === modePayload.name)
          : collection.modes.find((mode) => mode.modeId === modePayload.sourceId);
      if (existingMode !== undefined) {
        if (existingMode.name !== modePayload.name) {
          collection.renameMode(existingMode.modeId, modePayload.name);
        }
        resolvedModes[modePayload.ref] = existingMode.modeId;
        continue;
      }

      if (!collectionWasCreated && modePayload.sourceId !== undefined) {
        throw new Error(
          `Source mode "${modePayload.sourceId}" was not found in collection "${collection.name}".`,
        );
      }

      if (collectionWasCreated && index === 0 && collection.modes.length === 1 && collection.modes[0]?.name === 'Mode 1') {
        const defaultMode = collection.modes[0];
        collection.renameMode(defaultMode.modeId, modePayload.name);
        resolvedModes[modePayload.ref] = defaultMode.modeId;
      } else {
        resolvedModes[modePayload.ref] = collection.addMode(modePayload.name);
      }
    }

    collectionObjects.set(collectionPayload.ref, collection);
    collectionIds[collectionPayload.ref] = collection.id;
    modeIds[collectionPayload.ref] = resolvedModes;
  }

  const variableObjects = new Map<string, Variable>();
  const variableIds: Record<string, string> = {};

  // Create/update every variable before assigning values so aliases may point
  // forward to another entry in the same payload.
  for (const variablePayload of payload.variables) {
    const collection = collectionObjects.get(variablePayload.collectionRef);
    if (collection === undefined) {
      throw new Error(
        `Variable "${variablePayload.name}" references unknown collection "${variablePayload.collectionRef}".`,
      );
    }

    const variable = findVariable(localVariables, variablePayload) ??
      api.variables.createVariable(variablePayload.name, collection, variablePayload.resolvedType);
    if (variable.remote) throw new Error(`Cannot update remote variable "${variable.name}".`);
    if (variable.resolvedType !== variablePayload.resolvedType) {
      throw new Error(
        `Variable "${variable.name}" is ${variable.resolvedType}, but the payload requires ${variablePayload.resolvedType}.`,
      );
    }
    if (variable.variableCollectionId !== collection.id) {
      throw new Error(`Variable "${variable.name}" belongs to a different collection.`);
    }

    variable.name = variablePayload.name;
    if (variablePayload.description !== undefined) variable.description = variablePayload.description;
    if (variablePayload.scopes !== undefined) variable.scopes = variablePayload.scopes.slice();
    if (variablePayload.hiddenFromPublishing !== undefined) {
      variable.hiddenFromPublishing = variablePayload.hiddenFromPublishing;
    }
    writePluginData(variable, variablePayload.pluginData, variablePayload.identity);

    if (variablePayload.codeSyntax !== undefined) {
      for (const platform of ['ANDROID', 'WEB', 'iOS'] as const) {
        const syntax = variablePayload.codeSyntax[platform];
        if (syntax === undefined) {
          if (variable.codeSyntax[platform] !== undefined) {
            variable.removeVariableCodeSyntax(platform);
          }
        }
        else variable.setVariableCodeSyntax(platform, syntax);
      }
    }

    variableObjects.set(variablePayload.ref, variable);
    variableIds[variablePayload.ref] = variable.id;
  }

  for (const variablePayload of payload.variables) {
    const variable = variableObjects.get(variablePayload.ref);
    if (variable === undefined) throw new Error(`Internal error resolving variable "${variablePayload.ref}".`);
    const resolvedModes = modeIds[variablePayload.collectionRef];
    if (resolvedModes === undefined) {
      throw new Error(`Internal error resolving collection "${variablePayload.collectionRef}".`);
    }

    for (const [modeRef, inputValue] of Object.entries(variablePayload.valuesByMode)) {
      const modeId = resolvedModes[modeRef];
      if (modeId === undefined) {
        throw new Error(`Variable "${variablePayload.name}" references unknown mode "${modeRef}".`);
      }
      variable.setValueForMode(modeId, await resolveVariableValue(api, inputValue, variableObjects));
    }
  }

  applyApprovedDeletes(localCollections, localVariables, options.operations ?? []);

  return { collections: collectionIds, modes: modeIds, variables: variableIds };
}

function applyApprovedDeletes(
  collections: readonly VariableCollection[],
  variables: readonly Variable[],
  operations: readonly MixFigmaSyncOperation[],
): void {
  for (const operation of approvedDeletes(operations, 'variable')) {
    const variable = variables.find((item) => item.id === operation.sourceId);
    if (variable === undefined) throw new Error(`Approved variable delete target "${operation.sourceId}" was not found.`);
    if (variable.remote) throw new Error(`Cannot delete remote variable "${variable.name}".`);
    assertOwned(variable, operation.ref, 'variable');
    variable.remove();
  }
  for (const operation of approvedDeletes(operations, 'mode')) {
    const collection = collections.find((item) => item.modes.some((mode) => mode.modeId === operation.sourceId));
    if (collection === undefined) throw new Error(`Approved mode delete target "${operation.sourceId}" was not found.`);
    if (collection.remote) throw new Error(`Cannot delete a mode from remote collection "${collection.name}".`);
    assertOwned(collection, undefined, 'mode');
    collection.removeMode(operation.sourceId as string);
  }
  for (const operation of approvedDeletes(operations, 'collection')) {
    const collection = collections.find((item) => item.id === operation.sourceId);
    if (collection === undefined) throw new Error(`Approved collection delete target "${operation.sourceId}" was not found.`);
    if (collection.remote) throw new Error(`Cannot delete remote collection "${collection.name}".`);
    assertOwned(collection, operation.ref, 'collection');
    collection.remove();
  }
}

function approvedDeletes(
  operations: readonly MixFigmaSyncOperation[],
  kind: string,
): Array<MixFigmaSyncOperation & { readonly sourceId: string }> {
  return operations
    .filter(
      (operation): operation is MixFigmaSyncOperation & { readonly sourceId: string } =>
        operation.action === 'delete' &&
        operation.destructive &&
        operation.kind === kind &&
        operation.sourceId !== undefined,
    );
}

function assertOwned(
  resource: Pick<PluginDataMixin, 'getPluginData'>,
  expectedIdentity: string | undefined,
  kind: string,
): void {
  const identity =
    resource.getPluginData(MIX_FIGMA_PLUGIN_DATA_KEYS.identity) ||
    resource.getPluginData('mix.key');
  if (identity.length === 0 || (expectedIdentity !== undefined && identity !== expectedIdentity)) {
    throw new Error(`Refusing to delete unowned ${kind}.`);
  }
}

function findCollection(
  collections: readonly VariableCollection[],
  payload: FigmaVariablesWritePayload['collections'][number],
): VariableCollection | undefined {
  return findManagedResource(collections, payload.sourceId, payload.identity?.id);
}

function findVariable(
  variables: readonly Variable[],
  payload: FigmaVariablesWritePayload['variables'][number],
): Variable | undefined {
  return findManagedResource(variables, payload.sourceId, payload.identity?.id);
}

function findManagedResource<T extends Pick<PluginDataMixin, 'getPluginData'> & { readonly id: string }>(
  resources: readonly T[],
  sourceId: string | undefined,
  expectedIdentity: string | undefined,
): T | undefined {
  if (expectedIdentity === undefined) return undefined;
  const bySourceId = sourceId === undefined
    ? undefined
    : resources.find((resource) => resource.id === sourceId);
  if (bySourceId !== undefined && managedIdentity(bySourceId) === expectedIdentity) {
    return bySourceId;
  }
  return resources.find((resource) => managedIdentity(resource) === expectedIdentity);
}

function managedIdentity(
  resource: Pick<PluginDataMixin, 'getPluginData'>,
): string {
  return (
    resource.getPluginData(MIX_FIGMA_PLUGIN_DATA_KEYS.identity) ||
    resource.getPluginData('mix.key')
  );
}

async function resolveVariableValue(
  api: PluginAPI,
  value: FigmaVariableValue,
  payloadVariables: ReadonlyMap<string, Variable>,
): Promise<VariableValue> {
  if (typeof value === 'boolean' || typeof value === 'number' || typeof value === 'string') return value;
  if (!('type' in value)) return value;

  const target = value.ref === undefined ? undefined : payloadVariables.get(value.ref);
  const variable = target ?? (value.id === undefined ? null : await api.variables.getVariableByIdAsync(value.id));
  if (variable === null || variable === undefined) {
    const reference = value.ref ?? value.id ?? '<missing>';
    throw new Error(`Variable alias target "${reference}" was not found.`);
  }
  return api.variables.createVariableAlias(variable);
}

function assertUniqueRefs(kind: string, refs: readonly string[]): void {
  const seen = new Set<string>();
  for (const ref of refs) {
    if (seen.has(ref)) throw new Error(`Duplicate ${kind} ref "${ref}".`);
    seen.add(ref);
  }
}

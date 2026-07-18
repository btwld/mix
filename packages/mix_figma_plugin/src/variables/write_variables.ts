import { writePluginData } from '../plugin_data';
import { MIX_FIGMA_PLUGIN_DATA_KEYS, type FigmaVariableValue, type FigmaVariablesWritePayload, type FigmaVariablesWriteResult } from '../types';

export async function writeVariables(
  api: PluginAPI,
  payload: FigmaVariablesWritePayload,
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

    const collection = findCollection(localCollections, collectionPayload) ??
      api.variables.createVariableCollection(collectionPayload.name);
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
      const existingMode = collection.modes.find(
        (mode) => mode.modeId === modePayload.sourceId || mode.name === modePayload.name,
      );
      if (existingMode !== undefined) {
        if (existingMode.name !== modePayload.name) {
          collection.renameMode(existingMode.modeId, modePayload.name);
        }
        resolvedModes[modePayload.ref] = existingMode.modeId;
        continue;
      }

      if (index === 0 && collection.modes.length === 1 && collection.modes[0]?.name === 'Mode 1') {
        const defaultMode = collection.modes[0];
        collection.renameMode(defaultMode.modeId, modePayload.name);
        resolvedModes[modePayload.ref] = defaultMode.modeId;
      } else {
        resolvedModes[modePayload.ref] = collection.addMode(modePayload.name);
      }
    }

    const desiredModeIds = new Set(Object.values(resolvedModes));
    for (const mode of collection.modes.slice()) {
      if (!desiredModeIds.has(mode.modeId)) collection.removeMode(mode.modeId);
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

    const variable = findVariable(localVariables, variablePayload, collection.id) ??
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
        if (syntax === undefined) variable.removeVariableCodeSyntax(platform);
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

  return { collections: collectionIds, modes: modeIds, variables: variableIds };
}

function findCollection(
  collections: readonly VariableCollection[],
  payload: FigmaVariablesWritePayload['collections'][number],
): VariableCollection | undefined {
  return collections.find(
    (collection) =>
      collection.id === payload.sourceId ||
      (payload.identity !== undefined &&
        collection.getPluginData(MIX_FIGMA_PLUGIN_DATA_KEYS.identity) === payload.identity.id) ||
      collection.name === payload.name,
  );
}

function findVariable(
  variables: readonly Variable[],
  payload: FigmaVariablesWritePayload['variables'][number],
  collectionId: string,
): Variable | undefined {
  return variables.find(
    (variable) =>
      variable.id === payload.sourceId ||
      (payload.identity !== undefined &&
        variable.getPluginData(MIX_FIGMA_PLUGIN_DATA_KEYS.identity) === payload.identity.id) ||
      (variable.variableCollectionId === collectionId && variable.name === payload.name),
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

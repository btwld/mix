import { readPluginData } from '../plugin_data';
import type {
  FigmaCodeSyntax,
  FigmaColorValue,
  FigmaVariableValue,
  FigmaVariablesDocument,
} from '../types';

export async function readVariables(api: PluginAPI): Promise<FigmaVariablesDocument> {
  const [localCollections, localVariables] = await Promise.all([
    api.variables.getLocalVariableCollectionsAsync(),
    api.variables.getLocalVariablesAsync(),
  ]);

  const collections = localCollections
    .slice()
    .sort(compareByNameAndId)
    .map((collection) => ({
      id: collection.id,
      key: collection.key,
      name: collection.name,
      defaultModeId: collection.defaultModeId,
      modes: collection.modes.map((mode) => ({ modeId: mode.modeId, name: mode.name })),
      remote: collection.remote,
      hiddenFromPublishing: collection.hiddenFromPublishing,
      variableIds: collection.variableIds.slice(),
      pluginData: readPluginData(collection),
    }));

  const variables = localVariables
    .slice()
    .sort(compareByNameAndId)
    .map((variable) => ({
      id: variable.id,
      key: variable.key,
      name: variable.name,
      description: variable.description,
      variableCollectionId: variable.variableCollectionId,
      resolvedType: variable.resolvedType,
      valuesByMode: Object.fromEntries(
        Object.entries(variable.valuesByMode)
          .sort(([left], [right]) => left.localeCompare(right))
          .map(([modeId, value]) => [modeId, serializeVariableValue(value)]),
      ),
      scopes: variable.scopes.slice(),
      codeSyntax: serializeCodeSyntax(variable.codeSyntax),
      remote: variable.remote,
      hiddenFromPublishing: variable.hiddenFromPublishing,
      pluginData: readPluginData(variable),
    }));

  return { version: 1, collections, variables };
}

function compareByNameAndId(left: { readonly id: string; readonly name: string }, right: { readonly id: string; readonly name: string }): number {
  return left.name.localeCompare(right.name) || left.id.localeCompare(right.id);
}

function serializeCodeSyntax(codeSyntax: Variable['codeSyntax']): FigmaCodeSyntax {
  const entries = (['ANDROID', 'WEB', 'iOS'] as const).flatMap((platform) => {
    const value = codeSyntax[platform];
    return value === undefined ? [] : ([[platform, value]] as const);
  });
  return Object.fromEntries(entries);
}

function serializeVariableValue(value: VariableValue): FigmaVariableValue {
  if (typeof value === 'boolean' || typeof value === 'number' || typeof value === 'string') {
    return value;
  }
  if ('type' in value) {
    return { type: 'VARIABLE_ALIAS', id: value.id };
  }
  const color: FigmaColorValue = { r: value.r, g: value.g, b: value.b };
  return 'a' in value ? { ...color, a: value.a } : color;
}

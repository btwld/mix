import { readPluginData } from '../plugin_data';
import { MIX_FIGMA_PLUGIN_DATA_KEYS, type ComponentSyncSnapshot } from '../types';

export async function readComponentSet(
  api: PluginAPI,
  componentRef: string,
): Promise<ComponentSyncSnapshot> {
  await api.loadAllPagesAsync();
  const componentSet = api.root
    .findAllWithCriteria({ types: ['COMPONENT_SET'] })
    .find(
      (node): node is ComponentSetNode =>
        node.type === 'COMPONENT_SET' &&
        node.getPluginData(MIX_FIGMA_PLUGIN_DATA_KEYS.identity) === componentRef,
    );
  if (componentSet === undefined) return { componentSet: null };

  return {
    componentSet: {
      id: componentSet.id,
      name: componentSet.name,
      pluginData: readPluginData(componentSet),
      variants: componentSet.children
        .filter((node): node is ComponentNode => node.type === 'COMPONENT')
        .map((node) => ({
          id: node.id,
          name: node.name,
          pluginData: readPluginData(node),
        }))
        .sort(compareByIdentityAndId),
    },
  };
}

function compareByIdentityAndId(
  left: { readonly id: string; readonly pluginData: Readonly<Record<string, string>> },
  right: { readonly id: string; readonly pluginData: Readonly<Record<string, string>> },
): number {
  const identity = (left.pluginData[MIX_FIGMA_PLUGIN_DATA_KEYS.identity] ?? '').localeCompare(
    right.pluginData[MIX_FIGMA_PLUGIN_DATA_KEYS.identity] ?? '',
  );
  return identity || left.id.localeCompare(right.id);
}

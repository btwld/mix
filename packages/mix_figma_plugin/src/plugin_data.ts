import { MIX_FIGMA_PLUGIN_DATA_KEYS, type MixIdentityStamp, type PluginData } from './types';

export interface PluginDataCarrier {
  getPluginData(key: string): string;
  getPluginDataKeys(): string[];
  setPluginData(key: string, value: string): void;
}

export function readPluginData(carrier: PluginDataCarrier): PluginData {
  return Object.fromEntries(
    carrier
      .getPluginDataKeys()
      .slice()
      .sort()
      .map((key) => [key, carrier.getPluginData(key)]),
  );
}

export function writePluginData(
  carrier: PluginDataCarrier,
  pluginData: PluginData | undefined,
  identity: MixIdentityStamp | undefined,
): void {
  const values: Record<string, string> = { ...pluginData };

  if (identity !== undefined) {
    values[MIX_FIGMA_PLUGIN_DATA_KEYS.identity] = identity.id;
    values[MIX_FIGMA_PLUGIN_DATA_KEYS.kind] = identity.kind;
    if (identity.protocolVersion !== undefined) {
      values[MIX_FIGMA_PLUGIN_DATA_KEYS.protocolVersion] = String(identity.protocolVersion);
    }
    if (identity.tokenGroup !== undefined) {
      values[MIX_FIGMA_PLUGIN_DATA_KEYS.tokenGroup] = identity.tokenGroup;
    }
  }

  for (const key of Object.keys(values).sort()) {
    carrier.setPluginData(key, values[key] ?? '');
  }
}

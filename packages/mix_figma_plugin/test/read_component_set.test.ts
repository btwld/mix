import { describe, expect, it, vi } from 'vitest';

import { readComponentSet } from '../src/components/read_component_set';
import { MIX_FIGMA_PLUGIN_DATA_KEYS } from '../src/types';

function node(
  type: 'COMPONENT' | 'COMPONENT_SET',
  id: string,
  name: string,
  identity: string,
) {
  const data = {
    [MIX_FIGMA_PLUGIN_DATA_KEYS.identity]: identity,
    'mix_figma.payloadFingerprint': `fingerprint:${id}`,
  };
  return {
    type,
    id,
    name,
    children: [] as unknown[],
    getPluginDataKeys: () => Object.keys(data),
    getPluginData: (key: string) => data[key as keyof typeof data] ?? '',
  };
}

describe('readComponentSet', () => {
  it('reads the stamped set and variants after loading dynamic pages', async () => {
    const componentSet = node('COMPONENT_SET', 'set:1', 'Button', 'button');
    const variant = node(
      'COMPONENT',
      'component:1',
      'state=default',
      'button.primary-default',
    );
    componentSet.children.push(variant);
    const loadAllPagesAsync = vi.fn(async () => undefined);
    const api = {
      loadAllPagesAsync,
      root: {
        findAllWithCriteria: vi.fn(() => [componentSet]),
      },
    } as unknown as PluginAPI;

    await expect(readComponentSet(api, 'button')).resolves.toEqual({
      componentSet: {
        id: 'set:1',
        name: 'Button',
        pluginData: expect.objectContaining({
          [MIX_FIGMA_PLUGIN_DATA_KEYS.identity]: 'button',
        }),
        variants: [
          {
            id: 'component:1',
            name: 'state=default',
            pluginData: expect.objectContaining({
              [MIX_FIGMA_PLUGIN_DATA_KEYS.identity]:
                'button.primary-default',
            }),
          },
        ],
      },
    });
    expect(loadAllPagesAsync).toHaveBeenCalledOnce();
  });

  it('returns an explicit empty snapshot when no owned set exists', async () => {
    const api = {
      loadAllPagesAsync: async () => undefined,
      root: { findAllWithCriteria: () => [] },
    } as unknown as PluginAPI;

    await expect(readComponentSet(api, 'button')).resolves.toEqual({
      componentSet: null,
    });
  });
});

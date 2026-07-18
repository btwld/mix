import { describe, expect, it } from 'vitest';

import { readVariables } from '../src/variables/read_variables';

function pluginData(values: Record<string, string>) {
  return {
    getPluginDataKeys: () => Object.keys(values),
    getPluginData: (key: string) => values[key] ?? '',
  };
}

describe('readVariables', () => {
  it('returns deterministic JSON-safe collections, aliases, scopes, code syntax, and plugin data', async () => {
    const collection = {
      id: 'collection:1',
      key: 'collection-key',
      name: 'Foundation',
      defaultModeId: 'mode:light',
      modes: [
        { modeId: 'mode:dark', name: 'Dark' },
        { modeId: 'mode:light', name: 'Light' },
      ],
      remote: false,
      hiddenFromPublishing: true,
      variableIds: ['variable:alias', 'variable:base'],
      ...pluginData({ 'mix_figma.id': 'foundation' }),
    };
    const variables = [
      {
        id: 'variable:alias',
        key: 'alias-key',
        name: 'color/brand',
        description: 'Brand alias',
        variableCollectionId: collection.id,
        resolvedType: 'COLOR',
        valuesByMode: {
          'mode:light': { type: 'VARIABLE_ALIAS', id: 'variable:base' },
          'mode:dark': { r: 0, g: 0, b: 0, a: 1 },
        },
        scopes: ['ALL_FILLS'],
        codeSyntax: { WEB: '--color-brand', ANDROID: 'colorBrand' },
        remote: false,
        hiddenFromPublishing: false,
        ...pluginData({ 'mix_figma.id': 'colors.brand', exact: 'preserved' }),
      },
      {
        id: 'variable:base',
        key: 'base-key',
        name: 'color/base',
        description: '',
        variableCollectionId: collection.id,
        resolvedType: 'COLOR',
        valuesByMode: {
          'mode:light': { r: 1, g: 1, b: 1 },
          'mode:dark': { r: 0.1, g: 0.2, b: 0.3 },
        },
        scopes: [],
        codeSyntax: {},
        remote: false,
        hiddenFromPublishing: false,
        ...pluginData({}),
      },
    ];
    const api = {
      variables: {
        getLocalVariableCollectionsAsync: async () => [collection],
        getLocalVariablesAsync: async () => variables,
      },
    } as unknown as PluginAPI;

    const document = await readVariables(api);

    expect(document).toEqual({
      version: 1,
      collections: [
        expect.objectContaining({
          id: 'collection:1',
          modes: [
            { modeId: 'mode:dark', name: 'Dark' },
            { modeId: 'mode:light', name: 'Light' },
          ],
          pluginData: { 'mix_figma.id': 'foundation' },
        }),
      ],
      variables: [
        expect.objectContaining({
          id: 'variable:base',
          name: 'color/base',
        }),
        expect.objectContaining({
          id: 'variable:alias',
          valuesByMode: expect.objectContaining({
            'mode:light': { type: 'VARIABLE_ALIAS', id: 'variable:base' },
          }),
          codeSyntax: { WEB: '--color-brand', ANDROID: 'colorBrand' },
          pluginData: { 'mix_figma.id': 'colors.brand', exact: 'preserved' },
        }),
      ],
    });
  });
});

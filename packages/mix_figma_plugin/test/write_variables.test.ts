import { describe, expect, it, vi } from 'vitest';

import { MIX_FIGMA_PLUGIN_DATA_KEYS, type FigmaVariablesWritePayload } from '../src/types';
import { writeVariables } from '../src/variables/write_variables';

function dataCarrier() {
  const data: Record<string, string> = {};
  return {
    data,
    getPluginDataKeys: () => Object.keys(data),
    getPluginData: (key: string) => data[key] ?? '',
    setPluginData: (key: string, value: string) => {
      data[key] = value;
    },
  };
}

describe('writeVariables', () => {
  it('creates variables in two passes, resolves modes and aliases, and stamps code syntax and plugin data', async () => {
    let nextId = 1;
    const collections: Array<Record<string, unknown>> = [];
    const variables: Array<Record<string, unknown>> = [];
    const loadCollection = () => {
      const carrier = dataCarrier();
      const collection = {
        id: `collection:${nextId++}`,
        key: '',
        name: '',
        modes: [{ modeId: `mode:${nextId++}`, name: 'Mode 1' }],
        defaultModeId: '',
        remote: false,
        hiddenFromPublishing: false,
        variableIds: [],
        addMode(name: string) {
          const mode = { modeId: `mode:${nextId++}`, name };
          this.modes.push(mode);
          return mode.modeId;
        },
        renameMode(modeId: string, name: string) {
          const mode = this.modes.find((item) => item.modeId === modeId);
          if (mode !== undefined) mode.name = name;
        },
        ...carrier,
      };
      collection.defaultModeId = collection.modes[0]?.modeId ?? '';
      collections.push(collection);
      return collection;
    };
    const loadVariable = (name: string, collection: Record<string, unknown>, resolvedType: string) => {
      const carrier = dataCarrier();
      const valueCalls: Array<[string, unknown]> = [];
      const codeCalls: Array<[string, string]> = [];
      const variable = {
        id: `variable:${nextId++}`,
        key: '',
        name,
        description: '',
        variableCollectionId: collection.id,
        resolvedType,
        valuesByMode: {},
        scopes: [],
        codeSyntax: {},
        remote: false,
        hiddenFromPublishing: false,
        valueCalls,
        codeCalls,
        setValueForMode: (modeId: string, value: unknown) => valueCalls.push([modeId, value]),
        setVariableCodeSyntax: (platform: string, value: string) => codeCalls.push([platform, value]),
        removeVariableCodeSyntax: vi.fn(() => {
          throw new Error('Code syntax field not found');
        }),
        ...carrier,
      };
      variables.push(variable);
      return variable;
    };
    const api = {
      variables: {
        getLocalVariableCollectionsAsync: async () => collections,
        getLocalVariablesAsync: async () => variables,
        createVariableCollection: vi.fn(() => loadCollection()),
        createVariable: vi.fn(loadVariable),
        createVariableAlias: (variable: { id: string }) => ({ type: 'VARIABLE_ALIAS', id: variable.id }),
        getVariableByIdAsync: async (id: string) => variables.find((variable) => variable.id === id) ?? null,
      },
    } as unknown as PluginAPI;
    const payload: FigmaVariablesWritePayload = {
      version: 1,
      collections: [
        {
          ref: 'foundation',
          name: 'Foundation',
          modes: [
            { ref: 'light', name: 'Light' },
            { ref: 'dark', name: 'Dark' },
          ],
          pluginData: { exact: 'collection-data' },
          identity: { id: 'foundation', kind: 'collection', protocolVersion: 1 },
        },
      ],
      variables: [
        {
          ref: 'brand',
          collectionRef: 'foundation',
          name: 'color/brand',
          resolvedType: 'COLOR',
          valuesByMode: {
            light: { type: 'VARIABLE_ALIAS', ref: 'base' },
            dark: { r: 0.1, g: 0.2, b: 0.3, a: 1 },
          },
          scopes: ['ALL_FILLS'],
          codeSyntax: { WEB: '--color-brand', ANDROID: 'colorBrand' },
          pluginData: { exact: 'variable-data' },
          identity: { id: 'colors.brand', kind: 'token', tokenGroup: 'colors', protocolVersion: 1 },
        },
        {
          ref: 'base',
          collectionRef: 'foundation',
          name: 'color/base',
          resolvedType: 'COLOR',
          valuesByMode: {
            light: { r: 1, g: 1, b: 1 },
            dark: { r: 0, g: 0, b: 0 },
          },
        },
      ],
    };

    const result = await writeVariables(api, payload);

    expect(result.collections.foundation).toMatch(/^collection:/);
    expect(result.modes.foundation).toEqual({ light: expect.any(String), dark: expect.any(String) });
    expect(result.variables).toEqual({ brand: expect.any(String), base: expect.any(String) });
    expect(api.variables.createVariable).toHaveBeenCalledTimes(2);

    const brand = variables.find((variable) => variable.name === 'color/brand');
    const base = variables.find((variable) => variable.name === 'color/base');
    expect(brand?.valueCalls).toEqual([
      [result.modes.foundation?.light, { type: 'VARIABLE_ALIAS', id: base?.id }],
      [result.modes.foundation?.dark, { r: 0.1, g: 0.2, b: 0.3, a: 1 }],
    ]);
    expect(brand?.codeCalls).toEqual([
      ['ANDROID', 'colorBrand'],
      ['WEB', '--color-brand'],
    ]);
    expect(brand?.removeVariableCodeSyntax).not.toHaveBeenCalled();
    expect(brand?.data).toMatchObject({
      exact: 'variable-data',
      [MIX_FIGMA_PLUGIN_DATA_KEYS.identity]: 'colors.brand',
      [MIX_FIGMA_PLUGIN_DATA_KEYS.kind]: 'token',
      [MIX_FIGMA_PLUGIN_DATA_KEYS.tokenGroup]: 'colors',
      [MIX_FIGMA_PLUGIN_DATA_KEYS.protocolVersion]: '1',
    });
  });

  it('preserves absent modes unless an approved delete names the exact source id', async () => {
    const collectionData = dataCarrier();
    collectionData.data[MIX_FIGMA_PLUGIN_DATA_KEYS.identity] = 'foundation';
    const collection = {
      id: 'collection:existing',
      key: 'collection-key',
      name: 'Old Foundation',
      modes: [
        { modeId: 'mode:light', name: 'Light' },
        { modeId: 'mode:dark', name: 'Dark' },
        { modeId: 'mode:legacy', name: 'Legacy' },
      ],
      defaultModeId: 'mode:light',
      remote: false,
      hiddenFromPublishing: false,
      variableIds: ['variable:existing'],
      addMode: vi.fn(),
      renameMode: vi.fn(),
      removeMode: vi.fn(function (this: { modes: Array<{ modeId: string; name: string }> }, modeId: string) {
        this.modes = this.modes.filter((mode) => mode.modeId !== modeId);
      }),
      ...collectionData,
    };
    const variableData = dataCarrier();
    variableData.data[MIX_FIGMA_PLUGIN_DATA_KEYS.identity] = 'spaces.sm';
    const variable = {
      id: 'variable:existing',
      key: 'variable-key',
      name: 'old/name',
      description: '',
      variableCollectionId: collection.id,
      resolvedType: 'FLOAT',
      valuesByMode: {},
      scopes: [],
      codeSyntax: {},
      remote: false,
      hiddenFromPublishing: false,
      setValueForMode: vi.fn(),
      setVariableCodeSyntax: vi.fn(),
      removeVariableCodeSyntax: vi.fn(),
      ...variableData,
    };
    const createVariableCollection = vi.fn();
    const createVariable = vi.fn();
    const api = {
      variables: {
        getLocalVariableCollectionsAsync: async () => [collection],
        getLocalVariablesAsync: async () => [variable],
        createVariableCollection,
        createVariable,
        createVariableAlias: vi.fn(),
        getVariableByIdAsync: async () => null,
      },
    } as unknown as PluginAPI;

    const payload: FigmaVariablesWritePayload = {
      version: 1,
      collections: [
        {
          ref: 'foundation',
          name: 'Foundation',
          modes: [
            { ref: 'light', sourceId: 'mode:light', name: 'Light' },
            { ref: 'dark', sourceId: 'mode:dark', name: 'Dark' },
          ],
          identity: { id: 'foundation', kind: 'collection' },
        },
      ],
      variables: [
        {
          ref: 'space-sm',
          collectionRef: 'foundation',
          name: 'space/sm',
          resolvedType: 'FLOAT',
          valuesByMode: { light: 4, dark: 4 },
          identity: { id: 'spaces.sm', kind: 'token', tokenGroup: 'spaces' },
        },
      ],
    };
    const result = await writeVariables(api, payload);

    expect(createVariableCollection).not.toHaveBeenCalled();
    expect(createVariable).not.toHaveBeenCalled();
    expect(collection.removeMode).not.toHaveBeenCalled();
    await writeVariables(api, payload, {
      operations: [
        {
          action: 'delete',
          kind: 'mode',
          ref: 'mode:legacy',
          sourceId: 'mode:legacy',
          name: 'Legacy',
          path: '/variables/collections/foundation/modes/mode:legacy',
          destructive: true,
          changes: ['delete'],
          diagnostics: [],
        },
      ],
    });
    expect(collection.removeMode).toHaveBeenCalledWith('mode:legacy');
    expect(result).toEqual({
      collections: { foundation: 'collection:existing' },
      modes: { foundation: { light: 'mode:light', dark: 'mode:dark' } },
      variables: { 'space-sm': 'variable:existing' },
    });
    expect(variable).toMatchObject({ name: 'space/sm' });
  });

  it('does not update an unowned variable referenced by a stale source id', async () => {
    const collectionData = dataCarrier();
    collectionData.data[MIX_FIGMA_PLUGIN_DATA_KEYS.identity] = 'foundation';
    const collection = {
      id: 'collection:managed',
      name: 'Foundation',
      modes: [{ modeId: 'mode:light', name: 'Light' }],
      remote: false,
      hiddenFromPublishing: false,
      addMode: vi.fn(),
      renameMode: vi.fn(),
      ...collectionData,
    };
    const unowned = {
      id: 'variable:user',
      name: 'User variable',
      description: 'Do not change',
      variableCollectionId: collection.id,
      resolvedType: 'FLOAT',
      scopes: [],
      remote: false,
      hiddenFromPublishing: false,
      setValueForMode: vi.fn(),
      setVariableCodeSyntax: vi.fn(),
      removeVariableCodeSyntax: vi.fn(),
      ...dataCarrier(),
    };
    const created = {
      id: 'variable:managed',
      name: '',
      description: '',
      variableCollectionId: collection.id,
      resolvedType: 'FLOAT',
      scopes: [],
      remote: false,
      hiddenFromPublishing: false,
      setValueForMode: vi.fn(),
      setVariableCodeSyntax: vi.fn(),
      removeVariableCodeSyntax: vi.fn(),
      ...dataCarrier(),
    };
    const createVariable = vi.fn(() => created);
    const api = {
      variables: {
        getLocalVariableCollectionsAsync: async () => [collection],
        getLocalVariablesAsync: async () => [unowned],
        createVariableCollection: vi.fn(),
        createVariable,
        createVariableAlias: vi.fn(),
        getVariableByIdAsync: async () => null,
      },
    } as unknown as PluginAPI;
    const payload: FigmaVariablesWritePayload = {
      version: 1,
      collections: [
        {
          ref: 'foundation',
          sourceId: collection.id,
          name: 'Foundation',
          modes: [{ ref: 'light', sourceId: 'mode:light', name: 'Light' }],
          identity: { id: 'foundation', kind: 'collection' },
        },
      ],
      variables: [
        {
          ref: 'space-sm',
          sourceId: unowned.id,
          collectionRef: 'foundation',
          name: 'space/sm',
          resolvedType: 'FLOAT',
          valuesByMode: { light: 4 },
          identity: { id: 'spaces.sm', kind: 'token', tokenGroup: 'spaces' },
        },
      ],
    };

    await expect(writeVariables(api, payload)).resolves.toMatchObject({
      variables: { 'space-sm': 'variable:managed' },
    });
    expect(createVariable).toHaveBeenCalledOnce();
    expect(unowned).toMatchObject({
      name: 'User variable',
      description: 'Do not change',
    });
    expect(unowned.setValueForMode).not.toHaveBeenCalled();
  });

  it('refuses an exact delete operation when the variable is not Mix-owned', async () => {
    const ownedData = dataCarrier();
    ownedData.data[MIX_FIGMA_PLUGIN_DATA_KEYS.identity] = 'spaces.owned';
    const owned = {
      id: 'variable:owned',
      name: 'space/owned',
      remote: false,
      remove: vi.fn(),
      ...ownedData,
    };
    const unowned = {
      id: 'variable:user',
      name: 'space/user',
      remote: false,
      remove: vi.fn(),
      ...dataCarrier(),
    };
    const api = {
      variables: {
        getLocalVariableCollectionsAsync: async () => [],
        getLocalVariablesAsync: async () => [owned, unowned],
      },
    } as unknown as PluginAPI;
    const payload: FigmaVariablesWritePayload = {
      version: 1,
      collections: [],
      variables: [],
    };
    const operation = {
      action: 'delete' as const,
      kind: 'variable',
      ref: 'spaces.owned',
      sourceId: 'variable:owned',
      name: 'space/owned',
      path: '/variables/variables/spaces.owned',
      destructive: true,
      changes: ['delete'],
      diagnostics: [],
    };

    await expect(writeVariables(api, payload, { operations: [operation] })).resolves.toEqual({
      collections: {},
      modes: {},
      variables: {},
    });
    expect(owned.remove).toHaveBeenCalledOnce();

    await expect(
      writeVariables(api, payload, {
        operations: [{
          ...operation,
          ref: 'spaces.user',
          sourceId: 'variable:user',
          name: 'space/user',
        }],
      }),
    ).rejects.toThrow('Refusing to delete unowned variable');
    expect(unowned.remove).not.toHaveBeenCalled();
  });
});

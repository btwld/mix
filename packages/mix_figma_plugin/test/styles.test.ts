import { describe, expect, it, vi } from 'vitest';

import { readStyles } from '../src/styles/read_styles';
import { writeStyles } from '../src/styles/write_styles';
import { MIX_FIGMA_PLUGIN_DATA_KEYS, type FigmaStylesWritePayload } from '../src/types';

function pluginData(initial: Record<string, string> = {}) {
  const data = { ...initial };
  return {
    data,
    getPluginDataKeys: () => Object.keys(data),
    getPluginData: (key: string) => data[key] ?? '',
    setPluginData: (key: string, value: string) => {
      data[key] = value;
    },
  };
}

describe('Figma styles', () => {
  it('reads values-bearing text, effect, and paint styles with private plugin data', async () => {
    const common = {
      key: 'key',
      description: 'description',
      remote: false,
      ...pluginData({ exact: 'preserved' }),
    };
    const textStyle = {
      ...common,
      id: 'style:text',
      name: 'Typography/Body',
      fontName: { family: 'Inter', style: 'Regular' },
      fontSize: 16,
      letterSpacing: { unit: 'PIXELS', value: 0 },
      lineHeight: { unit: 'PIXELS', value: 24 },
      leadingTrim: 'CAP_HEIGHT',
      paragraphIndent: 0,
      paragraphSpacing: 4,
      listSpacing: 6,
      hangingPunctuation: true,
      hangingList: false,
      textCase: 'ORIGINAL',
      textDecoration: 'NONE',
      boundVariables: { fontSize: { type: 'VARIABLE_ALIAS', id: 'variable:font-size' } },
      fills: [{ type: 'SOLID', color: { r: 0, g: 0, b: 0 } }],
    };
    const effectStyle = {
      ...common,
      id: 'style:effect',
      name: 'Shadow/Card',
      effects: [
        {
          type: 'DROP_SHADOW',
          color: { r: 0, g: 0, b: 0, a: 0.2 },
          offset: { x: 0, y: 2 },
          radius: 8,
          spread: 0,
          visible: true,
          blendMode: 'NORMAL',
        },
      ],
      boundVariables: { effects: [{ type: 'VARIABLE_ALIAS', id: 'variable:shadow' }] },
    };
    const paintStyle = {
      ...common,
      id: 'style:paint',
      name: 'Border/Default',
      paints: [{ type: 'SOLID', color: { r: 1, g: 0, b: 0 } }],
      boundVariables: { colors: [{ type: 'VARIABLE_ALIAS', id: 'variable:border' }] },
    };
    const api = {
      getLocalTextStylesAsync: async () => [textStyle],
      getLocalEffectStylesAsync: async () => [effectStyle],
      getLocalPaintStylesAsync: async () => [paintStyle],
    } as unknown as PluginAPI;

    await expect(readStyles(api)).resolves.toEqual({
      version: 1,
      textStyles: [expect.objectContaining({
        kind: 'TEXT',
        id: 'style:text',
        leadingTrim: 'CAP_HEIGHT',
        listSpacing: 6,
        hangingPunctuation: true,
        hangingList: false,
        boundVariables: textStyle.boundVariables,
        pluginData: { exact: 'preserved' },
      })],
      effectStyles: [expect.objectContaining({
        kind: 'EFFECT',
        id: 'style:effect',
        effects: effectStyle.effects,
        boundVariables: effectStyle.boundVariables,
      })],
      paintStyles: [expect.objectContaining({
        kind: 'PAINT',
        id: 'style:paint',
        paints: paintStyle.paints,
        boundVariables: paintStyle.boundVariables,
      })],
    });
  });

  it('writes native values and identity stamps without encoding composites as variables', async () => {
    let nextId = 1;
    const textStyles: Array<Record<string, unknown>> = [];
    const effectStyles: Array<Record<string, unknown>> = [];
    const paintStyles: Array<Record<string, unknown>> = [];
    const createTextStyle = () => {
      const style = {
        id: `text:${nextId++}`,
        name: '',
        description: '',
        fontName: { family: 'Inter', style: 'Regular' },
        fontSize: 12,
        letterSpacing: { unit: 'PIXELS', value: 0 },
        lineHeight: { unit: 'AUTO' },
        leadingTrim: 'NONE',
        paragraphIndent: 0,
        paragraphSpacing: 0,
        listSpacing: 0,
        hangingPunctuation: false,
        hangingList: false,
        textCase: 'ORIGINAL',
        textDecoration: 'NONE',
        fills: [],
        setBoundVariable: vi.fn(),
        ...pluginData(),
      };
      textStyles.push(style);
      return style;
    };
    const createEffectStyle = () => {
      const style = { id: `effect:${nextId++}`, name: '', description: '', effects: [], ...pluginData() };
      effectStyles.push(style);
      return style;
    };
    const createPaintStyle = () => {
      const style = { id: `paint:${nextId++}`, name: '', description: '', paints: [], ...pluginData() };
      paintStyles.push(style);
      return style;
    };
    const loadFontAsync = vi.fn(async () => undefined);
    const api = {
      getLocalTextStylesAsync: async () => textStyles,
      getLocalEffectStylesAsync: async () => effectStyles,
      getLocalPaintStylesAsync: async () => paintStyles,
      createTextStyle: vi.fn(createTextStyle),
      createEffectStyle: vi.fn(createEffectStyle),
      createPaintStyle: vi.fn(createPaintStyle),
      getStyleByIdAsync: async () => null,
      loadFontAsync,
      variables: {
        createVariable: vi.fn(),
        getVariableByIdAsync: async (id: string) => id === 'variable:font-size' ? { id } : null,
      },
    } as unknown as PluginAPI;
    const payload: FigmaStylesWritePayload = {
      version: 1,
      textStyles: [
        {
          ref: 'body',
          name: 'Typography/Body',
          description: 'Body',
          fontName: { family: 'Roboto', style: 'Medium' },
          fontSize: 16,
          lineHeight: { unit: 'PIXELS', value: 24 },
          leadingTrim: 'CAP_HEIGHT',
          listSpacing: 6,
          hangingPunctuation: true,
          hangingList: true,
          variableBindings: { fontSize: 'variable:font-size' },
          pluginData: { 'mix_figma.protocolValue': '{"fontSize":16}' },
          identity: { id: 'textStyles.body', kind: 'textStyle', tokenGroup: 'textStyles' },
        },
      ],
      effectStyles: [
        {
          ref: 'shadow',
          name: 'Shadow/Card',
          effects: [],
          identity: { id: 'boxShadows.card', kind: 'effectStyle', tokenGroup: 'boxShadows' },
        },
      ],
      paintStyles: [
        {
          ref: 'border',
          name: 'Border/Default',
          paints: [],
          identity: { id: 'borders.default', kind: 'paintStyle', tokenGroup: 'borders' },
        },
      ],
    };

    const result = await writeStyles(api, payload);

    expect(result).toEqual({
      textStyles: { body: expect.any(String) },
      effectStyles: { shadow: expect.any(String) },
      paintStyles: { border: expect.any(String) },
    });
    expect(loadFontAsync).toHaveBeenCalledWith({ family: 'Roboto', style: 'Medium' });
    expect(api.variables.createVariable).not.toHaveBeenCalled();
    expect(textStyles[0]).toMatchObject({
      name: 'Typography/Body',
      description: 'Body',
      fontSize: 16,
      lineHeight: { unit: 'PIXELS', value: 24 },
      leadingTrim: 'CAP_HEIGHT',
      listSpacing: 6,
      hangingPunctuation: true,
      hangingList: true,
      data: {
        'mix_figma.protocolValue': '{"fontSize":16}',
        [MIX_FIGMA_PLUGIN_DATA_KEYS.identity]: 'textStyles.body',
        [MIX_FIGMA_PLUGIN_DATA_KEYS.kind]: 'textStyle',
        [MIX_FIGMA_PLUGIN_DATA_KEYS.tokenGroup]: 'textStyles',
      },
    });
    expect(textStyles[0]?.setBoundVariable).toHaveBeenCalledWith('fontSize', { id: 'variable:font-size' });
  });

  it('does not update an unowned style referenced by a stale source id', async () => {
    const unowned = {
      id: 'style:user',
      name: 'User Typography',
      description: 'Do not change',
      remote: false,
      fontName: { family: 'Inter', style: 'Regular' },
      fontSize: 12,
      letterSpacing: { unit: 'PIXELS', value: 0 },
      lineHeight: { unit: 'AUTO' },
      setBoundVariable: vi.fn(),
      ...pluginData(),
    };
    const created = {
      id: 'style:managed',
      name: '',
      description: '',
      remote: false,
      fontName: { family: 'Inter', style: 'Regular' },
      fontSize: 12,
      letterSpacing: { unit: 'PIXELS', value: 0 },
      lineHeight: { unit: 'AUTO' },
      setBoundVariable: vi.fn(),
      ...pluginData(),
    };
    const createTextStyle = vi.fn(() => created);
    const api = {
      getLocalTextStylesAsync: async () => [unowned],
      getLocalEffectStylesAsync: async () => [],
      getLocalPaintStylesAsync: async () => [],
      createTextStyle,
      loadFontAsync: async () => undefined,
      variables: { getVariableByIdAsync: async () => null },
    } as unknown as PluginAPI;
    const payload: FigmaStylesWritePayload = {
      version: 1,
      textStyles: [
        {
          ref: 'textStyles/type.body',
          sourceId: unowned.id,
          name: 'Typography/Body',
          fontName: { family: 'Inter', style: 'Regular' },
          fontSize: 16,
          identity: { id: 'textStyles/type.body', kind: 'textStyle' },
        },
      ],
      effectStyles: [],
      paintStyles: [],
    };

    await expect(writeStyles(api, payload)).resolves.toMatchObject({
      textStyles: { 'textStyles/type.body': 'style:managed' },
    });
    expect(createTextStyle).toHaveBeenCalledOnce();
    expect(unowned).toMatchObject({
      name: 'User Typography',
      description: 'Do not change',
      fontSize: 12,
    });
  });

  it('deletes only the exact approved Mix-owned style', async () => {
    const ownedData = pluginData({
      [MIX_FIGMA_PLUGIN_DATA_KEYS.identity]: 'textStyles.body',
    });
    const owned = {
      id: 'style:owned',
      name: 'Typography/Body',
      remote: false,
      remove: vi.fn(),
      ...ownedData,
    };
    const unowned = {
      id: 'style:user',
      name: 'Typography/User',
      remote: false,
      remove: vi.fn(),
      ...pluginData(),
    };
    const api = {
      getLocalTextStylesAsync: async () => [owned, unowned],
      getLocalEffectStylesAsync: async () => [],
      getLocalPaintStylesAsync: async () => [],
    } as unknown as PluginAPI;
    const payload: FigmaStylesWritePayload = {
      version: 1,
      textStyles: [],
      effectStyles: [],
      paintStyles: [],
    };
    const operation = {
      action: 'delete' as const,
      kind: 'textStyle',
      ref: 'textStyles.body',
      sourceId: 'style:owned',
      name: 'Typography/Body',
      path: '/styles/textStyles.body',
      destructive: true,
      changes: ['delete'],
      diagnostics: [],
    };

    await expect(writeStyles(api, payload, { operations: [operation] })).resolves.toEqual({
      textStyles: {},
      effectStyles: {},
      paintStyles: {},
    });
    expect(owned.remove).toHaveBeenCalledOnce();

    await expect(
      writeStyles(api, payload, {
        operations: [{
          ...operation,
          ref: 'textStyles.user',
          sourceId: 'style:user',
          name: 'Typography/User',
        }],
      }),
    ).rejects.toThrow('Refusing to delete unowned text style');
    expect(unowned.remove).not.toHaveBeenCalled();
  });
});

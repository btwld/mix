import { describe, expect, it, vi } from 'vitest';

import { writeComponentSet } from '../src/components/write_component_set';
import { MIX_FIGMA_PLUGIN_DATA_KEYS, type ComponentSetWritePayload } from '../src/types';

function makeNode(type: string, id: string) {
  const data: Record<string, string> = {};
  const children: Array<Record<string, unknown>> = [];
  return {
    id,
    type,
    name: '',
    description: '',
    x: 0,
    y: 0,
    width: 100,
    height: 40,
    children,
    appendChild(child: Record<string, unknown>) {
      children.push(child);
    },
    resize(width: number, height: number) {
      this.width = width;
      this.height = height;
    },
    getPluginDataKeys: () => Object.keys(data),
    getPluginData: (key: string) => data[key] ?? '',
    setPluginData: (key: string, value: string) => {
      data[key] = value;
    },
    data,
    setBoundVariable: vi.fn(),
    remove: vi.fn(),
  };
}

describe('writeComponentSet', () => {
  it('creates deterministic variants, nested anatomy, variable bindings, and visible unsupported placeholders', async () => {
    let id = 1;
    const page = makeNode('PAGE', 'page:1');
    const components: Array<ReturnType<typeof makeNode>> = [];
    const create = (type: string) => makeNode(type, `${type.toLowerCase()}:${id++}`);
    const variable = { id: 'variable:space' };
    const componentSet = makeNode('COMPONENT_SET', 'set:1');
    const api = {
      currentPage: page,
      createComponent: vi.fn(() => {
        const node = create('COMPONENT');
        components.push(node);
        return node;
      }),
      createFrame: vi.fn(() => create('FRAME')),
      createText: vi.fn(() => create('TEXT')),
      createRectangle: vi.fn(() => create('RECTANGLE')),
      createEllipse: vi.fn(() => create('ELLIPSE')),
      createLine: vi.fn(() => create('LINE')),
      combineAsVariants: vi.fn((nodes: unknown[], parent: ReturnType<typeof makeNode>) => {
        for (const node of nodes) parent.appendChild(node as Record<string, unknown>);
        return componentSet;
      }),
      getNodeByIdAsync: async () => null,
      loadFontAsync: vi.fn(async () => undefined),
      variables: {
        getVariableByIdAsync: async (variableId: string) => (variableId === variable.id ? variable : null),
        setBoundVariableForPaint: vi.fn(),
      },
    } as unknown as PluginAPI;
    const root = {
      id: 'root',
      name: 'Root',
      kind: 'FRAME' as const,
      layout: { mode: 'HORIZONTAL' as const, itemSpacing: 8 },
      variableBindings: { itemSpacing: variable.id },
      children: [
        {
          id: 'label',
          name: 'Label',
          kind: 'TEXT' as const,
          text: { characters: 'Button', fontName: { family: 'Inter', style: 'Regular' } },
        },
        {
          id: 'spinner',
          name: 'Spinner',
          kind: 'UNSUPPORTED' as const,
          unsupportedReason: 'RemixSpinner has no neutral Mix protocol primitive.',
        },
      ],
    };
    const payload: ComponentSetWritePayload = {
      version: 1,
      ref: 'button',
      name: 'Button',
      description: 'Button component set',
      columns: 2,
      variants: [
        { ref: 'solid-default', properties: { State: 'Default', Recipe: 'Solid' }, root },
        { ref: 'solid-hovered', properties: { State: 'Hovered', Recipe: 'Solid' }, root },
      ],
      pluginData: { exact: 'component-data' },
      identity: { id: 'button', kind: 'componentSet', protocolVersion: 1 },
      diagnostics: [
        { code: 'fixture_notice', severity: 'info', path: 'component.button', message: 'Fixture diagnostic.' },
      ],
    };

    const result = await writeComponentSet(api, payload);

    expect(components.map((component) => component.name)).toEqual([
      'Recipe=Solid, State=Default',
      'Recipe=Solid, State=Hovered',
    ]);
    expect(components[0]?.setBoundVariable).toHaveBeenCalledWith('itemSpacing', variable);
    expect(components[0]?.children).toEqual([
      expect.objectContaining({ type: 'TEXT', name: 'Label', characters: 'Button' }),
      expect.objectContaining({ type: 'FRAME', name: 'Spinner [unsupported]' }),
    ]);
    expect(componentSet).toMatchObject({
      name: 'Button',
      description: 'Button component set',
      data: {
        exact: 'component-data',
        [MIX_FIGMA_PLUGIN_DATA_KEYS.identity]: 'button',
        [MIX_FIGMA_PLUGIN_DATA_KEYS.kind]: 'componentSet',
        [MIX_FIGMA_PLUGIN_DATA_KEYS.protocolVersion]: '1',
      },
    });
    expect(result).toEqual({
      componentSetId: 'set:1',
      variants: { 'solid-default': components[0]?.id, 'solid-hovered': components[1]?.id },
      diagnostics: [
        expect.objectContaining({ code: 'fixture_notice' }),
        expect.objectContaining({ code: 'unsupported_component_anatomy_node', path: 'variants.solid-default.root.spinner' }),
        expect.objectContaining({ code: 'unsupported_component_anatomy_node', path: 'variants.solid-hovered.root.spinner' }),
      ],
    });
  });

  it('rejects an empty variant set before mutating the document', async () => {
    const createComponent = vi.fn();
    const api = { createComponent } as unknown as PluginAPI;

    await expect(
      writeComponentSet(api, { version: 1, ref: 'empty', name: 'Empty', variants: [] }),
    ).rejects.toThrow('Component set "Empty" must contain at least one variant.');
    expect(createComponent).not.toHaveBeenCalled();
  });

  it('updates a source component set in place, reuses stamped variants, and removes stale variants', async () => {
    const existingSet = makeNode('COMPONENT_SET', 'set:existing');
    const existingVariant = makeNode('COMPONENT', 'component:existing');
    const staleVariant = makeNode('COMPONENT', 'component:stale');
    existingVariant.setPluginData(MIX_FIGMA_PLUGIN_DATA_KEYS.identity, 'button.default');
    staleVariant.setPluginData(MIX_FIGMA_PLUGIN_DATA_KEYS.identity, 'button.stale');
    existingSet.children.push(existingVariant, staleVariant);
    const createComponent = vi.fn();
    const combineAsVariants = vi.fn();
    const api = {
      currentPage: makeNode('PAGE', 'page:1'),
      getNodeByIdAsync: async (id: string) => id === existingSet.id ? existingSet : null,
      createComponent,
      combineAsVariants,
      loadFontAsync: vi.fn(),
      variables: { getVariableByIdAsync: vi.fn() },
    } as unknown as PluginAPI;

    const result = await writeComponentSet(api, {
      version: 1,
      ref: 'button',
      sourceId: existingSet.id,
      name: 'Button',
      variants: [
        {
          ref: 'default',
          properties: { State: 'Default' },
          root: { id: 'root', name: 'Root', kind: 'FRAME' },
        },
      ],
      identity: { id: 'button', kind: 'componentSet' },
    });

    expect(createComponent).not.toHaveBeenCalled();
    expect(combineAsVariants).not.toHaveBeenCalled();
    expect(staleVariant.remove).toHaveBeenCalledOnce();
    expect(existingVariant.name).toBe('State=Default');
    expect(result).toMatchObject({
      componentSetId: 'set:existing',
      variants: { default: 'component:existing' },
    });
  });
});

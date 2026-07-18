import { describe, expect, it } from 'vitest';

import { readSelection } from '../src/nodes/read_selection';

function pluginData(values: Record<string, string>) {
  return {
    getPluginDataKeys: () => Object.keys(values),
    getPluginData: (key: string) => values[key] ?? '',
  };
}

describe('readSelection', () => {
  it('serializes style/layout/bindings and emits every known no-analog diagnostic', () => {
    const child = {
      id: 'node:child',
      name: 'Absolute child',
      type: 'RECTANGLE',
      visible: true,
      locked: false,
      opacity: 1,
      layoutPositioning: 'ABSOLUTE',
      fills: [],
      strokes: [],
      effects: [],
      ...pluginData({}),
    };
    const root = {
      id: 'node:root',
      name: 'Card',
      type: 'FRAME',
      visible: true,
      locked: false,
      opacity: 0.9,
      layoutMode: 'HORIZONTAL',
      primaryAxisAlignItems: 'CENTER',
      counterAxisAlignItems: 'CENTER',
      itemSpacing: 8,
      paddingTop: 4,
      paddingRight: 8,
      paddingBottom: 4,
      paddingLeft: 8,
      fills: [{ type: 'GRADIENT_ANGULAR', gradientStops: [], gradientTransform: [[1, 0, 0], [0, 1, 0]] }],
      strokes: [],
      effects: [
        {
          type: 'INNER_SHADOW',
          color: { r: 0, g: 0, b: 0, a: 1 },
          offset: { x: 0, y: 1 },
          radius: 2,
          spread: 0,
          visible: true,
          blendMode: 'NORMAL',
        },
      ],
      strokeTopWeight: 1,
      strokeRightWeight: 2,
      strokeBottomWeight: 1,
      strokeLeftWeight: 2,
      boundVariables: { itemSpacing: { type: 'VARIABLE_ALIAS', id: 'variable:space' } },
      children: [child],
      ...pluginData({
        'mix_figma.margin': '{"left":8}',
        'mix_figma.foregroundDecoration': '{"color":"#fff"}',
      }),
    };
    const api = {
      currentPage: {
        id: 'page:1',
        name: 'Components',
        selection: [root],
      },
    } as unknown as PluginAPI;

    const document = readSelection(api);

    expect(document.selection[0]).toMatchObject({
      id: 'node:root',
      properties: {
        layoutMode: 'HORIZONTAL',
        itemSpacing: 8,
        boundVariables: { itemSpacing: { type: 'VARIABLE_ALIAS', id: 'variable:space' } },
      },
      children: [expect.objectContaining({ id: 'node:child' })],
    });
    expect(document.diagnostics.map((diagnostic) => diagnostic.code).sort()).toEqual([
      'unsupported_absolute_positioned_child',
      'unsupported_foreground_decoration',
      'unsupported_inner_shadow',
      'unsupported_margin',
      'unsupported_per_edge_borders',
      'unsupported_sweep_gradient',
    ]);
    expect(document.diagnostics.every((diagnostic) => diagnostic.path.startsWith('selection.'))).toBe(true);
  });
});

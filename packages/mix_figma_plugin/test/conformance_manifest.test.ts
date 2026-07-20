import { describe, expect, it } from 'vitest';

import buttonComponent from '../../mix_figma/test/fixtures/components/button.component.json';
import cardComponent from '../../mix_figma/test/fixtures/components/card.component.json';
import inputComponent from '../../mix_figma/test/fixtures/components/input.component.json';
import manifestJson from '../../mix_figma/test/fixtures/conformance/manifest.json';
import variablesFixture from '../../mix_figma/test/fixtures/figma_variables/primitives.json';
import buttonSelection from '../../mix_figma/test/fixtures/style_docs/button.node.json';
import cardSelection from '../../mix_figma/test/fixtures/style_docs/card.node.json';
import stylesFixture from '../../mix_figma/test/fixtures/style_docs/figma_styles.json';
import inputSelection from '../../mix_figma/test/fixtures/style_docs/input.node.json';

interface ConformanceCase {
  readonly id: string;
  readonly kind: 'component' | 'selection' | 'styles' | 'variables';
  readonly source: string;
}

interface ConformanceManifest {
  readonly schema: string;
  readonly cases: readonly ConformanceCase[];
}

const manifest = manifestJson as ConformanceManifest;
const fixturesBySource: Readonly<Record<string, unknown>> = {
  '../figma_variables/primitives.json': variablesFixture,
  '../style_docs/figma_styles.json': stylesFixture,
  '../style_docs/button.node.json': buttonSelection,
  '../style_docs/input.node.json': inputSelection,
  '../style_docs/card.node.json': cardSelection,
  '../components/button.component.json': buttonComponent,
  '../components/input.component.json': inputComponent,
  '../components/card.component.json': cardComponent,
};

describe('shared Mix Figma conformance corpus', () => {
  it('is consumed by the plugin suite with unique resolvable cases', () => {
    expect(manifest.schema).toBe('mix_figma/conformance/v1');
    expect(new Set(manifest.cases.map((item) => item.id)).size).toBe(
      manifest.cases.length,
    );
    for (const item of manifest.cases) {
      expect(fixturesBySource[item.source], item.id).toBeDefined();
    }
  });

  it('covers Button, Input, and Card component fixtures', () => {
    const componentIds = manifest.cases
      .filter((item) => item.kind === 'component')
      .map((item) => (fixturesBySource[item.source] as { id: string }).id);

    expect(componentIds).toEqual(expect.arrayContaining(['button', 'input', 'card']));
  });
});

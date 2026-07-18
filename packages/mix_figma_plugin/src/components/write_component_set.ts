import { writePluginData } from '../plugin_data';
import type {
  ComponentNodePayload,
  ComponentSetWritePayload,
  ComponentSetWriteResult,
  MixFigmaDiagnostic,
} from '../types';

export async function writeComponentSet(
  api: PluginAPI,
  payload: ComponentSetWritePayload,
): Promise<ComponentSetWriteResult> {
  if (payload.variants.length === 0) {
    throw new Error(`Component set "${payload.name}" must contain at least one variant.`);
  }
  assertUniqueRefs(payload.variants.map((variant) => variant.ref));

  const existingSet = await resolveComponentSet(api, payload.sourceId);
  const parent = existingSet === null ? await resolveParent(api, payload.parentNodeId) : null;
  const diagnostics = [...(payload.diagnostics ?? [])];
  const components: ComponentNode[] = [];
  const variantIds: Record<string, string> = {};

  for (const variant of payload.variants) {
    const identity = `${payload.ref}.${variant.ref}`;
    const component = findExistingVariant(existingSet, identity, variantName(variant.properties)) ?? api.createComponent();
    if (component.parent?.type === 'COMPONENT_SET') {
      for (const child of component.children.slice()) child.remove();
    }
    await applyPayload(api, component, variant.root, `variants.${variant.ref}.root`, diagnostics, true);
    component.name = variantName(variant.properties);
    writePluginData(component, variant.root.pluginData, {
      id: identity,
      kind: 'component',
      ...(payload.identity?.protocolVersion === undefined
        ? {}
        : { protocolVersion: payload.identity.protocolVersion }),
    });
    if (existingSet !== null) existingSet.appendChild(component);
    else parent?.appendChild(component);
    components.push(component);
    variantIds[variant.ref] = component.id;
  }

  arrangeGrid(
    components,
    Math.max(1, payload.columns ?? Math.ceil(Math.sqrt(components.length))),
    payload.columnGap ?? 48,
    payload.rowGap ?? 48,
  );

  if (existingSet !== null) {
    const retainedIds = new Set(components.map((component) => component.id));
    for (const child of existingSet.children.slice()) {
      if (child.type === 'COMPONENT' && !retainedIds.has(child.id)) child.remove();
    }
  }

  const componentSet = existingSet ?? api.combineAsVariants(components, requireParent(parent));
  componentSet.name = payload.name;
  if (payload.description !== undefined) componentSet.description = payload.description;
  writePluginData(componentSet, payload.pluginData, payload.identity);

  return { componentSetId: componentSet.id, variants: variantIds, diagnostics };
}

async function resolveComponentSet(api: PluginAPI, sourceId: string | undefined): Promise<ComponentSetNode | null> {
  if (sourceId === undefined) return null;
  const node = await api.getNodeByIdAsync(sourceId);
  if (node === null || node.type !== 'COMPONENT_SET') {
    throw new Error(`Source component set "${sourceId}" was not found.`);
  }
  return node;
}

function findExistingVariant(
  componentSet: ComponentSetNode | null,
  identity: string,
  name: string,
): ComponentNode | undefined {
  return componentSet?.children.find(
    (child): child is ComponentNode =>
      child.type === 'COMPONENT' &&
      (child.getPluginData('mix_figma.id') === identity || child.name === name),
  );
}

function requireParent(parent: (BaseNode & ChildrenMixin) | null): BaseNode & ChildrenMixin {
  if (parent === null) throw new Error('Internal error resolving component-set parent.');
  return parent;
}

async function resolveParent(
  api: PluginAPI,
  parentNodeId: string | undefined,
): Promise<BaseNode & ChildrenMixin> {
  if (parentNodeId === undefined) return api.currentPage;
  const node = await api.getNodeByIdAsync(parentNodeId);
  if (node === null || !hasChildren(node)) {
    throw new Error(`Component-set parent "${parentNodeId}" was not found or cannot contain children.`);
  }
  return node;
}

async function applyPayload(
  api: PluginAPI,
  node: SceneNode,
  payload: ComponentNodePayload,
  path: string,
  diagnostics: MixFigmaDiagnostic[],
  isVariantRoot = false,
): Promise<void> {
  const mutable = node as unknown as Record<string, unknown>;
  if (!isVariantRoot) node.name = payload.kind === 'UNSUPPORTED' ? `${payload.name} [unsupported]` : payload.name;
  if (payload.width !== undefined || payload.height !== undefined) {
    const resize = mutable.resize;
    const currentWidth = typeof mutable.width === 'number' ? mutable.width : 1;
    const currentHeight = typeof mutable.height === 'number' ? mutable.height : 1;
    if (typeof resize === 'function') resize.call(node, payload.width ?? currentWidth, payload.height ?? currentHeight);
  }

  if (payload.layout !== undefined) {
    assignIfSupported(mutable, 'layoutMode', payload.layout.mode);
    assignIfSupported(mutable, 'primaryAxisAlignItems', payload.layout.primaryAxisAlignItems);
    assignIfSupported(mutable, 'counterAxisAlignItems', payload.layout.counterAxisAlignItems);
    assignIfSupported(mutable, 'itemSpacing', payload.layout.itemSpacing);
    assignIfSupported(mutable, 'paddingTop', payload.layout.paddingTop);
    assignIfSupported(mutable, 'paddingRight', payload.layout.paddingRight);
    assignIfSupported(mutable, 'paddingBottom', payload.layout.paddingBottom);
    assignIfSupported(mutable, 'paddingLeft', payload.layout.paddingLeft);
  }

  if (payload.style !== undefined) {
    assignIfSupported(mutable, 'opacity', payload.style.opacity);
    assignIfSupported(mutable, 'fills', payload.style.fills?.slice());
    assignIfSupported(mutable, 'strokes', payload.style.strokes?.slice());
    assignIfSupported(mutable, 'strokeWeight', payload.style.strokeWeight);
    assignIfSupported(mutable, 'cornerRadius', payload.style.cornerRadius);
    assignIfSupported(mutable, 'effects', payload.style.effects?.slice());
  }

  if (payload.text !== undefined) {
    if (node.type !== 'TEXT') {
      diagnostics.push({
        code: 'invalid_component_text_payload',
        severity: 'error',
        path,
        message: `Text content was supplied for non-text node "${payload.name}".`,
      });
    } else {
      const fontName = payload.text.fontName ?? node.fontName;
      if (typeof fontName !== 'symbol') {
        await api.loadFontAsync(fontName);
        node.fontName = fontName;
      }
      node.characters = payload.text.characters;
      if (payload.text.fontSize !== undefined) node.fontSize = payload.text.fontSize;
    }
  }

  writePluginData(node, payload.pluginData, undefined);
  await applyVariableBindings(api, node, payload.variableBindings, path, diagnostics);

  if (payload.children === undefined || payload.children.length === 0) return;
  if (!hasChildren(node)) {
    diagnostics.push({
      code: 'unsupported_component_parent',
      severity: 'error',
      path,
      message: `Node "${payload.name}" cannot contain anatomy children in Figma.`,
    });
    return;
  }

  for (const childPayload of payload.children) {
    const childPath = `${path}.${childPayload.id}`;
    const child = createNode(api, childPayload, childPath, diagnostics);
    node.appendChild(child);
    await applyPayload(api, child, childPayload, childPath, diagnostics);
  }
}

function createNode(
  api: PluginAPI,
  payload: ComponentNodePayload,
  path: string,
  diagnostics: MixFigmaDiagnostic[],
): SceneNode {
  switch (payload.kind) {
    case 'FRAME':
      return api.createFrame();
    case 'TEXT':
      return api.createText();
    case 'RECTANGLE':
      return api.createRectangle();
    case 'ELLIPSE':
      return api.createEllipse();
    case 'LINE':
      return api.createLine();
    case 'UNSUPPORTED': {
      const placeholder = api.createFrame();
      placeholder.name = `${payload.name} [unsupported]`;
      placeholder.resize(payload.width ?? 16, payload.height ?? 16);
      placeholder.setPluginData('mix_figma.unsupportedReason', payload.unsupportedReason ?? 'Unsupported anatomy node.');
      diagnostics.push({
        code: 'unsupported_component_anatomy_node',
        severity: 'warning',
        path,
        message: payload.unsupportedReason ?? `Anatomy node "${payload.name}" is unsupported.`,
      });
      return placeholder;
    }
  }
}

async function applyVariableBindings(
  api: PluginAPI,
  node: SceneNode,
  bindings: Readonly<Record<string, string>> | undefined,
  path: string,
  diagnostics: MixFigmaDiagnostic[],
): Promise<void> {
  for (const [field, variableId] of Object.entries(bindings ?? {}).sort(([left], [right]) => left.localeCompare(right))) {
    const variable = await api.variables.getVariableByIdAsync(variableId);
    if (variable === null) {
      diagnostics.push({
        code: 'missing_component_variable',
        severity: 'error',
        path: `${path}.bindings.${field}`,
        message: `Figma variable "${variableId}" was not found.`,
      });
      continue;
    }

    if (isVariableBindableField(field)) {
      node.setBoundVariable(field, variable);
      continue;
    }

    if (field === 'fill' || field === 'stroke') {
      bindPaint(api, node, field, variable, path, diagnostics);
      continue;
    }

    diagnostics.push({
      code: 'unsupported_component_variable_binding',
      severity: 'warning',
      path: `${path}.bindings.${field}`,
      message: `Variable binding field "${field}" is not supported by the plugin.`,
    });
  }
}

function bindPaint(
  api: PluginAPI,
  node: SceneNode,
  field: 'fill' | 'stroke',
  variable: Variable,
  path: string,
  diagnostics: MixFigmaDiagnostic[],
): void {
  const property = field === 'fill' ? 'fills' : 'strokes';
  const mutable = node as unknown as Record<string, unknown>;
  if (!(property in mutable)) {
    diagnostics.push({
      code: 'unsupported_component_paint_binding',
      severity: 'warning',
      path: `${path}.bindings.${field}`,
      message: `Node "${node.name}" does not support ${property}.`,
    });
    return;
  }

  const paintValue = mutable[property];
  if (typeof paintValue === 'symbol') {
    diagnostics.push({
      code: 'mixed_component_paint_binding',
      severity: 'warning',
      path: `${path}.bindings.${field}`,
      message: `Node "${node.name}" has mixed ${property}; the binding was skipped.`,
    });
    return;
  }
  const paints = Array.isArray(paintValue) ? paintValue.filter(isPaint) : [];
  const solidIndex = paints.findIndex(isSolidPaint);
  const solidPaint = solidIndex < 0
    ? ({ type: 'SOLID', color: { r: 0, g: 0, b: 0 } } satisfies SolidPaint)
    : paints[solidIndex] as SolidPaint;
  const boundPaint = api.variables.setBoundVariableForPaint(solidPaint, 'color', variable);
  if (solidIndex < 0) mutable[property] = [boundPaint, ...paints];
  else mutable[property] = paints.map((paint, index) => index === solidIndex ? boundPaint : paint);
}

function variantName(properties: Readonly<Record<string, boolean | string>>): string {
  const entries = Object.entries(properties).sort(([left], [right]) => left.localeCompare(right));
  if (entries.length === 0) return 'Variant=Default';
  return entries.map(([name, value]) => `${name}=${typeof value === 'boolean' ? titleBoolean(value) : value}`).join(', ');
}

function titleBoolean(value: boolean): string {
  return value ? 'True' : 'False';
}

function arrangeGrid(nodes: readonly ComponentNode[], columns: number, columnGap: number, rowGap: number): void {
  const cellWidth = Math.max(...nodes.map((node) => node.width));
  const cellHeight = Math.max(...nodes.map((node) => node.height));
  nodes.forEach((node, index) => {
    node.x = (index % columns) * (cellWidth + columnGap);
    node.y = Math.floor(index / columns) * (cellHeight + rowGap);
  });
}

function assignIfSupported(target: Record<string, unknown>, property: string, value: unknown): void {
  if (value !== undefined && property in target) target[property] = value;
}

function hasChildren(node: BaseNode): node is BaseNode & ChildrenMixin {
  return 'appendChild' in node && typeof node.appendChild === 'function';
}

function isPaint(value: unknown): value is Paint {
  return typeof value === 'object' && value !== null && 'type' in value && typeof value.type === 'string';
}

function isSolidPaint(value: Paint): value is SolidPaint {
  return value.type === 'SOLID';
}

const VARIABLE_BINDABLE_FIELDS = new Set<string>([
  'height', 'width', 'characters', 'itemSpacing', 'paddingLeft', 'paddingRight', 'paddingTop', 'paddingBottom',
  'visible', 'cornerRadius', 'topLeftRadius', 'topRightRadius', 'bottomLeftRadius', 'bottomRightRadius',
  'minWidth', 'maxWidth', 'minHeight', 'maxHeight', 'counterAxisSpacing', 'strokeWeight', 'strokeTopWeight',
  'strokeRightWeight', 'strokeBottomWeight', 'strokeLeftWeight', 'opacity', 'gridRowGap', 'gridColumnGap',
  'fontFamily', 'fontSize', 'fontStyle', 'fontWeight', 'letterSpacing', 'lineHeight', 'paragraphSpacing',
  'paragraphIndent',
]);

function isVariableBindableField(field: string): field is VariableBindableNodeField | VariableBindableTextField {
  return VARIABLE_BINDABLE_FIELDS.has(field);
}

function assertUniqueRefs(refs: readonly string[]): void {
  const seen = new Set<string>();
  for (const ref of refs) {
    if (seen.has(ref)) throw new Error(`Duplicate component variant ref "${ref}".`);
    seen.add(ref);
  }
}

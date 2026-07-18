import { readPluginData } from '../plugin_data';
import type { FigmaNodeSnapshot, FigmaSelectionDocument, JsonObject, JsonValue, MixFigmaDiagnostic } from '../types';

const SERIALIZED_PROPERTIES = [
  'x',
  'y',
  'width',
  'height',
  'rotation',
  'blendMode',
  'isMask',
  'layoutPositioning',
  'constraints',
  'layoutMode',
  'layoutWrap',
  'primaryAxisAlignItems',
  'counterAxisAlignItems',
  'primaryAxisSizingMode',
  'counterAxisSizingMode',
  'itemSpacing',
  'counterAxisSpacing',
  'paddingTop',
  'paddingRight',
  'paddingBottom',
  'paddingLeft',
  'minWidth',
  'maxWidth',
  'minHeight',
  'maxHeight',
  'fills',
  'strokes',
  'strokeWeight',
  'strokeAlign',
  'strokeJoin',
  'strokeCap',
  'dashPattern',
  'strokeTopWeight',
  'strokeRightWeight',
  'strokeBottomWeight',
  'strokeLeftWeight',
  'cornerRadius',
  'topLeftRadius',
  'topRightRadius',
  'bottomRightRadius',
  'bottomLeftRadius',
  'effects',
  'boundVariables',
  'characters',
  'fontName',
  'fontSize',
  'fontWeight',
  'letterSpacing',
  'lineHeight',
  'textAlignHorizontal',
  'textAlignVertical',
  'textAutoResize',
  'componentProperties',
] as const;

export function readSelection(api: PluginAPI): FigmaSelectionDocument {
  const diagnostics: MixFigmaDiagnostic[] = [];
  const selection = api.currentPage.selection.map((node, index) =>
    serializeNode(node, `selection.${index}`, diagnostics),
  );

  return {
    version: 1,
    pageId: api.currentPage.id,
    pageName: api.currentPage.name,
    selection,
    diagnostics,
  };
}

function serializeNode(
  node: SceneNode,
  path: string,
  diagnostics: MixFigmaDiagnostic[],
): FigmaNodeSnapshot {
  const raw = node as unknown as Record<string, unknown>;
  const pluginData = readPluginData(node);
  const properties: Record<string, JsonValue> = {};

  for (const key of SERIALIZED_PROPERTIES) {
    const serialized = toJsonValue(raw[key]);
    if (serialized !== undefined) properties[key] = serialized;
  }

  collectDiagnostics(raw, pluginData, path, diagnostics);

  const snapshot: {
    id: string;
    name: string;
    type: string;
    visible?: boolean;
    locked?: boolean;
    opacity?: number;
    pluginData: Readonly<Record<string, string>>;
    properties: JsonObject;
    children?: readonly FigmaNodeSnapshot[];
  } = {
    id: node.id,
    name: node.name,
    type: node.type,
    pluginData,
    properties,
  };

  if (typeof raw.visible === 'boolean') snapshot.visible = raw.visible;
  if (typeof raw.locked === 'boolean') snapshot.locked = raw.locked;
  if (typeof raw.opacity === 'number') snapshot.opacity = raw.opacity;
  if (Array.isArray(raw.children)) {
    snapshot.children = raw.children
      .filter(isSceneNodeLike)
      .map((child, index) => serializeNode(child, `${path}.children.${index}`, diagnostics));
  }

  return snapshot;
}

function collectDiagnostics(
  raw: Readonly<Record<string, unknown>>,
  pluginData: Readonly<Record<string, string>>,
  path: string,
  diagnostics: MixFigmaDiagnostic[],
): void {
  if (raw.layoutPositioning === 'ABSOLUTE') {
    diagnostics.push(diagnostic(
      'unsupported_absolute_positioned_child',
      path,
      'Absolute-positioned auto-layout children have no lossless Mix stack analogue.',
    ));
  }

  if (containsTypedObject(raw.effects, 'INNER_SHADOW')) {
    diagnostics.push(diagnostic(
      'unsupported_inner_shadow',
      path,
      'Figma inner shadows have no direct Mix protocol analogue.',
    ));
  }

  if (containsTypedObject(raw.fills, 'GRADIENT_ANGULAR') || containsTypedObject(raw.strokes, 'GRADIENT_ANGULAR')) {
    diagnostics.push(diagnostic(
      'unsupported_sweep_gradient',
      path,
      'Figma angular (sweep) gradients cannot be represented losslessly by the Mix protocol.',
    ));
  }

  const edgeWeights = [raw.strokeTopWeight, raw.strokeRightWeight, raw.strokeBottomWeight, raw.strokeLeftWeight]
    .filter((value): value is number => typeof value === 'number');
  if (edgeWeights.length === 4 && new Set(edgeWeights).size > 1) {
    diagnostics.push(diagnostic(
      'unsupported_per_edge_borders',
      path,
      'Different Figma stroke weights per edge cannot be represented losslessly.',
    ));
  }

  if ((pluginData['mix_figma.margin'] ?? '').length > 0) {
    diagnostics.push(diagnostic(
      'unsupported_margin',
      path,
      'Margin metadata is preserved, but Figma has no native margin property.',
    ));
  }
  if ((pluginData['mix_figma.foregroundDecoration'] ?? '').length > 0) {
    diagnostics.push(diagnostic(
      'unsupported_foreground_decoration',
      path,
      'Foreground decoration metadata is preserved, but Figma has no direct analogue.',
    ));
  }
}

function diagnostic(code: string, path: string, message: string): MixFigmaDiagnostic {
  return { code, severity: 'warning', path, message };
}

function containsTypedObject(value: unknown, type: string): boolean {
  return Array.isArray(value) && value.some((entry) => isRecord(entry) && entry.type === type);
}

function isSceneNodeLike(value: unknown): value is SceneNode {
  return isRecord(value) && typeof value.id === 'string' && typeof value.name === 'string' && typeof value.type === 'string';
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function toJsonValue(value: unknown): JsonValue | undefined {
  if (value === null || typeof value === 'boolean' || typeof value === 'number' || typeof value === 'string') {
    return value;
  }
  if (Array.isArray(value)) {
    return value.flatMap((entry) => {
      const serialized = toJsonValue(entry);
      return serialized === undefined ? [] : [serialized];
    });
  }
  if (!isRecord(value)) return undefined;

  const entries = Object.entries(value)
    .sort(([left], [right]) => left.localeCompare(right))
    .flatMap(([key, entry]) => {
      const serialized = toJsonValue(entry);
      return serialized === undefined ? [] : ([[key, serialized]] as const);
    });
  return Object.fromEntries(entries);
}

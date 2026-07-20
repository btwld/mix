import { writePluginData } from '../plugin_data';
import {
  MIX_FIGMA_PLUGIN_DATA_KEYS,
  type FigmaStylesWritePayload,
  type FigmaStylesWriteResult,
  type FigmaWriteOptions,
  type MixFigmaSyncOperation,
  type MixIdentityStamp,
} from '../types';

export async function writeStyles(
  api: PluginAPI,
  payload: FigmaStylesWritePayload,
  options: FigmaWriteOptions = {},
): Promise<FigmaStylesWriteResult> {
  assertUniqueRefs('text style', payload.textStyles.map((style) => style.ref));
  assertUniqueRefs('effect style', payload.effectStyles.map((style) => style.ref));
  assertUniqueRefs('paint style', (payload.paintStyles ?? []).map((style) => style.ref));

  const [localTextStyles, localEffectStyles, localPaintStyles] = await Promise.all([
    api.getLocalTextStylesAsync(),
    api.getLocalEffectStylesAsync(),
    api.getLocalPaintStylesAsync(),
  ]);
  const textStyleIds: Record<string, string> = {};
  const effectStyleIds: Record<string, string> = {};
  const paintStyleIds: Record<string, string> = {};

  for (const stylePayload of payload.textStyles) {
    const style = findStyle(localTextStyles, stylePayload) ?? api.createTextStyle();
    assertLocal(style, stylePayload.name);
    style.name = stylePayload.name;
    if (stylePayload.description !== undefined) style.description = stylePayload.description;

    if (stylePayload.fontName !== undefined) {
      await api.loadFontAsync(stylePayload.fontName);
      style.fontName = stylePayload.fontName;
    }
    if (stylePayload.fontSize !== undefined) style.fontSize = stylePayload.fontSize;
    if (stylePayload.letterSpacing !== undefined) style.letterSpacing = stylePayload.letterSpacing;
    if (stylePayload.lineHeight !== undefined) style.lineHeight = stylePayload.lineHeight;
    if (stylePayload.leadingTrim !== undefined) style.leadingTrim = stylePayload.leadingTrim;
    if (stylePayload.paragraphIndent !== undefined) style.paragraphIndent = stylePayload.paragraphIndent;
    if (stylePayload.paragraphSpacing !== undefined) style.paragraphSpacing = stylePayload.paragraphSpacing;
    if (stylePayload.listSpacing !== undefined) style.listSpacing = stylePayload.listSpacing;
    if (stylePayload.hangingPunctuation !== undefined) style.hangingPunctuation = stylePayload.hangingPunctuation;
    if (stylePayload.hangingList !== undefined) style.hangingList = stylePayload.hangingList;
    if (stylePayload.textCase !== undefined) style.textCase = stylePayload.textCase;
    if (stylePayload.textDecoration !== undefined) style.textDecoration = stylePayload.textDecoration;
    await writeTextStyleBindings(api, style, stylePayload.variableBindings);
    writePluginData(style, stylePayload.pluginData, stylePayload.identity);
    textStyleIds[stylePayload.ref] = style.id;
  }

  for (const stylePayload of payload.effectStyles) {
    const style = findStyle(localEffectStyles, stylePayload) ?? api.createEffectStyle();
    assertLocal(style, stylePayload.name);
    style.name = stylePayload.name;
    if (stylePayload.description !== undefined) style.description = stylePayload.description;
    style.effects = stylePayload.effects.slice();
    writePluginData(style, stylePayload.pluginData, stylePayload.identity);
    effectStyleIds[stylePayload.ref] = style.id;
  }

  for (const stylePayload of payload.paintStyles ?? []) {
    const style = findStyle(localPaintStyles, stylePayload) ?? api.createPaintStyle();
    assertLocal(style, stylePayload.name);
    style.name = stylePayload.name;
    if (stylePayload.description !== undefined) style.description = stylePayload.description;
    style.paints = stylePayload.paints.slice();
    writePluginData(style, stylePayload.pluginData, stylePayload.identity);
    paintStyleIds[stylePayload.ref] = style.id;
  }

  applyApprovedStyleDeletes(
    localTextStyles,
    localEffectStyles,
    localPaintStyles,
    options.operations ?? [],
  );

  return { textStyles: textStyleIds, effectStyles: effectStyleIds, paintStyles: paintStyleIds };
}

function applyApprovedStyleDeletes(
  textStyles: readonly TextStyle[],
  effectStyles: readonly EffectStyle[],
  paintStyles: readonly PaintStyle[],
  operations: readonly MixFigmaSyncOperation[],
): void {
  const stylesByKind: Readonly<Record<string, readonly BaseStyle[]>> = {
    textStyle: textStyles,
    effectStyle: effectStyles,
    paintStyle: paintStyles,
  };
  for (const operation of operations) {
    if (
      operation.action !== 'delete' ||
      !operation.destructive ||
      operation.sourceId === undefined
    ) {
      continue;
    }
    const styles = stylesByKind[operation.kind];
    if (styles === undefined) continue;
    const style = styles.find((item) => item.id === operation.sourceId);
    if (style === undefined) {
      throw new Error(`Approved ${operation.kind} delete target "${operation.sourceId}" was not found.`);
    }
    assertLocal(style, style.name);
    assertOwnedStyle(style, operation.ref, operation.kind);
    style.remove();
  }
}

function assertOwnedStyle(style: BaseStyle, expectedIdentity: string, kind: string): void {
  const identity =
    style.getPluginData(MIX_FIGMA_PLUGIN_DATA_KEYS.identity) ||
    style.getPluginData('mix.key');
  if (identity.length === 0 || identity !== expectedIdentity) {
    const label = kind === 'textStyle'
      ? 'text style'
      : kind === 'effectStyle'
        ? 'effect style'
        : 'paint style';
    throw new Error(`Refusing to delete unowned ${label}.`);
  }
}

interface StyleLookupPayload {
  readonly sourceId?: string;
  readonly name: string;
  readonly identity?: MixIdentityStamp;
}

function findStyle<T extends BaseStyle>(styles: readonly T[], payload: StyleLookupPayload): T | undefined {
  const expectedIdentity = payload.identity?.id;
  if (expectedIdentity === undefined) return undefined;
  const bySourceId = payload.sourceId === undefined
    ? undefined
    : styles.find((style) => style.id === payload.sourceId);
  if (bySourceId !== undefined && managedIdentity(bySourceId) === expectedIdentity) {
    return bySourceId;
  }
  return styles.find((style) => managedIdentity(style) === expectedIdentity);
}

function managedIdentity(style: Pick<PluginDataMixin, 'getPluginData'>): string {
  return (
    style.getPluginData(MIX_FIGMA_PLUGIN_DATA_KEYS.identity) ||
    style.getPluginData('mix.key')
  );
}

function assertLocal(style: BaseStyle, payloadName: string): void {
  if (style.remote) throw new Error(`Cannot update remote Figma style "${payloadName}".`);
}

function assertUniqueRefs(kind: string, refs: readonly string[]): void {
  const seen = new Set<string>();
  for (const ref of refs) {
    if (seen.has(ref)) throw new Error(`Duplicate ${kind} ref "${ref}".`);
    seen.add(ref);
  }
}

const TEXT_BINDABLE_FIELDS = new Set<string>([
  'fontFamily',
  'fontSize',
  'fontStyle',
  'fontWeight',
  'letterSpacing',
  'lineHeight',
  'paragraphSpacing',
  'paragraphIndent',
]);

async function writeTextStyleBindings(
  api: PluginAPI,
  style: TextStyle,
  bindings: Readonly<Record<string, string>> | undefined,
): Promise<void> {
  for (const [field, variableId] of Object.entries(bindings ?? {}).sort(([left], [right]) => left.localeCompare(right))) {
    if (!isTextBindableField(field)) {
      throw new Error(`Text style "${style.name}" has unsupported variable binding field "${field}".`);
    }
    const variable = await api.variables.getVariableByIdAsync(variableId);
    if (variable === null) {
      throw new Error(`Text style "${style.name}" references missing variable "${variableId}".`);
    }
    style.setBoundVariable(field, variable);
  }
}

function isTextBindableField(field: string): field is VariableBindableTextField {
  return TEXT_BINDABLE_FIELDS.has(field);
}

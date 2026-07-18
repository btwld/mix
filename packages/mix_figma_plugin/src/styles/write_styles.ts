import { writePluginData } from '../plugin_data';
import { MIX_FIGMA_PLUGIN_DATA_KEYS, type FigmaStylesWritePayload, type FigmaStylesWriteResult, type MixIdentityStamp } from '../types';

export async function writeStyles(
  api: PluginAPI,
  payload: FigmaStylesWritePayload,
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

  return { textStyles: textStyleIds, effectStyles: effectStyleIds, paintStyles: paintStyleIds };
}

interface StyleLookupPayload {
  readonly sourceId?: string;
  readonly name: string;
  readonly identity?: MixIdentityStamp;
}

function findStyle<T extends BaseStyle>(styles: readonly T[], payload: StyleLookupPayload): T | undefined {
  return styles.find(
    (style) =>
      style.id === payload.sourceId ||
      (payload.identity !== undefined &&
        style.getPluginData(MIX_FIGMA_PLUGIN_DATA_KEYS.identity) === payload.identity.id) ||
      style.name === payload.name,
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

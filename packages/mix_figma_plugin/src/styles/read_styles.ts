import { readPluginData } from '../plugin_data';
import type { FigmaStylesDocument } from '../types';

export async function readStyles(api: PluginAPI): Promise<FigmaStylesDocument> {
  const [localTextStyles, localEffectStyles, localPaintStyles] = await Promise.all([
    api.getLocalTextStylesAsync(),
    api.getLocalEffectStylesAsync(),
    api.getLocalPaintStylesAsync(),
  ]);

  return {
    version: 1,
    textStyles: localTextStyles
      .slice()
      .sort(compareByNameAndId)
      .map((style) => ({
        ...metadata(style),
        kind: 'TEXT' as const,
        fontName: style.fontName,
        fontSize: style.fontSize,
        letterSpacing: style.letterSpacing,
        lineHeight: style.lineHeight,
        leadingTrim: style.leadingTrim,
        paragraphIndent: style.paragraphIndent,
        paragraphSpacing: style.paragraphSpacing,
        listSpacing: style.listSpacing,
        hangingPunctuation: style.hangingPunctuation,
        hangingList: style.hangingList,
        textCase: style.textCase,
        textDecoration: style.textDecoration,
        ...(style.boundVariables === undefined ? {} : { boundVariables: serializeBoundVariables(style.boundVariables) }),
      })),
    effectStyles: localEffectStyles
      .slice()
      .sort(compareByNameAndId)
      .map((style) => ({
        ...metadata(style),
        kind: 'EFFECT' as const,
        effects: style.effects.slice(),
        ...(style.boundVariables === undefined ? {} : { boundVariables: serializeBoundVariables(style.boundVariables) }),
      })),
    paintStyles: localPaintStyles
      .slice()
      .sort(compareByNameAndId)
      .map((style) => ({
        ...metadata(style),
        kind: 'PAINT' as const,
        paints: style.paints.slice(),
        ...(style.boundVariables === undefined ? {} : { boundVariables: serializeBoundVariables(style.boundVariables) }),
      })),
  };
}

function metadata(style: BaseStyle) {
  return {
    id: style.id,
    key: style.key,
    name: style.name,
    description: style.description,
    remote: style.remote,
    pluginData: readPluginData(style),
  };
}

function compareByNameAndId(left: BaseStyle, right: BaseStyle): number {
  return left.name.localeCompare(right.name) || left.id.localeCompare(right.id);
}

function serializeBoundVariables(
  bindings: Readonly<Record<string, VariableAlias | readonly VariableAlias[]>>,
) {
  return Object.fromEntries(
    Object.entries(bindings)
      .sort(([left], [right]) => left.localeCompare(right))
      .map(([field, value]) => [
        field,
        isAliasArray(value)
          ? value.map((alias) => ({ type: 'VARIABLE_ALIAS' as const, id: alias.id }))
          : { type: 'VARIABLE_ALIAS' as const, id: value.id },
      ]),
  );
}

function isAliasArray(value: VariableAlias | readonly VariableAlias[]): value is readonly VariableAlias[] {
  return Array.isArray(value);
}

import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/json_map.dart';
import '../../core/schema_wire_types.dart';
import '../../encoder/payload_encoder.dart';
import '../shared/edge_insets_schema.dart';
import '../shared/enum_schemas.dart';
import '../shared/primitive_schemas.dart';
import '../shared/typography_schemas.dart';

typedef ModifierFieldsEncoder = JsonMap Function(ModifierMix modifier);

final class ModifierDefinition {
  final SchemaModifier type;
  final Type runtimeType;
  final AckSchema<ModifierMix> schema;
  final ModifierMix Function() sample;
  final ModifierFieldsEncoder _encodeFields;

  const ModifierDefinition({
    required this.type,
    required this.runtimeType,
    required this.schema,
    required this.sample,
    required ModifierFieldsEncoder encodeFields,
  }) : _encodeFields = encodeFields;

  JsonMap encode(ModifierMix modifier) {
    return {'type': type.wireValue, ..._encodeFields(modifier)};
  }
}

final Map<SchemaModifier, ModifierDefinition> modifierDefinitions =
    _buildModifierDefinitions();

Map<SchemaModifier, ModifierDefinition> _buildModifierDefinitions() {
  final definitions = <SchemaModifier, ModifierDefinition>{
    SchemaModifier.reset: ModifierDefinition(
      type: SchemaModifier.reset,
      runtimeType: ResetModifier,
      schema: Ack.object(
        const {},
      ).transform<ModifierMix>((_) => const ResetModifierMix()),
      sample: () => const ResetModifierMix(),
      encodeFields: (_) => const {},
    ),
    SchemaModifier.blur: ModifierDefinition(
      type: SchemaModifier.blur,
      runtimeType: BlurModifier,
      schema: Ack.object({'sigma': Ack.double().min(0).optional()})
          .transform<ModifierMix>((data) {
            final map = data;

            return BlurModifierMix(sigma: map['sigma'] as double?);
          }),
      sample: () => BlurModifierMix(sigma: 4),
      encodeFields: (modifier) {
        final value = modifier as BlurModifierMix;

        return {if (_propValue(value.sigma) case final sigma?) 'sigma': sigma};
      },
    ),
    SchemaModifier.opacity: ModifierDefinition(
      type: SchemaModifier.opacity,
      runtimeType: OpacityModifier,
      schema: Ack.object({'value': Ack.double().min(0).max(1)})
          .transform<ModifierMix>((data) {
            final map = data;

            return OpacityModifierMix(opacity: map['value'] as double);
          }),
      sample: () => OpacityModifierMix(opacity: 0.5),
      encodeFields: (modifier) {
        final value = modifier as OpacityModifierMix;

        return {'value': _requiredPropValue(value.opacity, 'opacity')};
      },
    ),
    SchemaModifier.visibility: ModifierDefinition(
      type: SchemaModifier.visibility,
      runtimeType: VisibilityModifier,
      schema: Ack.object({'visible': Ack.boolean()}).transform<ModifierMix>((
        data,
      ) {
        final map = data;

        return VisibilityModifierMix(visible: map['visible'] as bool);
      }),
      sample: () => VisibilityModifierMix(visible: false),
      encodeFields: (modifier) {
        final value = modifier as VisibilityModifierMix;

        return {'visible': _requiredPropValue(value.visible, 'visible')};
      },
    ),
    SchemaModifier.align: ModifierDefinition(
      type: SchemaModifier.align,
      runtimeType: AlignModifier,
      schema:
          Ack.object({
            'alignment': alignmentSchema.optional(),
            'widthFactor': Ack.double().optional(),
            'heightFactor': Ack.double().optional(),
          }).transform<ModifierMix>((data) {
            final map = data;

            return AlignModifierMix(
              alignment: map['alignment'] as AlignmentGeometry?,
              widthFactor: map['widthFactor'] as double?,
              heightFactor: map['heightFactor'] as double?,
            );
          }),
      sample: () => AlignModifierMix(
        alignment: const Alignment(-1, 0.5),
        widthFactor: 2,
        heightFactor: 3,
      ),
      encodeFields: (modifier) {
        final value = modifier as AlignModifierMix;

        return {
          if (_propValue(value.alignment) case final alignment?)
            'alignment': payloadAlignment(alignment),
          if (_propValue(value.widthFactor) case final widthFactor?)
            'widthFactor': widthFactor,
          if (_propValue(value.heightFactor) case final heightFactor?)
            'heightFactor': heightFactor,
        };
      },
    ),
    SchemaModifier.padding: ModifierDefinition(
      type: SchemaModifier.padding,
      runtimeType: PaddingModifier,
      schema: Ack.object({'padding': edgeInsetsGeometrySchema.optional()})
          .transform<ModifierMix>((data) {
            final map = data;

            return PaddingModifierMix(
              padding: map['padding'] as EdgeInsetsGeometryMix?,
            );
          }),
      sample: () => PaddingModifierMix(
        padding: EdgeInsetsMix(top: 1, bottom: 2, left: 3, right: 4),
      ),
      encodeFields: (modifier) {
        final value = modifier as PaddingModifierMix;

        return {
          if (_propMix<EdgeInsetsGeometryMix>(value.padding)
              case final padding?)
            'padding': _encodeEdgeInsetsGeometryMix(padding),
        };
      },
    ),
    SchemaModifier.scale: ModifierDefinition(
      type: SchemaModifier.scale,
      runtimeType: ScaleModifier,
      schema:
          Ack.object({
            'x': Ack.double(),
            'y': Ack.double(),
            'alignment': alignmentSchema.optional(),
          }).transform<ModifierMix>((data) {
            final map = data;

            return ScaleModifierMix(
              x: map['x'] as double,
              y: map['y'] as double,
              alignment: map['alignment'] as Alignment?,
            );
          }),
      sample: () =>
          ScaleModifierMix(x: 1.25, y: 0.75, alignment: Alignment.topLeft),
      encodeFields: (modifier) {
        final value = modifier as ScaleModifierMix;

        return {
          'x': _requiredPropValue(value.x, 'x'),
          'y': _requiredPropValue(value.y, 'y'),
          if (_propValue(value.alignment) case final alignment?)
            'alignment': payloadAlignment(alignment),
        };
      },
    ),
    SchemaModifier.rotate: ModifierDefinition(
      type: SchemaModifier.rotate,
      runtimeType: RotateModifier,
      schema:
          Ack.object({
            'radians': Ack.double(),
            'alignment': alignmentSchema.optional(),
          }).transform<ModifierMix>((data) {
            final map = data;

            return RotateModifierMix(
              radians: map['radians'] as double,
              alignment: map['alignment'] as Alignment?,
            );
          }),
      sample: () =>
          RotateModifierMix(radians: 0.25, alignment: Alignment.bottomRight),
      encodeFields: (modifier) {
        final value = modifier as RotateModifierMix;

        return {
          'radians': _requiredPropValue(value.radians, 'radians'),
          if (_propValue(value.alignment) case final alignment?)
            'alignment': payloadAlignment(alignment),
        };
      },
    ),
    SchemaModifier.defaultTextStyle: ModifierDefinition(
      type: SchemaModifier.defaultTextStyle,
      runtimeType: DefaultTextStyleModifier,
      schema:
          Ack.object({
            'style': textStyleSchema.optional(),
            'textAlign': textAlignSchema.optional(),
            'softWrap': Ack.boolean().optional(),
            'overflow': textOverflowSchema.optional(),
            'maxLines': Ack.integer().min(1).optional(),
            'textWidthBasis': textWidthBasisSchema.optional(),
            'textHeightBehavior': textHeightBehaviorSchema.optional(),
          }).transform<ModifierMix>((data) {
            final map = data;

            return DefaultTextStyleModifierMix(
              style: map['style'] as TextStyleMix?,
              textAlign: map['textAlign'] as TextAlign?,
              softWrap: map['softWrap'] as bool?,
              overflow: map['overflow'] as TextOverflow?,
              maxLines: map['maxLines'] as int?,
              textWidthBasis: map['textWidthBasis'] as TextWidthBasis?,
              textHeightBehavior:
                  map['textHeightBehavior'] as TextHeightBehaviorMix?,
            );
          }),
      sample: () => DefaultTextStyleModifierMix(
        style: TextStyleMix(
          color: const Color(0xFF112233),
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          letterSpacing: 0.5,
          wordSpacing: 1.5,
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.underline,
          decorationColor: const Color(0xFF445566),
          decorationStyle: TextDecorationStyle.dashed,
          height: 1.25,
          decorationThickness: 2,
          fontFamily: 'Inter',
          fontFamilyFallback: const ['Roboto', 'Arial'],
          inherit: false,
        ),
        textAlign: TextAlign.center,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        textWidthBasis: TextWidthBasis.longestLine,
        textHeightBehavior: TextHeightBehaviorMix(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        ),
      ),
      encodeFields: (modifier) {
        final value = modifier as DefaultTextStyleModifierMix;

        return {
          if (_propMix<TextStyleMix>(value.style) case final style?)
            'style': _encodeTextStyleMix(style),
          if (_propValue(value.textAlign) case final textAlign?)
            'textAlign': textAlign.name,
          if (_propValue(value.softWrap) case final softWrap?)
            'softWrap': softWrap,
          if (_propValue(value.overflow) case final overflow?)
            'overflow': overflow.name,
          if (_propValue(value.maxLines) case final maxLines?)
            'maxLines': maxLines,
          if (_propValue(value.textWidthBasis) case final textWidthBasis?)
            'textWidthBasis': textWidthBasis.name,
          if (_propMix<TextHeightBehaviorMix>(value.textHeightBehavior)
              case final textHeightBehavior?)
            'textHeightBehavior': _encodeTextHeightBehaviorMix(
              textHeightBehavior,
            ),
        };
      },
    ),
  };

  assert(
    definitions.length == SchemaModifier.values.length &&
        SchemaModifier.values.every(definitions.containsKey),
    'modifierDefinitions must cover every SchemaModifier.',
  );

  return Map.unmodifiable(definitions);
}

Type modifierRuntimeType(SchemaModifier type) {
  return modifierDefinitions[type]!.runtimeType;
}

T? _propValue<T>(Prop<T>? prop) {
  if (prop == null) return null;
  if (prop.sources.length != 1) {
    throw UnsupportedError('Only single-source value props can be encoded.');
  }

  final source = prop.sources.single;
  if (source is ValueSource<T>) {
    return source.value;
  }

  throw UnsupportedError('Only direct value props can be encoded.');
}

T _requiredPropValue<T>(Prop<T>? prop, String field) {
  final value = _propValue(prop);
  if (value == null) {
    throw StateError('Modifier field "$field" is required.');
  }

  return value;
}

M? _propMix<M extends Mix>(Prop? prop) {
  if (prop == null) return null;
  if (prop.sources.length != 1) {
    throw UnsupportedError('Only single-source mix props can be encoded.');
  }

  final source = prop.sources.single;
  if (source is MixSource && source.mix is M) {
    return source.mix as M;
  }

  throw UnsupportedError('Only direct mix props can be encoded.');
}

JsonMap _encodeEdgeInsetsGeometryMix(EdgeInsetsGeometryMix value) {
  return switch (value) {
    EdgeInsetsMix() => {
      if (_propValue(value.$top) case final top?) 'top': top,
      if (_propValue(value.$bottom) case final bottom?) 'bottom': bottom,
      if (_propValue(value.$left) case final left?) 'left': left,
      if (_propValue(value.$right) case final right?) 'right': right,
    },
    EdgeInsetsDirectionalMix() => {
      if (_propValue(value.$top) case final top?) 'top': top,
      if (_propValue(value.$bottom) case final bottom?) 'bottom': bottom,
      if (_propValue(value.$start) case final start?) 'start': start,
      if (_propValue(value.$end) case final end?) 'end': end,
    },
  };
}

JsonMap _encodeTextStyleMix(TextStyleMix value) {
  return {
    if (_propValue(value.$color) case final color?)
      'color': payloadColor(color),
    if (_propValue(value.$backgroundColor) case final backgroundColor?)
      'backgroundColor': payloadColor(backgroundColor),
    if (_propValue(value.$fontSize) case final fontSize?) 'fontSize': fontSize,
    if (_propValue(value.$fontWeight) case final fontWeight?)
      'fontWeight': _fontWeightWireName(fontWeight),
    if (_propValue(value.$fontStyle) case final fontStyle?)
      'fontStyle': fontStyle.name,
    if (_propValue(value.$letterSpacing) case final letterSpacing?)
      'letterSpacing': letterSpacing,
    if (_propValue(value.$wordSpacing) case final wordSpacing?)
      'wordSpacing': wordSpacing,
    if (_propValue(value.$textBaseline) case final textBaseline?)
      'textBaseline': textBaseline.name,
    if (_propValue(value.$decoration) case final decoration?)
      'decoration': _textDecorationWireName(decoration),
    if (_propValue(value.$decorationColor) case final decorationColor?)
      'decorationColor': payloadColor(decorationColor),
    if (_propValue(value.$decorationStyle) case final decorationStyle?)
      'decorationStyle': decorationStyle.name,
    if (_propValue(value.$height) case final height?) 'height': height,
    if (_propValue(value.$decorationThickness) case final decorationThickness?)
      'decorationThickness': decorationThickness,
    if (_propValue(value.$fontFamily) case final fontFamily?)
      'fontFamily': fontFamily,
    if (_propValue(value.$fontFamilyFallback) case final fontFamilyFallback?)
      'fontFamilyFallback': fontFamilyFallback,
    if (_propValue(value.$inherit) case final inherit?) 'inherit': inherit,
    if (_propMix<ShadowListMix>(value.$shadows) case final shadows?)
      'shadows': [for (final shadow in shadows.items) _encodeShadowMix(shadow)],
  };
}

JsonMap _encodeShadowMix(ShadowMix value) {
  return {
    if (_propValue(value.$color) case final color?)
      'color': payloadColor(color),
    if (_propValue(value.$offset) case final offset?)
      'offset': payloadOffset(offset),
    if (_propValue(value.$blurRadius) case final blurRadius?)
      'blurRadius': blurRadius,
  };
}

JsonMap _encodeTextHeightBehaviorMix(TextHeightBehaviorMix value) {
  return {
    if (_propValue(value.$applyHeightToFirstAscent)
        case final applyHeightToFirstAscent?)
      'applyHeightToFirstAscent': applyHeightToFirstAscent,
    if (_propValue(value.$applyHeightToLastDescent)
        case final applyHeightToLastDescent?)
      'applyHeightToLastDescent': applyHeightToLastDescent,
    if (_propValue(value.$leadingDistribution) case final leadingDistribution?)
      'leadingDistribution': leadingDistribution.name,
  };
}

String _fontWeightWireName(FontWeight value) {
  return switch (value) {
    FontWeight.w100 => 'w100',
    FontWeight.w200 => 'w200',
    FontWeight.w300 => 'w300',
    FontWeight.w400 => 'w400',
    FontWeight.w500 => 'w500',
    FontWeight.w600 => 'w600',
    FontWeight.w700 => 'w700',
    FontWeight.w800 => 'w800',
    FontWeight.w900 => 'w900',
    _ => throw StateError('Unsupported font weight: $value'),
  };
}

String _textDecorationWireName(TextDecoration value) {
  if (value == TextDecoration.none) return 'none';
  if (value == TextDecoration.underline) return 'underline';
  if (value == TextDecoration.overline) return 'overline';
  if (value == TextDecoration.lineThrough) return 'lineThrough';

  throw StateError('Unsupported text decoration: $value');
}

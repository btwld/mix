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
  final Type modifierRuntimeType;
  final AckSchema<ModifierMix> schema;
  final ModifierMix Function() sample;
  final ModifierFieldsEncoder _encodeFields;

  const ModifierDefinition({
    required this.type,
    required this.modifierRuntimeType,
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
      modifierRuntimeType: ResetModifier,
      schema: Ack.object(
        const {},
      ).transform<ModifierMix>((_) => const ResetModifierMix()),
      sample: () => const ResetModifierMix(),
      encodeFields: (_) => const {},
    ),
    SchemaModifier.blur: ModifierDefinition(
      type: SchemaModifier.blur,
      modifierRuntimeType: BlurModifier,
      schema: Ack.object({'sigma': Ack.double().min(0).optional()})
          .transform<ModifierMix>((data) {
            final map = data;

            return BlurModifierMix(sigma: map['sigma'] as double?);
          }),
      sample: () => BlurModifierMix(sigma: 4),
      encodeFields: (modifier) {
        final value = modifier as BlurModifierMix;

        return _optionalJsonMap([('sigma', _propValue(value.sigma))]);
      },
    ),
    SchemaModifier.opacity: ModifierDefinition(
      type: SchemaModifier.opacity,
      modifierRuntimeType: OpacityModifier,
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
      modifierRuntimeType: VisibilityModifier,
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
      modifierRuntimeType: AlignModifier,
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

        return _optionalJsonMap([
          (
            'alignment',
            _mapOptional(_propValue(value.alignment), payloadAlignment),
          ),
          ('widthFactor', _propValue(value.widthFactor)),
          ('heightFactor', _propValue(value.heightFactor)),
        ]);
      },
    ),
    SchemaModifier.padding: ModifierDefinition(
      type: SchemaModifier.padding,
      modifierRuntimeType: PaddingModifier,
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

        return _optionalJsonMap([
          (
            'padding',
            _mapOptional(
              _propMix<EdgeInsetsGeometryMix>(value.padding),
              _encodeEdgeInsetsGeometryMix,
            ),
          ),
        ]);
      },
    ),
    SchemaModifier.scale: ModifierDefinition(
      type: SchemaModifier.scale,
      modifierRuntimeType: ScaleModifier,
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
          ..._optionalJsonMap([
            (
              'alignment',
              _mapOptional(_propValue(value.alignment), payloadAlignment),
            ),
          ]),
        };
      },
    ),
    SchemaModifier.rotate: ModifierDefinition(
      type: SchemaModifier.rotate,
      modifierRuntimeType: RotateModifier,
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
          ..._optionalJsonMap([
            (
              'alignment',
              _mapOptional(_propValue(value.alignment), payloadAlignment),
            ),
          ]),
        };
      },
    ),
    SchemaModifier.defaultTextStyle: ModifierDefinition(
      type: SchemaModifier.defaultTextStyle,
      modifierRuntimeType: DefaultTextStyleModifier,
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

        return _optionalJsonMap([
          (
            'style',
            _mapOptional(
              _propMix<TextStyleMix>(value.style),
              _encodeTextStyleMix,
            ),
          ),
          (
            'textAlign',
            _mapOptional(_propValue(value.textAlign), (value) => value.name),
          ),
          ('softWrap', _propValue(value.softWrap)),
          (
            'overflow',
            _mapOptional(_propValue(value.overflow), (value) => value.name),
          ),
          ('maxLines', _propValue(value.maxLines)),
          (
            'textWidthBasis',
            _mapOptional(
              _propValue(value.textWidthBasis),
              (value) => value.name,
            ),
          ),
          (
            'textHeightBehavior',
            _mapOptional(
              _propMix<TextHeightBehaviorMix>(value.textHeightBehavior),
              _encodeTextHeightBehaviorMix,
            ),
          ),
        ]);
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
  return modifierDefinitions[type]!.modifierRuntimeType;
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

JsonMap _optionalJsonMap(Iterable<(String, Object?)> fields) {
  final payload = <String, Object?>{};

  for (final (key, value) in fields) {
    if (value != null) {
      payload[key] = value;
    }
  }

  return payload;
}

Object? _mapOptional<T>(T? value, Object? Function(T value) encode) {
  return value == null ? null : encode(value);
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
    EdgeInsetsMix() => _optionalJsonMap([
      ('top', _propValue(value.$top)),
      ('bottom', _propValue(value.$bottom)),
      ('left', _propValue(value.$left)),
      ('right', _propValue(value.$right)),
    ]),
    EdgeInsetsDirectionalMix() => _optionalJsonMap([
      ('top', _propValue(value.$top)),
      ('bottom', _propValue(value.$bottom)),
      ('start', _propValue(value.$start)),
      ('end', _propValue(value.$end)),
    ]),
  };
}

JsonMap _encodeTextStyleMix(TextStyleMix value) {
  return _optionalJsonMap([
    ('color', _mapOptional(_propValue(value.$color), payloadColor)),
    (
      'backgroundColor',
      _mapOptional(_propValue(value.$backgroundColor), payloadColor),
    ),
    ('fontSize', _propValue(value.$fontSize)),
    (
      'fontWeight',
      _mapOptional(_propValue(value.$fontWeight), _fontWeightWireName),
    ),
    (
      'fontStyle',
      _mapOptional(_propValue(value.$fontStyle), (value) => value.name),
    ),
    ('letterSpacing', _propValue(value.$letterSpacing)),
    ('wordSpacing', _propValue(value.$wordSpacing)),
    (
      'textBaseline',
      _mapOptional(_propValue(value.$textBaseline), (value) => value.name),
    ),
    (
      'decoration',
      _mapOptional(_propValue(value.$decoration), _textDecorationWireName),
    ),
    (
      'decorationColor',
      _mapOptional(_propValue(value.$decorationColor), payloadColor),
    ),
    (
      'decorationStyle',
      _mapOptional(_propValue(value.$decorationStyle), (value) => value.name),
    ),
    ('height', _propValue(value.$height)),
    ('decorationThickness', _propValue(value.$decorationThickness)),
    ('fontFamily', _propValue(value.$fontFamily)),
    ('fontFamilyFallback', _propValue(value.$fontFamilyFallback)),
    ('inherit', _propValue(value.$inherit)),
    (
      'shadows',
      _mapOptional(_propMix<ShadowListMix>(value.$shadows), (shadows) {
        return [for (final shadow in shadows.items) _encodeShadowMix(shadow)];
      }),
    ),
  ]);
}

JsonMap _encodeShadowMix(ShadowMix value) {
  return _optionalJsonMap([
    ('color', _mapOptional(_propValue(value.$color), payloadColor)),
    ('offset', _mapOptional(_propValue(value.$offset), payloadOffset)),
    ('blurRadius', _propValue(value.$blurRadius)),
  ]);
}

JsonMap _encodeTextHeightBehaviorMix(TextHeightBehaviorMix value) {
  return _optionalJsonMap([
    ('applyHeightToFirstAscent', _propValue(value.$applyHeightToFirstAscent)),
    ('applyHeightToLastDescent', _propValue(value.$applyHeightToLastDescent)),
    (
      'leadingDistribution',
      _mapOptional(
        _propValue(value.$leadingDistribution),
        (value) => value.name,
      ),
    ),
  ]);
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

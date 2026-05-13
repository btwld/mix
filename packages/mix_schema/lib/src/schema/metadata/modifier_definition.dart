import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/codec_typed_encode.dart';
import '../../core/json_casts.dart';
import '../../core/json_map.dart';
import '../../core/prop_encode.dart';
import '../../core/schema_wire_types.dart';
import '../shared/shared_schemas.dart';

final class ModifierDefinition {
  final SchemaModifier type;
  final Type modifierRuntimeType;
  final CodecSchema<Map<String, Object?>, ModifierMix> codec;

  const ModifierDefinition({
    required this.type,
    required this.modifierRuntimeType,
    required this.codec,
  });

  JsonMap encode(ModifierMix modifier) => codec.encodeTyped(modifier);
}

CodecSchema<Map<String, Object?>, ModifierMix>
_modifierCodec<T extends Object>({
  required SchemaModifier type,
  required ObjectSchema input,
  required T Function(Map<String, Object?> data) decoder,
  required JsonMap Function(T value) encoder,
}) {
  return Ack.codec<Map<String, Object?>, ModifierMix>(
    input: input.copyWith(
      properties: {'type': Ack.literal(type.wireValue), ...input.properties},
    ),
    output: Ack.instance<ModifierMix>().refine(
      (value) => value is T,
      message: 'Expected $T.',
    ),
    decoder: (data) => decoder(data) as ModifierMix,
    encoder: (value) => {'type': type.wireValue, ...encoder(value as T)},
  );
}

final Map<SchemaModifier, ModifierDefinition> modifierDefinitions =
    _buildModifierDefinitions();

Map<SchemaModifier, ModifierDefinition> _buildModifierDefinitions() {
  final definitions = {
    SchemaModifier.reset: ModifierDefinition(
      type: .reset,
      modifierRuntimeType: ResetModifier,
      codec: _modifierCodec<ResetModifierMix>(
        type: .reset,
        input: Ack.object(const {}),
        decoder: (_) => const ResetModifierMix(),
        encoder: (_) => const {},
      ),
    ),
    SchemaModifier.blur: ModifierDefinition(
      type: .blur,
      modifierRuntimeType: BlurModifier,
      codec: _modifierCodec<BlurModifierMix>(
        type: .blur,
        input: Ack.object({'sigma': Ack.number().min(0).optional()}),
        decoder: (data) {
          final map = data;

          return BlurModifierMix(sigma: castDoubleOrNull(map['sigma']));
        },
        encoder: (value) {
          return optionalJsonMap([('sigma', propValue(value.sigma))]);
        },
      ),
    ),
    SchemaModifier.opacity: ModifierDefinition(
      type: .opacity,
      modifierRuntimeType: OpacityModifier,
      codec: _modifierCodec<OpacityModifierMix>(
        type: .opacity,
        input: Ack.object({
          'value': Ack.number().refine(
            (value) => value >= 0 && value <= 1,
            message: 'Must be in [0, 1].',
          ),
        }),
        decoder: (data) {
          final map = data;

          return OpacityModifierMix(opacity: castDouble(map['value']));
        },
        encoder: (value) {
          return {'value': requiredPropValue(value.opacity, 'opacity')};
        },
      ),
    ),
    SchemaModifier.visibility: ModifierDefinition(
      type: .visibility,
      modifierRuntimeType: VisibilityModifier,
      codec: _modifierCodec<VisibilityModifierMix>(
        type: .visibility,
        input: Ack.object({'visible': Ack.boolean()}),
        decoder: (data) {
          final map = data;

          return VisibilityModifierMix(visible: map['visible'] as bool);
        },
        encoder: (value) {
          return {'visible': requiredPropValue(value.visible, 'visible')};
        },
      ),
    ),
    SchemaModifier.align: ModifierDefinition(
      type: .align,
      modifierRuntimeType: AlignModifier,
      codec: _modifierCodec<AlignModifierMix>(
        type: .align,
        input: Ack.object({
          'alignment': alignmentCodec.optional(),
          'widthFactor': Ack.number().optional(),
          'heightFactor': Ack.number().optional(),
        }),
        decoder: (data) {
          final map = data;

          return AlignModifierMix(
            alignment: map['alignment'] as AlignmentGeometry?,
            widthFactor: castDoubleOrNull(map['widthFactor']),
            heightFactor: castDoubleOrNull(map['heightFactor']),
          );
        },
        encoder: (value) {
          return optionalJsonMap([
            ('alignment', propValue(value.alignment)),
            ('widthFactor', propValue(value.widthFactor)),
            ('heightFactor', propValue(value.heightFactor)),
          ]);
        },
      ),
    ),
    SchemaModifier.padding: ModifierDefinition(
      type: .padding,
      modifierRuntimeType: PaddingModifier,
      codec: _modifierCodec<PaddingModifierMix>(
        type: .padding,
        input: Ack.object({'padding': edgeInsetsGeometryCodec.optional()}),
        decoder: (data) {
          final map = data;

          return PaddingModifierMix(
            padding: map['padding'] as EdgeInsetsGeometryMix?,
          );
        },
        encoder: (value) {
          return optionalJsonMap([
            ('padding', propMix<EdgeInsetsGeometryMix>(value.padding)),
          ]);
        },
      ),
    ),
    SchemaModifier.scale: ModifierDefinition(
      type: .scale,
      modifierRuntimeType: ScaleModifier,
      codec: _modifierCodec<ScaleModifierMix>(
        type: .scale,
        input: Ack.object({
          'x': Ack.number(),
          'y': Ack.number(),
          'alignment': alignmentCodec.optional(),
        }),
        decoder: (data) {
          final map = data;

          return ScaleModifierMix(
            x: castDouble(map['x']),
            y: castDouble(map['y']),
            alignment: map['alignment'] as Alignment?,
          );
        },
        encoder: (value) {
          return {
            'x': requiredPropValue(value.x, 'x'),
            'y': requiredPropValue(value.y, 'y'),
            ...optionalJsonMap([('alignment', propValue(value.alignment))]),
          };
        },
      ),
    ),
    SchemaModifier.rotate: ModifierDefinition(
      type: .rotate,
      modifierRuntimeType: RotateModifier,
      codec: _modifierCodec<RotateModifierMix>(
        type: .rotate,
        input: Ack.object({
          'radians': Ack.number(),
          'alignment': alignmentCodec.optional(),
        }),
        decoder: (data) {
          final map = data;

          return RotateModifierMix(
            radians: castDouble(map['radians']),
            alignment: map['alignment'] as Alignment?,
          );
        },
        encoder: (value) {
          return {
            'radians': requiredPropValue(value.radians, 'radians'),
            ...optionalJsonMap([('alignment', propValue(value.alignment))]),
          };
        },
      ),
    ),
    SchemaModifier.defaultTextStyle: ModifierDefinition(
      type: .defaultTextStyle,
      modifierRuntimeType: DefaultTextStyleModifier,
      codec: _modifierCodec<DefaultTextStyleModifierMix>(
        type: .defaultTextStyle,
        input: Ack.object({
          'style': textStyleCodec.optional(),
          'textAlign': textAlignSchema.optional(),
          'softWrap': Ack.boolean().optional(),
          'overflow': textOverflowSchema.optional(),
          'maxLines': Ack.integer().min(1).optional(),
          'textWidthBasis': textWidthBasisSchema.optional(),
          'textHeightBehavior': textHeightBehaviorCodec.optional(),
        }),
        decoder: (data) {
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
        },
        encoder: (value) {
          return optionalJsonMap([
            ('style', propMix<TextStyleMix>(value.style)),
            ('textAlign', propValue(value.textAlign)),
            ('softWrap', propValue(value.softWrap)),
            ('overflow', propValue(value.overflow)),
            ('maxLines', propValue(value.maxLines)),
            ('textWidthBasis', propValue(value.textWidthBasis)),
            (
              'textHeightBehavior',
              propMix<TextHeightBehaviorMix>(value.textHeightBehavior),
            ),
          ]);
        },
      ),
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

SchemaModifier? schemaModifierForRuntimeType(Type runtimeType) {
  for (final definition in modifierDefinitions.values) {
    if (definition.modifierRuntimeType == runtimeType) {
      return definition.type;
    }
  }

  return null;
}

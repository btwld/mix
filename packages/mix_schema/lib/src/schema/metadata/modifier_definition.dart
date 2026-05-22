import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/numeric_codecs.dart';
import '../../core/prop_encode.dart';
import '../../core/schema_wire_types.dart';
import '../shared/shared_schemas.dart';

final class ModifierDefinition {
  final SchemaModifier type;
  final Type modifierRuntimeType;
  final CodecSchema<JsonMap, ModifierMix> codec;

  const ModifierDefinition({
    required this.type,
    required this.modifierRuntimeType,
    required this.codec,
  });

  JsonMap encode(ModifierMix modifier) => codec.encode(modifier)!;
}

CodecSchema<JsonMap, ModifierMix> _modifierCodec<T extends Object>({
  required SchemaModifier type,
  required ObjectSchema input,
  required T Function(JsonMap data) decode,
  required JsonMap Function(T value) encode,
}) {
  return Ack.codec<JsonMap, JsonMap, ModifierMix>(
    input: input.copyWith(
      properties: {'type': Ack.literal(type.wireValue), ...input.properties},
    ),
    output: Ack.instance<ModifierMix>().refine(
      (value) => value is T,
      message: 'Expected $T.',
    ),
    decode: (data) => decode(data) as ModifierMix,
    encode: (value) => {'type': type.wireValue, ...encode(value as T)},
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
        decode: (_) => const ResetModifierMix(),
        encode: (_) => const {},
      ),
    ),
    SchemaModifier.blur: ModifierDefinition(
      type: .blur,
      modifierRuntimeType: BlurModifier,
      codec: _modifierCodec<BlurModifierMix>(
        type: .blur,
        input: Ack.object({
          'sigma': doubleFromNum()
              .refine((v) => v >= 0, message: 'Must be ≥ 0')
              .optional(),
        }),
        decode: (data) => BlurModifierMix(sigma: data['sigma'] as double?),
        encode: (value) => optionalJsonMap([('sigma', propValue(value.sigma))]),
      ),
    ),
    SchemaModifier.opacity: ModifierDefinition(
      type: .opacity,
      modifierRuntimeType: OpacityModifier,
      codec: _modifierCodec<OpacityModifierMix>(
        type: .opacity,
        input: Ack.object({
          'value': doubleFromNum().refine(
            (value) => value >= 0 && value <= 1,
            message: 'Must be in [0, 1].',
          ),
        }),
        decode: (data) => OpacityModifierMix(opacity: data['value']! as double),
        encode: (value) => {
          'value': requiredPropValue(value.opacity, 'opacity'),
        },
      ),
    ),
    SchemaModifier.visibility: ModifierDefinition(
      type: .visibility,
      modifierRuntimeType: VisibilityModifier,
      codec: _modifierCodec<VisibilityModifierMix>(
        type: .visibility,
        input: Ack.object({'visible': Ack.boolean()}),
        decode: (data) =>
            VisibilityModifierMix(visible: data['visible']! as bool),
        encode: (value) => {
          'visible': requiredPropValue(value.visible, 'visible'),
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
          'widthFactor': doubleFromNum().optional(),
          'heightFactor': doubleFromNum().optional(),
        }),
        decode: (data) => AlignModifierMix(
          alignment: data['alignment'] as AlignmentGeometry?,
          widthFactor: data['widthFactor'] as double?,
          heightFactor: data['heightFactor'] as double?,
        ),
        encode: (value) => optionalJsonMap([
          ('alignment', propValue(value.alignment)),
          ('widthFactor', propValue(value.widthFactor)),
          ('heightFactor', propValue(value.heightFactor)),
        ]),
      ),
    ),
    SchemaModifier.padding: ModifierDefinition(
      type: .padding,
      modifierRuntimeType: PaddingModifier,
      codec: _modifierCodec<PaddingModifierMix>(
        type: .padding,
        input: Ack.object({'padding': edgeInsetsGeometryCodec.optional()}),
        decode: (data) => PaddingModifierMix(
          padding: data['padding'] as EdgeInsetsGeometryMix?,
        ),
        encode: (value) => optionalJsonMap([
          ('padding', propMix<EdgeInsetsGeometryMix>(value.padding)),
        ]),
      ),
    ),
    SchemaModifier.scale: ModifierDefinition(
      type: .scale,
      modifierRuntimeType: ScaleModifier,
      codec: _modifierCodec<ScaleModifierMix>(
        type: .scale,
        input: Ack.object({
          'x': doubleFromNum(),
          'y': doubleFromNum(),
          'alignment': alignmentCodec.optional(),
        }),
        decode: (data) => ScaleModifierMix(
          x: data['x']! as double,
          y: data['y']! as double,
          alignment: data['alignment'] as Alignment?,
        ),
        encode: (value) => {
          'x': requiredPropValue(value.x, 'x'),
          'y': requiredPropValue(value.y, 'y'),
          ...optionalJsonMap([('alignment', propValue(value.alignment))]),
        },
      ),
    ),
    SchemaModifier.rotate: ModifierDefinition(
      type: .rotate,
      modifierRuntimeType: RotateModifier,
      codec: _modifierCodec<RotateModifierMix>(
        type: .rotate,
        input: Ack.object({
          'radians': doubleFromNum(),
          'alignment': alignmentCodec.optional(),
        }),
        decode: (data) => RotateModifierMix(
          radians: data['radians']! as double,
          alignment: data['alignment'] as Alignment?,
        ),
        encode: (value) => {
          'radians': requiredPropValue(value.radians, 'radians'),
          ...optionalJsonMap([('alignment', propValue(value.alignment))]),
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
        decode: (data) => DefaultTextStyleModifierMix(
          style: data['style'] as TextStyleMix?,
          textAlign: data['textAlign'] as TextAlign?,
          softWrap: data['softWrap'] as bool?,
          overflow: data['overflow'] as TextOverflow?,
          maxLines: data['maxLines'] as int?,
          textWidthBasis: data['textWidthBasis'] as TextWidthBasis?,
          textHeightBehavior:
              data['textHeightBehavior'] as TextHeightBehaviorMix?,
        ),
        encode: (value) => optionalJsonMap([
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
        ]),
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

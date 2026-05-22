import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';

/// Builds a bidirectional codec between a wire string and an enum-like type.
///
/// [canonical] defines the round-trippable forward direction (`E → wire`) and
/// the reverse direction used on decode. [aliases] adds extra decode-only
/// mappings — useful when the wire vocabulary accepts multiple strings for
/// the same value (e.g. `'normal'` aliasing `FontWeight.w400`).
///
/// Encoding always emits the canonical wire name, so round-trips
/// `decode(encode(value))` stabilize on the canonical form.
CodecSchema<String, E> aliasedEnumCodec<E extends Object>({
  required Map<E, String> canonical,
  Map<String, E> aliases = const {},
}) {
  final byName = <String, E>{
    for (final entry in canonical.entries) entry.value: entry.key,
    ...aliases,
  };

  return Ack.codec<String, String, E>(
    input: Ack.enumString(byName.keys.toList(growable: false)),
    output: Ack.instance<E>(),
    decode: (value) => byName[value]!,
    encode: (value) =>
        canonical[value] ??
        (throw ArgumentError('Unsupported value for enum codec: $value')),
  );
}

CodecSchema<String, E> enumNameCodec<E extends Enum>(List<E> values) {
  return aliasedEnumCodec(
    canonical: {for (final value in values) value: value.name},
  );
}

final axisSchema = enumNameCodec(Axis.values);
final blendModeSchema = enumNameCodec(BlendMode.values);
final brightnessSchema = enumNameCodec(Brightness.values);
final borderStyleSchema = enumNameCodec(BorderStyle.values);
final boxFitSchema = enumNameCodec(BoxFit.values);
final boxShapeSchema = enumNameCodec(BoxShape.values);
final crossAxisAlignmentSchema = enumNameCodec(CrossAxisAlignment.values);
final clipSchema = enumNameCodec(Clip.values);
final filterQualitySchema = enumNameCodec(FilterQuality.values);
final fontStyleSchema = enumNameCodec(FontStyle.values);
final fontWeightCodec = aliasedEnumCodec<FontWeight>(
  canonical: {
    FontWeight.w100: 'w100',
    FontWeight.w200: 'w200',
    FontWeight.w300: 'w300',
    FontWeight.w400: 'w400',
    FontWeight.w500: 'w500',
    FontWeight.w600: 'w600',
    FontWeight.w700: 'w700',
    FontWeight.w800: 'w800',
    FontWeight.w900: 'w900',
  },
  aliases: {'normal': FontWeight.w400, 'bold': FontWeight.w700},
);
final imageRepeatSchema = enumNameCodec(ImageRepeat.values);
final mainAxisAlignmentSchema = enumNameCodec(MainAxisAlignment.values);
final mainAxisSizeSchema = enumNameCodec(MainAxisSize.values);
final stackFitSchema = enumNameCodec(StackFit.values);
final textAlignSchema = enumNameCodec(TextAlign.values);
final textBaselineSchema = enumNameCodec(TextBaseline.values);
final textDecorationStyleSchema = enumNameCodec(TextDecorationStyle.values);
final textDirectionSchema = enumNameCodec(TextDirection.values);
final textLeadingDistributionSchema = enumNameCodec(
  TextLeadingDistribution.values,
);
final textOverflowSchema = enumNameCodec(TextOverflow.values);
final textWidthBasisSchema = enumNameCodec(TextWidthBasis.values);
final tileModeSchema = enumNameCodec(TileMode.values);
final verticalDirectionSchema = enumNameCodec(VerticalDirection.values);
final widgetStateSchema = enumNameCodec(WidgetState.values);

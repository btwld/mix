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

  return Ack.codec<String, E>(
    input: Ack.enumString(byName.keys.toList(growable: false)),
    output: Ack.instance<E>(),
    decoder: (value) => byName[value]!,
    encoder: (value) =>
        canonical[value] ??
        (throw ArgumentError('Unsupported value for enum codec: $value')),
  );
}

CodecSchema<String, E> enumNameCodec<E extends Enum>(List<E> values) {
  return aliasedEnumCodec(
    canonical: {for (final value in values) value: value.name},
  );
}

final AckSchema<Axis> axisSchema = enumNameCodec(Axis.values);
final AckSchema<BlendMode> blendModeSchema = enumNameCodec(BlendMode.values);
final AckSchema<Brightness> brightnessSchema = enumNameCodec(Brightness.values);
final AckSchema<BorderStyle> borderStyleSchema = enumNameCodec(
  BorderStyle.values,
);
final AckSchema<BoxFit> boxFitSchema = enumNameCodec(BoxFit.values);
final AckSchema<BoxShape> boxShapeSchema = enumNameCodec(BoxShape.values);
final AckSchema<CrossAxisAlignment> crossAxisAlignmentSchema = enumNameCodec(
  CrossAxisAlignment.values,
);
final AckSchema<Clip> clipSchema = enumNameCodec(Clip.values);
final AckSchema<FilterQuality> filterQualitySchema = enumNameCodec(
  FilterQuality.values,
);
final AckSchema<FontStyle> fontStyleSchema = enumNameCodec(FontStyle.values);
final CodecSchema<String, FontWeight> fontWeightCodec =
    aliasedEnumCodec<FontWeight>(
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
final AckSchema<ImageRepeat> imageRepeatSchema = enumNameCodec(
  ImageRepeat.values,
);
final AckSchema<MainAxisAlignment> mainAxisAlignmentSchema = enumNameCodec(
  MainAxisAlignment.values,
);
final AckSchema<MainAxisSize> mainAxisSizeSchema = enumNameCodec(
  MainAxisSize.values,
);
final AckSchema<StackFit> stackFitSchema = enumNameCodec(StackFit.values);
final AckSchema<TextAlign> textAlignSchema = enumNameCodec(TextAlign.values);
final AckSchema<TextBaseline> textBaselineSchema = enumNameCodec(
  TextBaseline.values,
);
final AckSchema<TextDecorationStyle> textDecorationStyleSchema = enumNameCodec(
  TextDecorationStyle.values,
);
final AckSchema<TextDirection> textDirectionSchema = enumNameCodec(
  TextDirection.values,
);
final AckSchema<TextLeadingDistribution> textLeadingDistributionSchema =
    enumNameCodec(TextLeadingDistribution.values);
final AckSchema<TextOverflow> textOverflowSchema = enumNameCodec(
  TextOverflow.values,
);
final AckSchema<TextWidthBasis> textWidthBasisSchema = enumNameCodec(
  TextWidthBasis.values,
);
final AckSchema<TileMode> tileModeSchema = enumNameCodec(TileMode.values);
final AckSchema<VerticalDirection> verticalDirectionSchema = enumNameCodec(
  VerticalDirection.values,
);
final AckSchema<WidgetState> widgetStateSchema = enumNameCodec(
  WidgetState.values,
);

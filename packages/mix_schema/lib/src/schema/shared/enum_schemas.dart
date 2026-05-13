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

final AckSchema<Axis> axisSchema = Ack.enumValues(Axis.values);
final AckSchema<BlendMode> blendModeSchema = Ack.enumValues(BlendMode.values);
final AckSchema<Brightness> brightnessSchema = Ack.enumValues(
  Brightness.values,
);
final AckSchema<BorderStyle> borderStyleSchema = Ack.enumValues(
  BorderStyle.values,
);
final AckSchema<BoxFit> boxFitSchema = Ack.enumValues(BoxFit.values);
final AckSchema<BoxShape> boxShapeSchema = Ack.enumValues(BoxShape.values);
final AckSchema<CrossAxisAlignment> crossAxisAlignmentSchema = Ack.enumValues(
  CrossAxisAlignment.values,
);
final AckSchema<Clip> clipSchema = Ack.enumValues(Clip.values);
final AckSchema<FilterQuality> filterQualitySchema = Ack.enumValues(
  FilterQuality.values,
);
final AckSchema<FontStyle> fontStyleSchema = Ack.enumValues(FontStyle.values);
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
final AckSchema<ImageRepeat> imageRepeatSchema = Ack.enumValues(
  ImageRepeat.values,
);
final AckSchema<MainAxisAlignment> mainAxisAlignmentSchema = Ack.enumValues(
  MainAxisAlignment.values,
);
final AckSchema<MainAxisSize> mainAxisSizeSchema = Ack.enumValues(
  MainAxisSize.values,
);
final AckSchema<StackFit> stackFitSchema = Ack.enumValues(StackFit.values);
final AckSchema<TextAlign> textAlignSchema = Ack.enumValues(TextAlign.values);
final AckSchema<TextBaseline> textBaselineSchema = Ack.enumValues(
  TextBaseline.values,
);
final AckSchema<TextDecorationStyle> textDecorationStyleSchema = Ack.enumValues(
  TextDecorationStyle.values,
);
final AckSchema<TextDirection> textDirectionSchema = Ack.enumValues(
  TextDirection.values,
);
final AckSchema<TextLeadingDistribution> textLeadingDistributionSchema =
    Ack.enumValues(TextLeadingDistribution.values);
final AckSchema<TextOverflow> textOverflowSchema = Ack.enumValues(
  TextOverflow.values,
);
final AckSchema<TextWidthBasis> textWidthBasisSchema = Ack.enumValues(
  TextWidthBasis.values,
);
final AckSchema<TileMode> tileModeSchema = Ack.enumValues(TileMode.values);
final AckSchema<VerticalDirection> verticalDirectionSchema = Ack.enumValues(
  VerticalDirection.values,
);
final AckSchema<WidgetState> widgetStateSchema = Ack.enumValues(
  WidgetState.values,
);

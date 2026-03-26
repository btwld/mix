import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';

const Map<String, FontWeight> _fontWeightByName = {
  'w100': FontWeight.w100,
  'w200': FontWeight.w200,
  'w300': FontWeight.w300,
  'w400': FontWeight.w400,
  'w500': FontWeight.w500,
  'w600': FontWeight.w600,
  'w700': FontWeight.w700,
  'w800': FontWeight.w800,
  'w900': FontWeight.w900,
  'normal': FontWeight.w400,
  'bold': FontWeight.w700,
};

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
final AckSchema<FontWeight> fontWeightSchema = Ack.enumString(
  _fontWeightByName.keys.toList(growable: false),
).transform<FontWeight>((value) => _fontWeightByName[value]!);
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

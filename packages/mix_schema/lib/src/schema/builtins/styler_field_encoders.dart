import 'package:mix/mix.dart';

import '../../core/json_map.dart';
import '../../core/prop_encode.dart';

JsonMap encodeBoxFields(BoxStyler value) {
  return optionalJsonMap([
    ('alignment', propValue(value.$alignment)),
    ('padding', propMix<EdgeInsetsGeometryMix>(value.$padding)),
    ('margin', propMix<EdgeInsetsGeometryMix>(value.$margin)),
    ('constraints', propMix<BoxConstraintsMix>(value.$constraints)),
    ('decoration', propMix<DecorationMix>(value.$decoration)),
    (
      'foregroundDecoration',
      propMix<DecorationMix>(value.$foregroundDecoration),
    ),
    ('transform', propValue(value.$transform)),
    ('transformAlignment', propValue(value.$transformAlignment)),
    ('clipBehavior', propValue(value.$clipBehavior)),
  ]);
}

JsonMap encodeFlexFields(
  FlexStyler value, {
  String clipBehaviorField = 'clipBehavior',
}) {
  return optionalJsonMap([
    ('direction', propValue(value.$direction)),
    ('mainAxisAlignment', propValue(value.$mainAxisAlignment)),
    ('crossAxisAlignment', propValue(value.$crossAxisAlignment)),
    ('mainAxisSize', propValue(value.$mainAxisSize)),
    ('verticalDirection', propValue(value.$verticalDirection)),
    ('textDirection', propValue(value.$textDirection)),
    ('textBaseline', propValue(value.$textBaseline)),
    (clipBehaviorField, propValue(value.$clipBehavior)),
    ('spacing', propValue(value.$spacing)),
  ]);
}

JsonMap encodeStackFields(
  StackStyler value, {
  String alignmentField = 'alignment',
  String clipBehaviorField = 'clipBehavior',
}) {
  return optionalJsonMap([
    (alignmentField, propValue(value.$alignment)),
    ('fit', propValue(value.$fit)),
    ('textDirection', propValue(value.$textDirection)),
    (clipBehaviorField, propValue(value.$clipBehavior)),
  ]);
}

JsonMap encodeTextFields(TextStyler value) {
  final textDirectives = value.$textDirectives;
  Directive<String>? textTransform;
  if (textDirectives != null && textDirectives.isNotEmpty) {
    if (textDirectives.length != 1) {
      throw UnsupportedError(
        'Only one text transform directive can be encoded.',
      );
    }
    textTransform = textDirectives.single;
  }

  return optionalJsonMap([
    ('overflow', propValue(value.$overflow)),
    ('strutStyle', propMix<StrutStyleMix>(value.$strutStyle)),
    ('textAlign', propValue(value.$textAlign)),
    ('textScaler', propValue(value.$textScaler)),
    ('maxLines', propValue(value.$maxLines)),
    ('style', propMix<TextStyleMix>(value.$style)),
    ('textWidthBasis', propValue(value.$textWidthBasis)),
    (
      'textHeightBehavior',
      propMix<TextHeightBehaviorMix>(value.$textHeightBehavior),
    ),
    ('textDirection', propValue(value.$textDirection)),
    ('softWrap', propValue(value.$softWrap)),
    ('textTransform', textTransform),
    ('selectionColor', propValue(value.$selectionColor)),
    ('semanticsLabel', propValue(value.$semanticsLabel)),
    ('locale', propValue(value.$locale)),
  ]);
}

JsonMap encodeImageFields(ImageStyler value) {
  return {
    'image': requiredPropValue(value.$image, 'image'),
    ...optionalJsonMap([
      ('width', propValue(value.$width)),
      ('height', propValue(value.$height)),
      ('color', propValue(value.$color)),
      ('repeat', propValue(value.$repeat)),
      ('fit', propValue(value.$fit)),
      ('alignment', propValue(value.$alignment)),
      ('centerSlice', propValue(value.$centerSlice)),
      ('filterQuality', propValue(value.$filterQuality)),
      ('colorBlendMode', propValue(value.$colorBlendMode)),
      ('semanticLabel', propValue(value.$semanticLabel)),
      ('excludeFromSemantics', propValue(value.$excludeFromSemantics)),
      ('gaplessPlayback', propValue(value.$gaplessPlayback)),
      ('isAntiAlias', propValue(value.$isAntiAlias)),
      ('matchTextDirection', propValue(value.$matchTextDirection)),
    ]),
  };
}

JsonMap encodeIconFields(IconStyler value) {
  final ShadowListMix? shadows = propMix(value.$shadows);

  return optionalJsonMap([
    ('icon', propValue(value.$icon)),
    ('color', propValue(value.$color)),
    ('size', propValue(value.$size)),
    ('weight', propValue(value.$weight)),
    ('grade', propValue(value.$grade)),
    ('opticalSize', propValue(value.$opticalSize)),
    ('shadows', shadows?.items),
    ('textDirection', propValue(value.$textDirection)),
    ('applyTextScaling', propValue(value.$applyTextScaling)),
    ('fill', propValue(value.$fill)),
    ('semanticsLabel', propValue(value.$semanticsLabel)),
    ('opacity', propValue(value.$opacity)),
    ('blendMode', propValue(value.$blendMode)),
  ]);
}

JsonMap encodeFlexBoxFields(FlexBoxStyler value) {
  final box = propMix<BoxStyler>(value.$box);
  final flex = propMix<FlexStyler>(value.$flex);

  return {
    if (box != null) ...encodeBoxFields(box),
    if (flex != null)
      ...encodeFlexFields(flex, clipBehaviorField: 'flexClipBehavior'),
  };
}

JsonMap encodeStackBoxFields(StackBoxStyler value) {
  final box = propMix<BoxStyler>(value.$box);
  final stack = propMix<StackStyler>(value.$stack);

  return {
    if (box != null) ...encodeBoxFields(box),
    if (stack != null)
      ...encodeStackFields(
        stack,
        alignmentField: 'stackAlignment',
        clipBehaviorField: 'stackClipBehavior',
      ),
  };
}

import 'package:ack/ack.dart' show JsonMap;
import 'package:mix/mix.dart';

import '../../core/prop_encode.dart';

JsonMap encodeBoxFields(BoxStyler value) {
  return optionalJsonMap([
    ('alignment', directPropValue(value.$alignment)),
    ('padding', directPropMix<EdgeInsetsGeometryMix>(value.$padding)),
    ('margin', directPropMix<EdgeInsetsGeometryMix>(value.$margin)),
    ('constraints', directPropMix<BoxConstraintsMix>(value.$constraints)),
    ('decoration', directPropMix<DecorationMix>(value.$decoration)),
    (
      'foregroundDecoration',
      directPropMix<DecorationMix>(value.$foregroundDecoration),
    ),
    ('transform', directPropValue(value.$transform)),
    ('transformAlignment', directPropValue(value.$transformAlignment)),
    ('clipBehavior', directPropValue(value.$clipBehavior)),
  ]);
}

JsonMap encodeFlexFields(
  FlexStyler value, {
  String clipBehaviorField = 'clipBehavior',
}) {
  return optionalJsonMap([
    ('direction', directPropValue(value.$direction)),
    ('mainAxisAlignment', directPropValue(value.$mainAxisAlignment)),
    ('crossAxisAlignment', directPropValue(value.$crossAxisAlignment)),
    ('mainAxisSize', directPropValue(value.$mainAxisSize)),
    ('verticalDirection', directPropValue(value.$verticalDirection)),
    ('textDirection', directPropValue(value.$textDirection)),
    ('textBaseline', directPropValue(value.$textBaseline)),
    (clipBehaviorField, directPropValue(value.$clipBehavior)),
    ('spacing', directPropValue(value.$spacing)),
  ]);
}

JsonMap encodeStackFields(
  StackStyler value, {
  String alignmentField = 'alignment',
  String clipBehaviorField = 'clipBehavior',
}) {
  return optionalJsonMap([
    (alignmentField, directPropValue(value.$alignment)),
    ('fit', directPropValue(value.$fit)),
    ('textDirection', directPropValue(value.$textDirection)),
    (clipBehaviorField, directPropValue(value.$clipBehavior)),
  ]);
}

JsonMap encodeFlexBoxFields(FlexBoxStyler value) {
  final box = foldMixProp<BoxStyler>(value.$box);
  final flex = foldMixProp<FlexStyler>(value.$flex);

  return {
    if (box != null) ...encodeBoxFields(box),
    if (flex != null)
      ...encodeFlexFields(flex, clipBehaviorField: 'flexClipBehavior'),
  };
}

JsonMap encodeStackBoxFields(StackBoxStyler value) {
  final box = foldMixProp<BoxStyler>(value.$box);
  final stack = foldMixProp<StackStyler>(value.$stack);

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

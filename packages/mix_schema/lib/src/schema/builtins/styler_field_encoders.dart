import 'package:ack/ack.dart' show JsonMap;
import 'package:mix/mix.dart';

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

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'element.dart';
import 'spec.dart';
import 'utility.dart';

abstract class WidgetModifierSpec<Self extends WidgetModifierSpec<Self>>
    extends Spec<Self> {
  const WidgetModifierSpec({super.animated}) : super(modifiers: null);

  static WidgetModifierSpec? lerpValue(
    WidgetModifierSpec? begin,
    WidgetModifierSpec? end,
    double t,
  ) {
    if (begin != null && end != null) {
      assert(
        begin.runtimeType == end.runtimeType,
        'You can only lerp the same type of ModifierSpec',
      );

      return begin.lerp(end, t) as WidgetModifierSpec?;
    }

    return begin ?? end;
  }

  @override
  WidgetModifierSpecAttribute<Self> toAttribute();

  Widget build(Widget child);
}

abstract class WidgetModifierSpecAttribute<
        Value extends WidgetModifierSpec<Value>> extends SpecAttribute<Value>
    with Diagnosticable {
  const WidgetModifierSpecAttribute();
}

abstract class WidgetModifierUtility<
    T extends Attribute,
    D extends WidgetModifierSpecAttribute<Value>,
    Value extends WidgetModifierSpec<Value>> extends MixUtility<T, D> {
  const WidgetModifierUtility(super.builder);
}

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'element.dart';
import 'factory/mix_data.dart';
import 'spec.dart';
import 'utility.dart';

/// Base class for widget modifiers that can be applied to styled widgets.
///
/// Widget modifiers transform or wrap widgets with additional functionality
/// while maintaining style inheritance and animation support.
abstract class WidgetModifierSpec<Self extends WidgetModifierSpec<Self>>
    extends Spec<Self> {
  const WidgetModifierSpec({super.animated}) : super(modifiers: null);

  /// Linearly interpolates between two modifier specs.
  ///
  /// Returns null if either [begin] or [end] is null, otherwise interpolates
  /// between the specs at position [t]. Both specs must be the same type.

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

  /// Builds the modified widget by wrapping or transforming [child].
  Widget build(Widget child);
}

abstract class WidgetModifierSpecAttribute<
        Value extends WidgetModifierSpec<Value>> extends SpecAttribute<Value>
    with Diagnosticable {
  const WidgetModifierSpecAttribute();

  /// Resolves the attribute to a [WidgetModifierSpec] using the provided [MixData].
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  @override
  Value resolve(MixData mix);
}

abstract class WidgetModifierUtility<
    T extends StyleElement,
    D extends WidgetModifierSpecAttribute<Value>,
    Value extends WidgetModifierSpec<Value>> extends MixUtility<T, D> {
  const WidgetModifierUtility(super.builder);
}

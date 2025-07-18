import 'package:flutter/widgets.dart';

import 'attribute.dart';
import 'spec.dart';
import 'utility.dart';

/// Base class for widget modifiers that can be applied to styled widgets.
///
/// Widget modifiers transform or wrap widgets with additional functionality
/// while maintaining style inheritance and animation support.
abstract class ModifierSpec<Self extends ModifierSpec<Self>>
    extends Spec<Self> {
  const ModifierSpec();

  /// Linearly interpolates between two modifier specs.
  ///
  /// Returns null if either [begin] or [end] is null, otherwise interpolates
  /// between the specs at position [t]. Both specs must be the same type.

  static ModifierSpec? lerpValue(
    ModifierSpec? begin,
    ModifierSpec? end,
    double t,
  ) {
    if (begin != null && end != null) {
      assert(
        begin.runtimeType == end.runtimeType,
        'You can only lerp the same type of ModifierSpec',
      );

      return begin.lerp(end, t) as ModifierSpec?;
    }

    return begin ?? end;
  }

  /// Builds the modified widget by wrapping or transforming [child].
  Widget build(Widget child);
}

abstract class WidgetModifierUtility<
  T extends ModifierSpec<T>,
  D extends WidgetModifierSpecAttribute<Value>,
  Value extends ModifierSpec<Value>
>
    extends MixUtility<D, T> {
  const WidgetModifierUtility(super.builder);
}
